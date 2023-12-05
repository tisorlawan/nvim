local prefix = "<leader><leader>"
local maps = { n = {} }
local icon = vim.g.icons_enabled and "󱡀 " or ""

maps.n[prefix] = { desc = icon .. "Harpoon" }

return {
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Harpoon" },
    keys = {
      {
        prefix .. "a",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "add file",
      },
      {
        prefix .. "e",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "toggle quick menu",
      },
      {
        "<M-1>",
        function()
          require("harpoon.ui").nav_file(1)
        end,
      },
      {
        "<M-2>",
        function()
          require("harpoon.ui").nav_file(2)
        end,
      },
      {
        "<M-3>",
        function()
          require("harpoon.ui").nav_file(3)
        end,
      },
      {
        "<M-4>",
        function()
          require("harpoon.ui").nav_file(4)
        end,
      },
      {
        "<C-p>",
        function()
          require("harpoon.ui").nav_prev()
        end,
        desc = "goto previous mark",
      },
      {
        "<C-n>",
        function()
          require("harpoon.ui").nav_next()
        end,
        desc = "goto next mark",
      },
    },
  },
}
