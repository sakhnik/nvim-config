local C = {}

C.plugins = {
  'nvim-lua/popup.nvim';
  'nvim-lua/plenary.nvim';
  'nvim-telescope/telescope.nvim';
  'nvim-telescope/telescope-project.nvim';
  'nvim-telescope/telescope-live-grep-args.nvim';
  'nvim-telescope/telescope-ui-select.nvim';
}

function C.setup()
  local noremap_silent = {noremap = true, silent = true}
  local tsbi = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', tsbi.find_files, noremap_silent)
  vim.keymap.set('n', '<leader>fg', tsbi.git_files, noremap_silent)
  vim.keymap.set('n', '<leader>f<space>', tsbi.builtin, noremap_silent)
  --vim.keymap.set('n', '<leader>gg', tsbi.live_grep, noremap_silent)
  vim.keymap.set("n", "<leader>gg", require'telescope'.extensions.live_grep_args.live_grep_args, noremap_silent)
  vim.keymap.set('n', '<leader>fc', tsbi.current_buffer_fuzzy_find, noremap_silent)
  vim.keymap.set('n', '<leader>fh', tsbi.command_history, noremap_silent)
  vim.keymap.set('n', '<leader>fp', function() require'telescope'.extensions.project.project{} end, noremap_silent)

  local lga_actions = require"telescope-live-grep-args.actions"

  require'telescope'.setup {
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
            ["<M-k>"] = lga_actions.quote_prompt(),
            ["<M-i>"] = lga_actions.quote_prompt({ postfix = " -t cpp" }),
          },
        },
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      }
    }
  }

  require'telescope'.load_extension("live_grep_args")
  require("telescope").load_extension("ui-select")
end

return C
