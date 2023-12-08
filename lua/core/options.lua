vim.g.transparent = true

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 6

vim.opt.virtualedit = "block"

vim.opt.inccommand = "split"

vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.statuscolumn = "%s%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . ' ' : v:lnum) : ''}%="
vim.opt.signcolumn = "yes"

vim.opt.undodir = vim.fn.expand("$HOME/.undodir")
vim.opt.undofile = true
