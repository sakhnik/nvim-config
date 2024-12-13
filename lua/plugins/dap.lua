
--function C.setup()
--
--  local widgets = function() return require'dap.ui.widgets' end
--
--  -- TODO: activate mapping together with DAP UI
--  vim.keymap.set({'n', 'v'}, '<Leader>dh', function() widgets().hover() end, {noremap = true, desc = 'DAP hover'})
--  vim.keymap.set({'n', 'v'}, '<Leader>dp', function() widgets().preview() end, {noremap = true, desc = 'DAP preview'})
--  vim.keymap.set('n', '<Leader>df', function() widgets().centered_float(widgets().frames) end, {noremap = true, desc = 'DAP frames'})
--  vim.keymap.set('n', '<Leader>ds', function() widgets().centered_float(widgets().scopes) end, {noremap = true, desc = 'DAP scopes'})
--
--end
--
--return C

return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>bb', function() require'dap'.toggle_breakpoint() end, noremap = true, desc = 'DAP toggle breakpoint' },
      { '<leader>bc', function() require'dap'.continue() end, noremap = true, desc = 'DAP continue' },
    },
    dependencies = {
      { 'nvim-neotest/nvim-nio', },

      {
        'rcarriga/nvim-dap-ui',
        opts = {},
        keys = {
          { '<leader>D', function() require'dapui'.toggle() end, noremap = true, desc = 'DAP UI' },
        }
      },

      { 'theHamsta/nvim-dap-virtual-text', opts = {} },
      { 'mfussenegger/nvim-dap-python', },
    },

    config = function()
      if vim.fn.executable('gdb') == 1 then
        require('local.modules.dap.cpp')
      end

      require'local.modules.dap.lua'
    end,
  },

  { 'jbyuki/one-small-step-for-vimkind', },
}
