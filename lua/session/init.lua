vim.o.sessionoptions = table.concat({
  "buffers",
  "help",
  "folds",
  "winsize",
  "curdir",
  "tabpages"
}, ",")

local sessions_directory = vim.fs.joinpath(vim.fn.stdpath("data"), "sessions")
vim.fn.mkdir(sessions_directory, "p")

local get_session_path = function()
  local cwd = vim.fn.getcwd()
  local session_name = vim.fn.fnamemodify(cwd, ":t")

  if session_name == "" then
    if require("util").platform.windows() then
      session_name = vim.fn.fnamemodify(cwd, ":d")
      session_name = vim.fn.substitute(session_name, ":", "", "")
    else
      session_name = "ROOT"
    end
  end

  local path_hash           = vim.fn.sha256(cwd)
  local short_hash          = vim.fn.strpart(path_hash, 0, 7)
  local unique_session_name = session_name .. short_hash

  return vim.fs.joinpath(sessions_directory, unique_session_name)
end

local save_session = function()
  local session_path = get_session_path()
  vim.cmd.mksession({ session_path, bang = true })
end

local load_session = function()
  local session_path = get_session_path()

  if vim.fn.filereadable(session_path) == 1 then
    vim.cmd.source(session_path)
  end
end

local delete_session = function()
  local session_path = get_session_path()

  if vim.fn.filereadable(session_path) == 1 then
    vim.fn.delete(session_path)
  end
end

vim.api.nvim_create_user_command("SessionSave", save_session, {})
vim.api.nvim_create_user_command("SessionLoad", load_session, {})
vim.api.nvim_create_user_command("SessionDelete", delete_session, {})

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>ss", save_session, vim.tbl_extend("force", opts, { desc = "[S]ession [S]ave" }))
vim.keymap.set("n", "<leader>sl", load_session, vim.tbl_extend("force", opts, { desc = "[S]ession [L]oad" }))
vim.keymap.set("n", "<leader>sd", delete_session, vim.tbl_extend("force", opts, { desc = "[S]ession [D]elete" }))

local session_group = vim.api.nvim_create_augroup("NativeSession", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = session_group,
  callback = function()
    if vim.fn.argc() ~= 0 then return end

    local session_path = get_session_path()

    if vim.fn.filereadable(session_path) == 1 then
      vim.defer_fn(load_session, 1)
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = session_group,
  callback = function()
    if vim.fn.argc() ~= 0 then return end
    save_session()
  end,
})
