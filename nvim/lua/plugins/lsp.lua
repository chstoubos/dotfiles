-- https://github.com/neovim/nvim-lspconfig

return {
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonUninstall', 'MasonLog' },
    opts = {},
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      -- you are enabling servers yourself via vim.lsp.enable()
      automatic_enable = false,
    },
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    -- run even if you start Neovim with an empty buffer
    event = 'VimEnter',
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate', 'MasonToolsClean' },
    opts = function()
      return {
        ensure_installed = require('config.lsp_servers').ensure_installed(),
        run_on_start = true, -- default is true, but make it explicit
        start_delay = 0,
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      require('config.lsp').setup(require('config.lsp_servers').servers)
    end,
  },
}
