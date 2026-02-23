require("mappings")
require("options")
require("autocmds")
-- Only load plugins when not runing as root
if (vim.fn.exists('$SUDO_USER') == 0) then
    require('plugins')
end
