vim.pack.add({
  { src = "https://github.com/romgrk/barbar.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-web-devicons" },
})

vim.g.barbar_auto_setup = false

require("barbar").setup({
  animation = false,
  tabpages = false,

  focus_on_close = 'previous',

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

    inactive = {
      separator = { left = "", right = "" },
      separator_at_end = false,
    },
    separator = { left = "", right = "" },
    separator_at_end = false,
  },
})

local opts = { noremap = true, silent = true } ---@type vim.keymap.set.Opts

for i = 1, 9 do
  vim.keymap.set("n", ('<A-%i>'):format(i), function() vim.cmd.BufferGoto(i) end, opts)
end

vim.keymap.set("n", '<C-S-T>', vim.cmd.BufferRestore, opts)
vim.keymap.set('n', ']b', vim.cmd.BufferNext, opts)
vim.keymap.set('n', '[b', vim.cmd.BufferPrevious, opts)
