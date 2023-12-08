---@diagnostic disable: missing-fields
vim.g.linters = {
  css = { "stylelint" },
  sh = { "zsh", "shellcheck" },
  markdown = { "markdownlint" },
}

vim.g.formatters = {
  javascript = { "prettierd" },
  typescript = { "prettierd" },
  typescriptreact = { "prettierd" },
  c = { "clang_format" },
  json = { "prettierd" },
  lua = { "stylua", "ast-grep" },
  python = { "ruff_format", "isort" },
  markdown = { "markdown-toc", "markdownlint", "injected" },
  css = { "stylelint", "prettier" },
  sh = { "shellcheck", "shfmt" },
  bib = { "bibtex-tidy" },
}

vim.g.lspToMasonMap = {
  -- use plugin pmizio/typescript-tools.nvim
  -- tsserver = "typescript-language-server",

  -- ast_grep = "ast-grep", -- custom, ast-based linter
  clangd = "clangd",
  autotools_ls = "autotools-language-server", -- Makefiles
  bashls = "bash-language-server", -- used for zsh
  -- biome = "biome", -- ts/js/json linter/formatter
  cssls = "css-lsp",
  tailwindcss = "tailwindcss-language-server",
  -- emmet_ls = "emmet-ls", -- css/html completion
  html = "html-lsp",
  -- jedi_language_server = "jedi-language-server", -- python (has much better hovers)
  jsonls = "json-lsp",
  -- ltex = "ltex-ls", -- languagetool
  lua_ls = "lua-language-server",
  marksman = "marksman", -- markdown
  pyright = "pyright", -- python
  ruff_lsp = "ruff-lsp", -- python linter
  taplo = "taplo", -- toml
  yamlls = "yaml-language-server",
}

vim.g.lspConfig = {
  pyright = {
    settings = {
      python = {
        analysis = {
          autoImportCompletions = false,
          autoSearchPaths = false,
          useLibraryCodeForTypes = false,
          diagnosticMode = "openFilesOnly", -- "off"
          typeCheckingMode = "off",
          stubPath = "~/.typings",
        },
      },
    },
  },
}

return {
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
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neodev.nvim", opts = {}, ft = { "lua" } },
    },
    config = function()
      require("neodev").setup({})

      -- Setup language servers.
      local lspconfig = require("lspconfig")
      local ok, _ = pcall(require, "cmp_nvim_lsp")
      if not ok then
        for server_name, _ in pairs(vim.g.lspToMasonMap) do
          local default_cfg = {}
          local cfg = vim.g.lspConfig[server_name]

          local server_cfg = default_cfg
          if cfg ~= nil then
            server_cfg = vim.tbl_deep_extend("force", default_cfg, cfg)
            vim.print(server_cfg)
          end

          lspconfig[server_name].setup(server_cfg)
        end
      end

      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Diagnostic line" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

      -- Diagnostics
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

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
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

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
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
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        }),
        formatting = {
          format = function(entry, item)
            local fmt = lspkind.cmp_format({
              mode = "symbol", -- show only symbol annotations
              maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
              ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

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
      for server_name, _ in pairs(vim.g.lspToMasonMap) do
        local default_cfg = { capabilities = capabilities }

        local cfg = vim.g.lspConfig[server_name]

        local server_cfg = default_cfg
        if cfg ~= nil then
          server_cfg = vim.tbl_deep_extend("force", default_cfg, cfg)
        end

        lspconfig[server_name].setup(server_cfg)
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
      end, { desc = "Workspace diagnostics" })
      vim.keymap.set("n", "<leader>x", function()
        require("trouble").toggle("document_diagnostics")
      end, { desc = "Document diagnostics" })
      vim.keymap.set("n", "gR", function()
        require("trouble").toggle("lsp_references")
      end, { desc = "References" })
    end,
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
    ft = { "rust", "python" },
  },
}
