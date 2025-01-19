return {
  "nvim-lua/plenary.nvim",       -- Common utilities
  "nvim-tree/nvim-web-devicons", -- Icons

  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = true,
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<C-n>",     ":NvimTreeToggle<CR>",   silent = true },
      { "<leader>n", ":NvimTreeFindFile<CR>", silent = true },
    },
    opts = {
      view = {
        adaptive_size = true,
        width = {
          max = 80
        }
      },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del("n", "<C-E>", { buffer = bufnr })
      end,
    },
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    event = "VeryLazy",
    opts = function()
      return { pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() }
    end,
  },

  -- Color highlighter
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    config = true,
  },

  --Indent line
  {
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
  },
}
