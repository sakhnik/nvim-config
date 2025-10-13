return {
  {
    'stevearc/oil.nvim',
    -----@module 'oil'
    -----@type oil.SetupOpts
    opts = {
      default_file_explorer = false,
    },
    init = function()
      vim.keymap.set('n', '-', require'oil'.open, { desc = "Open parent directory" })
    end,
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  }
}
