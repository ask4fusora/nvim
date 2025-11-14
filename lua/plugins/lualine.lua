vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" }
})

local lualine = require("lualine")
local palette = require("catppuccin.palettes").get_palette("mocha")

local condition = {
  is_buffer_name_nonempty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  is_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')

    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = "catppuccin"
  },
  sections = {
    -- These are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- These are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

local default_padding = { left = 1, right = 1 }

-- Inserts a component in lualine_c at left section
local insert_left = function(component)
  component = vim.tbl_deep_extend("keep", component, { padding = default_padding })
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local insert_right = function(component)
  table.insert(config.sections.lualine_x, component)
end

insert_left {
  function() return ' ' end,
  padding = { left = 0, right = 0 },
}

insert_left {
  'filename',
  cond = condition.is_buffer_name_nonempty,
  color = function()
    if vim.bo.modified then
      return { fg = palette.yellow }
    end

    return { fg = palette.text }
  end,
  padding = default_padding
}

insert_left {
  'diff',
  symbols = { added = '·', modified = '·', removed = '·' },
}

insert_left {
  'branch',
  icon = '',
  color = { fg = palette.text },
  padding = { left = 0 }
}

insert_left {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = '·', warn = '·', hint = '·' },
}

insert_right { 'location' }

insert_right {
  "mode",
  color = function()
    local color_set = {
      n = { bg = palette.rosewater },
      i = { bg = palette.green },
      v = { bg = palette.lavender },
      V = { bg = palette.lavender },
      [""] = { bg = palette.mauve },
      R = { bg = palette.maroon }
    }

    return vim.tbl_extend("force", color_set[vim.fn.mode()], { fg = palette.crust })
  end
}

insert_right {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false,
}

insert_right {
  'filetype',
  icons_enabled = false,
}

insert_right {
  function() return ' ' end,
  padding = { right = 0 }
}

lualine.setup(config)
