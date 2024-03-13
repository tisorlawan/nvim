local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  require("plugins.colorscheme"),
  require("plugins.treesitter"),
  require("plugins.which-key"),
  require("plugins.telescope"),
  require("plugins.filetree"),
  require("plugins.mini"),
  require("plugins.leap"),
  require("plugins.pairs"),
  require("plugins.lualine"),
  require("plugins.smart-split"),
  require("plugins.colorizer"),
  require("plugins.ufo"),
  require("plugins.aerial"),
  require("plugins.surround"),
  require("plugins.undotree"),
  require("plugins.git"),
  require("plugins.misc"),
  require("plugins.lsp"),
  require("plugins.conform"),
  require("plugins.nvim-lint"),
  require("plugins.arrow"),
  require("plugins.mason-tool-installer"),
  require("plugins.autotag"),
  require("plugins.multicursor"),
  require("plugins.langs.just"),
  require("plugins.codium"),
}

local ft_plugins = {
  rust = require("plugins.langs.rust"),
  go = require("plugins.langs.go"),
  python = require("plugins.langs.python"),
  markdown = require("plugins.langs.markdown"),
  typescript = require("plugins.langs.typescript"),
  norg = require("plugins.langs.neorg"),
}

local used_ft = require("installer").used_ft
for ft, plugin in pairs(ft_plugins) do
  if require("utils").contains(used_ft, ft) then
    table.insert(plugins, plugin)
  end
end

require("lazy").setup(plugins)
