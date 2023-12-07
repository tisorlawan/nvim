vim.api.nvim_create_autocmd("FileType", {
  desc = "Add semicolon",
  pattern = "rust,c",
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
