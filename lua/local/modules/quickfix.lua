return {
  plugins = {
    'yorickpeterse/nvim-pqf';
  },

  setup = function()
    require'pqf'.setup()
  end
}
