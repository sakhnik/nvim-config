vim.pack.add {
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/tpope/vim-eunuch' },            -- :SudoWrite
  { src = 'https://github.com/tpope/vim-repeat' },            -- Repeat mapping with .
  { src = 'https://github.com/tpope/vim-sleuth' },            -- Set buffer options heuristically
  { src = 'https://github.com/tpope/vim-unimpaired' },        -- ]q, ]a etc
  { src = 'https://github.com/tpope/vim-abolish' },           -- coerce cr_, crc etc
  {
    src = 'https://github.com/kylechui/nvim-surround',        -- Movements s', s(
    version = vim.version.range('*'),
  },
  { src = 'https://github.com/bronson/vim-visual-star-search' },
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/wellle/targets.vim' },
  { src = 'https://github.com/mh21/errormarker.vim' },
  { src = 'https://github.com/sirtaj/vim-openscad' },
  { src = 'https://github.com/plasticboy/vim-markdown' },
  { src = 'https://github.com/Kris2k/A.vim' },
  { src = 'https://github.com/ledger/vim-ledger' },
  {
    src = 'https://github.com/folke/which-key.nvim',
    version = vim.version.range('*'),
  },
  { src = 'https://github.com/LittleMorph/copyright-updater.nvim' },
}

require'nvim-autopairs'.setup {}

vim.g.vim_markdown_folding_disabled = true

vim.g.ledger_bin = 'ledger'
vim.g.ledger_date_format = '%Y-%m-%d'
vim.g.ledger_extra_options = '--pedantic --explicit --date-format ' .. vim.g.ledger_date_format
vim.g.ledger_align_at = 45
vim.g.ledger_default_commodity = '₴'
vim.g.ledger_commodity_before = 0
vim.g.ledger_commodity_sep = ' '
vim.g.ledger_fold_blanks = 1

require'nvim-surround'.setup {}
require'which-key'.setup {}
require'copyright-updater'.setup {}
