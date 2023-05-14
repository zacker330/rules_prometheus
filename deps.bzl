load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@io_bazel_rules_prometheus//internal/prometheus:repos.bzl", "prometheus_download_rule")
load("@io_bazel_rules_prometheus//internal/alertmanager:repos.bzl","alertmanager_download_rule")
load("@io_bazel_rules_prometheus//internal/prometheus:prometheus_versions.bzl", "DEFAULT_AVAILABLE_PROMETHEUS_BINARIES")
load("@io_bazel_rules_prometheus//internal/alertmanager:alertmanager_versions.bzl", "DEFAULT_AVAILABLE_ALERTMANAGER_BINARIES")




def _maybe(rule, name, **kwargs):
    """Declares an external repository if it hasn't been declared already."""
    if name not in native.existing_rules():
        rule(name = name, **kwargs)


def rules_prometheus_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
        ],
        sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
    )

def prometheus_register_toolchains(version = None, urls = None):
    for key in DEFAULT_AVAILABLE_PROMETHEUS_BINARIES:
        if key[0] == version:
            platform = key[1]
            os, _, arch = platform.partition("-")
            name = "prometheus_register_toolchains_" + platform
            prometheus_download_rule(name = name, version=version, urls=urls, os = os, arch = arch)
            native.register_toolchains(
                "@"+ name +"//:toolchain",
            )

def alertmanager_register_toolchains(version = None, urls = None):
    for key in DEFAULT_AVAILABLE_ALERTMANAGER_BINARIES:
        if key[0] == version:
            platform = key[1]
            os, _, arch = platform.partition("-")
            name = "alertmanager_register_toolchains_" + platform

            alertmanager_download_rule(name = name, version=version, urls=urls, os=os, arch=arch)
            native.register_toolchains(
                "@"+ name +"//:toolchain",
            )

