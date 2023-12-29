return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      { "sindrets/diffview.nvim", opts = { use_icons = false } },

      "ibhagwan/fzf-lua", -- optional
    },
    config = true,
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    cmd = { "Neogit" },
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]g", function()
            if vim.wo.diff then
              return "]g"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "next hunk" })

          map("n", "[g", function()
            if vim.wo.diff then
              return "[g"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "prev hunk" })

          -- Actions
          map("n", "<leader>gs", gs.stage_hunk, { desc = "stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk, { desc = "reset hunk" })
          map("v", "<leader>gs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "stage hunk" })
          map("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "reset hunk" })
          map("n", "<leader>gS", gs.stage_buffer, { desc = "stage buffer" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
          map("n", "<leader>gR", gs.reset_buffer, { desc = "reset buffer" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "preview hunk" })
          map("n", "<leader>gb", function()
            gs.blame_line({ full = true }, { desc = "blame line" })
          end, { desc = "blame line" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle blame line" })
          map("n", "<leader>gd", gs.diffthis, { desc = "diff this" })
          map("n", "<leader>gD", function()
            gs.diffthis("~")
          end, { desc = "diff this ~" })
          map("n", "<leader>gd", gs.toggle_deleted, { desc = "toggle deleted" })

          -- Text object
          map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      })
    end,
  },
}
