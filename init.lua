-- #OPTIONS
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 6

vim.opt.virtualedit = "block"

vim.opt.inccommand = "split"

vim.opt.ignorecase = true

vim.opt.termguicolors = true

vim.opt.swapfile = false
vim.opt.statuscolumn = "%s%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . ' ' : v:lnum) : ''}%="
vim.opt.signcolumn = "yes"

vim.opt.undodir = vim.fn.expand("$HOME/.undodir")
vim.opt.undofile = true

-- #PLUGINS
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
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1)
						end,
					},
				},
				lualine_b = {
					"branch",
					"diff",
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = {
							error = "󰅚 ",
							warn = "󰀪 ",
							hint = "󰌶 ",
							info = " ",
						},
						colored = true,
					},
				},
				lualine_c = {
					{
						"filename",
						path = 1,
					},
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
					end, { expr = true, desc = "Next Hunk" })

					map("n", "[g", function()
						if vim.wo.diff then
							return "[g"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, desc = "Prev Hunk" })

					-- Actions
					map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
					map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
					map("v", "<leader>gs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Stage hunk" })
					map("v", "<leader>gr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { desc = "Reset hunk" })
					map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
					map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
					map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
					map("n", "<leader>gb", function()
						gs.blame_line({ full = true }, { desc = "Blame line" })
					end, { desc = "Blame line" })
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame line" })
					map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
					map("n", "<leader>gD", function()
						gs.diffthis("~")
					end, { desc = "Diff this ~" })
					map("n", "<leader>gd", gs.toggle_deleted, { desc = "Toggle deleted" })

					-- Text object
					map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
	{ "romainl/vim-cool" },
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", "<Plug>(leap-forward-to)", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", "<Plug>(leap-backward-to)", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "x", "<Plug>(leap-forward-till)", mode = { "x", "o" }, desc = "Leap forward till" },
			{ "X", "<Plug>(leap-backward-till)", mode = { "x", "o" }, desc = "Leap backward till" },
			{ "gs", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from window" },
		},
		opts = {},
		init = function() -- https://github.com/ggandor/leap.nvim/issues/70#issuecomment-1521177534
			vim.api.nvim_create_autocmd("User", {
				callback = function()
					vim.cmd.hi("Cursor", "blend=100")
					vim.opt.guicursor:append({ "a:Cursor/lCursor" })
				end,
				pattern = "LeapEnter",
			})
			vim.api.nvim_create_autocmd("User", {
				callback = function()
					vim.cmd.hi("Cursor", "blend=0")
					vim.opt.guicursor:remove({ "a:Cursor/lCursor" })
				end,
				pattern = "LeapLeave",
			})
		end,
		dependencies = {
			"tpope/vim-repeat",
		},
	},
	{
		"catppuccin/nvim",
		optional = true,
		opts = { integrations = { leap = true } },
	},

	{
		"Aasim-A/scrollEOF.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("scrollEOF").setup()
		end,
	},

	{
		"nacro90/numb.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("numb").setup({
				show_numbers = true, -- Enable 'number' for the window while peeking
				show_cursorline = true, -- Enable 'cursorline' for the window while peeking
			})
		end,
	},
	{
		"mbbill/undotree",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.keymap.set("n", "<leader>fu", "<cmd>UndotreeToggle<cr>", { desc = "Undotree toggle" })
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
	},
	{
		"wintermute-cell/gitignore.nvim",
		cmd = "Gitignore",
	},
	{
		"lambdalisue/suda.vim",
		keys = {
			{
				"<leader>W",
				":SudaWrite<CR>",
				desc = "Suda Write",
			},
		},
		cmd = {
			"SudaRead",
			"SudaWrite",
		},
	},
	{ "folke/todo-comments.nvim", opts = {}, event = { "BufReadPre", "BufNewFile" } },

	{
		"kevinhwang91/nvim-bqf",
		ft = "qf",
		opts = {},
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		-- dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", silent = true, desc = "Files" },
			{ "<leader>fh", "<cmd>lua require('fzf-lua').help_tags()<CR>", silent = true, desc = "Help" },
			{ "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", silent = true, desc = "Bbuffers" },
			{ "<leader>fn", "<cmd>lua require('fzf-lua').builtin()<CR>", silent = true, desc = "Builtin" },
			{
				"<leader>fw",
				"<cmd>lua require('fzf-lua').live_grep_native()<CR>",
				silent = true,
				desc = "Live Grep [Word]",
			},
			{ "<leader>*", "<cmd>lua require('fzf-lua').grep_cword()<CR>", silent = true, desc = "Grep cword" },
			{
				mode = "x",
				"<leader>q",
				"<cmd>lua require('fzf-lua').grep_visual()<CR>",
				silent = true,
				desc = "Grep visual",
			},
			{ "<leader>fs", "<cmd>lua require('fzf-lua').git_status()<CR>", silent = true, desc = "Git status" },
		},
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
	{
		"mrcjkb/rustaceanvim",
		version = "^3",
		ft = { "rust" },
	},
	{
		"mrjones2014/smart-splits.nvim",
		config = function()
			local s = require("smart-splits")

			vim.keymap.set("n", "<C-left>", s.resize_left)
			vim.keymap.set("n", "<C-down>", s.resize_down)
			vim.keymap.set("n", "<C-up>", s.resize_up)
			vim.keymap.set("n", "<C-right>", s.resize_right)
			-- moving between splits
			vim.keymap.set("n", "<C-h>", s.move_cursor_left)
			vim.keymap.set("n", "<C-j>", s.move_cursor_down)
			vim.keymap.set("n", "<C-k>", s.move_cursor_up)
			vim.keymap.set("n", "<C-l>", s.move_cursor_right)
			-- swapping buffers between windows
			vim.keymap.set("n", "<leader><leader>h", s.swap_buf_left)
			vim.keymap.set("n", "<leader><leader>j", s.swap_buf_down)
			vim.keymap.set("n", "<leader><leader>k", s.swap_buf_up)
			vim.keymap.set("n", "<leader><leader>l", s.swap_buf_right)

			s.setup({
				ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
				ignored_buftypes = { "nofile" },
			})
		end,
	},
	require("lsp"),
	require("linter-formatter"),
})

