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
    lang = 'cpp'
  },
}
