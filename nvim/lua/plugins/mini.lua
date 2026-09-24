-- https://github.com/nvim-mini/mini.nvim

return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.hipatterns').setup {
      highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        warning = { pattern = '%f[%w]()WARNING()%f[%W]', group = 'MiniHipatternsHack' },
        todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    }

    -- Replaces vim.ui.input, used by the stock `grn` rename prompt
    require('mini.input').setup()

    -- Show available keys after a delay
    local clue = require 'mini.clue'
    clue.setup {
      triggers = {
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = ']' },
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
      },
      clues = {
        clue.gen_clues.builtin_completion(),
        clue.gen_clues.g(),
        clue.gen_clues.marks(),
        clue.gen_clues.registers(),
        clue.gen_clues.square_brackets(),
        clue.gen_clues.windows(),
        clue.gen_clues.z(),
      },
      window = { delay = 400 },
    }

    local statusline = require 'mini.statusline'

    -- In quickfix/location list windows show the list's name (e.g. "References",
    -- "Diagnostics") instead of "[Quickfix List]", which stays as the fallback for
    -- untitled lists. Statusline expressions run in the context of the window
    -- being drawn, so vim.bo/vim.w refer to that window.
    local function list_name()
      if vim.bo.buftype == 'quickfix' then
        local title = vim.w.quickfix_title or ''
        return title ~= '' and title:gsub('%%', '%%%%') or '%t'
      end
    end

    statusline.setup {
      use_icons = true,
      content = {
        -- Default inactive content, plus the list name
        inactive = function()
          return '%#MiniStatuslineInactive#' .. (list_name() or '%F') .. '%='
        end,
      },
    }

    local section_filename = statusline.section_filename
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function(args)
      return list_name() or section_filename(args)
    end

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
