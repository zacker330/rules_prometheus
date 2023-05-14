load("//internal:platforms.bzl","detect_host_platform")
load("//internal/alertmanager:alertmanager_versions.bzl", "DEFAULT_AVAILABLE_ALERTMANAGER_BINARIES")


def _alertmanager_build_file(ctx, platform, version):
    os, _, arch = platform.partition("-")
    if os == "darwin":
        os_constraint = "@platforms//os:osx"
    elif os == "linux":
        os_constraint = "@platforms//os:linux"
    elif os == "windows":
        os_constraint = "@platforms//os:windows"
    else:
        fail("unsupported os: " + os)
    if arch == "amd64":
        arch_constraint = "@platforms//cpu:x86_64"
    elif arch == "arm64":
        arch_constraint = "@platforms//cpu:arm64"
    else:
        fail("unsupported arch: " + arch)
    constraints = [os_constraint, arch_constraint]
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


def _alertmanager_download(ctx, urls, strip_prefix, sha256):
    if len(urls) == 0:
        fail("no urls specified")
    ctx.report_progress("Downloading and extracting alertmanager toolchain")
    if urls[0].endswith(".tar.gz"):
        # BUG(#2771): Use a system tool to extract the archive instead of
        # Bazel's implementation. With some configurations (macOS + Docker +
        # some particular file system binding), Bazel's implementation rejects
        # files with invalid unicode names. Go has at least one test case with a
        # file like this, but we haven't been able to reproduce the failure, so
        # instead, we use this workaround.
        if strip_prefix != "alertmanager":
            fail("strip_prefix not supported")
        ctx.download(
            url = urls,
            sha256 = sha256,
            output = "alertmanager.tar.gz",
        )
        res = ctx.execute(["tar", "-xf", "alertmanager.tar.gz", "--strip-components=1"])
        if res.return_code:
            fail("error extracting alertmanager tar:\n" + res.stdout + res.stderr)
        ctx.delete("alertmanager.tar.gz")
    else:
        ctx.download_and_extract(
            url = urls,
            stripPrefix = strip_prefix,
            sha256 = sha256,
        )


def _format_url(version, platform, url):
    # https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.darwin-amd64.tar.gz
    whole_url = url.format(version, version, platform)
    return whole_url

def _alertmanager_download_rule_impl(ctx):
    if not ctx.attr.os and not ctx.attr.arch:
        os, arch = detect_host_platform(ctx)
    else:
        if not ctx.attr.os:
            fail("arch set but os not set")
        if not ctx.attr.arch:
            fail("os set but arch not set")
        os, arch = ctx.attr.os, ctx.attr.arch
    platform = os + "-" + arch

    version = ctx.attr.version

    # download actually
    sha256 = DEFAULT_AVAILABLE_ALERTMANAGER_BINARIES[(version, platform)]
    _alertmanager_download(ctx, [_format_url(version, platform, url) for url in ctx.attr.urls], ctx.attr.strip_prefix, sha256)
    
    # generate BUILD file for the toolchain
    _alertmanager_build_file(ctx, platform, version)

    return {
            "name": ctx.attr.name,
            "os": ctx.attr.os,
            "arch": ctx.attr.arch,
            "urls": ctx.attr.urls,
            "version": version,
            "strip_prefix": ctx.attr.strip_prefix,
        }

alertmanager_download_rule = repository_rule(
    implementation = _alertmanager_download_rule_impl,
    attrs = {
        "os": attr.string(),
        "arch": attr.string(),
        "urls": attr.string_list(default = ["https://github.com/prometheus/alertmanager/releases/download/v{}/alertmanager-{}.{}.tar.gz"]),
        "version": attr.string(),
        "strip_prefix": attr.string(default = "alertmanager"),
        "_build_file": attr.label(
            default = Label("//internal/alertmanager:BUILD.amtool.dist.bazel.tpl"),
        ),
    },
)