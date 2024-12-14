local cmd = vim.api.nvim_command

local lsp_configs = {
  lua_ls = {
  },

  clangd = {
    cmd = { "clangd", "--completion-style=detailed", "--enable-config", "--log=error" }
  }
}

--function C.show_line_diagnostics()
--  local opts = {
--    focusable = false,
--    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
--    border = 'rounded',
--    source = 'always',  -- show source in diagnostic popup window
--    prefix = ' '
--  }
--  vim.diagnostic.open_float(nil, opts)
--end
--
--function C.configureBuffer() --(client, bufnr)
--  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
--
--  local opts = {noremap = true, silent = true, buffer = true}
--  vim.keymap.set('n', 'gd', vim.lsp.buf.declaration, opts)
--  vim.keymap.set('n', '<c-]>', vim.lsp.buf.definition, opts)
--  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--  vim.keymap.set('n', 'gD', vim.lsp.buf.implementation, opts)
--  vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, opts)
--  vim.keymap.set('n', '1gD', vim.lsp.buf.type_definition, opts)
--  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--  vim.keymap.set('n', 'g0', vim.lsp.buf.document_symbol, opts)
--  vim.keymap.set('n', 'gW', vim.lsp.buf.workspace_symbol, opts)
--  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
--  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
--  vim.keymap.set("n", "<space>q", function() vim.diagnostic.setqflist({open = true}) end, opts)
--  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
--
--  vim.api.nvim_create_autocmd("CursorHold", {
--    callback = function() require'local.modules.lsp'.show_line_diagnostics() end,
--    buffer = vim.api.nvim_get_current_buf(),
--  })
--
--  -- Set completeopt to have a better completion experience
--  cmd "setlocal completeopt=menu,menuone,noselect"
--
--end
--
--local function get_caps()
--  return require'cmp_nvim_lsp'.default_capabilities()
--end
--
--local function setup_pylsp()
--  local opts = {
--    on_attach = C.configureBuffer,
--    capabilities = get_caps(),
--    cmd = { "pylsp" },
--    settings = {
--      pylsp = {
--        plugins = {
--          pycodestyle = {
--            ignore = {'E501'},
--            maxLineLength = 100
--          }
--        }
--      },
--    }
--  }
--  require'lspconfig'.pylsp.setup(opts)
--end

---- Setup nvim-cmp.
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    'neovim/nvim-lspconfig',
    --version = '*',
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      vim.lsp.set_log_level("ERROR")
      vim.diagnostic.config({ severity_sort = true, })

      for name, cfg in pairs(lsp_configs) do
        require'lspconfig'[name].setup(cfg)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(--[[args]])
          --local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- Avoid showing extra message when using completion
          cmd "setlocal shortmess+=c"
          vim.wo.signcolumn = 'yes'
        end
      })
    end,
  },

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

  { 'williamboman/mason.nvim', opts = {} },

  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require"mason-lspconfig".setup_handlers {
        function (server_name)
          if not lsp_configs[server_name] then
            require('lspconfig')[server_name].setup {}
          end
        end,
      }
    end,
  },
}
