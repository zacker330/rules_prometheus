# Installation



# Usage

```python 
load("@rules_prometheus//:def.bzl","alertmanager_config_test", "prometheus_rule_test", "alertmanager_route_test")

alertmanager_config_test(
  name = "simple_test",
  srcs = ["simple.yaml","simple2.json"],
)

alertmanager_route_test(
  name = "route_test",
  src = "simple.yaml",
  exp_receiver = "team-X-pager",
  match_labels = ["service=database", "owner=team-X"]
)

prometheus_rule_test(
  name = "prometheus_test",
  srcs = ["prometheus-sample.yaml"],
  rule_test = "promtool-rule.yaml",
)
```