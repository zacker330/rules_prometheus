# This template is used by go_download to generate a build file for
# a downloaded Go distribution.

load("@rules_prometheus//:def.bzl", "alertmanager_toolchain")

# tools contains executable files that are part of the toolchain.
filegroup(
    name = "tools",
    srcs = ["alertmanager{exe}","amtool{exe}"],
    visibility = ["//visibility:public"],
)

alertmanager_toolchain(
    name = "alertmanager_toolchain",
    tools = [":tools"],
)

toolchain(
    name = "toolchain",
    exec_compatible_with = [
        {exec_constraints},
    ],
    target_compatible_with = [
        {target_constraints},
    ],
    toolchain = ":alertmanager_toolchain",
    toolchain_type = "@rules_prometheus//:alertmanager_toolchain_type",
)
