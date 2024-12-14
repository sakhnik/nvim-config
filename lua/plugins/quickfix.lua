return {
  { 'yorickpeterse/nvim-pqf', opts = {} },

  {
    'sakhnik/make-async.nvim',
    opts = {},
    cmd = { 'Make', 'X' },
    keys = { '<leader>mm' },
  },

  {
    'sakhnik/nvim-gdb',
    cmd = {
      'GdbStart', 'GdbStartLLDB', 'GdbStartPDB', 'GdbStartBashDB', 'GdbStartRR',
    },
    keys = {
      '<leader>dd', '<leader>db', '<leader>dp', '<leader>db', '<leader>dr'
    }
  },
}
