# This template is used by go_download to generate a build file for
# a downloaded Go distribution.

load("@io_bazel_rules_prometheus//:def.bzl", "prometheus_toolchain")

# tools contains executable files that are part of the toolchain.
filegroup(
    name = "prometheus_tools",
    srcs = ["prometheus{exe}","promtool{exe}"],
    visibility = ["//visibility:public"],
)

prometheus_toolchain(
    name = "prometheus_toolchain",
    tools = [":prometheus_tools"],
)

toolchain(
    name = "toolchain",
    exec_compatible_with = [
        {exec_constraints},
    ],
    target_compatible_with = [
        {target_constraints},
    ],
    toolchain = ":prometheus_toolchain",
    toolchain_type = "@io_bazel_rules_prometheus//:prometheus_toolchain_type",
)
