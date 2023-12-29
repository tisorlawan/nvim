local function set_keymap_toggle_transparency(fn)
  vim.keymap.set("n", "<leader>ut", function()
    vim.g.transparent = not vim.g.transparent
    fn()
  end, { silent = true, desc = "toggle transparent" })
end

return {
  {
    "rebelot/kanagawa.nvim",
    priority = 0,
    config = function()
      local fn = function()
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
        vim.cmd.colorscheme("kanagawa-dragon")
      end
      fn()
      set_keymap_toggle_transparency(fn)
    end,
  },
  {
    "ramojus/mellifluous.nvim",
    priority = 10,
    config = function()
      local fn = function()
        require("mellifluous").setup({
          mellifluous = {
            neutral = true, -- set this to false and bg_contrast to 'medium' for original mellifluous (then it was called meliora theme)
            bg_contrast = "hard", -- options: 'soft', 'medium', 'hard'
          },
          transparent_background = {
            enabled = vim.g.transparent,
          },
        })
        vim.cmd("colorscheme mellifluous")
      end

      fn()
      set_keymap_toggle_transparency(fn)
    end,
  },
}
