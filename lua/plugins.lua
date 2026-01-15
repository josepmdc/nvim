--------------------------------------------------------------------------------
-- BOOTSTRAP MINI.NVIM
--------------------------------------------------------------------------------
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing [`mini.nvim`](../doc/mini-nvim.qmd#mini.nvim)" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/nvim-mini/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed [`mini.nvim`](../doc/mini-nvim.qmd#mini.nvim)" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
add({
    source = 'neovim/nvim-lspconfig',
    depends = {
        'mason-org/mason.nvim',
        'mason-org/mason-lspconfig.nvim',
    },
})
add('tpope/vim-fugitive')
add('rebelot/kanagawa.nvim')
add('stevearc/conform.nvim')
add({
    source = "saghen/blink.cmp",
    depends = { "rafamadriz/friendly-snippets" },
    checkout = "v1.8.0",
})
add('https://git.sr.ht/~whynothugo/lsp_lines.nvim')

now(function()
    require('mini.basics').setup()
    require('mini.icons').setup()
    require('mini.statusline').setup()
    require('mini.tabline').setup()
    require('plugins.colors')
    require('plugins.autoformat')
    require('plugins.treesitter')
    require('plugins.lsp')
    require('plugins.picker')
    require("lsp_lines").setup()
end)

later(function()
    require('mini.files').setup()

    require('mini.notify').setup()
    vim.notify = require('mini.notify').make_notify()

    require('mini.indentscope').setup()
    require('mini.pairs').setup()
    require('mini.comment').setup()
    require('plugins.autocomplete')
    require('mini.diff').setup()
end)
