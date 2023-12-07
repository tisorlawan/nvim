return {
  "echasnovski/mini.nvim",
  ---@diagnostic disable-next-line: assign-type-mismatch
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
}
