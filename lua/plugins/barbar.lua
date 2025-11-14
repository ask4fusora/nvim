vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/romgrk/barbar.nvim" }
})

vim.g.barbar_auto_setup = false

require("barbar").setup({
  animation = false,
  tabpages = false,

  icons = {
    diagnostics = {
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = false },
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "·" },
      [vim.diagnostic.severity.WARN] = { enabled = true, icon = "·" },
    },

    gitsigns = {
      added = { enabled = false, icon = "·" },
      changed = { enabled = false, icon = "·" },
      deleted = { enabled = false, icon = "·" },
    },

    separator = { left = "", right = "" },
    separator_at_end = false
  },
})

local opts = { noremap = true, silent = true }

for i = 1, 9 do
  vim.keymap.set('n', "<M-" .. tostring(i) .. ">", function() vim.cmd.BufferGoto(i) end, opts)
end

vim.keymap.set("n", "<C-S-T>", function() vim.cmd.BufferRestore() end, opts)
vim.keymap.set("n", "[b", function() vim.cmd.BufferPrevious() end, opts)
vim.keymap.set("n", "]b", function() vim.cmd.BufferNext() end, opts)
