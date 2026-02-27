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
    {
      '<leader>fs',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' }, function(err)
          if err then
            return
          end
          local mode = vim.api.nvim_get_mode().mode
          if vim.startswith(string.lower(mode), 'v') then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
          end
        end)
      end,
      mode = 'v',
      desc = '[F]ormat [S]election',
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
