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
end

return M
