return {
  plugins = {
    -- database exploration
    'tpope/vim-dadbod',
    'kristijanhusak/vim-dadbod-ui',
    'kristijanhusak/vim-dadbod-completion',
  },
  setup = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {'sql', 'mysql', 'plsql'},
      callback = function(_)
        require'cmp'.setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
      end
    })
  end
}
