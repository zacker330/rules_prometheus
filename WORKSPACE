workspace(name = "rules_prometheus")
load("//:deps.bzl", "rules_prometheus_dependencies", "prometheus_register_toolchains", "alertmanager_register_toolchains")

rules_prometheus_dependencies()
prometheus_register_toolchains(version = "2.43.1")
alertmanager_register_toolchains(version = "0.24.0")

