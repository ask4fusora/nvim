---@type VimPack.Config
return {
    specs = { { src = "https://github.com/nvim-lualine/lualine.nvim" } },
    dependencies = { 'plugins.catppuccin', 'plugins.nvim-web-devicons' },
    defer_ms = 1,
    config = function()
        local lualine = require("lualine")
        local palette = require("catppuccin.palettes").get_palette()
        local theme = require("lualine.themes.catppuccin")

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

        theme.normal.c.bg = palette.crust
        theme.insert.c.bg = palette.crust
        theme.terminal.c.bg = palette.crust
        theme.command.c.bg = palette.crust
        theme.visual.c.bg = palette.crust
        theme.replace.c.bg = palette.crust
        theme.inactive.c.bg = palette.crust

        theme.normal.x.bg = palette.crust
        theme.insert.x.bg = palette.crust
        theme.terminal.x.bg = palette.crust
        theme.command.x.bg = palette.crust
        theme.visual.x.bg = palette.crust
        theme.replace.x.bg = palette.crust
        theme.inactive.x.bg = palette.crust

        theme.normal.y = { bg = palette.blue, fg = palette.crust }
        theme.insert.y = { bg = palette.green, fg = palette.crust }
        theme.terminal.y = { bg = palette.green, fg = palette.crust }
        theme.command.y = { bg = palette.peach, fg = palette.crust }
        theme.visual.y = { bg = palette.mauve, fg = palette.crust }
        theme.replace.y = { bg = palette.red, fg = palette.crust }
        theme.inactive.y = { bg = palette.crust, fg = palette.crust }

        theme.normal.z.bg = palette.crust
        theme.insert.z.bg = palette.crust
        theme.terminal.z.bg = palette.crust
        theme.command.z.bg = palette.crust
        theme.visual.z.bg = palette.crust
        theme.replace.z.bg = palette.crust
        theme.inactive.z.bg = palette.crust

        theme.normal.z.bg = palette.crust
        theme.insert.z.bg = palette.crust
        theme.terminal.z.bg = palette.crust
        theme.command.z.bg = palette.crust
        theme.visual.z.bg = palette.crust
        theme.replace.z.bg = palette.crust
        theme.inactive.z.bg = palette.crust

        local condition = require('util').condition

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
            cond = function() return not condition.is_buffer_name_empty() end,
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
            ---@param fileformat string
            fmt = function(fileformat)
                if fileformat == 'unix' then return 'LF' end
                if fileformat == 'dos' then return 'CRLF' end
                if fileformat == 'mac' then return 'CR' end

                return fileformat
            end,
            icons_enabled = false,
        }

        insert_z {
            'filetype',
            ---@param filetype string
            fmt = function(filetype)
                return filetype:gsub("(%a)([%w']*)", function(first, rest)
                    return first:upper() .. rest:lower()
                end)
            end,
            icons_enabled = false,
        }

        insert_z {
            'encoding',
            fmt = string.upper
        }

        insert_z {
            function() return ' ' end,
        }

        lualine.setup(config)
    end
}
