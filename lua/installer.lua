local utils = require("utils")

local used_ft = {}

local fpath = vim.fn.stdpath("config") .. "/ft"

-- Check if the file exists
if utils.file_exists(fpath) then
  for line in io.lines(fpath) do
    local trimmed_line = utils.trim(line)
    if trimmed_line:len() > 0 and trimmed_line:sub(1, 1) ~= "#" and trimmed_line:sub(1, 4) ~= "vim:" then
      table.insert(used_ft, trimmed_line)
    end
  end
end

local config = {
  c = {
    formatters = { "clang_format" },
    servers = { "clangd" },
  },
  css = {
    linters = { "stylelint" },
  },
  dockerfile = {
    linters = { "hadolint" },
  },
  go = {
    formatters = { "gofumpt", "goimports", "golines" },
    servers = { "gopls" },
  },
  html = {
    servers = { "html" },
    formatters = { "prettierd" },
    linters = { "htmlhint" },
  },
  javascript = {
    formatters = { "biome" },
  },
  json = {
    formatters = { "biome" },
    linters = { "jsonlint" },
    servers = { "jsonls" },
  },
  lua = {
    formatters = { "stylua" },
    servers = { "lua_ls" },
  },
  markdown = {
    linters = { "markdownlint" },
  },
  python = {
    formatters = { "ruff_format", "ruff_fix" },
    servers = { "pyright", "ruff_lsp" },
  },
  rust = {
    servers = { "rust_analyzer" },
  },
  sh = {
    servers = { "bashls" },
    formatters = { "shfmt" },
  },
  toml = {
    formatters = { "taplo" },
  },
}

local formatters_to_mason = {
  clang_format = "clang-format",
  ruff_fix = "ruff",
  ruff_format = "ruff",
}

local linters_to_mason = {}

local mason_lspserver = {}
for _, ft in pairs(used_ft) do
  for _, name in pairs((config[ft] or {}).servers or {}) do
    table.insert(mason_lspserver, name)
  end
end

local formatters_by_ft = {}
for _, ft in pairs(used_ft) do
  local cfg = (config[ft] or {}).formatters
  if cfg ~= nil then
    formatters_by_ft[ft] = cfg
  end
end

local mason_formatter_install = {}

for _, names in pairs(formatters_by_ft) do
  for _, name in pairs(names) do
    local mason_name = formatters_to_mason[name]
    if mason_name == nil then
      mason_name = name
    end
    table.insert(mason_formatter_install, mason_name)
  end
end

local linters_by_ft = {}
for _, ft in pairs(used_ft) do
  local cfg = (config[ft] or {}).linters
  if cfg ~= nil then
    linters_by_ft[ft] = cfg
  end
end

local mason_linter_install = {}

for _, names in pairs(linters_by_ft) do
  for _, name in pairs(names) do
    local mason_name = linters_to_mason[name]
    if mason_name == nil then
      mason_name = name
    end
    table.insert(mason_linter_install, mason_name)
  end
end

local M = {
  used_ft = used_ft,
  formatters_by_ft = formatters_by_ft,
  mason_formatter_install = mason_formatter_install,
  linters_by_ft = linters_by_ft,
  mason_linter_install = mason_linter_install,
  mason_lspserver = mason_lspserver,
}
return M
