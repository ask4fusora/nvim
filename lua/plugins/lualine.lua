vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" }
})

local lualine = require("lualine")
local palette = require("catppuccin.palettes").get_palette()
local catppuccin_options = require("catppuccin").options
local theme = require("lualine.themes.catppuccin")

local transparent_background = catppuccin_options.transparent_background and "NONE" or palette.crust

---@param key string
local add_section = function(key)
  for _, sections in pairs(theme) do
    if not sections[key] then
      sections[key] = { fg = palette.text }
    end
  end
end

add_section("c")
add_section("x")
add_section("y")
add_section("z")

theme.normal.c.bg = transparent_background
theme.insert.c.bg = transparent_background
theme.terminal.c.bg = transparent_background
theme.command.c.bg = transparent_background
theme.visual.c.bg = transparent_background
theme.replace.c.bg = transparent_background
theme.inactive.c.bg = transparent_background

theme.normal.x.bg = transparent_background
theme.insert.x.bg = transparent_background
theme.terminal.x.bg = transparent_background
theme.command.x.bg = transparent_background
theme.visual.x.bg = transparent_background
theme.replace.x.bg = transparent_background
theme.inactive.x.bg = transparent_background

theme.normal.y = { bg = palette.blue, fg = transparent_background }
theme.insert.y = { bg = palette.green, fg = transparent_background }
theme.terminal.y = { bg = palette.green, fg = transparent_background }
theme.command.y = { bg = palette.peach, fg = transparent_background }
theme.visual.y = { bg = palette.mauve, fg = transparent_background }
theme.replace.y = { bg = palette.red, fg = transparent_background }
theme.inactive.y = { bg = transparent_background, fg = transparent_background }

theme.normal.z.bg = transparent_background
theme.insert.z.bg = transparent_background
theme.terminal.z.bg = transparent_background
theme.command.z.bg = transparent_background
theme.visual.z.bg = transparent_background
theme.replace.z.bg = transparent_background
theme.inactive.z.bg = transparent_background

theme.normal.z.bg = transparent_background
theme.insert.z.bg = transparent_background
theme.terminal.z.bg = transparent_background
theme.command.z.bg = transparent_background
theme.visual.z.bg = transparent_background
theme.replace.z.bg = transparent_background
theme.inactive.z.bg = transparent_background

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
    theme = theme
  },
  sections = {
    -- These are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    -- These are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}

local default_padding = { left = 1, right = 1 }

-- Inserts a component in lualine_c at left section
local insert_c = function(component)
  component = vim.tbl_deep_extend("keep", component, { padding = default_padding })
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local insert_x = function(component)
  component = vim.tbl_deep_extend("keep", component, { padding = default_padding })
  table.insert(config.sections.lualine_x, component)
end

-- Inserts a component in lualine_y at right section
local insert_y = function(component)
  component = vim.tbl_deep_extend("keep", component, { padding = default_padding })
  table.insert(config.sections.lualine_y, component)
end

-- Inserts a component in lualine_z at right section
local insert_z = function(component)
  component = vim.tbl_deep_extend("keep", component, { padding = default_padding })
  table.insert(config.sections.lualine_z, component)
end

insert_c {
  function() return ' ' end,
}

insert_c {
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

insert_c {
  'diff',
  symbols = { added = '·', modified = '·', removed = '·' },
}

insert_c {
  'branch',
  icon = '',
  color = { fg = palette.text },
  padding = { left = 0 }
}

insert_c {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = '·', warn = '·', hint = '·' },
}

insert_x { 'location' }

insert_y {
  "mode",
}

insert_z {
  'fileformat',
  fmt = string.upper,
  icons_enabled = false,
}

insert_z {
  'filetype',
  icons_enabled = false,
}

insert_z {
  function() return ' ' end,
}

lualine.setup(config)