local function close_diagnostics()
	local windows = vim.api.nvim_list_wins()
	for _, win in ipairs(windows) do
		vim.api.nvim_win_call(win, function()
			if vim.bo.buftype == "quickfix" then
				vim.cmd("lclose")
			elseif vim.bo.buftype == "locationlist" then
				vim.cmd("cclose")
			elseif vim.bo.buftype == "help" then
				vim.cmd("bdelete")
			elseif vim.fn.bufname("%") == "Trouble" then
				vim.cmd("bdelete")
			end
		end)
	end

	vim.cmd("cclose")
end

local function jumps_to_qf()
	local jumplist, _ = unpack(vim.fn.getjumplist())
	local qf_list = {}
	for _, v in pairs(jumplist) do
		if vim.fn.bufloaded(v.bufnr) == 1 then
			table.insert(qf_list, {
				bufnr = v.bufnr,
				lnum = v.lnum,
				col = v.col,
				text = vim.api.nvim_buf_get_lines(v.bufnr, v.lnum - 1, v.lnum, false)[1],
			})
		end
	end
	vim.fn.setqflist(qf_list, " ")
	vim.cmd("copen")
end

local function toggle_diagnostics()
	if vim.diagnostic.is_disabled() then
		vim.diagnostic.enable()
		print("enabled diagnostic")
	else
		vim.diagnostic.disable()
		print("disable diagnostic")
	end
end

-- #KEYMAP
vim.keymap.set("n", "<leader><tab>", "<c-^>", { desc = "alternative buffer" })
vim.keymap.set("n", "<c-s>", ":w<cr>", { silent = true })
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, desc = "Write buffer" })
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-j>", "<c-w>j")

vim.keymap.set("n", "<m-n>", ":bnext<cr>", { silent = true })
vim.keymap.set("n", "<m-p>", ":bprev<cr>", { silent = true })

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")

vim.keymap.set("n", "'", "`")
vim.keymap.set("n", "`", "'")

vim.keymap.set("i", "<c-l>", "<right>")
vim.keymap.set("i", "<c-h>", "<left>")
vim.keymap.set("i", "<c-s>", "<esc>:w<cr>")
vim.keymap.set("i", "<m-h>", "<esc>I")
vim.keymap.set("i", "<m-l>", "<end>")

vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')

vim.keymap.set("v", "x", '"_dP')

vim.keymap.set("n", "cn", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "cp", ":cprev<CR>", { silent = true })
vim.keymap.set("n", "co", ":copen<CR>", { silent = true })
vim.keymap.set("n", "cq", close_diagnostics, { desc = "Close Diagnostics", silent = true })
vim.keymap.set("n", "cu", jumps_to_qf, { desc = "Jumps to Qf", silent = true })

vim.keymap.set("n", "<leader>ll", ":Lazy<cr>", { desc = "Lazy", silent = true })
vim.keymap.set("n", "<leader>lp", ":Lazy profile<cr>", { desc = "Lazy Profile", silent = true })

vim.keymap.set("n", "<leader>ud", toggle_diagnostics, { desc = "Toggle Diagnostics" })

vim.cmd([[
  xnoremap <expr> p 'pgv"'.v:register.'y`>'
  xnoremap <expr> P 'Pgv"'.v:register.'y`>'
]])

-- #AUTOCMDS
vim.api.nvim_create_autocmd("FileType", {
	desc = "Rust file autocmds",
	pattern = "rust",
	group = vim.api.nvim_create_augroup("rust_ft", { clear = true }),
	callback = function(opts)
		vim.keymap.set("i", "<C-d>", "<End>;", { silent = true, buffer = opts.buf })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	pattern = "*",
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})
