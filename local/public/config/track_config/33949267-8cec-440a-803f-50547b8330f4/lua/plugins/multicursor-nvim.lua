return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- Add or skip adding a new cursor by matching word/selection
    set({ "n", "x" }, "<leader>cn", function()
      mc.matchAddCursor(1)
    end)
    set({ "n", "x" }, "<leader>cN", function()
      mc.matchAddCursor(-1)
    end)
    set({ "n", "x" }, "<leader>s", function()
      mc.matchSkipCursor(1)
    end)
    set({ "n", "x" }, "<leader>S", function()
      mc.matchSkipCursor(-1)
    end)

    set({ "n", "x" }, "<leader>np", function()
      mc.lineAddCursor(-1)
    end)
    set({ "n", "x" }, "<leader>nl", function()
      mc.lineAddCursor(1)
    end)
    set({ "n", "x" }, "<leader>Np", function()
      mc.lineSkipCursor(-1)
    end)
    set({ "n", "x" }, "<leader>Nl", function()
      mc.lineSkipCursor(1)
    end)

    -- Disable and enable cursors.
    set({ "n", "x" }, "<c-q>", mc.toggleCursor)

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Add or skip cursor above/below the main cursor.
      --layerSet({ "n", "x" }, "<leader>np", function()
      --  mc.lineAddCursor(-1)
      --end)
      --layerSet({ "n", "x" }, "<leader>nl", function()
      --  mc.lineAddCursor(1)
      --end)
      --layerSet({ "n", "x" }, "<leader>Np", function()
      --  mc.lineSkipCursor(-1)
      --end)
      --layerSet({ "n", "x" }, "<leader>Nl", function()
      --  mc.lineSkipCursor(1)
      --end)

      -- Select a different cursor as the main one.
      layerSet({ "n", "x" }, "<leader>nc", mc.nextCursor)
      layerSet({ "n", "x" }, "<leader>pc", mc.prevCursor)

      -- Delete the main cursor.
      layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

      -- Enable and clear cursors using escape.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
