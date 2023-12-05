return {
  "ggandor/leap.nvim",
  keys = {
    { "s", "<Plug>(leap-forward-to)", mode = { "n", "x", "o" }, desc = "leap forward to" },
    { "S", "<Plug>(leap-backward-to)", mode = { "n", "x", "o" }, desc = "leap backward to" },
    { "x", "<Plug>(leap-forward-till)", mode = { "x", "o" }, desc = "leap forward till" },
    { "X", "<Plug>(leap-backward-till)", mode = { "x", "o" }, desc = "leap backward till" },
    { "gs", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "leap from window" },
  },
  opts = {
    safe_labels = "tyuiodfghjklvbn",
    labels = "sfnjklhodweimbuyvrgtqpcxz/SFNJKLHODWEIMBUYVRGTAQPCXZ",
  },
  init = function() -- https://github.com/ggandor/leap.nvim/issues/70#issuecomment-1521177534
    vim.api.nvim_create_autocmd("User", {
      callback = function()
        vim.cmd.hi("Cursor", "blend=100")
        vim.opt.guicursor:append({ "a:Cursor/lCursor" })
      end,
      pattern = "LeapEnter",
    })
    vim.api.nvim_create_autocmd("User", {
      callback = function()
        vim.cmd.hi("Cursor", "blend=0")
        vim.opt.guicursor:remove({ "a:Cursor/lCursor" })
      end,
      pattern = "LeapLeave",
    })
  end,
  dependencies = {
    "tpope/vim-repeat",
  },
}