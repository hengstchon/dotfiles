return {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   keys = {
  --     -- Add / Toggle menu
  --     { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon: add file" },
  --     {
  --       "<leader>he",
  --       function()
  --         local harpoon = require("harpoon")
  --         harpoon.ui:toggle_quick_menu(harpoon:list())
  --       end,
  --       desc = "Harpoon: toggle menu",
  --     },

  --     -- Direct navigation (1-5)
  --     { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: select 1" },
  --     { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: select 2" },
  --     { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: select 3" },
  --     { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: select 4" },
  --     { "<leader>h5", function() require("harpoon"):list():select(5) end, desc = "Harpoon: select 5" },

  --     -- Relative navigation
  --     { "[h", function() require("harpoon"):list():prev() end, desc = "Harpoon: previous item" },
  --     { "]h", function() require("harpoon"):list():next() end, desc = "Harpoon: next item" },
  --   },
  --   config = function() require("harpoon"):setup() end,
}
