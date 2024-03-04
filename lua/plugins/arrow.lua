return {
  "otavioschwanck/arrow.nvim",
  config = function()
    local opts = {
      show_icons = true,
      leader_key = "<space>a",
      mappings = {
        edit = "e",
        delete_mode = "d",
        clear_all_items = "C",
        toggle = "a", -- used as save if separate_save_and_remove is true
        open_vertical = "v",
        open_horizontal = "-",
        quit = "q",
        remove = "x", -- only used if separate_save_and_remove is true
      },
      separate_save_and_remove = true,
    }
    require("arrow").setup(opts)

    vim.keymap.set("n", "<C-n>", require("arrow.persist").next)
    vim.keymap.set("n", "<C-p>", require("arrow.persist").previous)
  end,
}
