local prefix = "<leader><leader>"
local term_string = vim.fn.exists("$TMUX") == 1 and "tmux" or "terminal"
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
        "<C-x>",
        function()
          vim.ui.input({ prompt = "Harpoon mark index: " }, function(input)
            local num = tonumber(input)
            if num then
              require("harpoon.ui").nav_file(num)
            end
          end)
        end,
        desc = "goto index of mark",
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
      {
        prefix .. "t",
        function()
          vim.ui.input({ prompt = term_string .. " window number: " }, function(input)
            local num = tonumber(input)
            if num then
              require("harpoon." .. term_string).gotoTerminal(num)
            end
          end)
        end,
        desc = "go to " .. term_string .. " window",
      },
    },
  },
}
