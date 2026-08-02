return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      -- High frequency (2-key shortcuts)
      { "<leader><leader>", function() require("fzf-lua").files() end, desc = "Find: files" },
      { "<leader>,", function() require("fzf-lua").buffers() end, desc = "Buffer: open buffers" },
      { "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Search: live grep" },

      -- Find
      { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Find: recent files" },
      { "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "Find: help tags" },
      { "<leader>fk", function() require("fzf-lua").keymaps() end, desc = "Find: keymaps" },
      { "<leader>fp", function() require("fzf-lua").builtin() end, desc = "Find: fzf-lua pickers" },
      {
        "<leader>fa",
        function()
          require("fzf-lua").files({
            cmd = "fd --type f --hidden --follow --no-ignore --exclude .git",
          })
        end,
        desc = "Find: all files including ignored",
      },

      -- Search
      { "<leader>sw", function() require("fzf-lua").grep_cword() end, desc = "Search: word under cursor" },
      { "<leader>sd", function() require("fzf-lua").diagnostics_workspace() end, desc = "Search: diagnostics" },
      { "<leader>sb", function() require("fzf-lua").blines() end, desc = "Search: current buffer lines" },
      { "<leader>sr", function() require("fzf-lua").resume() end, desc = "Search: resume last search" },

      -- Git
      { "<leader>gg", function() require("fzf-lua").git_status() end, desc = "Git: status" },
      { "<leader>gc", function() require("fzf-lua").git_commits() end, desc = "Git: commits" },
      { "<leader>gb", function() require("fzf-lua").git_bcommits() end, desc = "Git: buffer commits" },
    },
  },
}
