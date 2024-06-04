return {
  plugins = {
    'yorickpeterse/nvim-pqf';
    'sakhnik/make-async.nvim';
  },

  setup = function()
    require'pqf'.setup()
    require'make-async'.setup()
  end
}
