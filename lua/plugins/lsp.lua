local servers = {
    gopls = {
        settings = {
            gopls = {
                codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    compositeLiteralFields = true,
                    -- compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                },
                analyses = {
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                },
                completeUnimported = true,
                deepCompletion = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules", "-.nvim" },
                semanticTokens = true,
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                completion = {
                    callSnippet = 'Replace',
                },
                -- ignore Lua_LS's noisy `missing-fields` warnings
                diagnostics = { disable = { 'missing-fields' } },
            },
        },
    },
    pyright = {},
    clangd = {},
    rust_analyzer = {},
    html = {},
    ts_ls = {},
    tailwindcss = {},
    jsonls = {},
    jdtls = {},
    yamlls = {},
    elixirls = {},
}

require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(servers),
})
