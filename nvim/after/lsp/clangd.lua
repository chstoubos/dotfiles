local tc = '/home/chris/etheron/bsp/l4t-gcc/aarch64--glibc--stable-2022.08-1'
local esp = (vim.env.IDF_TOOLS_PATH or vim.env.HOME .. '/.espressif') .. '/tools'

return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--completion-style=detailed',
    '--header-insertion=iwyu',
    '--function-arg-placeholders',
    '--pch-storage=memory',
    '-j=' .. math.max(1, math.floor(#vim.uv.cpu_info() / 2)),
    '--query-driver=' .. table.concat({
      '/usr/bin/c++',
      '/usr/bin/g++',
      tc .. '/bin/aarch64*-gcc',
      tc .. '/bin/aarch64*-g++',
      esp .. '/**/bin/*-elf-gcc',
      esp .. '/**/bin/*-elf-g++',
    }, ','),
  },
  init_options = {
    fallbackFlags = { '-std=c++20' },
  },
}
