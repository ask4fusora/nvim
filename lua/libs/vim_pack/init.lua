local module_config_registry = {} ---@type table<string, VimPack.Config>
local loaded_modules = {} ---@type table<string, boolean>
local loading_modules = {} ---@type table<string, boolean>

---@param module_name string The module path to require (e.g., "plugins.telescope").
local function load_module(module_name)
    if loaded_modules[module_name] then return end

    if loading_modules[module_name] then
        vim.notify(
            ("VimPack: Circular dependencies detected for `%s`."):format(
                module_name),
            vim.log.levels.WARN)
        return
    end

    loading_modules[module_name] = true

    ---@type nil|VimPack.Config
    local config = module_config_registry[module_name]

    if not config then
        local is_success, _ = pcall(require, module_name)
        ---@diagnostic disable-next-line: empty-block
        if not is_success then
            -- Only notify if it looks like a user plugin failure, otherwise silent for optional stuff?
            -- Sticking to silent for now unless it breaks things.
        end

        loaded_modules[module_name] = true
        loading_modules[module_name] = nil
        return
    end

    if config.dependencies then
        for _, dependency in ipairs(config.dependencies) do
            load_module(dependency)
        end
    end

    vim.pack.add(config.specs)

    if config.config then
        local is_success, result = pcall(config.config)
        if not is_success then
            vim.notify(
                ("VimPack: Config function for `%s` failed.\n%s"):format(
                    module_name, result),
                vim.log.levels.ERROR)
            loading_modules[module_name] = nil
            return
        end
    end

    loaded_modules[module_name] = true
    loading_modules[module_name] = nil
end

---@param command string
---@param command_args vim.api.keyset.create_user_command.command_args
local function replay_user_command(command, command_args)
    local range = command_args.range ~= 0
        and { command_args.line1, command_args.line2 }
        or nil

    vim.api.nvim_cmd({
        cmd = command,
        args = command_args.fargs,
        bang = command_args.bang,
        range = range,
        mods = command_args.smods,
    }, {})
end

---@param module_names string[] List of module names to load.
local function add(module_names)
    for _, module_name in ipairs(module_names) do
        local is_success, pcall_config = pcall(require, module_name)
        if not is_success then
            vim.notify(
                ("VimPack: Failed to require module `%s`.\n%s"):format(
                    module_name, pcall_config),
                vim.log.levels.ERROR)
        end

        ---@type VimPack.Config
        local config = pcall_config
        module_config_registry[module_name] = config

        local total_triggers = 0
        local trigger = config.trigger

        if trigger then
            if trigger.keymaps then
                total_triggers = total_triggers + #trigger.keymaps

                for _, keymap in ipairs(trigger.keymaps) do
                    vim.keymap.set(
                        keymap.mode,
                        keymap.lhs,
                        function()
                            vim.schedule(function()
                                vim.keymap.del(keymap.mode, keymap.lhs)
                                load_module(module_name)
                                local lhs = vim.keycode(keymap.lhs)
                                vim.api.nvim_feedkeys(lhs, 'm', false)
                            end)
                        end,
                        {
                            desc = ("VimPack: Lazy load `%s`.").format(
                                module_name)
                        })
                end
            end

            if trigger.events then
                total_triggers = total_triggers + #trigger.events

                for _, event in ipairs(trigger.events) do
                    vim.api.nvim_create_autocmd(event, {
                        callback = function()
                            vim.schedule(function()
                                load_module(module_name)
                            end)
                        end,
                        once = true,
                        desc = ("VimPack: Lazy load `%s`."):format(module_name),
                    })
                end
            end

            if trigger.user_commands then
                total_triggers = total_triggers + #trigger.user_commands

                for _, command in ipairs(trigger.user_commands) do
                    vim.api.nvim_create_user_command(
                        command,
                        function(command_args)
                            vim.schedule(function()
                                vim.api.nvim_del_user_command(command)
                                load_module(module_name)
                                replay_user_command(command, command_args)
                            end)
                        end,
                        {
                            nargs = "*",
                            bang = true,
                            range = true,
                        })
                end
            end

            if trigger.file_types then
                total_triggers = total_triggers + #trigger.file_types
                for _, file_type in ipairs(trigger.file_types) do
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = file_type,
                        callback = function()
                            vim.schedule(function()
                                load_module(module_name)
                            end)
                        end,
                        once = true,
                    })
                end
            end
        end

        if config.defer_ms then
            total_triggers = total_triggers + 1
            vim.defer_fn(
                function()
                    load_module(module_name)
                end,
                config.defer_ms)
        end

        if total_triggers == 0 then
            load_module(module_name)
        end
    end
end

return {
    add = add
}
