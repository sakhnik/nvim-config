-- vim: set et ts=2 sw=2:
--

-- disable netrw in favour of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_liststyle = 3

vim.o.fileencodings = 'utf-8,cp1251,default'
vim.o.wildmode = 'longest,list,full'
vim.o.diffopt = vim.o.diffopt .. ',iwhite'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tabstop = 4
vim.o.cindent = true
vim.o.shiftwidth = 4
vim.o.cinoptions = ":0,=1s,g0,M1,U0,u0,N-s"
vim.o.copyindent = true
vim.o.expandtab = true
vim.o.hidden = false
vim.o.autowrite = true
vim.o.mouse = 'n'
vim.o.termguicolors = true
vim.o.completeopt = 'menu,preview'
vim.o.shortmess = 'ac'
if vim.fn.has('win32') == 1 then
  -- 'shellslash' may be necessary for lsp to detect workspace directories
  -- (for lua specifically)
  vim.o.shellslash = false
end

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.o.lazyredraw = true
vim.o.laststatus = 2

vim.o.showbreak = '\\'  --↪
vim.o.undofile = true

vim.o.keymap  = 'uk'
vim.o.iminsert = 0
vim.o.imsearch = 0

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    -- Neovide GUI
    if vim.g.neovide then
      vim.g.neovide_cursor_animation_length = 0.1
      vim.g.neovide_cursor_trail_size = 0.0
      vim.o.guifont = "VictorMono NF:h24"

      -- Compatibility mappings for children
      -- Copy selected text with Ctrl-Shift-C
      vim.api.nvim_set_keymap("v", "<C-S-c>", '"+y', { noremap = true, silent = true })
      -- Paste with Ctrl-Shift-V
      vim.api.nvim_set_keymap("i", "<C-S-v>", '<C-r>+', { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-S-v>", '"+P', { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<C-S-v>", '"+P', { noremap = true, silent = true })
    end
  end
})

-- Forget about ex mode
vim.keymap.set('', 'Q', function() end)

-- Find tailing white spaces
vim.keymap.set('n', '<Leader><space>', [[/\s\+$\| \+\ze\t<cr>]], {noremap = true})

require'local.digraphs'
require'local.autocmds'
require'config.lazy'
