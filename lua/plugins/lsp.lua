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

--function C.configureBuffer() --(client, bufnr)
--
--  local opts = {noremap = true, silent = true, buffer = true}
--  vim.keymap.set("n", "<space>q", function() vim.diagnostic.setqflist({open = true}) end, opts)
--  vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
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
      vim.diagnostic.config({ severity_sort = true, virtual_lines = { current_line = true } })

      for server, config in pairs(lsp_configs) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
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
      require"mason-lspconfig".setup_handlers {
        function (server_name)
          if not lsp_configs[server_name] then
            vim.lsp.enable(server_name)
          end
        end,
      }
    end,
  },
}
