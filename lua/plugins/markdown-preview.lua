---@type VimPack.Config
return {
    specs = {
        { src = "https://github.com/iamcco/markdown-preview.nvim" },
    },
    trigger = {
        file_types = { "markdown" },
        user_commands = {
            "MarkdownPreview",
            "MarkdownPreviewToggle",
            "MarkdownPreviewStop"
        }
    },
    config = function()
        vim.fn["mkdp#util#install"]()
    end
}
