-- https://github.com/stevearc/conform.nvim

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>ff',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      cpp = { 'clang-format', lsp_format = 'first' },
    },
  },
}
