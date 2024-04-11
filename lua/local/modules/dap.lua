local C = {}

C.plugins = {
  'mfussenegger/nvim-dap',
  'mfussenegger/nvim-dap-python',
  'nvim-neotest/nvim-nio',
  'rcarriga/nvim-dap-ui',
}

function C.setup()
  require'dapui'.setup()

  vim.api.nvim_set_keymap('n', '<leader>bb', '', { noremap = true, callback = function() require'dap'.toggle_breakpoint() end, desc = 'DAP toggle breakpoint' })
  vim.api.nvim_set_keymap('n', '<leader>bc', '', { noremap = true, callback = function() require'dap'.continue() end, desc = 'DAP continue' })
  vim.api.nvim_set_keymap('n', '<leader>D', '', { noremap = true, callback = function() require'dapui'.toggle() end, desc = 'DAP UI' })
  vim.api.nvim_set_keymap('n', '<leader>df', '', { noremap = true, callback = function() require'jdtls'.test_class() end, desc = 'JDT LS test class' })
  vim.api.nvim_set_keymap('n', '<leader>dm', '', { noremap = true, callback = function() require'jdtls'.test_nearest_method() end, desc = 'JDT LS test nearest method' })
end

return C
