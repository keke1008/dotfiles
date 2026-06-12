vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "go", "sh", "bash", "zsh", "asm" },
    callback = function(args)
        vim.api.nvim_set_option_value("expandtab", false, {
            buf = args.buf,
        })
    end,
})

require("keke.setup")

if not require("keke.lazy").load().loaded then
    require("keke.setup_noplugin")
end
