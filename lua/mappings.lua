local utils = require("utils")
local map = vim.keymap.set

map("n", "<Leader><Tab>", "<C-^>", { desc = "alternative buffer" })
map("n", "<C-s>", ":w<cr>", { silent = true })
map("n", "<Leader>w", ":w<cr>", { silent = true })

map("n", "<M-n>", ":bnext<cr>", { silent = true })
map("n", "<M-p>", ":bprev<cr>", { silent = true })

map("n", "H", "^")
map("n", "L", "$")

map("n", "'", "`")
map("n", "`", "'")

map("v", "x", '"_dP')

map("n", "gp", "`[v`]", { desc = "reselect pasted text" })
map({ "n", "v" }, "mp", '"0p', { desc = "paste from 0 register" })

map("n", "cn", ":cnext<CR>", { silent = true })
map("n", "cp", ":cprev<CR>", { silent = true })
map("n", "co", ":copen<CR>", { silent = true })
map("n", "cq", utils.close_diagnostics, { desc = "close diagnostics", silent = true })
map("n", "cu", utils.jumps_to_qf, { desc = "jumps to qf", silent = true })

map("n", "<Leader>ll", ":Lazy<cr>", { desc = "lazy", silent = true })
map("n", "<Leader>lt", utils.get_linters, { desc = "lint progress", silent = true })
map("n", "<Leader>lp", ":Lazy profile<cr>", { desc = "lazy profile", silent = true })
map("n", "<Leader>li", ":LspInfo<cr>", { desc = "lspinfo", silent = true })
map("n", "<Leader>lm", ":Mason<cr>", { desc = "Mason", silent = true })
map("n", "<Leader>lc", ":ConformInfo<cr>", { desc = "conform info", silent = true })
map("n", "<Leader>ud", utils.toggle_diagnostics, { desc = "toggle diagnostics" })

map("i", "<C-l>", "<Right>")
map("i", "<C-h>", "<Left>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
map("i", "<C-s>", "<Esc>:w<Cr>")
map("i", "<M-h>", "<Esc>I")
map("i", "<M-l>", "<End>")

map("v", ":s", ":s/\\%V")

local ufo_ok, ufo = pcall(require, "ufo")
if ufo_ok then
  local map_ufo = function(key, fn, desc)
    map("n", key, function()
      fn()
    end, { desc = desc })
  end

  map_ufo("zR", ufo.openAllFolds, "open all folds")
  map_ufo("zM", ufo.closeAllFolds, "close all folds")
  map_ufo("zr", ufo.openFoldsExceptKinds, "fold less")
  map_ufo("zm", ufo.closeFoldsWith, "fold more")
  map_ufo("zp", ufo.peekFoldedLinesUnderCursor, "peek fold")
end
