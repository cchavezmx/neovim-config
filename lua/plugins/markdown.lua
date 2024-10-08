return {
  "iamcco/markdown-preview.nvim",
  config = function()
    vim.g.mkdp_auto_start = 1
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 1
    vim.g.mkdp_command_for_global = 0
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_browser = "firefox"
    vim.g.mkdp_preview_options = {
      mkit = {},
      katex = {},
      uml = {},
      disable_sync_scroll = 0,
      sync_scroll_type = "middle",
      hide_yaml_meta = 1,
      sequence_diagrams = {},
      flowchart_diagrams = {},
    }
  end,
}
