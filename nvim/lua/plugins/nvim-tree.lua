return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    {
      "<C-b>",
      function() require("nvim-tree.api").tree.toggle({ find_file = true, focus = true }) end,
      desc = "Explorer: toggle file tree (with reveal)",
      silent = true,
    },
  },
  opts = {
    view = {
      adaptive_size = true,
      width = {
        max = 80,
      },
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      api.map.on_attach.default(bufnr)
      vim.keymap.del("n", "<C-E>", { buffer = bufnr })
    end,
  },
}
