local prefix = "gz"
local maps = { n = {} }
local icon = vim.g.icons_enabled and "󰑤 " or ""
maps.n[prefix] = { desc = icon .. "Surround" }

return {
  {
    "echasnovski/mini.surround",
    keys = function(plugin, keys)
      -- Populate the keys based on the user's options
      local mappings = {
        { plugin.opts.mappings.add, desc = "add surrounding", mode = { "n", "v" } },
        { plugin.opts.mappings.delete, desc = "delete surrounding" },
        { plugin.opts.mappings.find, desc = "find right surrounding" },
        { plugin.opts.mappings.find_left, desc = "find left surrounding" },
        { plugin.opts.mappings.highlight, desc = "highlight surrounding" },
        { plugin.opts.mappings.replace, desc = "replace surrounding" },
        { plugin.opts.mappings.update_n_lines, desc = "update `MiniSurround.config.n_lines`" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = prefix .. "a", -- Add surrounding in Normal and Visual modes
        delete = prefix .. "d", -- Delete surrounding
        find = prefix .. "f", -- Find surrounding (to the right)
        find_left = prefix .. "F", -- Find surrounding (to the left)
        highlight = prefix .. "h", -- Highlight surrounding
        replace = prefix .. "r", -- Replace surrounding
        update_n_lines = prefix .. "n", -- Update `n_lines`
      },
    },
  },
}
