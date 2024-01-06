require("core.options")

-- #PLUGINS
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

require("lazy").setup({
  -- require("plugins.colorscheme"),
  require("plugins.treesitter"),
  require("plugins.status"),
  require("plugins.mini"),
  require("plugins.surround"),
  require("plugins.filetree"),
  require("plugins.pairs"),
  require("plugins.git"),
  require("plugins.which-key"),
  require("plugins.leap"),
  require("plugins.undo"),
  require("plugins.picker"),
  require("plugins.split"),
  require("plugins.misc"),
  require("plugins.colorizer"),
  require("plugins.harpoon"),
  require("plugins.outline"),
  require("plugins.fold"),

  require("plugins.rust"),
  require("plugins.go"),
  require("plugins.typescript"),
  require("plugins.markdown"),

  require("lsp"),
  require("linter-formatter"),
})

require("core.mappings")
require("core.autocmds")
require("core.filetypes")
