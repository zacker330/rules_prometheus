workspace(name = "io_bazel_rules_prometheus")
load("@io_bazel_rules_prometheus//:deps.bzl", "rules_prometheus_dependencies", "prometheus_register_toolchains", "alertmanager_register_toolchains")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "platforms",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.6/platforms-0.0.6.tar.gz",
        "https://github.com/bazelbuild/platforms/releases/download/0.0.6/platforms-0.0.6.tar.gz",
    ],
    sha256 = "5308fc1d8865406a49427ba24a9ab53087f17f5266a7aabbfc28823f3916e1ca",
)


http_archive(
    name = "io_bazel_rules_jsonnet",
    sha256 = "d20270872ba8d4c108edecc9581e2bb7f320afab71f8caa2f6394b5202e8a2c3",
    strip_prefix = "rules_jsonnet-0.4.0",
    urls = ["https://github.com/bazelbuild/rules_jsonnet/archive/0.4.0.tar.gz"],
)

http_archive(
    name = "jsonnet",
    sha256 = "85c240c4740f0c788c4d49f9c9c0942f5a2d1c2ae58b2c71068107bc80a3ced4",
    strip_prefix = "jsonnet-0.18.0",
    urls = [
        "https://github.com/google/jsonnet/archive/v0.18.0.tar.gz",
    ],
)

http_archive(
    name = "google_jsonnet_go",
    sha256 = "20fdb3599c2325fb11a63860e7580705590faf732abf47ed144203715bd03a70",
    strip_prefix = "go-jsonnet-0d78479d37eabd9451892dd02be2470145b4d4fa",
    urls = ["https://github.com/google/go-jsonnet/archive/0d78479d37eabd9451892dd02be2470145b4d4fa.tar.gz"],
)


load("@google_jsonnet_go//bazel:repositories.bzl", "jsonnet_go_repositories")

jsonnet_go_repositories()

load("@google_jsonnet_go//bazel:deps.bzl", "jsonnet_go_dependencies")

jsonnet_go_dependencies(go_sdk_version='1.18.2')


rules_prometheus_dependencies()
prometheus_register_toolchains(version = "2.43.1")
alertmanager_register_toolchains(version = "0.24.0")
