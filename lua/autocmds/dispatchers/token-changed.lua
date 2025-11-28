local last_token = nil ---@type string?

vim.api.nvim_create_autocmd('CursorMoved', {
  group = vim.api.nvim_create_augroup('TokenChanged', { clear = true }),
  callback = function()
    local col = vim.fn.col('.') -- 1-based byte index
    local line = vim.api.nvim_get_current_line()
    local char = line:sub(col, col)

    local current_token = nil

    -- Determine Token Type
    if char:match("[%w_]") then
      -- CASE A: Alphanumeric -> Safe to use cword (grabs "my_variable")
      current_token = vim.fn.expand('<cword>')
    elseif char:match("%s") or char == "" then
      -- CASE B: Whitespace -> Sentinel
      current_token = "WHITESPACE_SENTINEL"
    else
      -- CASE C: Symbol (., =, :) -> STRICT SINGLE CHAR
      -- We use the character itself as the token ID.
      -- This prevents <cword> from jumping over the dot to the next word.
      current_token = char
    end

    if last_token ~= current_token then
      last_token = current_token

      vim.schedule(function()
        vim.api.nvim_exec_autocmds('User', { pattern = 'TokenChanged' })
      end)
    end
  end
})
