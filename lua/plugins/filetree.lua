return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "tree toggle" },
      { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "tree focus" },
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
