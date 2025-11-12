vim.pack.add({ { src = "https://github.com/nvim-mini/mini.pick" } })

local pick = require("mini.pick")

pick.setup()

vim.keymap.set("n", "<C-p>", function() pick.builtin.files({ tool = "git" }) end)
vim.keymap.set("n", "g/", function() pick.builtin.grep_live() end)
vim.keymap.set("n", "	", function() pick.builtin.buffers() end)
