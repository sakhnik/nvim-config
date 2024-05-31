
vim.api.nvim_buf_set_keymap(vim.api.nvim_get_current_buf(), 'n', '<esc>', ':cclose<cr>', { noremap = true, desc = 'Close quickfix window'})
