local M = {}

-- LSP
M.servers = {
  'lua_ls',
  'clangd',
  'rust_analyzer',
}

-- Non-LSP tools (formatters/linters)
M.tools = {
  'stylua',
  'shfmt',
}

function M.ensure_installed()
  local ensure = vim.deepcopy(M.servers)
  vim.list_extend(ensure, M.tools)
  return ensure
end

return M
