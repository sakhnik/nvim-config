-- vim: set et ts=2 sw=2:
--

-- netrw is required for spellfile.vim
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1
vim.g.netrw_liststyle = 3

vim.o.fileencodings = 'utf-8,cp1251,default'
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
--vim.o.messagesopt = 'wait:500,history:500'
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

-- Find tailing white spaces
vim.keymap.set('n', '<Leader><space>', [[/\s\+$\| \+\ze\t<cr>]], { noremap = true })

-- Copy everything to the clipboard
vim.keymap.set('n', '<leader>yy', [[:%y+<cr>]], { noremap = true })

require('vim._core.ui2').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = 'cmd',
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5 -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
})

require'local.digraphs'
require'local.autocmds'

require'plugins.color'
require'plugins.libs'
require'plugins.vim'
require'plugins.fs'
require'plugins.telescope'
require'plugins.treesitter'
require'plugins.notify'
require'plugins.quickfix'
require'plugins.term'
require'plugins.lsp'
require'plugins.completion'
require'plugins.dap'
require'plugins.jdtls'
require'plugins.db'
--require'plugins.leetcode'
require'plugins.rust'
--require'plugins.test'
require'plugins.wiki'

--require'plugins.diff',
