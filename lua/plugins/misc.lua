return {
  -- restore cursor position
  { "farmergreg/vim-lastplace" },
  { "romainl/vim-cool" },
  {
    "famiu/bufdelete.nvim",
    config = function()
      vim.keymap.set("n", "<leader>c", function()
        require("bufdelete").bufdelete(0, true)
      end, { desc = "close buffer" })
    end,
  },
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
