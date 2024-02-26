vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.cursorline = true

vim.opt.wrap = false

vim.opt.cmdheight = 1

vim.opt.expandtab = true
vim.opt.tabstop = 4 -- interpret a tab as 4 spaces
vim.opt.shiftwidth = 4 -- indent and dedent with 4 spaces

vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 8

vim.opt.swapfile = false

vim.opt.virtualedit = "block" -- for better visual block

vim.opt.inccommand = "split"

vim.opt.ignorecase = true

vim.opt.termguicolors = true -- enable 24 bit color depth support

vim.opt.statuscolumn = "%s%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . ' ' : v:lnum) : ''}%="
vim.opt.signcolumn = "yes"

vim.opt.undodir = vim.fn.expand("$HOME/.undodir")
vim.opt.undofile = true

vim.opt.mouse = "a"

-- Wildignore for better experience
vim.opt.wildignorecase = true
vim.opt.wildignore:append("**/node_modules/*")
vim.opt.wildignore:append("**/.git/*")
vim.opt.wildignore:append("**/build/*")

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = vim.fn.has("nvim-0.9") == 1 and "1" or nil
