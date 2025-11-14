vim.pack.add({ { src = "https://github.com/folke/which-key.nvim" } })

local which_key = require("which-key")

which_key.setup({
  delay = function(ctx)
    return ctx.plugin and 0 or 610
  end
})

vim.keymap.set("n", "<leader>?", function() which_key.show({ global = false }) end)
