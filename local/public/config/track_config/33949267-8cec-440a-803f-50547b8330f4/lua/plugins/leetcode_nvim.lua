local leet_arg = "leetcode.nvim"
local homedata = (os.getenv("HOME") or os.getenv("USERPROFILE"))
local homecache = (os.getenv("HOME") or os.getenv("USERPROFILE"))

if homedata ~= nil then
  homedata = homedata .. "/leetcode"
  homecache = homecache .. "/leetcode/.cache"
else
  homedata = vim.fn.stdpath("data") .. "/leetcode"
  homecache = vim.fn.stdpath("cache") .. "/leetcode"
end

return {
  "kawre/leetcode.nvim",
  lazy = leet_arg ~= vim.fn.argv(0, -1),
  build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
  dependencies = {
    "nvim-telescope/telescope.nvim",
    -- "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim",
  },
  opts = {
    ---@type lc.storage
    storage = {
      home = homedata,
      cache = homecache,
    },
    ---@type string
    arg = leet_arg,
    -- configuration goes here
    ---@type boolean
    image_support = true,
    ---@type lc.lang
    lang = "java",
  },
  --keys = {
  --  {
  --    "<leader>lc",
  --    "Leet console<CR>",
  --    desc = "Toggle Leet console",
  --  },
  --},
}
