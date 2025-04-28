return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    keys = {
      { '<leader>f', function() require'telescope.builtin'.builtin() end,
        noremap = true, silent = true, desc = 'Telescope: select a finder'},
      { '<leader>ff', function() require'telescope.builtin'.find_files() end,
        noremap = true, silent = true, desc = 'Telescope: a file'},
      { '<leader>fg', function() require'telescope.builtin'.git_files() end,
        noremap = true, silent = true, desc = 'Telescope: git file'},
      { '<leader>fc', function() require'telescope.builtin'.current_buffer_fuzzy_find() end,
        noremap = true, silent = true, desc = 'Telescope: current buffer'},
      { '<leader>fh', function() require'telescope.builtin'.command_history() end,
        noremap = true, silent = true, desc = 'Telescope: command history'},
      { "<leader>gg", function() require'telescope'.extensions.live_grep_args.live_grep_args() end,
        noremap = true, silent = true, desc = 'Telescope: live grep' },

      { "<leader>tt", "<Plug>PlenaryTestFile", ft = 'lua', noremap = true, silent = true, desc = 'Plenary: test file' },
    },
    config = function()
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
    end,
  },

  {
    'protex/better-digraphs.nvim',
    keys = {
      { '<C-k><C-k>', function() require'better-digraphs'.digraphs("insert") end,
        mode = 'i', noremap = true, silent = true, desc = 'Insert a digraph' },
      { 'r<C-k><C-k>', function() require'better-digraphs'.digraphs("normal") end,
        mode = 'n', noremap = true, silent = true, desc = 'Replace with a digraph' },
      { 'r<C-k><C-k>', function() require'better-digraphs'.digraphs("visual") end,
        mode = 'v', noremap = true, silent = true, desc = 'Replace with a digraph' },
    },
  }
  --'nvim-telescope/telescope-project.nvim';
}
