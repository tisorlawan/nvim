vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true, desc = "[F]iles" })
vim.keymap.set("n", "<leader>fh", "<cmd>lua require('fzf-lua').help_tags()<CR>", { silent = true, desc = "[H]elp" })
vim.keymap.set("n", "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true, desc = "[B]buffers" })
vim.keymap.set("n", "<leader>fn", "<cmd>lua require('fzf-lua').builtin()<CR>", { silent = true, desc = "Built-i[N]" })
vim.keymap.set(
	"n",
	"<leader>fw",
	"<cmd>lua require('fzf-lua').live_grep_native()<CR>",
	{ silent = true, desc = "Live Grep [Word]" }
)
vim.keymap.set("n", "<leader>*", "<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true, desc = "Grep cword" })
vim.keymap.set(
	"x",
	"<leader>q",
	"<cmd>lua require('fzf-lua').grep_visual()<CR>",
	{ silent = true, desc = "Grep visual" }
)

return {
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {},
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		-- dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- fix: small delay on closing the window
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "fzf" },
				callback = function(event)
					vim.bo[event.buf].buflisted = false
					vim.keymap.set("t", "<C-c>", "<C-c>", { buffer = event.buf, silent = true })
					vim.keymap.set("t", "<Esc>", "<C-c>", { buffer = event.buf, silent = true })
				end,
			})

			require("fzf-lua").setup({
				winopts = {
					preview = { default = "bat_native" },
				},
				files = {
					git_icons = false,
					file_icons = false,
				},
				keymap = {
					fzf = {
						["ctrl-q"] = "select-all+accept",
					},
				},
			})
		end,
	},
}
