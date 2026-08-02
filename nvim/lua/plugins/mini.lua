return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      -- Minimal and fast autopairs
      require("mini.pairs").setup({})

      -- Fast and feature-rich surround actions
      require("mini.surround").setup({})
    end,
  },
}
