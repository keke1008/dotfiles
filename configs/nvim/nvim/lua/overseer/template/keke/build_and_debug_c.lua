return {
    name = "Build & Debug C",
    desc = "build and debug C program",
    condition = {
        filetype = "c",
    },
    builder = function()
        local file = vim.fn.expand("%:p")
        local out = vim.fn.fnamemodify(file, ":r")

        return {
            cmd = "gcc",
            args = { "-g", file, "-o", out },
            components = {
                { "keke.launch_codelldb", program = out },
                "default",
            },
        }
    end,
}
