return {
  plugins = {
    --"rcarriga/nvim-notify",
    'j-hui/fidget.nvim',
  },

  setup = function()
    require'fidget'.setup {
      -- options
    }
  end,
}
