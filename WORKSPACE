workspace(name = "io_bazel_rules_prometheus")
load("@io_bazel_rules_prometheus//:deps.bzl", "rules_prometheus_dependencies", "prometheus_register_toolchains", "alertmanager_register_toolchains")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")



rules_prometheus_dependencies()
prometheus_register_toolchains(version = "2.43.1")
alertmanager_register_toolchains(version = "0.24.0")

local_repository(
    name = "io_bazel_rules_prometheus_examples",
    path = "examples",
)
