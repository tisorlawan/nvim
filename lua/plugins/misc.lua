return {
  { "farmergreg/vim-lastplace" }, -- restore cursor position
  { "romainl/vim-cool" },
  { "ton/vim-bufsurf" },
  { "haya14busa/vim-asterisk" },
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
  {
    "johnfrankmorgan/whitespace.nvim",
    config = function()
      require("whitespace-nvim").setup({
        -- highlight = "NvimInternalError",
        highlight = "DiffDelete",
        ignored_filetypes = { "TelescopePrompt", "Trouble", "help", "lazy", "mason", "lspinfo" },
        ignore_terminal = true,
        return_cursor = true,
      })

      vim.keymap.set("n", "<Leader>t", require("whitespace-nvim").trim, { desc = "Trim Whitespace" })
    end,
  },
}
