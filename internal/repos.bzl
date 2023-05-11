def _detect_host_platform(ctx):
    goos = ctx.os.name
    if goos == "mac os x":
        goos = "darwin"
    elif goos.startswith("windows"):
        goos = "windows"

    goarch = ctx.os.arch
    if goarch == "aarch64":
        goarch = "arm64"
    elif goarch == "x86_64":
        goarch = "amd64"

    return goos, goarch


def _prometheus_download(ctx):
    ctx.download(
        ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        output = "prometheus.tar.gz",
    )
    ctx.report_progress("extracting")
    ctx.execute(["tar", "xf", "prometheus.tar.gz", "--strip-components=1"])
    ctx.delete("prometheus.tar.gz")
    
    goos, goarch = _detect_host_platform(ctx)

    ctx.report_progress("generating build file")
    if goos == "darwin":
        os_constraint = "@platforms//os:osx"
    elif goos == "linux":
        os_constraint = "@platforms//os:linux"
    elif goos == "windows":
        os_constraint = "@platforms//os:windows"
    else:
        fail("unsupported goos: " + goos)
    if goarch == "amd64":
        arch_constraint = "@platforms//cpu:x86_64"
    elif goarch == "arm64":
        arch_constraint = "@platforms//cpu:arm64"
    else:
        fail("unsupported arch: " + goarch)
    constraints = [os_constraint, arch_constraint]
    constraint_str = ",\n        ".join(['"%s"' % c for c in constraints])

    substitutions = {
        "{goos}": goos,
        "{goarch}": goarch,
        "{exe}": ".exe" if goos == "windows" else "",
        "{exec_constraints}": constraint_str,
        "{target_constraints}": constraint_str,
    }
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = substitutions,
    )



def _alertmanager_download(ctx):
    ctx.download(
        ctx.attr.urls,
        sha256 = ctx.attr.sha256,
        output = "alertmanager.tar.gz",
    )
    ctx.report_progress("extracting")
    ctx.execute(["tar", "xf", "alertmanager.tar.gz", "--strip-components=1"])
    ctx.delete("alertmanager.tar.gz")
    
    goos, goarch = _detect_host_platform(ctx)

    ctx.report_progress("generating build file")
    if goos == "darwin":
        os_constraint = "@platforms//os:osx"
    elif goos == "linux":
        os_constraint = "@platforms//os:linux"
    elif goos == "windows":
        os_constraint = "@platforms//os:windows"
    else:
        fail("unsupported goos: " + goos)
    if goarch == "amd64":
        arch_constraint = "@platforms//cpu:x86_64"
    elif goarch == "arm64":
        arch_constraint = "@platforms//cpu:arm64"
    else:
        fail("unsupported arch: " + goarch)
    constraints = [os_constraint, arch_constraint]
    constraint_str = ",\n        ".join(['"%s"' % c for c in constraints])

    substitutions = {
        "{goos}": goos,
        "{goarch}": goarch,
        "{exe}": ".exe" if goos == "windows" else "",
        "{exec_constraints}": constraint_str,
        "{target_constraints}": constraint_str,
    }
    ctx.template(
        "BUILD.bazel",
        ctx.attr._build_tpl,
        substitutions = substitutions,
    )





prometheus_download = repository_rule(
    implementation = _prometheus_download,
    attrs = {
        "urls": attr.string_list(
            mandatory = True,
            doc = "List of mirror URLs where a Prometheus distribution archive can be downloaded",
        ),
        "sha256": attr.string(
            mandatory = True,
            doc = "Expected SHA-256 sum of the downloaded archive",
        ),
        "_build_tpl": attr.label(
            default = "@rules_prometheus//internal:BUILD.prometheus.dist.bazel.tpl",
        ),
    },
    doc = "Downloads a standard prometheus distribution and installs a build file",
)


alertmanager_download = repository_rule(
    implementation = _alertmanager_download,
    attrs = {
        "urls": attr.string_list(
            mandatory = True,
            doc = "List of mirror URLs where a Alertmanager distribution archive can be downloaded",
        ),
        "sha256": attr.string(
            mandatory = True,
            doc = "Expected SHA-256 sum of the downloaded archive",
        ),
        "_build_tpl": attr.label(
            default = "@rules_prometheus//internal:BUILD.amtool.dist.bazel.tpl",
        ),
    },
    doc = "Downloads a standard alertmanager distribution and installs a build file",
)

