return {
  "sphamba/smear-cursor.nvim",
  opts = {},
  config = function()
    require("smear_cursor").setup({
      --cursor_color = "#ff8800",
      --stiffness = 0.3,
      --trailing_stiffness = 0.1,
      --trailing_exponent = 5,
      --hide_target_hack = true,
      --gamma = 1,
    })
  end,
}
