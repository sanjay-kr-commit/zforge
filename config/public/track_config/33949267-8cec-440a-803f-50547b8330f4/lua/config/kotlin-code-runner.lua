return function()
  local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p")
  local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
  vim.cmd("w")
  vim.cmd(
    "split | terminal " .. require("lib.std").home() .. "/.config/nvim/lua/bash/kotlinc.sh " .. dir .. " " .. filepath
  )
end
