local ok, dap = pcall(require, 'dap')
if not ok then
  return
end

-- See
-- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Interpreters.html
-- https://sourceware.org/gdb/current/onlinedocs/gdb.html/Debugger-Adapter-Protocol.html
dap.adapters.gdb = {
  id = 'gdb',
  type = 'executable',
  command = 'gdb',
  args = { '--quiet', '--interpreter=dap' },
}

dap.configurations.cpp = {
  {
    name = 'Run executable (GDB)',
    type = 'gdb',
    request = 'launch',
    -- This requires special handling of 'run_last', see
    -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
    program = function()
      local path = vim.fn.input({
        prompt = 'Path to executable: ',
        default = vim.fn.getcwd() .. '/',
        completion = 'file',
      })

      return (path and path ~= '') and path or dap.ABORT
    end,
  },
  {
    name = 'Run executable with arguments (GDB)',
    type = 'gdb',
    request = 'launch',
    -- This requires special handling of 'run_last', see
    -- https://github.com/mfussenegger/nvim-dap/issues/1025#issuecomment-1695852355
    program = function()
      local path = vim.fn.input({
        prompt = 'Path to executable: ',
        default = vim.fn.getcwd() .. '/',
        completion = 'file',
      })

      return (path and path ~= '') and path or dap.ABORT
    end,
    args = function()
      local args_str = vim.fn.input({
        prompt = 'Arguments: ',
      })
      return vim.split(args_str, ' +')
    end,
  },
  {
    name = 'Attach to process (GDB)',
    type = 'gdb',
    request = 'attach',
    processId = require('dap.utils').pick_process,
  },
}

dap.configurations.c = dap.configurations.cpp
