return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ff", "<cmd>lua require('fzf-lua').files()<cr>", silent = true, desc = "files" },
    { "<leader>fh", "<cmd>lua require('fzf-lua').help_tags()<cr>", silent = true, desc = "help" },
    { "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<cr>", silent = true, desc = "bbuffers" },
    { "<leader>fn", "<cmd>lua require('fzf-lua').builtin()<cr>", silent = true, desc = "builtin" },
    {
      "<leader>fw",
      "<cmd>lua require('fzf-lua').live_grep_native()<CR>",
      silent = true,
      desc = "live grep [word]",
    },
    { "<leader>*", "<cmd>lua require('fzf-lua').grep_cword()<CR>", silent = true, desc = "grep cword" },
    {
      mode = "x",
      "<leader>q",
      "<cmd>lua require('fzf-lua').grep_visual()<CR>",
      silent = true,
      desc = "grep visual",
    },
    { "<leader>fs", "<cmd>lua require('fzf-lua').git_status()<CR>", silent = true, desc = "git status" },
    { "<leader>ld", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", silent = true, desc = "doc lsp symbols" },
    {
      "<leader>lw",
      "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>",
      silent = true,
      desc = "worksppace lsp symbols",
    },
  },
  config = function()
    -- fix: small delay on closing the window
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "fzf" },
      callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("t", "<C-c>", "<C-c>", { buffer = event.buf, silent = true })
        vim.keymap.set("t", "<Esc>", "<C-c>", { buffer = event.buf, silent = true })
      end,
    })

    require("fzf-lua").setup({
      winopts = {
        preview = { default = "bat_native" },
      },
      files = {
        git_icons = false,
        file_icons = false,
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
    })
  end,
}
