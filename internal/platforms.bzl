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

OS_ARCH = (
    ("aix", "ppc64"),
    ("darwin", "386"),
    ("darwin", "amd64"),
    ("darwin", "arm"),
    ("darwin", "arm64"),
    ("dragonfly", "amd64"),
    ("freebsd", "386"),
    ("freebsd", "amd64"),
    ("freebsd", "arm"),
    ("freebsd", "arm64"),
    ("illumos", "amd64"),
    ("linux", "386"),
    ("linux", "amd64"),
    ("linux", "arm"),
    ("linux", "arm64"),
    ("linux", "mips"),
    ("linux", "mips64"),
    ("linux", "mips64le"),
    ("linux", "mipsle"),
    ("linux", "ppc64"),
    ("linux", "ppc64le"),
    ("linux", "riscv64"),
    ("linux", "s390x"),
    ("nacl", "386"),
    ("nacl", "amd64p32"),
    ("nacl", "arm"),
    ("netbsd", "386"),
    ("netbsd", "amd64"),
    ("netbsd", "arm"),
    ("netbsd", "arm64"),
    ("openbsd", "386"),
    ("openbsd", "amd64"),
    ("openbsd", "arm"),
    ("openbsd", "arm64"),
    ("plan9", "386"),
    ("plan9", "amd64"),
    ("plan9", "arm"),
    ("solaris", "amd64"),
    ("windows", "386"),
    ("windows", "amd64"),
    ("windows", "arm"),
    ("windows", "arm64"),
)



def _generate_constraints(names, bazel_constraints):
    return {
        name: bazel_constraints.get(name, "@io_bazel_rules_prometheus//internal/toolchain:" + name)
        for name in names
    }

OS_CONSTRAINTS = _generate_constraints([p[0] for p in OS_ARCH], BAZEL_OS_CONSTRAINTS)
ARCH_CONSTRAINTS = _generate_constraints([p[1] for p in OS_ARCH], BAZEL_ARCH_CONSTRAINTS)

def _generate_platforms():
    platforms = []
    for os, arch in OS_ARCH:
        constraints = [
            OS_CONSTRAINTS[os],
            ARCH_CONSTRAINTS[arch],
        ]
        platforms.append(struct(
            name = os + "-" + arch,
            os = os,
            arch = arch,
            constraints = constraints,
        ))

    return platforms

PLATFORMS = _generate_platforms()


def declare_constraints():
    """Generates constraint_values and platform targets for valid platforms.

    Each constraint_value corresponds to a valid os or arch.
    The os and arch values belong to the constraint_settings
    @platforms//os:os and @platforms//cpu:cpu, respectively.
    To avoid redundancy, if there is an equivalent value in @platforms,
    we define an alias here instead of another constraint_value.

    Each platform defined here selects a os and arch constraint value.
    These platforms may be used with --platforms for cross-compilation,
    though users may create their own platforms (and
    @bazel_tools//platforms:default_platform will be used most of the time).
    """
    for os, constraint in OS_CONSTRAINTS.items():
        if constraint.startswith("@io_bazel_rules_prometheus//internal/toolchain:"):
            native.constraint_value(
                name = os,
                constraint_setting = "@platforms//os:os",
            )
        else:
            native.alias(
                name = os,
                actual = constraint,
            )

    for arch, constraint in ARCH_CONSTRAINTS.items():
        if constraint.startswith("@io_bazel_rules_prometheus//internal/toolchain:"):
            native.constraint_value(
                name = arch,
                constraint_setting = "@platforms//cpu:cpu",
            )
        else:
            native.alias(
                name = arch,
                actual = constraint,
            )

    for p in PLATFORMS:
        native.platform(
            name = p.name,
            constraint_values = p.constraints,
        )