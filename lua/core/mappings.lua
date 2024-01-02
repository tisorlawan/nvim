local utils = require("utils")

vim.keymap.set("n", "<leader><tab>", "<c-^>", { desc = "alternative buffer" })
vim.keymap.set("n", "<c-s>", ":w<cr>", { silent = true })
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, desc = "write buffer" })

vim.keymap.set("n", "<m-n>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<m-p>", ":bprev<cr>", { silent = true })

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")

vim.keymap.set("i", "<c-l>", "<right>")
vim.keymap.set("i", "<c-h>", "<left>")
vim.keymap.set("i", "<c-j>", "<down>")
vim.keymap.set("i", "<c-k>", "<up>")
vim.keymap.set("i", "<c-s>", "<esc>:w<cr>")
vim.keymap.set("i", "<m-h>", "<esc>I")
vim.keymap.set("i", "<m-l>", "<end>")

-- vim.keymap.set({ "n", "v" }, "c", '"_c')
-- vim.keymap.set({ "n", "v" }, "C", '"_C')

vim.keymap.set("v", "x", '"_dP')

vim.keymap.set("n", "cn", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "cp", ":cprev<CR>", { silent = true })
vim.keymap.set("n", "co", ":copen<CR>", { silent = true })
vim.keymap.set("n", "cq", utils.close_diagnostics, { desc = "close diagnostics", silent = true })
vim.keymap.set("n", "cu", utils.jumps_to_qf, { desc = "jumps to qf", silent = true })

vim.keymap.set("n", "<leader>ll", ":Lazy<cr>", { desc = "lazy", silent = true })
vim.keymap.set("n", "<leader>lt", utils.get_linters, { desc = "lint progress", silent = true })
vim.keymap.set("n", "<leader>lp", ":Lazy profile<cr>", { desc = "lazy profile", silent = true })
vim.keymap.set("n", "<leader>li", ":LspInfo<cr>", { desc = "lspinfo", silent = true })
vim.keymap.set("n", "<leader>lm", ":Mason<cr>", { desc = "Mason", silent = true })
vim.keymap.set("n", "<leader>lc", ":ConformInfo<cr>", { desc = "conform info", silent = true })

vim.keymap.set("n", "<leader>ud", utils.toggle_diagnostics, { desc = "toggle diagnostics" })

vim.keymap.set("n", "gp", "`[v`]", { desc = "reselect pasted text" })

local ufo_ok, ufo = pcall(require, "ufo")
if ufo_ok then
  local map_ufo = function(key, fn, desc)
    vim.keymap.set("n", key, function()
      fn()
    end, { desc = desc })
  end

  map_ufo("zR", ufo.openAllFolds, "open all folds")
  map_ufo("zM", ufo.closeAllFolds, "close all folds")
  map_ufo("zr", ufo.openFoldsExceptKinds, "fold less")
  map_ufo("zm", ufo.closeFoldsWith, "fold more")
  map_ufo("zp", ufo.peekFoldedLinesUnderCursor, "peek fold")
end

vim.cmd([[
  xnoremap <expr> p 'pgv"'.v:register.'y`>'
  xnoremap <expr> P 'Pgv"'.v:register.'y`>'
]])

vim.keymap.set("v", ":s", ":s/\\%V")
