local utils = require("utils")

vim.keymap.set("n", "<leader><tab>", "<c-^>", { desc = "alternative buffer" })
vim.keymap.set("n", "<c-s>", ":w<cr>", { silent = true })
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, desc = "Write buffer" })
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-j>", "<c-w>j")

vim.keymap.set("n", "<m-n>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<m-p>", ":bprev<cr>", { silent = true })

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")

vim.keymap.set("i", "<c-l>", "<right>")
vim.keymap.set("i", "<c-h>", "<left>")
vim.keymap.set("i", "<c-s>", "<esc>:w<cr>")
vim.keymap.set("i", "<m-h>", "<esc>I")
vim.keymap.set("i", "<m-l>", "<end>")

vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')

vim.keymap.set("v", "x", '"_dP')

vim.keymap.set("n", "cn", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "cp", ":cprev<CR>", { silent = true })
vim.keymap.set("n", "co", ":copen<CR>", { silent = true })
vim.keymap.set("n", "cq", utils.close_diagnostics, { desc = "Close Diagnostics", silent = true })
vim.keymap.set("n", "cu", utils.jumps_to_qf, { desc = "Jumps to Qf", silent = true })

vim.cmd([[
  xnoremap <expr> p 'pgv"'.v:register.'y`>'
  xnoremap <expr> P 'Pgv"'.v:register.'y`>'
]])
