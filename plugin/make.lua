local M = {}

function M.make()
  local lines = {""}
  --local winnr = vim.fn.win_getid()
  --local bufnr = vim.api.nvim_win_get_buf(winnr)

  local makeprg = vim.o.makeprg
  print(makeprg)
  if not makeprg then return end

  local cmd = vim.fn.expandcmd(makeprg)

  local function on_event(job_id, data, event)
    if M.job_id ~= job_id then return end

    if event == "stdout" or event == "stderr" then
      if data then
        vim.list_extend(lines, data)
      end
    elseif event == "exit" then
      vim.fn.setqflist({}, " ", {
        title = cmd,
        lines = lines,
        --efm = vim.api.nvim_buf_get_option(bufnr, "errorformat")
      })
      vim.api.nvim_command("doautocmd QuickFixCmdPost")
    end
  end

  if M.job_id ~= nil then
    vim.fn.chanclose(M.job_id)
  end

  M.job_id = vim.fn.jobstart(cmd, {
      on_stderr = on_event,
      on_stdout = on_event,
      on_exit = on_event,
      stdout_buffered = true,
      stderr_buffered = true,
    })
end

vim.api.nvim_set_keymap('n', '<leader>mm', '', { noremap = true, callback = M.make, desc = "Run 'makeprg' asynchronously and populate quickfix" })
return M
