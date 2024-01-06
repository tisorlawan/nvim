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

vim.opt.ignorecase = false

vim.opt.termguicolors = true

vim.opt.swapfile = false
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

vim.opt.foldenable = true -- enable fold for nvim-ufo
vim.opt.foldlevel = 99 -- set high foldlevel for nvim-ufo
vim.opt.foldlevelstart = 99 -- start with all code unfolded
vim.opt.foldcolumn = vim.fn.has("nvim-0.9") == 1 and "1" or nil -- show foldcolumn in nvim 0.9
