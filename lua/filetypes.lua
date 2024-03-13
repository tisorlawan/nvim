vim.filetype.add({
  extension = {
    ["env"] = "bash",
    ["templ"] = "templ",
  },
  filename = {
    [".env"] = "bash",
    [".env.template"] = "bash",
    ["poetry.lock"] = "toml",
  },
})
