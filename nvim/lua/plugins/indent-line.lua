--Indent line

return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPre",
  main = "ibl",
  opts = {
    indent = { char = "▏" },
    scope = {
      char = "▏",
      highlight = { "SpecialKey" },
      show_start = false,
      include = {
        node_type = { ["*"] = { "*" } },
      },
    },
  },
}
