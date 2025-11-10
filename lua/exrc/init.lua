vim.opt.exrc = true

local function load_project_settings()
  local root_marker = ".nvim"
  local buffer_id = vim.api.nvim_get_current_buf()
  local root_directory = vim.fs.root(buffer_id, root_marker)
  local neovim_configuration_directory = vim.fs.joinpath(root_directory, root_marker)

  if vim.fn.isdirectory(neovim_configuration_directory) == 0 then return end
  if string.find(vim.o.runtimepath, neovim_configuration_directory) then return end

  vim.o.runtimepath = vim.o.runtimepath .. "," .. neovim_configuration_directory

  local init_lua = vim.fs.joinpath(neovim_configuration_directory, "init.lua")

  if not vim.fn.filereadable(init_lua) then return end

  local success, error_message = pcall(dofile, init_lua)

  if success then return end

  vim.notify(
    "[Neovim] Project configurations failed to load: " .. error_message .. ".",
    vim.log.levels.ERROR
  )
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function() pcall(load_project_settings) end,
})
