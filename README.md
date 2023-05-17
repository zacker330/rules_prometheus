# Overview

The aim of the rules are for validating or testing the configurations of Prometheus and Alertmanger via promtool and amtool.

# Installation

```python

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_prometheus",
    sha256 = "<please have a look at Release>",
    urls = [ "<please have a look at Release>" ],
)

load("@io_bazel_rules_prometheus//:deps.bzl", "rules_prometheus_dependencies", "prometheus_register_toolchains", "alertmanager_register_toolchains")
rules_prometheus_dependencies()
prometheus_register_toolchains(version = "2.43.1") 
alertmanager_register_toolchains(version = "0.24.0")

```

# Usage



```python 

load("@io_bazel_rules_prometheus//:def.bzl","alertmanager_config_test", "prometheus_rule_test", "alertmanager_route_test")

alertmanager_config_test(
  name = "simple_test",
  srcs = ["simple.yaml","simple2.json"],
)

alertmanager_route_test(
  name = "route_test",
  src = "simple.yaml",
  exp_receivers = "team-X-pager",
  match_labels = ["service=database", "owner=team-X"]
)

prometheus_rule_test(
  name = "prometheus_test",
  srcs = ["prometheus-sample.yaml"],
  rule_test = "promtool-rule.yaml",
)
```

May be you would like to use Jsonnet format instead of YAML or JSON format as the configuration of Promtheus or Alertmanager. There're a few examples in `examples` folder, you can have a look at that.