local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>ft", "<cmd>!cargo fmt<cr>", { silent = true, buffer = bufnr })

vim.keymap.set("i", "<C-d>", "<End>;", { silent = true, buffer = bufnr })
