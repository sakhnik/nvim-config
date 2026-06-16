vim.pack.add {
  { src = 'https://github.com/stevearc/quicker.nvim', },
  { src = 'https://github.com/sakhnik/make-async.nvim', },
  { src = 'https://github.com/sakhnik/nvim-gdb', },
}

require'quicker'.setup {}
require'make-async'.setup {}
