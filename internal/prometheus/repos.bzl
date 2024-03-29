load("@io_bazel_rules_prometheus//internal:platforms.bzl","detect_host_platform")
load("@io_bazel_rules_prometheus//internal/prometheus:prometheus_versions.bzl", "DEFAULT_AVAILABLE_PROMETHEUS_BINARIES")
load("@io_bazel_rules_prometheus//internal:platforms.bzl", "BAZEL_OS_CONSTRAINTS", "BAZEL_ARCH_CONSTRAINTS")


def _prometheus_build_file(ctx, platform, version):
    os, _, arch = platform.partition("-")

    constraints = [BAZEL_OS_CONSTRAINTS[os], BAZEL_ARCH_CONSTRAINTS[arch]]

    constraint_str = ",\n        ".join(['"%s"' % c for c in constraints])
    ctx.template(
        "BUILD.bazel",
        ctx.path(ctx.attr._build_file),
        executable = False,
        substitutions = {
            "{os}": os,
            "{arch}": arch,
            "{exe}": ".exe" if os == "windows" else "",
            "{exec_constraints}": constraint_str,
            "{target_constraints}": constraint_str,
        }
    )


def _prometheus_download(ctx, urls, strip_prefix, sha256):
    if len(urls) == 0:
        fail("no urls specified")
    ctx.report_progress("Downloading and extracting prometheus toolchain")
    if urls[0].endswith(".tar.gz"):
        # BUG(#2771): Use a system tool to extract the archive instead of
        # Bazel's implementation. With some configurations (macOS + Docker +
        # some particular file system binding), Bazel's implementation rejects
        # files with invalid unicode names. Go has at least one test case with a
        # file like this, but we haven't been able to reproduce the failure, so
        # instead, we use this workaround.
        if strip_prefix != "prometheus":
            fail("strip_prefix not supported")
        ctx.download(
            url = urls,
            sha256 = sha256,
            output = "prometheus.tar.gz",
        )
        res = ctx.execute(["tar", "-xf", "prometheus.tar.gz", "--strip-components=1"])
        if res.return_code:
            fail("error extracting prometheus tar:\n" + res.stdout + res.stderr)
        ctx.delete("prometheus.tar.gz")
    else:
        ctx.download_and_extract(
            url = urls,
            stripPrefix = strip_prefix,
            sha256 = sha256,
        )


def _format_url(version, platform, url):
    # https://github.com/prometheus/prometheus/releases/download/v0.25.0/prometheus-0.25.0.darwin-amd64.tar.gz
    whole_url = url.format(version, version, platform)
    return whole_url

def _prometheus_download_rule_impl(ctx):
    os, arch = detect_host_platform(ctx)
#    if not ctx.attr.os and not ctx.attr.arch:
#        os, arch = detect_host_platform(ctx)
#    else:
#        if not ctx.attr.os:
#            fail("arch set but os not set")
#        if not ctx.attr.arch:
#            fail("os set but arch not set")
#    os, arch = ctx.attr.os, ctx.attr.arch
    platform = os + "-" + arch

    version = ctx.attr.version

    # download actually
    sha256 = DEFAULT_AVAILABLE_PROMETHEUS_BINARIES[(version, platform)]
    _prometheus_download(ctx, [_format_url(version, platform, url) for url in ctx.attr.urls], ctx.attr.strip_prefix, sha256)
    
    # generate BUILD file for the toolchain
    _prometheus_build_file(ctx, platform, version)

    return {
            "name": ctx.attr.name,
            "os": ctx.attr.os,
            "arch": ctx.attr.arch,
            "urls": ctx.attr.urls,
            "version": version,
            "strip_prefix": ctx.attr.strip_prefix,
        }

prometheus_download_rule = repository_rule(
    implementation = _prometheus_download_rule_impl,
    attrs = {
        "os": attr.string(),
        "arch": attr.string(),
        "urls": attr.string_list(default = ["https://github.com/prometheus/prometheus/releases/download/v{}/prometheus-{}.{}.tar.gz"]),
        "version": attr.string(),
        "strip_prefix": attr.string(default = "prometheus"),
        "_build_file": attr.label(
            default = Label("//internal/prometheus:BUILD.prometheus.dist.bazel.tpl"),
        ),
    },
)