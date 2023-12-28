return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "GS: stage hunk" })
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "GS: reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "GS: stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "GS: undo stage hunk" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "GS: reset buffer" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "GS: preview hunk" })
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, { desc = "GS: blame line" })
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "GS: toggle current line blame" })
        map("n", "<leader>hd", gs.diffthis, { desc = "GS: diff this" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "GS: toggle deleted" })

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
    },
  },
}
