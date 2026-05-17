-- File explorer
return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "<C-n>", ":NvimTreeToggle<CR>", silent = true },
    { "<leader>n", ":NvimTreeFindFile<CR>", silent = true },
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
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.del("n", "<C-E>", { buffer = bufnr })
    end,
  },
}
