return {
  {
    "echasnovski/mini.indentscope",
    ft = { "python" },
    config = function()
      require("mini.indentscope").setup({
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
        },
        symbol = "│",
      })
    end,
  },
  {
    "echasnovski/mini.nvim",
    ---@diagnostic disable-next-line: assign-type-mismatch
    version = false,
    config = function()
      -- require("mini.hues").setup({ background = "#262630", foreground = "#d0d0d0", saturation = "medium" })
      -- require("mini.move").setup()
      -- require("mini.jump").setup()
      require("mini.bufremove").setup()

      vim.keymap.set("n", "<leader>c", MiniBufremove.delete, { desc = "delete buffer" })
      vim.keymap.set("n", "<leader>C", MiniBufremove.wipeout, { desc = "wipeout buffer" })
    end,
  },
}
