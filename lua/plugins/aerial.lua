return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({})

      vim.keymap.set("n", "<leader>ls", "<cmd>Telescope aerial<Cr>", { desc = "Outline Telescope" })
    end,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>lS", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
  },
}
