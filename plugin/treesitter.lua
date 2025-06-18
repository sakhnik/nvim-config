vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*' },
  callback = function(ev)
    local nts = require'nvim-treesitter'

    local ft = ev.match
    local lang = vim.treesitter.language.get_lang(ft)

    if lang and vim.treesitter.language.add(lang) then
      local installed = nts.get_installed('parsers')
      for _, installed_lang in ipairs(installed) do
        if installed_lang == lang then
          if vim.treesitter.query.get(lang, 'highlights') then
            pcall(vim.treesitter.start)
            --vim.bo[ev.buf].indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
          end
          break
        end
      end

      pcall(nts.install, lang);
    end
  end,
})
