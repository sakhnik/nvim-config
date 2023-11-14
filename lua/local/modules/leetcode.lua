local C = {}

C.plugins = {
  "MunifTanjim/nui.nvim",
  "rcarriga/nvim-notify",
  "kawre/leetcode.nvim",
}

local lang = 'cpp'
if vim.env.LEETCODE_LANG ~= nil then
  lang = vim.env.LEETCODE_LANG
end

function C.setup()
  require'leetcode'.setup {
    ---@type lc.lang
    lang = lang,

    ---@type lc.sql
    sql = "pythondata",
  }
end

return C
