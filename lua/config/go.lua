require('go').setup({
    luasnip = true,
    icons = { breakpoint = '🔴', currentpos = '▶️' },
    test_runner = 'gotestsum',
    run_in_floaterm = false,
    floaterm = {
        posititon = 'bottom', -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
        width = 0.75,
        height = 0.5,
    },
    diagnostic = {
        virtual_text = false,
    },
})

-- Run gofmt + goimport on save
local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require('go.format').goimport()
    end,
    group = format_sync_grp,
})
