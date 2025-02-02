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
  local api = vim.api

  local function close_hover()
    if api.nvim_win_is_valid(view.win) then
      api.nvim_win_close(view.win, true)
    end
  end

  -- Close the hover when the buffer is left
  api.nvim_create_autocmd("BufLeave", {
    callback = close_hover,
    buffer = view.buf,
    once = true
  })

  vim.keymap.set('n', '<esc>', close_hover, { buffer = view.buf, silent = true })
end

-- Left click to print the symbol (hover)
local function on_left_click()
  local mpos = vim.fn.getmousepos()
  if vim.api.nvim_win_is_valid(mpos.winid) and mpos.line > 0 and mpos.column > 0 then
    local buf = vim.api.nvim_win_get_buf(mpos.winid)
    if vim.fn.buflisted(buf) ~= 0 then
      local ok, lines = pcall(vim.api.nvim_buf_get_lines, buf, mpos.line - 1, mpos.line, true)
      if ok and #lines > 0 and mpos.column <= #lines[1] then
        vim.api.nvim_set_current_win(mpos.winid)
        if pcall(vim.api.nvim_win_set_cursor, mpos.winid, {mpos.line, mpos.column - 1}) then
          create_dap_hover()
          return
        end
      end
    end
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true), "n", true)
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
      vim.keymap.set('n', '<f4>', require'dap'.run_to_cursor, { silent = true })
      vim.keymap.set('n', '<f5>', require'dap'.continue, { silent = true })
      vim.keymap.set('n', '<f8>', require'dap'.set_breakpoint, { silent = true })
      vim.keymap.set('n', '<f9>', create_dap_hover, { silent = true })
      vim.keymap.set('n', '<f10>', require'dap'.step_over, { silent = true })
      vim.keymap.set('n', '<f11>', require'dap'.step_into, { silent = true })
      vim.keymap.set('n', '<f12>', require'dap'.step_out, { silent = true })
      vim.keymap.set('n', '<LeftMouse>', on_left_click, { silent = true })

      timer_id = vim.fn.timer_start(1000, check_restore_keymaps)
    end
  end

  dap.listeners.after['event_terminated']['me'] = check_restore_keymaps
end

return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>bb', function() require'dap'.toggle_breakpoint() end, desc = 'DAP toggle breakpoint' },
      { '<leader>bc', debug_last_session, desc = 'DAP last session' },
      { '<leader>bC', function() require'dap'.continue() end, desc = 'DAP continue' },
    },
    dependencies = {
      { 'nvim-neotest/nvim-nio', },

      {
        'rcarriga/nvim-dap-ui',
        opts = {},
        keys = {
          { '<leader>D', function() require'dapui'.toggle() end, desc = 'DAP UI' },
        }
      },

      {
        'mfussenegger/nvim-dap-python',
        ft = 'python',
        config = function()
          require'dap-python'.setup('python3')
        end,
      },
    },

    config = function()
      configure_dap()

      if vim.fn.executable('gdb') == 1 then
        require('dapcfg.cpp')
      end

      require'dapcfg.lua'
    end,
  },

  {
    'jbyuki/one-small-step-for-vimkind',
    lazy = true,
  },
}
