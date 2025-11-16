vim.o.clipboard = vim.o.clipboard .. "unnamedplus,unnamed"

vim.o.shellslash = true
vim.o.isfname = table.concat({ vim.o.isfname, "(", ")" }, ",")

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 5
vim.o.statuscolumn = " %s%=%{v:relnum ? v:relnum : v:lnum} "
vim.o.signcolumn = "yes:1"
vim.o.cursorline = true

vim.o.wrap = false

vim.o.winborder = "rounded"

vim.o.completeopt = "fuzzy,menu,menuone,noinsert,popup"

vim.o.smartindent = true
vim.o.ff = "unix"

vim.o.swapfile = false

vim.o.termguicolors = true

vim.o.undofile = true

vim.o.incsearch = true

vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "

require("session")
require("exrc")
require("keymaps")
require("plugins")
require("lsp")
require("autocmds")
