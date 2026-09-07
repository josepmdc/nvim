local auto_install_servers = {
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
    biome = {},
    tailwindcss = {},
    jsonls = {},
    jdtls = {},
    yamlls = {},
    expert = {
        cmd_env = {
            -- override the deps path so it doesn't conflict with the one used by the docker container
            MIX_DEPS_PATH = ".expert/deps",
        },
        on_attach = function(client)
            -- disable all capabilities except for diagnostics
            client.server_capabilities = {
                textDocumentSync = client.server_capabilities.textDocumentSync,
                diagnosticProvider = client.server_capabilities.diagnosticProvider,
            }
        end,
    },
    graphql = {},
}

local manual_install_servers = {
    tsc = {},
    gleam = {},
    dexter = {
        cmd = { 'dexter', 'lsp' },
        root_markers = { '.dexter/dexter.db', '.dexter.db', '.git', 'mix.exs' },
        filetypes = { 'elixir', 'eelixir', 'heex' },
        init_options = {
            followDelegates = true, -- jump through defdelegate to the target function
            -- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
            -- debug = false,        -- verbose logging to stderr (view with :LspLog)
        },
    }
}

require('mason').setup()
require('mason-lspconfig').setup({ ensure_installed = vim.tbl_keys(auto_install_servers) })

local servers = vim.tbl_deep_extend('force', auto_install_servers, manual_install_servers)

for server, config in pairs(servers) do
    vim.lsp.config(server, config)
end

for server, _ in pairs(manual_install_servers) do
    vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('josepmdc-lsp-attach', { clear = true }),
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- disable the default keybinds {{
        for _, bind in ipairs({ "grn", "gra", "gri", "grr", "grt" }) do
            pcall(vim.keymap.del, "n", bind)
        end

        pcall(vim.keymap.del, "x", "gra")
        -- }}

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('gr', function()
            require('telescope.builtin').lsp_references({ show_line = false })
        end, '[G]oto [R]eferences')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

        map('<leader>ds', function()
            require('telescope.builtin').lsp_document_symbols({ sorting_strategy = "ascending" })
        end, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        -- clashes with <leader>w to save
        -- map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>a', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap.
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        map('<leader>cl', vim.lsp.codelens.run, 'Run [C]ode [L]ens')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
            })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, '[T]oggle Inlay [H]ints')
        end
    end,
})
