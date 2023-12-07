return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Tree Toggle" },
      { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "Tree Focus" },
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = false,
        hijack_netrw = false,
        view = {
          number = true,
          relativenumber = true,
        },
        filters = {
          custom = { ".git" },
        },
      })
    end,
  },
  {
    "justinmk/vim-dirvish",
    event = "VeryLazy",
    dependencies = {
      "roginfarrer/vim-dirvish-dovish",
    },
    lazy = false,
  },
}
