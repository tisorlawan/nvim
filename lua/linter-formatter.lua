require("lsp")

for _, list in pairs(vim.g.linters) do
  table.insert(list, "editorconfig-checker")
  table.insert(list, "typos")
end

local lspFormattingFiletypes = {
  "toml",
  "yaml",
  "html",
}

--------------------------------------------------------------------------------
-- if not using real names
local extraInstalls = {
  "debugpy",
  "ruff",
  "clang-format",
}

local dontInstall = {
  "stylelint", -- installed externally due to its plugins: https://github.com/williamboman/mason.nvim/issues/695
  "zsh", -- builtin
  "injected",
  "ruff_format",
  "ruff_fix",
  "clang_format",
}

---given the linter- and formatter-list of nvim-lint and conform.nvim, extract a
---list of all tools that need to be auto-installed
---@param myLinters object[]
---@param myFormatters object[]
---@param extraTools string[]
---@param ignoreTools string[]
---@return string[] tools
---@nodiscard
local function toolsToAutoinstall(myLinters, myFormatters, myLsps, extraTools, ignoreTools)
  -- get all linters, formatters, & extra tools and merge them into one list
  local linterList = vim.tbl_flatten(vim.tbl_values(myLinters))
  local formatterList = vim.tbl_flatten(vim.tbl_values(myFormatters))
  local tools = vim.list_extend(linterList, formatterList)
  vim.list_extend(tools, myLsps)
  vim.list_extend(tools, extraTools)

  -- only unique tools
  table.sort(tools)
  tools = vim.fn.uniq(tools)

  -- remove exceptions not to install
  tools = vim.tbl_filter(function(tool)
    return not vim.tbl_contains(ignoreTools, tool)
  end, tools)
  return tools
end

local function linterConfigs()
  local lint = require("lint")
  lint.linters_by_ft = vim.g.linters

  lint.linters.shellcheck.args = { "--shell=bash", "--format=json", "--external-sources", "-" }
end

local function lintTriggers()
  local function doLint()
    if vim.bo.buftype ~= "" then
      return
    end
    require("lint").try_lint()
  end

  vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "TextChanged", "FocusGained" }, {
    callback = doLint,
  })

  -- due to auto-save.nvim, we need the custom event "AutoSaveWritePost"
  -- instead of "BufWritePost" to trigger linting to prevent race conditions
  vim.api.nvim_create_autocmd("User", {
    pattern = "AutoSaveWritePost",
    callback = doLint,
  })

  doLint() -- run on initialization
end

--------------------------------------------------------------------------------

local formatterConfig = {
  formatters_by_ft = vim.g.formatters,
  formatters = {
    markdownlint = {},
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
}

return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      linterConfigs()
      lintTriggers()
    end,
  },
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    lazy = false,
    keys = {
      {
        "<leader>ft",
        function()
          local useLsp = vim.tbl_contains(lspFormattingFiletypes, vim.bo.ft) and "always" or false
          require("conform").format({
            lsp_fallback = useLsp,
            async = false,
            callback = vim.cmd.update,
          })
        end,
        mode = { "n", "x" },
        desc = "Format & Save",
      },
    },
    config = function()
      require("conform").setup(formatterConfig)

      vim.api.nvim_create_user_command("ToggleAutoFormat", function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        if vim.b.disable_autoformat then
          print("disable auto format")
        else
          print("enabled auto format")
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.keymap.set("n", "<leader>uf", "<cmd>ToggleAutoFormat<cr>", { desc = "Toggle Autoformat" })
    end,
  },
  {
    "williamboman/mason.nvim",
    keys = {
      { "<leader>pm", vim.cmd.Mason, desc = " Mason Home" },
    },
    opts = {
      ui = {
        height = 0.8,
        width = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "󰔟",
          package_uninstalled = "✗",
        },
        keymaps = {
          uninstall_package = "x",
          toggle_help = "?",
          toggle_package_expand = "<Tab>",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>pM", vim.cmd.MasonToolsUpdate, desc = " Mason Update" },
    },
    dependencies = "williamboman/mason.nvim",
    config = function()
      local lsps = vim.tbl_values(vim.g.lspToMasonMap)
      local myTools = toolsToAutoinstall(vim.g.linters, vim.g.formatters, lsps, extraInstalls, dontInstall)

      require("mason-tool-installer").setup({
        ensure_installed = myTools,
        run_on_start = false,
      })

      vim.defer_fn(vim.cmd.MasonToolsInstall, 500)
      vim.defer_fn(vim.cmd.MasonToolsClean, 500)
    end,
  },
}
