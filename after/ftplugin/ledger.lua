local map = vim.keymap.set
local buf = { buffer = true }

-- Normal-mode mappings
map("n", "<leader>ld",
    function() vim.fn['ledger#transaction_date_set']('.', 'auxiliary') end,
    buf)

map("n", "<leader>la",
    function() vim.cmd("LedgerAlign") end,
    buf)

map("n", "<leader>lh",
    function() vim.fn['ledger#align_amount_at_cursor']() end,
    buf)

-- Insert-mode <Tab>: first completion item + alignment
map("i", "<Tab>", function()
    local n = vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
    local y = vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
    vim.api.nvim_feedkeys(n, "n", false)
    vim.api.nvim_feedkeys(y, "n", false)

    -- Run alignment deferred to avoid flicker
    vim.schedule(function()
        vim.fn['ledger#autocomplete_and_align']()
    end)
end, buf)

map("v", "<Tab>", function()
    vim.cmd("LedgerAlign")
end, { buffer = true, silent = true })

map("i", "<C-l>", function()
    vim.fn['ledger#entry']()
end, { buffer = true, silent = true })

vim.opt_local.completeopt:remove("noinsert")
vim.opt_local.completeopt:remove("noselect")
