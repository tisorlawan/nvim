return {
  {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    keys = {
      { "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "tree toggle" },
      { "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "tree focus" },
    },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = false,
        hijack_netrw = false,
        view = {
          number = true,
          relativenumber = true,
        },
        filters = {
          custom = { ".git" },
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    keys = {
      {
        "<Leader>e",
        ":Neotree source=filesystem reveal=true position=left toggle<Cr>",
        desc = "Neotree toggle",
        silent = true,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      filesystem = {
        follow_current_file = {
          enabled = false,
        },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "disabled",
        filtered_items = {
          always_show = { -- remains visible even if other settings would normally hide it
            ".gitignore",
          },
        },
      },
      default_component_configs = {
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          default = "*",
          highlight = "NeoTreeFileIcon",
        },

        git_status = {
          symbols = {
            -- Change type
            added = "",
            modified = "",
            deleted = "",
            renamed = "",
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
    },
  },
  {
    "justinmk/vim-dirvish",
    event = "VeryLazy",
    dependencies = {
      "roginfarrer/vim-dirvish-dovish",
    },
    lazy = false,
    enabled = true,
  },
}

--[[
 Press the corresponding key to execute the command.
               Press <Esc> to cancel.

         KEY(S)    COMMAND
              # -> fuzzy_sorter
              . -> set_root
              / -> fuzzy_finder
              < -> prev_source
  <2-leftmouse> -> open
           <bs> -> navigate_up
          <c-x> -> clear_filter
           <cr> -> open
          <esc> -> cancel
        <space> -> toggle_node
              > -> next_source
              ? -> show_help
              A -> add_directory
              C -> close_node
              D -> fuzzy_finder_directory
              H -> toggle_hidden
              P -> toggle_preview
              R -> refresh
              S -> open_split
             [g -> prev_git_modified
             ]g -> next_git_modified
              a -> add
              c -> copy
              d -> delete
              e -> toggle_auto_expand_width
              f -> filter_on_submit
              i -> show_file_details
              l -> focus_preview
              m -> move
              o -> show_help
             oc -> order_by_created
             od -> order_by_diagnostics
             og -> order_by_git_status
             om -> order_by_modified
             on -> order_by_name
             os -> order_by_size
             ot -> order_by_type
              p -> paste_from_clipboard
              q -> close_window
              r -> rename
              s -> open_vsplit
              t -> open_tabnew
              w -> open_with_window_picker
              x -> cut_to_clipboard
              y -> copy_to_clipboard
              z -> close_all_nodes

--]]
