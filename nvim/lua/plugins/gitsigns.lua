return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "Git: Next Hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "Git: Prev Hunk")

        -- Actions
        map("n", "<leader>gs", gitsigns.stage_hunk, "Git: Stage Hunk")
        map("n", "<leader>gr", gitsigns.reset_hunk, "Git: Reset Hunk")
        map(
          "v",
          "<leader>gs",
          function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          "Git: Stage Selected Hunk"
        )
        map(
          "v",
          "<leader>gr",
          function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          "Git: Reset Selected Hunk"
        )
        map("n", "<leader>gS", gitsigns.stage_buffer, "Git: Stage Buffer")
        map("n", "<leader>gR", gitsigns.reset_buffer, "Git: Reset Buffer")
        map("n", "<leader>gp", gitsigns.preview_hunk, "Git: Preview Hunk")
        map("n", "<leader>gl", function() gitsigns.blame_line({ full = true }) end, "Git: Blame Line")
        map("n", "<leader>gd", gitsigns.diffthis, "Git: Diff This")
        map("n", "<leader>gD", function() gitsigns.diffthis("~") end, "Git: Diff This (~)")

        -- Toggles
        map("n", "<leader>gtb", gitsigns.toggle_current_line_blame, "Git: Toggle Line Blame")
        map("n", "<leader>gtd", gitsigns.toggle_word_diff, "Git: Toggle Word Diff")

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git: Select Hunk")
      end,
    },
  },
}
