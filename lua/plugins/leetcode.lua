vim.pack.add {
  { src = 'https://github.com/kawre/leetcode.nvim', },
  { src = 'https://github.com/MunifTanjim/nui.nvim', },
}

require'leetcode'.setup {
  lang = vim.env.LEET_LANG and vim.env.LEET_LANG or 'cpp'
}
