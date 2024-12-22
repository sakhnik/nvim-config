local last_config = nil

local function debug_last_session()
  if last_config then
    require'dap'.run(last_config)
  else
    require'dap'.continue()
  end
end

local function create_dap_hover()
  local view = require("dap.ui.widgets").hover()

  -- Close the hover when the buffer is left
  local api = vim.api
  api.nvim_create_autocmd("BufLeave", {
    callback = function()
      if api.nvim_win_is_valid(view.win) then
        api.nvim_win_close(view.win, true)
      end
    end,
    buffer = view.buf,
    once = true
  })
end

-- Left click to print the symbol (hover)
local function on_left_click()
  local mpos = vim.fn.getmousepos()
  if vim.api.nvim_win_is_valid(mpos.winid) then
    vim.api.nvim_set_current_win(mpos.winid)
    vim.api.nvim_win_set_cursor(mpos.winid, {mpos.line, mpos.column - 1})
  end
  create_dap_hover()
end

local function configure_dap()
  local dap = require('dap')
  local timer_id = -1

  ---@param session dap.Session
  dap.listeners.after.event_initialized["store_config"] = function(session)
    last_config = session.config
  end

  local function restore_keymaps()
    vim.keymap.del('n', '<LeftMouse>')
    vim.keymap.del('n', '<f4>')
    vim.keymap.del('n', '<f5>')
    vim.keymap.del('n', '<f8>')
    vim.keymap.del('n', '<f9>')
    vim.keymap.del('n', '<f10>')
    vim.keymap.del('n', '<f11>')
    vim.keymap.del('n', '<f12>')
  end

  local function check_restore_keymaps()
    if not next(dap.sessions()) then
      restore_keymaps()
      vim.fn.timer_stop(timer_id)
      timer_id = -1
    end
  end

  dap.listeners.after['event_initialized']['me'] = function()
    if timer_id == -1 then
      -- Set keymaps like in nvim-gdb
      vim.keymap.set('n', '<f4>', require'dap'.run_to_cursor, { noremap = true, silent = true })
      vim.keymap.set('n', '<f5>', require'dap'.continue, { noremap = true, silent = true })
      vim.keymap.set('n', '<f8>', require'dap'.set_breakpoint, { noremap = true, silent = true })
      vim.keymap.set('n', '<f9>', create_dap_hover, { noremap = true, silent = true })
      vim.keymap.set('n', '<f10>', require'dap'.step_over, { noremap = true, silent = true })
      vim.keymap.set('n', '<f11>', require'dap'.step_into, { noremap = true, silent = true })
      vim.keymap.set('n', '<f12>', require'dap'.step_out, { noremap = true, silent = true })
      vim.keymap.set('n', '<LeftMouse>', on_left_click, { noremap = true, silent = true })

      timer_id = vim.fn.timer_start(1000, check_restore_keymaps)
    end
  end

  dap.listeners.after['event_terminated']['me'] = check_restore_keymaps
end

return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>bb', require'dap'.toggle_breakpoint, noremap = true, desc = 'DAP toggle breakpoint' },
      { '<leader>bc', debug_last_session, noremap = true, desc = 'DAP last session' },
      { '<leader>bC', require'dap'.continue, noremap = true, desc = 'DAP continue' },
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
      configure_dap()

      if vim.fn.executable('gdb') == 1 then
        require('dapcfg.cpp')
      end

      require'dapcfg.lua'
    end,
  },

  { 'jbyuki/one-small-step-for-vimkind', },
}
