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

-- Restore cursor last position
local ignore_buftype = { "quickfix", "nofile", "help" }
local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

local function goto_lastplace()
  if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
    return
  end

  if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
    -- reset cursor to first line
    vim.cmd([[normal! gg]])
    return
  end

  -- If a line has already been specified on the command line, we are done
  --   nvim file +num
  if vim.fn.line(".") > 1 then
    return
  end

  local last_line = vim.fn.line([['"]])
  local buff_last_line = vim.fn.line("$")

  -- If the last line is set and the less than the last line in the buffer
  if last_line > 0 and last_line <= buff_last_line then
    local win_last_line = vim.fn.line("w$")
    local win_first_line = vim.fn.line("w0")
    -- Check if the last line of the buffer is the same as the win
    if win_last_line == buff_last_line then
      -- Set line to last line edited
      vim.cmd([[normal! g`"]])
      -- Try to center
    elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
      vim.cmd([[normal! g`"zz]])
    else
      vim.cmd([[normal! G'"<c-e>]])
    end
  end
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
  group = vim.api.nvim_create_augroup("nvim-lastplace", {}),
  callback = goto_lastplace,
})
