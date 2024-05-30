local M = {}

local wheel = {'-', '\\', '|', '/'}

local function filter_out_controls(line)
    return line:gsub('\x1B[@-_][0-?]*[ -/]*[@-~]', '')
end

local function jump_to_bottom()
  -- If the quickfix window has been closed, check if there's another window with quickfix
  if not vim.api.nvim_win_is_valid(M.qf_winnr) then
    local windows = vim.fn.win_findbuf(M.qf_bufnr)
    if #windows == 0 then return end  -- no quickfix window at the moment
    M.qf_winnr = windows[1]
  end
  -- Put cursor to the end of the quickfix window
  local num_lines = vim.api.nvim_buf_line_count(M.qf_bufnr)
  local _, col = unpack(vim.api.nvim_win_get_cursor(M.qf_winnr))
  vim.api.nvim_win_set_cursor(M.qf_winnr, {num_lines, col})
end

local function stop_job()
  if M.timer_id >= 0 then
    vim.fn.timer_stop(M.timer_id)
    M.timer_id = -1
  end
  if M.job_id > 0 then
    vim.fn.jobstop(M.job_id)
    M.job_id = 0
    print("Command interrupted")
  end
end

local function set_keymap(finalize)
  vim.api.nvim_buf_set_keymap(M.qf_bufnr, 'n', '<c-c>', '', { noremap = true, callback = function() stop_job(); finalize() end, desc = "Stop 'makeprg'" })
  vim.api.nvim_buf_set_keymap(M.qf_bufnr, 'n', '<esc>', ':cclose<cr>', { noremap = true, desc = 'Close quickfix window'})
  M.keymap_set = true
end

local function del_keymap()
  if M.keymap_set then
    vim.api.nvim_buf_del_keymap(M.qf_bufnr, 'n', '<c-c>')
    vim.api.nvim_buf_del_keymap(M.qf_bufnr, 'n', '<esc>')
    M.keymap_set = false
  end
end

local function get_phase_title(cmd)
  M.wheel_phase = M.wheel_phase % #wheel + 1
  return wheel[M.wheel_phase] .. ' ' .. cmd
end

local function append_qf(title, lines)
  vim.fn.setqflist({}, "a", { title = title, lines = lines, })
end

local function append_qf_in_progress(title, lines)
  append_qf(get_phase_title(title), lines)
end

--- @param command_provider function(): string Get the command to execute
function M.execute(command_provider)
  -- Stop any previous jobs
  if M.job_id ~= nil then
    vim.fn.chanclose(M.job_id)
    stop_job()
    del_keymap()
  end
  M.wheel_phase = 1

  -- Clear the qf list
  vim.fn.setqflist({}, "r")

  local cmd = command_provider()
  if not cmd then return end

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
            append_qf_in_progress(cmd, {filter_out_controls(partial_chunk .. chunk)})
            partial_chunk = ''
          elseif i == #data then
            -- Just remember the last chunk
            partial_chunk = chunk
          else
            -- Output immediately complete lines
            append_qf_in_progress(cmd, {filter_out_controls(chunk)})
          end
        end
      end
      jump_to_bottom()
    elseif event == "exit" then
      vim.fn.timer_stop(M.timer_id)
      M.timer_id = -1
      if partial_chunk ~= '' then
        append_qf(cmd, {filter_out_controls(partial_chunk)})
        jump_to_bottom()
      else
        append_qf(cmd, {})
      end
      del_keymap()
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
    M.qf_winnr = vim.fn.win_getid()
    M.qf_bufnr = vim.api.nvim_win_get_buf(M.qf_winnr)
    M.timer_id = vim.fn.timer_start(500, function() append_qf_in_progress(cmd, {}) end, {["repeat"] = -1})
    set_keymap(function() append_qf(cmd, {}) end)
  end
end

function M.make()
  M.execute(function()
    local makeprg = vim.o.makeprg
    if not makeprg then return "" end
    return vim.fn.expandcmd(makeprg)
  end)
end

vim.api.nvim_set_keymap('n', '<leader>mm', '', { noremap = true, callback = M.make, desc = "Run 'makeprg' asynchronously and populate quickfix" })
vim.api.nvim_create_user_command('X',
  function(a) M.execute(function() return a.args end) end,
  {nargs = "+", complete = "shellcmd", force = true, desc = 'Execute command asynchronously'})

return M
