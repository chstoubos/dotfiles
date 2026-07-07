local M = {}

-- LSP
M.servers = {
  'lua_ls',
  'clangd',
  'neocmake',
  'bashls',
  'rust_analyzer',
  'gopls',
  'pylsp',
  'prismals',
  'tailwindcss',
  'eslint',
  'vtsls'
}

-- Non-LSP tools (formatters/linters)
M.tools = {
  'stylua',
  'shfmt',
  'shellcheck',
  'prettier',
}

function M.ensure_installed()
  local ensure = vim.deepcopy(M.servers)
  vim.list_extend(ensure, M.tools)
  return ensure
end

return M
