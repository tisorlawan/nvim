return {
  "numToStr/Comment.nvim",
  lazy = false,
  config = function()
    local comment = require("Comment")
    local ft = require("Comment.ft")

    comment.setup()

    ft.set("templ", { "<!-- %s -->", "<!-- %s -->" })
  end,
}
