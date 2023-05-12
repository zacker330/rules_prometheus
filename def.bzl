load("//internal/alertmanager:rules.bzl", _alertmanager_config_test = "alertmanager_config_test",  _alertmanager_route_test = "alertmanager_route_test")
load("//internal/prometheus:rules.bzl", _prometheus_rule_test = "prometheus_rule_test")

load("//internal/prometheus:toolchains.bzl",  _prometheus_toolchain = "prometheus_toolchain")
load("//internal/alertmanager:toolchains.bzl", _alertmanager_toolchain = "alertmanager_toolchain", )

alertmanager_toolchain = _alertmanager_toolchain

prometheus_toolchain = _prometheus_toolchain

alertmanager_config_test = _alertmanager_config_test

prometheus_rule_test = _prometheus_rule_test

alertmanager_route_test = _alertmanager_route_test
