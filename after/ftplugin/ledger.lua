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
    -- Run alignment deferred to avoid flicker
    vim.schedule(function()
        vim.fn['ledger#autocomplete_and_align']()
    end)
    return "<c-n><c-y>"
end, { buffer = true, silent = true, expr = true })

map("v", "<Tab>", function()
    vim.cmd("LedgerAlign")
end, { buffer = true, silent = true })

map("i", "<C-l>", function()
    vim.fn['ledger#entry']()
end, { buffer = true, silent = true })

vim.opt_local.completeopt:remove("noinsert")
vim.opt_local.completeopt:remove("noselect")
