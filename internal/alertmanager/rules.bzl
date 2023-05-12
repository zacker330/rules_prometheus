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

def _alertmanager_route_test_impl(ctx):
  tool = ctx.toolchains["@rules_prometheus//:alertmanager_toolchain_type"].amtool
  cmd = tool.path + " config routes test --config.file={src} --tree --verify.receivers={exp_receivers} {label_matchs}".format(
      src = shell.quote(ctx.file.src.path),
      exp_receivers = ",".join([shell.quote(receiver) for receiver in ctx.attr.exp_receivers]),
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
    "exp_receivers": attr.string_list(
      mandatory = True,
      doc = "except recievers"

    )
  },
  toolchains=["@rules_prometheus//:alertmanager_toolchain_type"],
  doc = "run amtool config routes test command"
)