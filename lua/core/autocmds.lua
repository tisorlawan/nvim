vim.api.nvim_create_autocmd("FileType", {
  desc = "Add semicolon",
  pattern = "rust,c,typescriptreact",
  group = vim.api.nvim_create_augroup("add_semicolon", { clear = true }),
  callback = function(opts)
    vim.keymap.set("i", "<C-d>", "<End>;", { silent = true, buffer = opts.buf })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  pattern = "*",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "2 spaces",
  pattern = "lua",
  group = vim.api.nvim_create_augroup("two_spaces", { clear = true }),
  callback = function()
    vim.opt.expandtab = true
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
  end,
})
