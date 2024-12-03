return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = 'VeryLazy',
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()

    vim.keymap.set("n", "<leader>hH", function() harpoon:list():prepend() end, { desc = 'Harpoon: prepend' })
    vim.keymap.set("n", "<leader>hh", function() harpoon:list():add() end, { desc = 'Harpoon: add' })
    vim.keymap.set("n", "<C-\\>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = 'Harpoon: toggle menu' })

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = 'Harpoon: select 1' })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = 'Harpoon: select 2' })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = 'Harpoon: select 3' })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = 'Harpoon: select 4' })
    vim.keymap.set("n", "<leader>r1", function() harpoon:list():replace_at(1) end, { desc = 'Harpoon: replace 1' })
    vim.keymap.set("n", "<leader>r2", function() harpoon:list():replace_at(2) end, { desc = 'Harpoon: replace 2' })
    vim.keymap.set("n", "<leader>r3", function() harpoon:list():replace_at(3) end, { desc = 'Harpoon: replace 3' })
    vim.keymap.set("n", "<leader>r4", function() harpoon:list():replace_at(4) end, { desc = 'Harpoon: replace 4' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "[h", function() harpoon:list():prev() end, { desc = 'Harpoon: prev buffer in list' })
    vim.keymap.set("n", "]h", function() harpoon:list():next() end, { desc = 'Harpoon: next buffer in list' })
  end
}
