workspace(name = "rules_prometheus")
load("//:deps.bzl", "prometheus_rules_dependencies", "alertmanager_dependencies", "prometheus_dependencies")

prometheus_rules_dependencies()

alertmanager_dependencies(
    sha256 = "e9fa07f094b8efa3f1f209dc7d51a7cf428574906c7fd8eac9a3aed08b03ed63", 
    urls = ["https://github.com/prometheus/alertmanager/releases/download/v0.25.0/alertmanager-0.25.0.darwin-amd64.tar.gz"]
)

prometheus_dependencies(
    sha256 = "a5d5633c9a9250d480f83595fcac37b47ec3bd9e08d237a971e60db541f96315",
    urls = [
        "https://github.com/prometheus/prometheus/releases/download/v2.43.1/prometheus-2.43.1.darwin-amd64.tar.gz"
    ],
)
