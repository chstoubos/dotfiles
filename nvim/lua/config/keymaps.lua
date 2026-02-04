local M = {}

function M.setup()
  -- Move block of code in visual mode
  vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
  vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

  -- Move next line in the current line
  vim.keymap.set('n', 'J', 'mzJ`z')

  -- Keep the cursor in the middle of the screen while going up and down
  vim.keymap.set('n', '<C-d>', '<C-d>zz')
  vim.keymap.set('n', '<C-u>', '<C-u>zz')

  -- Keep the cursor in the middle of the screen while searching
  vim.keymap.set('n', 'n', 'nzzzv')
  vim.keymap.set('n', 'N', 'Nzzzv')

  -- Jump to start and end of line using the home row keys
  vim.keymap.set('', 'H', '^')
  vim.keymap.set('', 'L', '$')

  -- Paste without adding the contents to your buffer
  vim.keymap.set('x', '<leader>p', [["_dP]])

  -- Delete without adding the contents to the buffer
  vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Unmap Q
  vim.keymap.set('n', 'Q', '<nop>')

  -- Clear highlights on search when pressing <Esc> in normal mode
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Disable arrow keys in normal mode
  -- left and right arrows can switch buffers
  vim.keymap.set('n', '<left>', ':bp<cr>')
  vim.keymap.set('n', '<right>', ':bn<cr>')
  vim.keymap.set('n', '<up>', '<nop>')
  vim.keymap.set('n', '<down>', '<nop>')
end

return M
