load("@bazel_skylib//lib:shell.bzl", "shell")


def _alertmanager_config_test_impl(ctx):
  tool = ctx.toolchains["@rules_prometheus//:alertmanager_toolchain_type"].amtool
  cmd = tool.path + " check-config {srcs}".format(
      srcs = " ".join([shell.quote(src.path) for src in ctx.files.srcs]),
  )
  executable = ctx.actions.declare_file(ctx.label.name)
  ctx.actions.write(
      output = executable,
      content = cmd,
  )

  runfiles = ctx.runfiles(files = ctx.files.srcs, transitive_files = depset([tool]))
  return [DefaultInfo(runfiles = runfiles, executable=executable)]

alertmanager_config_test = rule(
  implementation = _alertmanager_config_test_impl,
  test = True,
  attrs = {
    "srcs": attr.label_list(
      allow_files = [".json", ".yaml", ".yml"],
      doc = "alertmanager configs to check",
    ),
  },
  toolchains=["@rules_prometheus//:alertmanager_toolchain_type"],
  doc = "Checks a alertmanager's config file",
)


def _prometheus_rule_test_impl(ctx):
  tool = ctx.toolchains["@rules_prometheus//:prometheus_toolchain_type"].promtool
  cmd = tool.path + " test rules {flags} {rule_test}".format(
      srcs = " ".join([shell.quote(src.path) for src in ctx.files.srcs]),
      rule_test = shell.quote(ctx.file.rule_test.path),
      flags = " ".join([shell.quote(flag) for flag in ctx.attr.flags])
  )
  executable = ctx.actions.declare_file(ctx.label.name)
  ctx.actions.write(
      output = executable,
      content = cmd,
  )

  runfiles = ctx.runfiles(files = ctx.files.srcs + [ctx.file.rule_test], transitive_files = depset([tool]))
  return [DefaultInfo(runfiles = runfiles, executable=executable)]

prometheus_rule_test = rule(
  implementation = _prometheus_rule_test_impl,
  test = True,
  attrs = {
    "srcs": attr.label_list(
      allow_files = [".json", ".yaml", ".yml"],
      doc = "prometheus configs to check",
    ),
    "rule_test": attr.label(
        allow_single_file = True,
        doc = "https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/",
    ),
    "flags": attr.string_list(
       doc = "The flag list for promtool command"
    )
  },
  toolchains=["@rules_prometheus//:prometheus_toolchain_type"],
  doc = "Checks a prometheus's config file",
)


def _alertmanager_route_test_impl(ctx):
  tool = ctx.toolchains["@rules_prometheus//:alertmanager_toolchain_type"].amtool
  cmd = tool.path + " config routes test --config.file={src} --tree --verify.receivers={exp_receiver} {label_matchs}".format(
      src = shell.quote(ctx.file.src.path),
      exp_receiver = shell.quote(ctx.attr.exp_receiver),
      label_matchs= " ".join([shell.quote(label) for label in ctx.attr.match_labels]),

  )
  executable = ctx.actions.declare_file(ctx.label.name)
  ctx.actions.write(
      output = executable,
      content = cmd,
  )

  runfiles = ctx.runfiles(files = [ctx.file.src], transitive_files = depset([tool]))
  return [DefaultInfo(runfiles = runfiles, executable=executable)]


alertmanager_route_test = rule(
  implementation = _alertmanager_route_test_impl,
  test = True,
  attrs = {
    "src": attr.label(
      # allow_files = [".json", ".yaml", ".yml"],
      allow_single_file = True,
      doc = "alertmanager configs to check",
    ),
    "match_labels": attr.string_list(
      doc = "labels to match receiver"
    ),
    "exp_receiver": attr.string(
      mandatory = True,
      doc = "except reciever"

    )
  },
  toolchains=["@rules_prometheus//:alertmanager_toolchain_type"],
  doc = "run amtool config routes test command"
)