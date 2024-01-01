return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "AndreM222/copilot-lualine",
    },
    event = "VeryLazy",
    opts = {
      options = {
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      extensions = { "nvim-tree" },
    },
  },
}
