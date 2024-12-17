return {
  { 'tpope/vim-fugitive'; },
  { 'tpope/vim-eunuch'; },            -- :SudoWrite
  { 'tpope/vim-repeat'; },            -- Repeat mapping with .
  { 'tpope/vim-sleuth'; },            -- Set buffer options heuristically
  { 'tpope/vim-unimpaired'; },        -- ]q, ]a etc
  { 'tpope/vim-abolish'; },           -- coerce cr_, crc etc
  { 'kylechui/nvim-surround', opts = {} },      -- Movements s', s(
  {
    'bronson/vim-visual-star-search',
    keys = {
      { '#', mode = 'x' },
      { '*', mode = 'x' },
    }
  },
  { 'raimondi/delimitmate'; },
  { 'wellle/targets.vim'; },
  { 'mh21/errormarker.vim'; },
  { 'sirtaj/vim-openscad'; },
  {
    'plasticboy/vim-markdown',
    ft = 'markdown',
    init = function()
      vim.g.vim_markdown_folding_disabled = true
    end
  },
  {
    'Kris2k/A.vim',
    cmd = {"A", "AS"},
  },
  {
    'ledger/vim-ledger',
    ft = 'ledger',
    init = function()
      vim.g.ledger_bin = 'ledger'
      vim.g.ledger_date_format = '%Y-%m-%d'
      vim.g.ledger_extra_options = '--pedantic --explicit --date-format ' .. vim.g.ledger_date_format
      vim.g.ledger_align_at = 45
      vim.g.ledger_default_commodity = '₴'
      vim.g.ledger_commodity_before = 0
      vim.g.ledger_commodity_sep = ' '
      vim.g.ledger_fold_blanks = 1
    end,
  },

  -- Keymap online help
  {
    'folke/which-key.nvim',
    version = '*',
    opts = {}
  },
  {
    'LittleMorph/copyright-updater.nvim',
    event = 'BufModifiedSet',
    opts = {}
  },
}
