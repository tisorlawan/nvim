local utils = require("utils")
local m = require("installer")

vim.g.lspConfig = {
  pyright = {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = false,
          autoSearchPaths = false,
          useLibraryCodeForTypes = false,
          diagnosticMode = "openFilesOnly", -- "off"
          -- typeCheckingMode = "off",
          stubPath = "~/.typings",
        },
      },
    },
  },
}

local servers_config_skip = { "rust_analyzer", "tsserver" }
-- local servers_config_skip = {}

local servers_install_skip = { "clangd", "rust_analyzer" }
local servers = m.mason_lspserver

local installed_servers = {}

for _, server in pairs(servers) do
  if not utils.contains(servers_install_skip, server) then
    table.insert(installed_servers, server)
  end
end

local function setup_diagnostic()
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "diagnostic line" })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic" })

  local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
  })
end

local function setup_lsp_keymaps(buf)
  local function map(key, fn, desc)
    vim.keymap.set("n", key, fn, { desc = desc, buffer = buf })
  end

  local function vnmap(key, fn, desc)
    vim.keymap.set({ "n", "v" }, key, fn, { desc = desc, buffer = buf })
  end

  map("gD", vim.lsp.buf.declaration, "Goto Declaration")
  map("gd", vim.lsp.buf.definition, "Goto Definition")
  map("K", vim.lsp.buf.hover, "Hover")
  map("gi", vim.lsp.buf.implementation, "Goto Implementation")
  map("<leader>k", vim.lsp.buf.signature_help, "Signature Help")
  map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
  map("<leader>rn", vim.lsp.buf.rename, "Rename")
  map("gr", vim.lsp.buf.references, "Goto References")

  local ok_fzf, _ = pcall(require, "fzf-lua")
  if ok_fzf then
    vnmap("<leader>la", "<cmd>lua require('fzf-lua').lsp_code_actions()<cr>", "Code action (FZF Lua)")
    vnmap("<leader>lA", vim.lsp.buf.code_action, "Code action")
  else
    vnmap("<leader>la", vim.lsp.buf.code_action, "Code action")
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          config = function()
            require("mason").setup()
          end,
        },
        config = function()
          require("mason-lspconfig").setup({
            ensure_installed = installed_servers,
          })
        end,
      },
      { "folke/neodev.nvim", opts = {}, ft = { "lua" } },
    },
    config = function()
      setup_diagnostic()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc" -- Enable completion triggered by <c-x><c-o>
          setup_lsp_keymaps(ev.buf)
        end,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",

      "onsails/lspkind.nvim",
      { "js-everts/cmp-tailwind-colors", opts = {} },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      local function has_words_before()
        local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local lsp_handler = vim.lsp.handlers
      lsp_handler["textDocument/hover"] = vim.lsp.with(lsp_handler.hover, { border = "single" })
      lsp_handler["textDocument/signatureHelp"] = vim.lsp.with(lsp_handler.signature_help, { border = "single" })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered({ border = "single" }),
          documentation = cmp.config.window.bordered({ border = "single" }),
        },
        -- completion = {
        --   autocomplete = false,
        -- },
        mapping = {
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = "path", priority = 1200 },
          -- { name = "codeium", priority = 1100 },
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
        }),
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = function(entry, item)
            local fmt = lspkind.cmp_format({
              mode = "symbol",
              maxwidth = 50,
              ellipsis_char = "...",
              symbol_map = { Codeium = "" },

              -- The function below will be called before any actual modifications from lspkind
              -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
              before = function(_, vim_item)
                return vim_item
              end,
            })
            if item.kind == "Color" then
              local vim_item = require("cmp-tailwind-colors").format(entry, item)
              if item.kind == "Color" then
                return fmt(entry, vim_item)
              end
              return vim_item
            end
            return fmt(entry, item)
          end,
        },
      })

      -- Setup language servers.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      for _, sn in pairs(servers) do
        if not utils.contains(servers_config_skip, sn) then
          local cfg = vim.g.lspConfig[sn]
          local merged_cfg = vim.tbl_deep_extend("force", { capabilities = capabilities }, cfg or {})

          lspconfig[sn].setup(merged_cfg)
        end
      end
    end,
  },

  {
    "folke/trouble.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      icons = false,
    },
    config = function(_, opts)
      require("trouble").setup(opts)
      vim.keymap.set("n", "<leader>X", function()
        require("trouble").toggle("workspace_diagnostics")
      end, { desc = "workspace diagnostics" })
      vim.keymap.set("n", "<leader>x", function()
        require("trouble").toggle("document_diagnostics")
      end, { desc = "document diagnostics" })
      vim.keymap.set("n", "gR", function()
        require("trouble").toggle("lsp_references")
      end, { desc = "references" })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    build = vim.fn.has("win32") == 0
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
      or nil,
    dependencies = { "rafamadriz/friendly-snippets" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
    config = function(_, opts)
      require("luasnip").config.setup(opts)
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  {
    "j-hui/fidget.nvim",
    opts = {},
    ft = { "rust", "python", "lua", "go" },
  },
  {
    "dgagn/diagflow.nvim",
    event = "LspAttach",
    enabled = false,
    opts = {
      scope = "line", -- line|cursor
      toggle_event = { "InsertEnter" },
      text_align = "right", -- left|right
      border_chars = {
        top_left = "┌",
        top_right = "┐",
        bottom_left = "└",
        bottom_right = "┘",
        horizontal = "─",
        vertical = "│",
      },
      show_borders = true,
    },
  },
}
