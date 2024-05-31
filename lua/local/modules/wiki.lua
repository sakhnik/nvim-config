return {
  plugins = {
    'renerocksai/telekasten.nvim';
  },

  setup = function()
    local home_dir = vim.fn.expand("~/work/vaults/home")
    require('telekasten').setup({
      home = home_dir,
      dailies = home_dir .. '/journals',
      templates = home_dir .. '/templates',
      new_note_filename = 'uuid-title',
      filename_space_subst = '_',
    })

    -- Launch panel if nothing is typed after <leader>z
    vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

    -- Most used functions
    vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
    vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
    vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
    vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
    vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
    vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
    vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
    vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

    -- Call insert link automatically when we start typing a link
    vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
  end
}
