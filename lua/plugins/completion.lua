local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp', },
      { 'hrsh7th/cmp-buffer', },
      { 'hrsh7th/cmp-nvim-lsp-signature-help', },
      { 'L3MON4D3/LuaSnip', },
      { 'saadparwaiz1/cmp_luasnip', },
    },
    opts = {
      enabled = function()
        return vim.api.nvim_get_option_value('buftype', {buf = 0}) ~= 'prompt'
          and vim.api.nvim_get_option_value('filetype', {buf = 0}) ~= 'ledger'
      end,
      snippet = {
        expand = function(args)
          -- For `vsnip` user.
          --vim.fn["vsnip#anonymous"](args.body)

          -- For `luasnip` user.
          require'luasnip'.lsp_expand(args.body)

          -- For `ultisnips` user.
          -- vim.fn["UltiSnips#Anon"](args.body)
        end,
      },
      mapping = {
        ['<C-d>'] = require'cmp'.mapping.scroll_docs(-4),
        ['<C-f>'] = require'cmp'.mapping.scroll_docs(4),
        ['<C-Space>'] = require'cmp'.mapping.complete(),
        ['<C-e>'] = require'cmp'.mapping.close(),
        ['<CR>'] = require'cmp'.mapping.confirm({ select = true }),
        ["<Tab>"] = require'cmp'.mapping(function(fallback)
          local luasnip = require"luasnip"
          local cmp = require'cmp'
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = require'cmp'.mapping(function(fallback)
          local luasnip = require"luasnip"
          local cmp = require'cmp'
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        -- ['<Tab>'] = function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   else
        --     fallback()
        --   end
        -- end
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },

        -- For vsnip user.
        -- { name = 'vsnip' },

        -- For luasnip user.
        { name = 'luasnip' },

        {
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        },

        -- For ultisnips user.
        -- { name = 'ultisnips' },

        { name = 'buffer' },
      },
    }
  },
}
