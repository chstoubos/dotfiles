return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },

      -- Optional but useful for name translation + :LspInstall.
      -- Disable auto-enable because we explicitly call vim.lsp.enable() ourselves.
      { 'mason-org/mason-lspconfig.nvim', opts = { automatic_enable = false } },

      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },

      -- Completion capabilities source (you already use it)
      'saghen/blink.cmp',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local servers = require 'config.lsp_servers'

      require('mason-tool-installer').setup { ensure_installed = servers.ensure_installed() }
      require('config.lsp').setup(servers.servers)
    end,
  },
}
