vim.pack.add {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
  },
  { src = 'https://github.com/andymass/vim-matchup', },
  { src = 'https://github.com/RRethy/vim-illuminate', },
}

vim.g.matchup_matchparen_offscreen = { method = "popup" }

require'illuminate'.configure({
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = { 'lsp', 'treesitter', },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '*' },
  callback = function(ev)
    local nts = require'nvim-treesitter'
    if not nts then
      return
    end

    local ft = ev.match
    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      vim.notify('No treesitter language for filetype ' .. ft, vim.log.levels.ERROR)
      return
    end

    local ok, job = pcall(nts.install, lang)
    if not ok then
      vim.notify("Can't install treesitter language " .. lang, vim.log.levels.ERROR)
      return
    end

    job:await(function()
      if vim.treesitter.language.add(lang) then
        local installed = nts.get_installed('parsers')
        for _, installed_lang in ipairs(installed) do
          if installed_lang == lang then
            if vim.treesitter.query.get(lang, 'highlights') then
              local ok, _ = pcall(vim.treesitter.start)
              if not ok then
                vim.notify("Can't start treesitter for language " .. lang)
              end
              --vim.bo[ev.buf].indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
            end
            break
          end
        end
      end
    end)
  end,
})
