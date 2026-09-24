local M = {}

-- Put items in the quickfix list called `title` and show it. An existing list with
-- that title is replaced rather than a new one added, so there is only ever one
-- (e.g. a single "References" list next to the "Diagnostics" one).
local function set_titled_qflist(title, items)
  local id
  for nr = 1, vim.fn.getqflist({ nr = '$' }).nr do
    local list = vim.fn.getqflist { nr = nr, title = 0, id = 0 }
    if list.title == title then
      id = list.id
    end
  end
  vim.fn.setqflist({}, id and 'r' or ' ', { id = id, title = title, items = items })
  vim.cmd(('silent %dchistory'):format(vim.fn.getqflist({ id = id or 0, nr = 0 }).nr))
  vim.cmd 'botright copen'
end

-- Telescope picker for document symbols that also shows the LSP `detail` field.
-- For clangd that is the signature (e.g. `void (const Foo &, double)`), so
-- overloads can be told apart even when the declaration spans several lines.
-- Telescope's builtin lsp_document_symbols drops this field.
local function document_symbols()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

  vim.lsp.buf_request_all(bufnr, 'textDocument/documentSymbol', params, function(results)
    local items = {}
    local function add(symbols, client)
      for _, s in ipairs(symbols) do
        -- DocumentSymbol has selectionRange (the name), SymbolInformation has location
        local pos = (s.selectionRange or s.location.range).start
        local line = vim.api.nvim_buf_get_lines(bufnr, pos.line, pos.line + 1, false)[1] or ''
        table.insert(items, {
          name = s.name,
          kind = vim.lsp.protocol.SymbolKind[s.kind] or 'Unknown',
          detail = s.detail or '',
          lnum = pos.line + 1,
          col = vim.str_byteindex(line, client.offset_encoding, pos.character, false),
        })
        add(s.children or {}, client)
      end
    end
    for client_id, res in pairs(results) do
      local client = vim.lsp.get_client_by_id(client_id)
      if client and res.result then
        add(res.result, client)
      end
    end
    if #items == 0 then
      vim.notify('No document symbols', vim.log.levels.INFO)
      return
    end

    local conf = require('telescope.config').values
    local name_width = 0
    for _, item in ipairs(items) do
      name_width = math.max(name_width, #item.name)
    end
    local displayer = require('telescope.pickers.entry_display').create {
      separator = '  ',
      items = { { width = math.min(name_width, 60) }, { width = 10 }, { remaining = true } },
    }
    local opts = {
      layout_strategy = 'vertical',
      layout_config = { width = 0.9, height = 0.9, preview_height = 0.4 },
    }

    require('telescope.pickers')
      .new(opts, {
        prompt_title = 'Document Symbols',
        finder = require('telescope.finders').new_table {
          results = items,
          entry_maker = function(item)
            return {
              value = item,
              -- Include the signature so typing a parameter type narrows overloads
              ordinal = item.name .. ' ' .. item.detail,
              display = function()
                return displayer { item.name, { item.kind:lower(), 'TelescopeResults' .. item.kind }, item.detail }
              end,
              bufnr = bufnr,
              filename = vim.api.nvim_buf_get_name(bufnr),
              lnum = item.lnum,
              col = item.col,
            }
          end,
        },
        sorter = conf.generic_sorter(opts),
        previewer = conf.qflist_previewer(opts),
      })
      :find()
  end)
end

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

  -- Created once so per-buffer autocmds from earlier attaches aren't wiped
  local hl_group = vim.api.nvim_create_augroup('chris-lsp-highlight', { clear = true })
  local detach_group = vim.api.nvim_create_augroup('chris-lsp-detach', { clear = true })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('chris-lsp-attach', { clear = true }),
    callback = function(args)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
      end

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-t>. Multiple results go to the quickfix list.
      --  reuse_win: if the target file is already open in another window, jump
      --  there instead (then use <C-w>p to go back, <C-t> is per-window).
      map('gd', function()
        vim.lsp.buf.definition { reuse_win = true }
      end, '[G]oto [D]efinition')

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Document symbols in a picker instead of the default location list, so it
      -- doesn't stack with the quickfix list from grr
      map('gO', document_symbols, 'Document symbols')

      -- Same as the default grr, but a new search replaces the previous
      -- "References" list instead of adding another one
      map('grr', function()
        vim.lsp.buf.references(nil, {
          on_list = function(list)
            set_titled_qflist('References', list.items)
          end,
        })
      end, 'References')

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
        -- Avoid duplicates when a second capable client attaches to the same buffer
        vim.api.nvim_clear_autocmds { group = hl_group, buffer = bufnr }
        vim.api.nvim_clear_autocmds { group = detach_group, buffer = bufnr }

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
          group = detach_group,
          buffer = bufnr,
          callback = function(ev)
            -- Keep highlights if another attached client still provides them (e.g. eslint leaving while vtsls stays)
            local method = vim.lsp.protocol.Methods.textDocument_documentHighlight
            for _, c in ipairs(vim.lsp.get_clients { bufnr = bufnr, method = method }) do
              if c.id ~= ev.data.client_id then
                return
              end
            end

            -- bufnr may not be the current buffer when a client detaches
            vim.lsp.util.buf_clear_references(bufnr)
            vim.api.nvim_clear_autocmds { group = hl_group, buffer = bufnr }
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
