local function get_shell()
  if vim.fn.has('win32') == 1 then
    return "powershell"
  end
  return os.getenv('SHELL')
end

vim.pack.add {
  { src = 'https://github.com/numToStr/FTerm.nvim', },
  { src = 'https://github.com/sakhnik/quickterm.nvim', }
}

require'FTerm'.setup {
  cmd = get_shell(),
  border = 'rounded',
}

vim.keymap.set('n', '<a-i>', function() require"FTerm".toggle() end,
  {noremap = true, silent = true, desc = 'Toggle terminal'})
vim.keymap.set('t', '<a-i>', function() vim.api.nvim_input('<C-\\><C-n>'); require("FTerm").toggle() end,
  {noremap = true, silent = true, desc = 'Toggle terminal'})
