local M = {}

function M.setup(servers)
  vim.diagnostic.config {
    update_in_insert = true,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    },
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity]
      end,
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('chris-lsp-attach', { clear = true }),
    callback = function(args)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
      end

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-t>.
      map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

      -- Fuzzy find all the symbols in your current workspace.
      --  Similar to document symbols, except searches over your entire project.
      map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      if client.name == 'clangd' then
        map('<leader>o', '<cmd>LspClangdSwitchSourceHeader<CR>', 'Switch source/header')
      end

      -- Document highlight (only if supported)
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
        local hl_group = vim.api.nvim_create_augroup('chris-lsp-highlight', { clear = false })

        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          group = hl_group,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          group = hl_group,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('chris-lsp-detach', { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'chris-lsp-highlight', buffer = bufnr }
          end,
        })
      end

      -- Optional: buffer-local inlay hint toggle (doesn't conflict with defaults)
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
        vim.keymap.set('n', '<leader>th', function()
          local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        end, { buffer = bufnr, desc = 'Toggle inlay hints' })
      end
    end,
  })

  -- Capabilities (blink.cmp → LSP)
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  -- Apply defaults to ALL LSP configs
  vim.lsp.config('*', {
    capabilities = capabilities,
  })

  -- Apply per-server overrides
  vim.lsp.enable(servers)
end

return M
