-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = { 'BufReadPost', 'BufNewFile' },

  -- Built-in ftplugins define their own ]m, [[ etc. which would shadow these
  init = function()
    vim.g.no_plugin_maps = true
  end,

  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true,
        selection_modes = {
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
        },
      },
      move = { set_jumps = true },
    }

    local select = require 'nvim-treesitter-textobjects.select'
    local move = require 'nvim-treesitter-textobjects.move'

    -- m = function, c = class. mini.ai already owns a/f/b/q/t.
    local objects = {
      ['am'] = '@function.outer',
      ['im'] = '@function.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
    }
    for key, query in pairs(objects) do
      vim.keymap.set({ 'x', 'o' }, key, function()
        select.select_textobject(query, 'textobjects')
      end, { desc = 'Select ' .. query })
    end

    local moves = {
      [']m'] = { move.goto_next_start, '@function.outer' },
      [']M'] = { move.goto_next_end, '@function.outer' },
      ['[m'] = { move.goto_previous_start, '@function.outer' },
      ['[M'] = { move.goto_previous_end, '@function.outer' },
      [']]'] = { move.goto_next_start, '@class.outer' },
      ['[['] = { move.goto_previous_start, '@class.outer' },
      [']['] = { move.goto_next_end, '@class.outer' },
      ['[]'] = { move.goto_previous_end, '@class.outer' },
    }
    for key, spec in pairs(moves) do
      local fn, query = spec[1], spec[2]
      vim.keymap.set({ 'n', 'x', 'o' }, key, function()
        fn(query, 'textobjects')
      end, { desc = 'Move ' .. query })
    end
  end,
}
