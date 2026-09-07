require('conform').setup({
    notify_on_error = false,
    format_on_save = function()
        return {
            lsp_format = "fallback",
            timeout_ms = 500,
        }
    end,
    formatters_by_ft = {
        templ = { "templ" },
        javascript = { "biome" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        javascriptreact = { "biome" },
    },
})
