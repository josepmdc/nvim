require('telescope').setup {
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
    },
    defaults = {
        layout_strategy = 'vertical',
        layout_config = {
            vertical = {
                height = 0.95,
                preview_height = 0.70,
            },
        },
        file_ignore_patterns = {},
    },
    pickers = {
        buffers = {
            mappings = {
                i = {
                    ['<c-d>'] = require('telescope.actions').delete_buffer,
                },
                n = {
                    ['<c-d>'] = require('telescope.actions').delete_buffer,
                },
            },
        },
        git_commits = {
            mappings = {
                i = {
                    ["<CR>"] = function(prompt_bufnr)
                        -- get the selected commit hash
                        local entry = require("telescope.actions.state").get_selected_entry()
                        -- close telescope
                        require("telescope.actions").close(prompt_bufnr)
                        -- open diffview
                        vim.cmd('DiffviewOpen ' .. entry.value)
                    end,
                }
            }
        },
    },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'file_browser')

local builtin = require 'telescope.builtin'
local map = vim.keymap.set
map('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
map('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
map('n', '<leader><leader>', function() builtin.find_files({ hidden = true }) end, { desc = '[F]ind [F]iles' })
map('n', '<leader>bi', builtin.builtin, { desc = '[B]uilt-[I]n' })
map('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
map('n', '<leader>fs', builtin.live_grep, { desc = '[F]ind [S]tring' })
map('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
map('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
map('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
map('n', '<leader>fo', builtin.buffers, { desc = '[F]ind [O]pen buffers' })
map("n", "<leader>fb", builtin.builtin)
map("n", "<leader>fm", builtin.marks, { desc = '[F]ind [M]arks' })

map('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
map('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
map('n', '<leader>gS', builtin.git_stash, { desc = '[G]it [S]tash' })

map('n', '<leader>/', function()
    -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer' })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
map('n', '<leader>f/', function()
    builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    }
end, { desc = '[F]ind [/] in Open Files' })

-- Shortcut for searching your Neovim configuration files
map('n', '<leader>fn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[F]ind [N]eovim files' })

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
