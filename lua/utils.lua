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

return M
