vim.pack.add {
  { src = 'https://github.com/echasnovski/mini.icons', },
  { src = 'https://github.com/nvim-lua/plenary.nvim', },
}

require'mini.icons'.setup {}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.keymap.set(
      'n',
      '<leader>tt',
      '<Plug>PlenaryTestFile',
      { silent = true, buffer = true, desc = 'Plenary: test file' }
    )
  end,
})
