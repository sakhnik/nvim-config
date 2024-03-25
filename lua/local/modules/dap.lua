local C = {}

C.plugins = {
  'mfussenegger/nvim-dap',
  'nvim-neotest/nvim-nio',
  'rcarriga/nvim-dap-ui',
}

function C.setup()
  require'dapui'.setup()

  vim.api.nvim_set_keymap('n', '<leader>bb', '', { noremap = true, callback = function() require'dap'.toggle_breakpoint() end })
  vim.api.nvim_set_keymap('n', '<leader>bc', '', { noremap = true, callback = function() require'dap'.continue() end })
  vim.api.nvim_set_keymap('n', '<leader>D', '', { noremap = true, callback = function() require'dapui'.toggle() end })
  vim.api.nvim_set_keymap('n', '<leader>df', '', { noremap = true, callback = function() require'jdtls'.test_class() end })
  vim.api.nvim_set_keymap('n', '<leader>dm', '', { noremap = true, callback = function() require'jdtls'.test_nearest_method() end })
end

return C
