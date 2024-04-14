local C = {}

C.plugins = {
  'mfussenegger/nvim-dap',
  'mfussenegger/nvim-dap-python',
  'nvim-neotest/nvim-nio',
  'rcarriga/nvim-dap-ui',
  'theHamsta/nvim-dap-virtual-text',
}

function C.setup()
  require'dapui'.setup()
  require'nvim-dap-virtual-text'.setup()

  vim.api.nvim_set_keymap('n', '<leader>bb', '', { noremap = true, callback = function() require'dap'.toggle_breakpoint() end, desc = 'DAP toggle breakpoint' })
  vim.api.nvim_set_keymap('n', '<leader>bc', '', { noremap = true, callback = function() require'dap'.continue() end, desc = 'DAP continue' })
  vim.api.nvim_set_keymap('n', '<leader>D', '', { noremap = true, callback = function() require'dapui'.toggle() end, desc = 'DAP UI' })

  local widgets = function() return require'dap.ui.widgets' end

  -- TODO: activate mapping together with DAP UI
  vim.keymap.set({'n', 'v'}, '<Leader>dh', function() widgets().hover() end, {noremap = true, desc = 'DAP hover'})
  vim.keymap.set({'n', 'v'}, '<Leader>dp', function() widgets().preview() end, {noremap = true, desc = 'DAP preview'})
  vim.keymap.set('n', '<Leader>df', function() widgets().centered_float(widgets().frames) end, {noremap = true, desc = 'DAP frames'})
  vim.keymap.set('n', '<Leader>ds', function() widgets().centered_float(widgets().scopes) end, {noremap = true, desc = 'DAP scopes'})

  if vim.fn.executable('gdb') == 1 then
    require('local.modules.dap.cpp')
  end
end

return C
