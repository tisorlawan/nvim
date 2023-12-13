return {
  "hedyhli/outline.nvim",
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    {
      "<leader>ls",
      "<cmd>Outline<CR>",
      desc = "Toggle Outline",
    },
  },
  config = function()
    require("outline").setup({
      -- Your setup opts here (leave empty to use defaults)
    })
  end,
}
