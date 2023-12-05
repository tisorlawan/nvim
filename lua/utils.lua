local M = {}

M.close_diagnostics = function()
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    vim.api.nvim_win_call(win, function()
      if vim.bo.buftype == "quickfix" then
        vim.cmd("lclose")
      elseif vim.bo.buftype == "locationlist" then
        vim.cmd("cclose")
      elseif vim.bo.buftype == "help" then
        vim.cmd("bdelete")
        ---@diagnostic disable-next-line: param-type-mismatch
      elseif vim.fn.bufname("%") == "Trouble" then
        vim.cmd("bdelete")
      end
    end)
  end

  vim.cmd("cclose")
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

M.toggle_diagnostics = function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    print("enabled diagnostic")
  else
    vim.diagnostic.disable()
    print("disable diagnostic")
  end
end

M.get_linters = function()
  local linters = require("lint").get_running()
  if #linters == 0 then
    print("-- No linters --")
  else
    print("Linters: " .. table.concat(linters, ", "))
  end
end

M.os_exec = function(cmd, raw)
  local handle = assert(io.popen(cmd, "r"))
  local output = assert(handle:read("*a"))

  handle:close()

  if raw then
    return output
  end

  output = string.gsub(string.gsub(string.gsub(output, "^%s+", ""), "%s+$", ""), "[\n\r]+", " ")

  return output
end

M.trim = function(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

M.file_exists = function(filepath)
  local file = io.open(filepath, "r")
  if file then
    file:close()
    return true
  end
  return false
end

M.contains = function(sequence, element)
  for _, value in ipairs(sequence) do
    if value == element then
      return true
    end
  end
  return false
end

M.buf_set_keymap_add_colon = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.keymap.set("i", "<C-d>", "<End>;", { noremap = true, silent = true, buffer = bufnr })
end

return M
