local function get_shell()
  if vim.fn.has('win32') == 1 then
    return "powershell"
  end
  return os.getenv('SHELL')
end

return {
  {
    'numToStr/FTerm.nvim',
    opts = {
      cmd = get_shell(),
      border = 'rounded',
    },
    keys = {
      { '<A-i>', require"FTerm".toggle },
      { '<A-i>', function()
        vim.api.nvim_input('<C-\\><C-n>')
        require("FTerm").toggle()
      end, mode = 't'}
    },
  }
}
