local home_dir = vim.fn.expand("~/work/vaults/home")

vim.pack.add {
  { src = 'https://github.com/renerocksai/telekasten.nvim', },
}

local tk_configured = false

local function get_tk()
  local tk = require'telekasten'
  if not tk_configured then
    tk_configured = true
    tk.setup {
      home = home_dir,
      dailies = home_dir .. '/journals',
      templates = home_dir .. '/templates',
      new_note_filename = 'uuid-title',
      filename_space_subst = '_',
    }
  end
  return tk
end


vim.keymap.set('n', '<leader>zz', function() get_tk().panel() end, {noremap = true, silent = true, desc = 'Telekasten panel'})
vim.keymap.set('n', '<leader>zf', function() get_tk().find_notes() end, {noremap = true, silent = true, desc = 'Telekasten find notes'})
vim.keymap.set('n', '<leader>zg', function() get_tk().search_notes() end, {noremap = true, silent = true, desc = 'Telekasten search notes'})
vim.keymap.set('n', '<leader>zd', function() get_tk().goto_today() end, {noremap = true, silent = true, desc = 'Telekasten goto today'})
--vim.keymap.set('n', '<leader>zz', function() get_tk().follow_link() end, {noremap = true, silent = true, desc = 'Telekasten follow link'})
vim.keymap.set('n', '<leader>zn', function() get_tk().new_note() end, {noremap = true, silent = true, desc = 'Telekasten new note'})
vim.keymap.set('n', '<leader>zc', function() get_tk().show_calendar() end, {noremap = true, silent = true, desc = 'Telekasten show calendar'})
vim.keymap.set('n', '<leader>zb', function() get_tk().show_backlinks() end, {noremap = true, silent = true, desc = 'Telekasten show backlinks'})
vim.keymap.set('n', '<leader>zI', function() get_tk().insert_img_link() end, {noremap = true, silent = true, desc = 'Telekasten insert img link'})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('i', '[[', function() get_tk().insert_link() end, {noremap = true, buffer = true, silent = true, desc = 'Telekasten insert link'})
  end,
})
