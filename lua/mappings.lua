local map = vim.keymap.set
local silent = { silent = true }

--Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Insert new line and stay in normal mode
map("n", "<leader>o", "o<Esc>", silent)
map("n", "<leader>O", "O<Esc>", silent)

--Remap for dealing with visual line wraps
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Shift up/down to scroll
map("n", "<S-Down>", "<C-E>", silent)
map("n", "<S-Up>", "<C-Y>", silent)

-- search selected text
map("v", "//", '"vy/\\V<C-r>=escape(@v, "/")<CR><CR>', silent)

-- search and replace current selection
map("v", "<C-S-l>", '"vy:%s/<C-r>v//g<Left><Left>', silent)

-- clear search
map("n", "<Esc>", ":noh<CR>", silent)

-- save
map("n", "<leader>w", ":w<CR>", silent)

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- == Open URL in browser ==
map("n", "gx", ":!open <cWORD><CR>", silent)

-- delete without yanking
map({ "n", "v" }, "<leader>d", '"_d', silent)

-- replace selected text yanking it
map("v", "<leader>p", '"_dP', silent)

-- Toggle lsp_lines
map("n", "<leader>e", function()
    local new_config = not vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = new_config })
end, silent)

-- ESC to exit terminal mode
map("t", "<Esc>", "<C-\\><C-n>")

-- restart LSP
map("n", "<leader>r", ":LspRestart<CR>", silent)

-- close buffer
map("n", "<leader>bd", ":bd<CR>", silent)

-- iterate buffers
map("n", "<Tab>", ":bnext<CR>", silent)
map("n", "<S-Tab>", ":bprevious<CR>", silent)

-- toggle file tree
map("n", "<C-b>", function() if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end end, silent)

map("n", "<leader>gg", ":G<CR> :only<CR>", silent)
