-- https://github.com/ellisonleao/gruvbox.nvim

return {
  'ellisonleao/gruvbox.nvim',

  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.

  opts = {
    italic = {
      strings = false,
      emphasis = false,
      comments = false,
      operators = false,
      folds = false,
    },
    contrast = 'hard',
  },

  config = function(_, opts)
    require('gruvbox').setup(opts)

    vim.o.background = 'dark'
    vim.cmd.colorscheme 'gruvbox'
    vim.cmd.hi 'Comment gui=none'
  end,
}
