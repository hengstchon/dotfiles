return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
      "nvim-telescope/telescope-file-browser.nvim",
      "benfowler/telescope-luasnip.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions_layout = require("telescope.actions.layout")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-y>"] = actions_layout.toggle_preview,
            },
          },
        },
      })

      telescope.load_extension("file_browser")
      telescope.load_extension("fzf")
      telescope.load_extension("luasnip")

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "TS: files in CWD" })
      vim.keymap.set("n", "<leader>fa", function()
        builtin.find_files({
          follow = true,
          no_ignore = true,
          hidden = true,
        })
      end, { desc = "TS: all files in CWD" })
      -- vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "TS: previously open files" })
      -- vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "TS: search string in CWD" })
      -- vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "TS: search under cursor in CWD" })
      -- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "TS: buffers" })
      -- vim.keymap.set("n", "<leader>fp", builtin.resume, { desc = "TS: previous picker" })
      -- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "TS: help tags" })
      -- vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "TS: normal mode keymappings" })
      -- vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "TS: diagnostics" })
      vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "TS: references" })
      vim.keymap.set("n", "<leader>cm", builtin.git_commits, { desc = "TS: git commits with diff" })
      vim.keymap.set("n", "<leader>bm", builtin.git_bcommits, { desc = "TS: buffer's git commits with diff" })
      vim.keymap.set("n", "<leader>gt", builtin.git_status, { desc = "TS: changes per file with diff" })
      vim.keymap.set("n", "<leader>bf", builtin.current_buffer_fuzzy_find, { desc = "TS: search in buffer" })
      vim.keymap.set(
        "n",
        "<leader>fn",
        telescope.extensions.file_browser.file_browser,
        { desc = "TS: file browser" }
      )
      vim.keymap.set("n", "<leader>sn", telescope.extensions.luasnip.luasnip, { desc = "TS: luasnip" })
    end,
  },
}
