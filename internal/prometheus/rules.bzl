load("@bazel_skylib//lib:shell.bzl", "shell")



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
