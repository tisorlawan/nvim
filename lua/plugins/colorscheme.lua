local function load()
  require("kanagawa").setup({
    -- compile = true, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = vim.g.transparent, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = { -- add/modify theme and palette colors
      palette = {},
      theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    theme = "wave", -- Load "wave" theme when 'background' option is not set
    background = { -- map the value of 'background' option to a theme
      dark = "wave", -- try "dragon" !
      light = "lotus",
    },
  })
  vim.cmd.colorscheme("kanagawa-wave")
end

return {
  "rebelot/kanagawa.nvim",
  config = function()
    load()

    vim.keymap.set("n", "<leader>ut", function()
      vim.g.transparent = not vim.g.transparent
      load()
    end, { silent = true, desc = "Toggle transparent" })
  end,
}
