local tc = '/home/chris/etheron/bsp/l4t-gcc/aarch64--glibc--stable-2022.08-1'
local esp = (vim.env.IDF_TOOLS_PATH or vim.env.HOME .. '/.espressif') .. '/tools'

return {
  cmd = {
    'clangd',
    '--query-driver=' .. table.concat({
      '/usr/bin/c++',
      '/usr/bin/g++',
      tc .. '/bin/aarch64*-gcc',
      tc .. '/bin/aarch64*-g++',
      esp .. '/**/bin/*-elf-gcc',
      esp .. '/**/bin/*-elf-g++',
    }, ','),
  },
}
