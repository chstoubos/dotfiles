-- https://github.com/saghen/blink.cmp

return {
  'saghen/blink.cmp',
  event = 'VimEnter', -- late startup
  version = '1.*',

  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      build = 'make install_jsregexp',
      dependencies = { 'rafamadriz/friendly-snippets' },
      config = function()
        local ls = require 'luasnip'
        require('luasnip.loaders.from_vscode').lazy_load()

        -- friendly-snippets “*doc” collections
        ls.filetype_extend('cpp', { 'cppdoc' })
        ls.filetype_extend('c', { 'cdoc' })
        ls.filetype_extend('go', { 'godoc' })
        ls.filetype_extend('rust', { 'rustdoc' })
        ls.filetype_extend('sh', { 'shelldoc' })
      end,
    },

    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
  },

  opts = {
    keymap = {
      preset = 'enter',
      ['<C-l>'] = { 'snippet_forward', 'fallback' },
      ['<C-h>'] = { 'snippet_backward', 'fallback' },
      ['<Tab>'] = {},
      ['<S-Tab>'] = {},
    },

    appearance = { nerd_font_variant = 'mono' },

    completion = {
      documentation = { auto_show = false },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },

      -- Lua-only: add lazydev without losing defaults
      per_filetype = {
        lua = { inherit_defaults = true, 'lazydev' },
      },

      providers = {
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
  },
}
