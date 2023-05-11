load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//internal:repos.bzl", "alertmanager_download", "prometheus_download")

def prometheus_rules_dependencies():
    _maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz",
        ],
        sha256 = "74d544d96f4a5bb630d465ca8bbcfe231e3594e5aae57e1edbf17a6eb3ca2506",
    )

def alertmanager_dependencies(sha256, urls):
    alertmanager_repo_name = ("alertmanager_dependencies"  + sha256)
    alertmanager_download(
        name = alertmanager_repo_name,
        sha256 = sha256,
        urls = urls,
    )

    native.register_toolchains(
        "@"+ alertmanager_repo_name +"//:toolchain",
    )


def prometheus_dependencies(sha256, urls):
    prometheus_repo_name = "prometheus_dependencies" + sha256
    prometheus_download(
        name = prometheus_repo_name,
        sha256 = sha256,
        urls = urls,
    )

    native.register_toolchains(
        "@"+ prometheus_repo_name +"//:toolchain",
    )


def _maybe(rule, name, **kwargs):
    """Declares an external repository if it hasn't been declared already."""
    if name not in native.existing_rules():
        rule(name = name, **kwargs)
