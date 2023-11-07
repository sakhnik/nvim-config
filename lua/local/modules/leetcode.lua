local C = {}

C.plugins = {
  "MunifTanjim/nui.nvim",
  "rcarriga/nvim-notify",
  "kawre/leetcode.nvim",
}

function C.setup()
  require'leetcode'.setup {
    ---@type lc.lang
    lang = "cpp",

    ---@type lc.sql
    sql = "sqlite",
  }
end

return C
