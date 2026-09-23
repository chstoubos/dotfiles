return {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        features = 'all', -- check.features inherits this
      },
      check = {
        command = 'clippy',
      },
    },
  },
}
