return {
  "nvim-neotest/neotest",
  version = "*",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  ft = {"lua", "python"},
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          python = "/tmp/venv/bin/python",
        }),
        --require("neotest-plenary"),
        --require("neotest-vim-test")({
        --  ignore_file_types = { "python", "vim", "lua" },
        --}),
      },
    })
  end
}
