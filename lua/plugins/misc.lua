return {
  { "farmergreg/vim-lastplace" }, -- restore cursor position
  { "romainl/vim-cool" },
  {
    "Aasim-A/scrollEOF.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("scrollEOF").setup()
    end,
  },
  {
    "nacro90/numb.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("numb").setup({
        show_numbers = true,
        show_cursorline = true,
      })
    end,
  },

  { "wintermute-cell/gitignore.nvim", cmd = "Gitignore" },
  {
    "lambdalisue/suda.vim",
    keys = { { "<leader>W", ":SudaWrite<CR>", desc = "suda write" } },
    cmd = {
      "SudaRead",
      "SudaWrite",
    },
  },
  { "folke/todo-comments.nvim", opts = {}, event = { "BufReadPre", "BufNewFile" } },
  { "kevinhwang91/nvim-bqf", ft = "qf", opts = {} },
  { "nmac427/guess-indent.nvim", opts = {}, event = { "BufReadPre" } },
}
