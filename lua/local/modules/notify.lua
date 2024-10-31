return {
  plugins = {
    --"rcarriga/nvim-notify",
    'j-hui/fidget.nvim',
  },

  setup = function()
    require'fidget'.setup {
      notification = {
        override_vim_notify = true,
      }
    }
  end,
}
