vim.pack.add({ { src = "https://github.com/karb94/neoscroll.nvim" } })

require("neoscroll").setup({
  easing = "quadratic",
  duration_multiplier = 0.056
})
