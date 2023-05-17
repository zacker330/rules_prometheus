def detect_host_platform(ctx):
    os = ctx.os.name
    if os == "mac os x":
        os = "darwin"
    elif os.startswith("windows"):
        os = "windows"

    arch = ctx.os.environ.get("PROCESSOR_ARCHITECTURE")
    if os == "darwin":
        arch = ctx.os.arch

    if arch == "aarch64":
        arch = "arm64"
    elif arch == "x86_64":
        arch = "amd64"

    return os, arch

BAZEL_OS_CONSTRAINTS = {
    "darwin" : "@platforms//os:osx",
    "freebsd" : "@platforms//os:freebsd",
    "dragonfly" : "@platforms//os:freebsd",
    "linux" : "@platforms//os:linux",
    "windows" : "@platforms//os:windows",
    "netbsd" : "@platforms//os:freebsd",
    "openbsd" : "@platforms//os:openbsd",
    "illumos" : "@platforms//os:openbsd",
}


BAZEL_ARCH_CONSTRAINTS = {
    "amd64" : "@platforms//cpu:x86_64",
    "arm" : "@platforms//cpu:arm",
    "arm64" : "@platforms//cpu:arm64",
    "armv5" : "@platforms//cpu:arm",
    "armv6" : "@platforms//cpu:arm",
    "armv7" : "@platforms//cpu:armv7",
    "mips64" : "@platforms//cpu:mips64",
    "mips64le" : "@platforms//cpu:mips64",
    "ppc64" : "@platforms//cpu:x86_32",
    "ppc64le" : "@platforms//cpu:ppc",
    "s390x" : "@platforms//cpu:s390x",
    "mips" : "@platforms//cpu:x86_32",
    "mipsle" : "@platforms//cpu:x86_32",
    "386" : "@platforms//cpu:x86_32",
    # because you can't pass integer as keyword in python
    # **{"386": "@platforms//cpu:x86_32"}
}
