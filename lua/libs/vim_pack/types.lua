---@class VimPack.Config.LoadTrigger.Keymap
---@field mode string Vim mode of the keymap.
---@field lhs string Left-hand side of the keymap.

---@class VimPack.Config.LoadTrigger
---@field keymaps? VimPack.Config.LoadTrigger.Keymap[] Keymaps to trigger loading.
---@field events? string[] Autocommand events to trigger loading.
---@field user_commands? string[] User commands to trigger loading.
---@field file_types? string[] Filetypes to trigger loading.

---@class VimPack.Config
---@field specs (string|vim.pack.Spec)[] List of plugin specifications. String item is treated as `src`.
---@field opts? vim.pack.keyset.add Options for vim.pack.add.
---@field dependencies? string[] List of module names that must be loaded before this one.
---@field trigger? VimPack.Config.LoadTrigger Load triggers for the module.
---@field defer_ms? number Time in ms to defer loading.
---@field config? fun() Function to run after loading the module.
