vim.pack.add {
  {
    src = 'https://github.com/j-hui/fidget.nvim',
    version = vim.version.range('*'),
  },
}

require'fidget'.setup {
  notification = {
    override_vim_notify = true,
  }
}
