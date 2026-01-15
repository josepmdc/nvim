require('mini.pick').setup()

local map = vim.keymap.set

-- [F]ind [H]elp
map('n', '<leader>fh', function() MiniExtra.pickers.help() end, { desc = 'Find Help' })

-- [F]ind [K]eymaps
map('n', '<leader>fk', function() MiniExtra.pickers.keymaps() end, { desc = 'Find Keymaps' })

-- [F]ind [F]iles (Double leader)
map('n', '<leader><leader>', function() MiniPick.builtin.files({}, { tool = 'git' }) end, { desc = 'Find Files' })

-- [F]ind current [W]ord (Grep for word under cursor)
map('n', '<leader>fw', function() MiniPick.builtin.grep({ pattern = vim.fn.expand('<cword>') }) end, { desc = 'Find Word' })

-- [F]ind [S]tring (Live Grep)
map('n', '<leader>fs', function() MiniPick.builtin.grep_live() end, { desc = 'Find String' })

-- [F]ind [D]iagnostics
map('n', '<leader>fd', function() MiniExtra.pickers.diag() end, { desc = 'Find Diagnostics' })

-- [F]ind [R]esume
map('n', '<leader>fr', function() MiniPick.builtin.resume() end, { desc = 'Find Resume' })

-- [F]ind Recent Files (".")
map('n', '<leader>f.', function() MiniExtra.pickers.oldfiles() end, { desc = 'Find Recent' })

-- [F]ind [O]pen buffers
map('n', '<leader>fo', function() MiniPick.builtin.buffers() end, { desc = 'Find Open Buffers' })

-- [F]ile browser (Using mini.files instead of telescope-file-browser)
map('n', '<leader>fb', function() MiniFiles.open() end, { desc = 'File Browser' })
map('n', '<leader>fc', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, { desc = 'File Browser (Current Dir)' })

-- [G]it [B]ranches / [S]tatus
map('n', '<leader>gb', function() MiniExtra.pickers.git_branches() end, { desc = 'Git Branches' })
map('n', '<leader>gs', function() MiniExtra.pickers.git_status() end, { desc = 'Git Status' })

-- [/] Fuzzily search in current buffer
map('n', '<leader>/', function() MiniPick.builtin.grep_live({ scope = 'current' }) end, { desc = 'Search Buffer' })

-- [F]ind [N]eovim files
map('n', '<leader>fn', function() 
  MiniPick.builtin.files({ cwd = vim.fn.stdpath('config') }) 
end, { desc = 'Find Neovim Files' })

-- [V]isual Selection Search
map('v', '<leader>ss', function()
  -- mini.pick natively handles patterns well
  vim.cmd('normal! "vy')
  MiniPick.builtin.grep({ pattern = vim.fn.getreg('v') })
end, { desc = 'Search Selection' })
