--------------------------------------------------------------------------------
-- BOOTSTRAP MINI.NVIM {
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
--------------------------------------------------------------------------------
-- }
--------------------------------------------------------------------------------

require('mini.deps').setup({ path = { package = path_package } })

vim.iter {
    'tpope/vim-fugitive',
    'sindrets/diffview.nvim',
    'rebelot/kanagawa.nvim',
    'stevearc/conform.nvim',
    {
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = {
            post_checkout = function() vim.cmd('TSUpdate') end
        },
    },
    {
        source = 'neovim/nvim-lspconfig',
        depends = {
            'mason-org/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
        },
    },
    {
        source = "saghen/blink.cmp",
        depends = {
            "rafamadriz/friendly-snippets",
        },
        checkout = "v1.8.0",
    },
    {
        source = "nvim-telescope/telescope.nvim",
        depends = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            {
                source = "nvim-telescope/telescope-fzf-native.nvim",
                hooks = {
                    post_install = function(params) vim.system({ "make" }, { cwd = params.path }) end,
                    post_checkout = function(params) vim.system({ "make" }, { cwd = params.path }) end
                },
            },
        },
    }
}:each(MiniDeps.add)

MiniDeps.now(function()
    require('mini.basics').setup()
    require('mini.icons').setup()
    require('mini.statusline').setup()
    require('mini.tabline').setup()
    require('plugins.colors')
    require('plugins.autoformat')
    require('plugins.treesitter')
    require('plugins.lsp')
    require('plugins.telescope')
end)

MiniDeps.later(function()
    require('mini.files').setup()
    require('mini.indentscope').setup()
    require('mini.pairs').setup()
    require('mini.comment').setup()
    require('mini.diff').setup()
    require('mini.notify').setup()
    vim.notify = require('mini.notify').make_notify()
    require('plugins.autocomplete')
    require('plugins.diffview')
end)
