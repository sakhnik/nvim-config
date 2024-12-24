local cmd = vim.api.nvim_command

local lsp_configs = {
  lua_ls = {
  },

  clangd = {
    cmd = { "clangd", "--completion-style=detailed", "--enable-config", "--log=error" }
  },

  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = {'E501'},
            maxLineLength = 100
          }
        }
      },
    }
  },
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


return {
  {
    'neovim/nvim-lspconfig',
    --version = '*',
    dependencies = {
      { 'hrsh7th/nvim-cmp', },

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

      local capabilities = require'cmp_nvim_lsp'.default_capabilities()
      for server, config in pairs(lsp_configs) do
        config.capabilities = capabilities
        require'lspconfig'[server].setup(config)
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

  { 'williamboman/mason.nvim', opts = {} },

  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      local capabilities = require'cmp_nvim_lsp'.default_capabilities()
      require"mason-lspconfig".setup_handlers {
        function (server_name)
          if not lsp_configs[server_name] then
            require('lspconfig')[server_name].setup {
              capabilities = capabilities
            }
          end
        end,
      }
    end,
  },
}
