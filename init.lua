require("options")
require("lsp")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"rebelot/kanagawa.nvim",
		config = function()
			vim.cmd.colorscheme("kanagawa-wave")
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 420
		end,
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
				auto_install = true,
				highlight = {
					enable = true,
				},
			})
		end,
	},
	{
		"justinmk/vim-dirvish",
		event = "VeryLazy",
		dependencies = {
			"roginfarrer/vim-dirvish-dovish",
		},
		lazy = false,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = false,
				theme = "auto",
				disabled_filetypes = {},
				always_divide_middle = true,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"diff",
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = "󰌵" },
						colored = true,
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
					},
					{ separator },
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },

				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = {},
		},
		event = "VeryLazy",
	},
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.comment").setup()
			require("mini.pairs").setup()
			require("mini.indentscope").setup({
				draw = {
					delay = 0,
					animation = require("mini.indentscope").gen_animation.none(),
				},
				symbol = "│",
			})

			require("mini.pick").setup()
			vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "[F]iles" })
			vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "[B]buffers" })
			vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep<cr>", { desc = "[G]rep" })
			vim.keymap.set("n", "<leader>fw", "<cmd>Pick grep_live<cr>", { desc = "[W]ord" })
			vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "[H]elp" })
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		keys = {
			{ "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Tree Toggle" },
			{ "<leader>o", "<cmd>NvimTreeFocus<cr>", desc = "Tree Focus" },
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
		"romainl/vim-cool",
	},
	require("linter-formatter"),
})

require("mappings")
