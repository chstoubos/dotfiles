local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd

  -- Highlight on yank
  local yank_group = augroup('highlight_yank', { clear = true })
  autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = yank_group,
    callback = function()
      vim.hl.on_yank()
    end,
  })

  -- When quitting the last normal window in a tab, also close any quickfix or
  -- location list windows, instead of leaving just the list behind
  autocmd('QuitPre', {
    desc = 'Close list windows along with the last normal window',
    group = augroup('close_lists_on_quit', { clear = true }),
    callback = function()
      local current = vim.api.nvim_get_current_win()
      local lists = {}
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local type = vim.fn.win_gettype(win)
        if win ~= current and type ~= 'popup' then
          if type ~= 'quickfix' and type ~= 'loclist' then
            return -- another normal window stays open
          end
          table.insert(lists, win)
        end
      end
      for _, win in ipairs(lists) do
        vim.api.nvim_win_close(win, true)
      end
    end,
  })

  -- Keep the "Diagnostics" quickfix list from <leader>q up to date. Only an existing
  -- list is updated (in place, keeping the selected entry); none is created, and
  -- the quickfix window keeps showing whichever list it was showing.
  autocmd('DiagnosticChanged', {
    desc = 'Refresh the Diagnostics quickfix list',
    group = augroup('refresh_diagnostics_qf', { clear = true }),
    callback = function()
      for nr = 1, vim.fn.getqflist({ nr = '$' }).nr do
        if vim.fn.getqflist({ nr = nr, title = 0 }).title == 'Diagnostics' then
          vim.diagnostic.setqflist { open = false }
          return
        end
      end
    end,
  })
end

return M
