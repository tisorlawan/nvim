return {
  "mbbill/undotree",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    vim.keymap.set("n", "<leader>fu", "<cmd>UndotreeToggle<cr>", { desc = "undotree toggle" })
    vim.cmd([[
        if has("persistent_undo")
           let target_path = expand('~/.undodir')

           if !isdirectory(target_path)
               call mkdir(target_path, "p", 0700)
           endif

           let &undodir=target_path
           set undofile
        endif
    ]])
  end,
}
