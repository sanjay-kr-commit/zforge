local opts = {
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  default_file_explorer = true,
  watch_for_changes = true,
  view_options = {
    show_hidden = true,
  },
}

return {
  "stevearc/oil.nvim",
  opts = opts,
  keys = {
    {
      "<leader>o",
      function()
        if vim.bo.filetype == "oil" then
          vim.notify("Already in Oil", vim.log.levels.WARN)
          return
        end
        local dir = vim.fn.expand("%:p:h")
        -- vim.notify("Opening: " .. dir)
        vim.cmd("tabnew")
        require("oil").open(dir, {})
      end,
      --"<cmd>tabnew | Oil<CR>",
      desc = "Open Oil In New Tab",
    },
  },
  -- Optional dependencies
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}

--local oil_preview_group = vim.api.nvim_create_augroup("OilAutoPreview", {})
--
--vim.api.nvim_create_autocmd("FileType", {
--  pattern = "oil",
--  callback = function(args)
--    vim.api.nvim_create_autocmd("CursorMoved", {
--      group = oil_preview_group,
--      buffer = args.buf,
--      once = true,
--      callback = function()
--        vim.schedule(function()
--          require("oil.actions").preview.callback({
--            vertical = true,
--          })
--        end)
--      end,
--    })
--  end,
--})
