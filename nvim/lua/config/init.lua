local M = {}

function M.setup()
  require('config.options').setup()
  require('config.keymaps').setup()
  require('config.autocmds').setup()

  -- plugin manager + plugins
  require 'config.lazy'
end

return M
