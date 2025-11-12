vim.pack.add({ { src = "https://github.com/nvim-mini/mini.pick" } })

local pick = require("mini.pick")

pick.setup()

vim.keymap.set("n", "<C-p>", function()
  if vim.fn.finddir(".git", vim.fn.getcwd() .. ";") ~= "" then
    pick.builtin.files({ tool = "git" })
  else
    pick.builtin.files()
  end
end)

vim.keymap.set("n", "g/", function() pick.builtin.grep_live() end)
vim.keymap.set("n", "	", function() pick.builtin.buffers() end)
