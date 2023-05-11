



def _prometheus_toolchain_impl(ctx):
    promtool_cmd = None
    for f in ctx.files.tools:
        if f.path.endswith("/promtool") or f.path.endswith("/promtool.exe"):
            promtool_cmd = f
            break
    if not promtool_cmd:
        fail("could not locate promtool command")

    prometheus_cmd = None
    for f in ctx.files.tools:
        if f.path.endswith("/prometheus") or f.path.endswith("/prometheus.exe"):
            prometheus_cmd = f
            break
    if not prometheus_cmd:
        fail("could not locate prometheus command")

    return [platform_common.ToolchainInfo(
          promtool = promtool_cmd,
          prometheus = prometheus_cmd
    )]



def _alertmanager_toolchain_impl(ctx):
    promtool_cmd = None
    for f in ctx.files.tools:
        if f.path.endswith("/amtool") or f.path.endswith("/amtool.exe"):
            promtool_cmd = f
            break
    if not promtool_cmd:
        fail("could not locate amtool command")

    prometheus_cmd = None
    for f in ctx.files.tools:
        if f.path.endswith("/alertmanager") or f.path.endswith("/alertmanager.exe"):
            prometheus_cmd = f
            break
    if not prometheus_cmd:
        fail("could not locate alertmanager command")

    return [platform_common.ToolchainInfo(
          amtool = promtool_cmd,
          alertmanager = prometheus_cmd
    )]



prometheus_toolchain = rule(
  implementation = _prometheus_toolchain_impl,
  attrs = {
      "tools": attr.label_list(
          mandatory = True,
      ),
  },
  doc = "promtool and prometheus command",
  provides = [platform_common.ToolchainInfo],

)


alertmanager_toolchain = rule(
  implementation = _alertmanager_toolchain_impl,
  attrs = {
      "tools": attr.label_list(
          mandatory = True,
      ),
  },
  doc = "amtool and alertmanager command",
  provides = [platform_common.ToolchainInfo],

)