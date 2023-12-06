local M = {}

function M.create_buffer()
	local dir = vim.fn.expand("%:p:h")

	local filename = vim.fn.input(dir .. "/")
	filename = filename:gsub("^%s*(.-)%s*$", "%1")

	vim.cmd('echo ""')
	if filename ~= nil and filename ~= "" then
		local filepath = dir .. "/" .. filename
		vim.cmd("e " .. filepath)
		print("Created buffer " .. filepath)
	else
		vim.cmd('echo ""')
	end
end

function M.edit_filedir()
	local dir = vim.fn.expand("%:p:h")

	vim.cmd("edit " .. dir)
end

function M.SemiColonConfig()
	vim.cmd([[
		inoremap <buffer> <C-d> <End>;
	]])
end

function M.find_dotfiles()
	require("telescope.builtin").git_files({
		prompt_title = "<Dotfiles>",
		cwd = "$HOME/.rice/",
	})
end

function M.close_diagnostics()
	local windows = vim.api.nvim_list_wins()
	for _, win in ipairs(windows) do
		vim.api.nvim_win_call(win, function()
			if vim.bo.buftype == "quickfix" then
				vim.cmd("lclose")
			elseif vim.bo.buftype == "locationlist" then
				vim.cmd("cclose")
			elseif vim.fn.bufname("%") == "Trouble" then
				vim.cmd("bdelete")
			end
		end)
	end

	vim.cmd("cclose")
end

function M.toggle_diagnostics()
	if vim.diagnostic.is_disabled() then
		vim.diagnostic.enable()
	else
		vim.diagnostic.disable()
	end
end

--- Register queued which-key mappings
function M.which_key_register()
	if M.which_key_queue then
		local wk_avail, wk = pcall(require, "which-key")
		if wk_avail then
			for mode, registration in pairs(M.which_key_queue) do
				wk.register(registration, { mode = mode })
			end
			M.which_key_queue = nil
		end
	end
end

function M.set_mappings(map_table, base)
	-- iterate over the first keys for each mode
	base = base or {}
	for mode, maps in pairs(map_table) do
		-- iterate over each keybinding set in the current mode
		for keymap, options in pairs(maps) do
			-- build the options for the command accordingly
			if options then
				local cmd = options
				local keymap_opts = base
				if type(options) == "table" then
					cmd = options[1]
					keymap_opts = vim.tbl_deep_extend("force", keymap_opts, options)
					keymap_opts[1] = nil
				end
				if not cmd or keymap_opts.name then -- if which-key mapping, queue it
					if not keymap_opts.name then
						keymap_opts.name = keymap_opts.desc
					end
					if not M.which_key_queue then
						M.which_key_queue = {}
					end
					if not M.which_key_queue[mode] then
						M.which_key_queue[mode] = {}
					end
					M.which_key_queue[mode][keymap] = keymap_opts
				else -- if not which-key mapping, set it
					vim.keymap.set(mode, keymap, cmd, keymap_opts)
				end
			end
		end
	end
	if package.loaded["which-key"] then
		M.which_key_register()
	end -- if which-key is loaded already, register
end

local function filter(arr, fn)
	if type(arr) ~= "table" then
		return arr
	end

	local filtered = {}
	for k, v in pairs(arr) do
		if fn(v, k, arr) then
			table.insert(filtered, v)
		end
	end

	return filtered
end

local function filterReactDTS(value)
	local filename = value.filename:match(".+/(.+)$")
	return string.match(value.filename, "react/index.d.ts") == nil and string.match(filename, "react.d.ts") == nil
end

function M.on_list(options)
	local items = options.items
	if #items > 1 then
		items = filter(items, filterReactDTS)
	end

	vim.fn.setqflist({}, " ", { title = options.title, items = items, context = options.context })
	vim.api.nvim_command("silent cfirst") -- or maybe you want 'copen' instead of 'cfirst'
end

function M.getHostname()
	local file = io.open("/proc/sys/kernel/hostname", "r")

	if file then
		local hostname = file:read("*line")
		file:close()
		return hostname
	else
		return ""
	end
end

local function shiftRGB(color, shift)
	local r, g, b = tonumber(color:sub(2, 3), 16), tonumber(color:sub(4, 5), 16), tonumber(color:sub(6, 7), 16)
	r = math.min(r + shift, 255)
	g = math.min(g + shift, 255)
	b = math.min(b + shift, 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

function M.setColors(normalBg)
	local cursorLineBg = shiftRGB(normalBg, 10)
	local normalNcBg = shiftRGB(normalBg, -5)

	vim.cmd(string.format("hi Normal       guibg=%s", normalBg))
	vim.cmd(string.format("hi SignColumn   guibg=%s", normalBg))
	vim.cmd(string.format("hi CursorLine   guibg=%s", cursorLineBg))
	vim.cmd(string.format("hi NormalNC     guibg=%s", normalNcBg))
	vim.cmd(string.format("hi SignColumnNC guibg=%s", normalNcBg))

	vim.cmd(string.format("hi LineNr       guifg=%s", "#505050"))
end

M.jumps_to_qf = function()
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

return M
