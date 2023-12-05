vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  pattern = "*",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

local attach_to_buffer = function(output_bufnr, pattern, command)
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("RunCMDtoBuffer", { clear = true }),
    pattern = pattern,
    callback = function()
      local append_data = function(_, data)
        if #data == 1 and data[1] == "" then
          return
        end
        vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
      end
      vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { "[Output " .. os.date("%Y-%m-%d %H:%M:%S") .. "]" })

      vim.fn.jobstart(command, {
        stdout_buffered = true,
        on_stdout = append_data,
        on_stderr = append_data,
      })
    end,
  })
end

vim.api.nvim_create_user_command("AutoRun", function()
  local bufnr = vim.api.nvim_get_current_buf()
  -- local pattern = vim.fn.input("Pattern: ")
  -- local command = vim.fn.input("Command: ")
  local pattern = "main.lua"
  local command = "lua main.lua"

  attach_to_buffer(tonumber(bufnr), pattern, vim.split(command, " "))
end, {})
