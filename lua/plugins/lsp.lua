vim.pack.add {
  { src = 'https://github.com/neovim/nvim-lspconfig', },
  { src = 'https://github.com/williamboman/mason.nvim', },
  { src = 'https://github.com/williamboman/mason-lspconfig.nvim', },
  { src = 'https://github.com/folke/lazydev.nvim', },
}

require'mason'.setup {}
require'mason-lspconfig'.setup {}

require'lazydev'.setup {
  library = {
    vim.env.VIMRUNTIME .. "/lua",   -- load builtin runtime
  }
}

vim.lsp.log.set_level("ERROR")
vim.diagnostic.config({ severity_sort = true, virtual_lines = { current_line = true } })
vim.diagnostic.handlers.loclist = {
  show = function(_, _, _, opts)
    -- Generally don't want it to open on every update
    ---@diagnostic disable-next-line: undefined-field
    opts.loclist.open = opts.loclist.open or false
    local winid = vim.api.nvim_get_current_win()
    ---@diagnostic disable-next-line: undefined-field
    vim.diagnostic.setloclist(opts.loclist)
    vim.api.nvim_set_current_win(winid)
  end
}

vim.keymap.set("n", "<m-k>", vim.diagnostic.open_float, {noremap = true, silent = true, desc = 'Open floating window with diagnostic info'})

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

for server, config in pairs(lsp_configs) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(--[[args]])
    --local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- Avoid showing extra message when using completion
    vim.cmd "setlocal shortmess+=c"
    vim.wo.signcolumn = 'yes'
    if vim.lsp.omnifunc ~= nil then
      vim.bo.complete = 'o'
    end
  end
})
