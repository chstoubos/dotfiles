-- https://github.com/nvim-treesitter/nvim-treesitter-context

return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    max_lines = 4,
    multiline_threshold = 1,
    trim_scope = 'outer',
    mode = 'cursor',
  },
}
