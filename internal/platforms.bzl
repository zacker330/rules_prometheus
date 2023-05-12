def detect_host_platform(ctx):
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

BAZEL_GOOS_CONSTRAINTS = {
    "darwin": "@platforms//os:osx",
    "freebsd": "@platforms//os:freebsd",
    "ios": "@platforms//os:ios",
    "linux": "@platforms//os:linux",
    "windows": "@platforms//os:windows",
}

BAZEL_GOARCH_CONSTRAINTS = {
    "386": "@platforms//cpu:x86_32",
    "amd64": "@platforms//cpu:x86_64",
    "arm": "@platforms//cpu:arm",
    "arm64": "@platforms//cpu:aarch64",
    "ppc64": "@platforms//cpu:ppc",
    "ppc64le": "@platforms//cpu:ppc",
    "s390x": "@platforms//cpu:s390x",
}

GOOS_GOARCH = (
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
        name: bazel_constraints.get(name, "@rules_prometheus//internal/toolchain:" + name)
        for name in names
    }

GOOS_CONSTRAINTS = _generate_constraints([p[0] for p in GOOS_GOARCH], BAZEL_GOOS_CONSTRAINTS)
GOARCH_CONSTRAINTS = _generate_constraints([p[1] for p in GOOS_GOARCH], BAZEL_GOARCH_CONSTRAINTS)

def _generate_platforms():
    platforms = []
    for goos, goarch in GOOS_GOARCH:
        constraints = [
            GOOS_CONSTRAINTS[goos],
            GOARCH_CONSTRAINTS[goarch],
        ]
        platforms.append(struct(
            name = goos + "_" + goarch,
            goos = goos,
            goarch = goarch,
            constraints = constraints,
            cgo = False,
        ))

    return platforms

PLATFORMS = _generate_platforms()


def declare_constraints():
    """Generates constraint_values and platform targets for valid platforms.

    Each constraint_value corresponds to a valid goos or goarch.
    The goos and goarch values belong to the constraint_settings
    @platforms//os:os and @platforms//cpu:cpu, respectively.
    To avoid redundancy, if there is an equivalent value in @platforms,
    we define an alias here instead of another constraint_value.

    Each platform defined here selects a goos and goarch constraint value.
    These platforms may be used with --platforms for cross-compilation,
    though users may create their own platforms (and
    @bazel_tools//platforms:default_platform will be used most of the time).
    """
    for goos, constraint in GOOS_CONSTRAINTS.items():
        if constraint.startswith("@rules_prometheus//internal/toolchain:"):
            native.constraint_value(
                name = goos,
                constraint_setting = "@platforms//os:os",
            )
        else:
            native.alias(
                name = goos,
                actual = constraint,
            )

    for goarch, constraint in GOARCH_CONSTRAINTS.items():
        if constraint.startswith("@rules_prometheus//internal/toolchain:"):
            native.constraint_value(
                name = goarch,
                constraint_setting = "@platforms//cpu:cpu",
            )
        else:
            native.alias(
                name = goarch,
                actual = constraint,
            )

    for p in PLATFORMS:
        native.platform(
            name = p.name,
            constraint_values = p.constraints,
        )