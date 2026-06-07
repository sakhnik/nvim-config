--local function get_shell()
--  if vim.fn.has('win32') == 1 then
--    return "powershell"
--  end
--  return os.getenv('SHELL')
--end

vim.pack.add {
  { src = 'https://github.com/sakhnik/quickterm.nvim', }
}
