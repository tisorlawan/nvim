local map = vim.keymap.set

local function getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  cmd = { "Telescope" },
  keys = {
    { "<Leader>ff", ":Telescope find_files<Cr>", desc = "files" },
    { "<Leader>fw", ":Telescope live_grep<Cr>", desc = "live grep" },
    { "<Leader>f/", ":Telescope grep_string<Cr>", desc = "grep string" },
    { "<Leader>fb", ":Telescope buffers<Cr>", desc = "buffers" },
    { "<Leader>fh", ":Telescope help_tags<Cr>", desc = "help" },
    { "<Leader>fn", ":Telescope builtin<Cr>", desc = "built-in" },
  },
  config = function()
    local previewers = require("telescope.previewers")
    local action_layout = require("telescope.actions.layout")
    local Job = require("plenary.job")

    local new_maker = function(filepath, bufnr, opts)
      filepath = vim.fn.expand(filepath)
      Job:new({
        command = "file",
        args = { filepath },
        on_exit = function(j)
          local mime_type = vim.split(j:result()[1], ":")[2]
          if mime_type:find("text") then
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          else
            vim.schedule(function()
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
            end)
          end
        end,
      }):sync()
    end

    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<M-p>"] = action_layout.toggle_preview,
          },
        },
        buffer_previewer_maker = new_maker,
      },
      pickers = {},
      extensions = {},
    })
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("aerial")

    local b = require("telescope.builtin")

    map("n", "<leader>f.", function()
      b.find_files({ cwd = vim.fn.expand("%:p:h") })
    end, { desc = "sibling files" })

    map("v", "<Leader>q", function()
      local text = getVisualSelection()
      b.live_grep({ default_text = text })
    end, { desc = "grep visual" })
  end,
}
