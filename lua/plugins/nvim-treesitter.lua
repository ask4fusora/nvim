vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" } })

require("nvim-treesitter.configs").setup({
  modules = {},
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "typst" },
  ignore_install = {},
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
})
