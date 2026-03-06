require("diffview").setup({
    file_panel = {
        listing_style = "list",
        win_config = {
            position = "top",
            height = 15,
        },
    },
})

local function toggle_diffview(cmd)
    if next(require("diffview.lib").views) == nil then
        vim.cmd(cmd)
    else
        vim.cmd("DiffviewClose")
    end
end

vim.keymap.set('n', '<leader>gs', function()
    toggle_diffview("DiffviewOpen")
end)

vim.keymap.set('n', '<leader>gf', function()
    toggle_diffview("DiffviewFileHistory %")
end)
