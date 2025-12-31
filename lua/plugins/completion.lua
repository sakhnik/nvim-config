
-- insert mode completion options
vim.o.autocomplete = true
vim.o.complete = "o,.,w,b,u"
vim.o.completeopt = "fuzzy,menuone,noselect,popup"
vim.o.pumheight = 7
vim.o.pummaxwidth = 80


vim.api.nvim_create_autocmd('FileType', {
  pattern = 'TelescopePrompt',
  callback = function()
    vim.bo.autocomplete = false;
  end,
})

-- Insert-mode <Tab>: completion next
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return '<c-n>'
  else
    return '<tab>'
  end
end, { expr = true })

-- Insert-mode <Tab>: completion prev
vim.keymap.set("i", "<s-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return '<c-p>'
  else
    return '<s-tab>'
  end
end, { expr = true })
