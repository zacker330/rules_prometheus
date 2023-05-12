load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//internal/prometheus:repos.bzl", "prometheus_download_rule")
load("//internal/alertmanager:repos.bzl","alertmanager_download_rule")




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
    prometheus_download_rule(name = "prometheus_register_toolchains", version=version, urls=urls)
    native.register_toolchains(
        "@prometheus_register_toolchains//:toolchain",
    )

def alertmanager_register_toolchains(version = None, urls = None):
    alertmanager_download_rule(name = "alertmanager_register_toolchains", version=version, urls=urls)
    native.register_toolchains(
        "@alertmanager_register_toolchains//:toolchain",
    )


    # _alertmanager_toolchains(
    #     name = name + "_toolchains",
    #     alertmanager_repo = name,
    #     sdk_version = kwargs.get("version"),
    #     goos = kwargs.get("goos"),
    #     goarch = kwargs.get("goarch"),
    # )
    # if register_toolchains:
    #     _register_toolchains(name)