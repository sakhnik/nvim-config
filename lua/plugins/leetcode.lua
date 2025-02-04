return {
  "kawre/leetcode.nvim",
  build = ':TSUpdate html',
  dependencies = {
    "nvim-telescope/telescope.nvim",
    -- "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    'nvim-treesitter/nvim-treesitter'
  },
  cmd = 'Leet',
  opts = {
    -- configuration goes here
    lang = vim.env.LEET_LANG and vim.env.LEET_LANG or 'cpp'
  },
}
