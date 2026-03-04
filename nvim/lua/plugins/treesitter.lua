-- https://github.com/nvim-treesitter/nvim-treesitter

return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      local parsers = {
        'ada',
        'arduino',
        'asm',
        'awk',
        'bibtex',
        'bitbake',
        'angular',
        'c_sharp',
        'c3',
        'devicetree',
        'haskell',
        'haskell_persistent',
        'ini',
        'linkerscript',
        'bash',
        'c',
        'cpp',
        'css',
        'csv',
        'clojure',
        'cmake',
        'comment',
        'commonlisp',
        'd',
        'dart',
        'desktop',
        'disassembly',
        'dockerfile',
        'dot',
        'doxygen',
        'editorconfig',
        'elixir',
        'elm',
        'erlang',
        'fortran',
        'fsharp',
        'gitattributes',
        'gitignore',
        'gitcommit',
        'glsl',
        'gnuplot',
        'go',
        'goctl',
        'gomod',
        'gosum',
        'gotmpl',
        'gpg',
        'gstlaunch',
        'cuda',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'python',
        'udev',
        'json',
        'hjson',
        'hlsl',
        'julia',
        'kconfig',
        'kotlin',
        'llvm',
        'matlab',
        'toml',
        'tmux',
        'yaml',
        'zsh',
        'xresources',
        'vue',
        'zig',
        'javascript',
        'git_config',
        'git_rebase',
        'latex',
        'make',
        'perl',
        'ssh_config',
        'terraform',
        'textproto',
        'tsx',
        'typescript',
        'xml',
      }
      require('nvim-treesitter').install(parsers)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          -- check if parser exists and load it
          if not vim.treesitter.language.add(language) then
            return
          end
          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          -- for more info on folds see `:help folds`
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          -- vim.wo.foldmethod = 'expr'

          -- enables treesitter based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
