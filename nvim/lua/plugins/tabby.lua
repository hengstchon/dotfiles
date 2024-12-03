return {
  'nanozuki/tabby.nvim',
  event = 'VeryLazy',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('tabby').setup({
      preset = 'active_wins_at_tail',
      option = {
        lualine_theme = 'rose-pine',
      },
    })
  end
}
