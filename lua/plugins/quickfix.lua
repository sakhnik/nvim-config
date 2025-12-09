vim.pack.add {
  { src = 'https://github.com/yorickpeterse/nvim-pqf', },
  { src = 'https://github.com/sakhnik/make-async.nvim', },
  { src = 'https://github.com/sakhnik/nvim-gdb', },
}

require'pqf'.setup {}
require'make-async'.setup {}
