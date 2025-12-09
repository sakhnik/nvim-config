vim.pack.add {
  { src = 'https://github.com/nvim-lua/popup.nvim', },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', },
  { src = 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim', },
  { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim', },
  { src = 'https://github.com/protex/better-digraphs.nvim', },
}

local telescope = require 'telescope'
telescope.setup({
  defaults = {
    path_display = {shorten = 4, 'truncate'},
    file_ignore_patterns = {'%.class'},
  },
  pickers = {
    find_files = {
      no_ignore = false,
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      mappings = { -- extend mappings
        i = {
          ["<M-k>"] = require"telescope-live-grep-args.actions".quote_prompt(),
          ["<M-i>"] = require"telescope-live-grep-args.actions".quote_prompt({ postfix = " -t cpp" }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
})

telescope.load_extension("live_grep_args")
telescope.load_extension("ui-select")

vim.keymap.set('n', '<leader>f', function() require'telescope.builtin'.builtin() end,
  {noremap = true, silent = true, desc = 'Telescope: select a finder'})
vim.keymap.set('n', '<leader>ff', function() require'telescope.builtin'.find_files() end,
  {noremap = true, silent = true, desc = 'Telescope: a file'})
vim.keymap.set('n', '<leader>fg', function() require'telescope.builtin'.git_files() end,
  {noremap = true, silent = true, desc = 'Telescope: git file'})
vim.keymap.set('n', '<leader>fc', function() require'telescope.builtin'.current_buffer_fuzzy_find() end,
  {noremap = true, silent = true, desc = 'Telescope: current buffer'})
vim.keymap.set('n', '<leader>fh', function() require'telescope.builtin'.command_history() end,
  {noremap = true, silent = true, desc = 'Telescope: command history'})
vim.keymap.set('n', '<leader>gg', function() require'telescope'.extensions.live_grep_args.live_grep_args() end,
  {noremap = true, silent = true, desc = 'Telescope: live grep'})

vim.keymap.set('i', '<c-k><c-k>', function() require'better-digraphs'.digraphs("insert") end,
  {noremap = true, silent = true, desc = 'Insert a digraph'})
vim.keymap.set('n', 'r<c-k><c-k>', function() require'better-digraphs'.digraphs("normal") end,
  {noremap = true, silent = true, desc = 'Replace with a digraph'})
vim.keymap.set('v', 'r<c-k><c-k>', function() require'better-digraphs'.digraphs("visual") end,
  {noremap = true, silent = true, desc = 'Replace with a digraph'})
