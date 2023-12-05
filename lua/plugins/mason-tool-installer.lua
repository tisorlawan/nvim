local m = require("installer")

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  event = "VeryLazy",
  opts = {
    ensure_installed = vim.list_extend(m.mason_linter_install, m.mason_formatter_install),
  },
}
