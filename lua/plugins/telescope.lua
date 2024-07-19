return {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
        -- [[ Configure Telescope ]]
        require('telescope').setup {
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown(),
                },
            },
            defaults = {
                layout_strategy = 'vertical',
                layout_config = {
                    height = 0.95,
                    preview_height = 0.70,
                },
            },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'
        local map = vim.keymap.set
        map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        map('n', '<leader>sb', builtin.builtin, { desc = '[S]earch [B]uiltin' })
        map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        map('n', '<leader>g', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

        -- Slightly advanced example of overriding default behavior and theme
        map('n', '<leader>/', function()
            -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        map('n', '<leader>s/', function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end, { desc = '[S]earch [/] in Open Files' })

        -- Shortcut for searching your Neovim configuration files
        map('n', '<leader>sn', function()
            builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })

        function vim.getVisualSelection()
            vim.cmd('noau normal! "vy"')
            local text = vim.fn.getreg('v')
            vim.fn.setreg('v', {})

            text = string.gsub(text, "\n", "")
            if #text > 0 then
                return text
            else
                return ''
            end
        end

        map('v', '<leader>ss', function()
            builtin.live_grep({ default_text = vim.getVisualSelection() })
        end)
    end,
}
