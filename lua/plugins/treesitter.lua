return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
  },

  {
    'andymass/vim-matchup',
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  },

  {
    'RRethy/vim-illuminate',
    event = 'BufWinEnter',
    config = function()
      require'illuminate'.configure({
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = { 'lsp', 'treesitter', },
      })
    end
  },
}
