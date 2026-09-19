-- https://github.com/danymat/neogen

return {
  'danymat/neogen',
  version = '*',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cmd = 'Neogen',
  opts = {
    snippet_engine = 'luasnip',
  },
}
