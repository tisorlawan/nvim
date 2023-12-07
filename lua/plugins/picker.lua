return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", silent = true, desc = "Files" },
    { "<leader>fh", "<cmd>lua require('fzf-lua').help_tags()<CR>", silent = true, desc = "Help" },
    { "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", silent = true, desc = "Bbuffers" },
    { "<leader>fn", "<cmd>lua require('fzf-lua').builtin()<CR>", silent = true, desc = "Builtin" },
    {
      "<leader>fw",
      "<cmd>lua require('fzf-lua').live_grep_native()<CR>",
      silent = true,
      desc = "Live Grep [Word]",
    },
    { "<leader>*", "<cmd>lua require('fzf-lua').grep_cword()<CR>", silent = true, desc = "Grep cword" },
    {
      mode = "x",
      "<leader>q",
      "<cmd>lua require('fzf-lua').grep_visual()<CR>",
      silent = true,
      desc = "Grep visual",
    },
    { "<leader>fs", "<cmd>lua require('fzf-lua').git_status()<CR>", silent = true, desc = "Git status" },
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
