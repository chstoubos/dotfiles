local tc = "/home/chris/etheron/bsp/l4t-gcc/aarch64--glibc--stable-2022.08-1"

return {
  cmd = {
    "clangd",
    "--query-driver="
      .. table.concat({
        "/usr/bin/c++",
        "/usr/bin/g++",
        tc .. "/bin/aarch64*-gcc",
        tc .. "/bin/aarch64*-g++",
      }, ","),
  },
}
