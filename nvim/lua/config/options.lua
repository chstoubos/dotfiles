local M = {}

function M.setup()
  vim.o.number = true
  vim.o.relativenumber = true

  -- Vertical bar character limit
  vim.opt.colorcolumn = '80'

  -- Enable mouse mode
  vim.o.mouse = 'a'

  -- No terminal beep
  vim.o.vb = true

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Sync clipboard between OS and Neovim.
  vim.o.clipboard = 'unnamedplus'

  vim.o.breakindent = true

  -- Keep undo history
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Control how to show whitespace characters
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = false

  -- Add a round border for all floating windows
  -- NOTE: Disable for now, looks ugly
  -- vim.o.winborder = 'rounded'
end

return M
