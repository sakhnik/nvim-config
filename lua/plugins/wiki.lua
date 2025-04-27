local home_dir = vim.fn.expand("~/work/vaults/home")

return {
  {
    'renerocksai/telekasten.nvim',
    opts = {
      home = home_dir,
      dailies = home_dir .. '/journals',
      templates = home_dir .. '/templates',
      new_note_filename = 'uuid-title',
      filename_space_subst = '_',
    },
    keys = {
      { "<leader>zz", "<cmd>Telekasten panel<CR>", desc = 'Telekasten panel' },
      { "<leader>zf", "<cmd>Telekasten find_notes<CR>", desc = 'Telekasten find notes' },
      { "<leader>zg", "<cmd>Telekasten search_notes<CR>", desc = 'Telekasten search notes' },
      { "<leader>zd", "<cmd>Telekasten goto_today<CR>", desc = 'Telekasten goto today' },
      --{ "<leader>zz", "<cmd>Telekasten follow_link<CR>", desc = 'Telekasten follow link' },
      { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = 'Telekasten new note' },
      { "<leader>zc", "<cmd>Telekasten show_calendar<CR>", desc = 'Telekasten show calendar' },
      { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", desc = 'Telekasten show backlinks' },
      { "<leader>zI", "<cmd>Telekasten insert_img_link<CR>", desc = 'Telekasten insert img link' },
      { "[[", "<cmd>Telekasten insert_link<CR>", mode = 'i', ft = 'markdown', desc = 'Telekasten insert link' },
    },
  }
}
