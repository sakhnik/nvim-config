local M = {}

function M.make()
  -- Stop any previous jobs
  if M.job_id ~= nil then
    vim.fn.chanclose(M.job_id)
  end

  -- Clear the qf list
  vim.fn.setqflist({}, "r")

  --local winnr = vim.fn.win_getid()
  --local bufnr = vim.api.nvim_win_get_buf(winnr)

  local makeprg = vim.o.makeprg
  if not makeprg then return end

  local cmd = vim.fn.expandcmd(makeprg)

  -- Collect unfinished line, which can be the last and first piece of data
  local partial_chunk = ''

  local function on_event(job_id, data, event)
    if M.job_id ~= job_id then return end

    if event == "stdout" or event == "stderr" then
      -- If only one chunk, it's a part of a line
      if #data == 1 then
        partial_chunk = partial_chunk .. data[1]
      else
        for i, chunk in ipairs(data) do
          -- Take into account potentially unfinished lines in the previous bunch of output
          if i == 1 then
            vim.fn.setqflist({}, "a", { title = cmd, lines = {partial_chunk .. chunk}, })
            partial_chunk = ''
          elseif i == #data then
            -- Just remember the last chunk
            partial_chunk = chunk
          else
            -- Output immediately complete lines
            vim.fn.setqflist({}, "a", { title = cmd, lines = {chunk}, })
          end
        end
      end
    elseif event == "exit" then
      if partial_chunk ~= '' then
        vim.fn.setqflist({}, "a", { title = cmd, lines = {partial_chunk}, })
      end
      vim.api.nvim_command("doautocmd QuickFixCmdPost")
    end
  end

  M.job_id = vim.fn.jobstart(cmd, {
      on_stderr = on_event,
      on_stdout = on_event,
      on_exit = on_event,
      stdout_buffered = false,
      stderr_buffered = false,
    })
  if M.job_id > 0 then
    vim.cmd('copen')
  end
end

vim.api.nvim_set_keymap('n', '<leader>mm', '', { noremap = true, callback = M.make, desc = "Run 'makeprg' asynchronously and populate quickfix" })
return M
