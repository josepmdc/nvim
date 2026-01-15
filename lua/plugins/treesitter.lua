local parsers = {
    "go",
    "python",
    "html",
    "javascript",
    "json",
    "markdown",
    "sql",
    "rust",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "make",
    "yaml",
    "bash",
    "fish",
    "c",
    "cpp",
    "diff",
    "lua",
    "templ",
    "elixir",
}

require("nvim-treesitter").install(parsers)

for _, lang in ipairs(parsers) do
    vim.api.nvim_create_autocmd('FileType', {
        pattern = lang,
        callback = function()
            vim.treesitter.start()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
    })
end
