return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 500, -- delay in ms before showing popup
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>s", group = "search" },
      { "<leader>g", group = "git" },
      { "<leader>gt", group = "git toggles" },
      { "<leader>h", group = "harpoon" },
      { "<leader>b", group = "buffer" },
      { "<leader>q", group = "quickfix" },
      { "<leader>l", group = "lsp" },
      { "<leader>lw", group = "workspace" },
      { "<leader>t", group = "toggle" },
    })
  end,
}
