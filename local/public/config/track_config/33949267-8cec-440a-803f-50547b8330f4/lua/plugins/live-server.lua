return {
  "https://git.barrettruth.com/barrettruth/live-server.nvim",
  init = function()
    vim.g.live_server = {
      port = 8080,
      browser = flase,
    }
  end,
}
