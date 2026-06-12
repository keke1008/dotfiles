local opts = function(desc)
    return {
        buffer = true,
        desc = desc,
    }
end

local remap_opts = function(desc)
    return {
        buffer = true,
        remap = true,
        desc = desc,
    }
end

vim.keymap.set("n", "b", "<Plug>NetrwBrowseUpDir", opts("Up"))

vim.keymap.set("n", "o", "<Plug>NetrwLocalBrowseCheck", opts("Edit"))
vim.keymap.set("n", "e", "<Plug>NetrwLocalBrowseCheck", opts("Edit"))
vim.keymap.set("n", "v", "<Plug>NetrwLocalBrowseCheck", opts("Edit"))
vim.keymap.set("n", "s", "<Plug>NetrwLocalBrowseCheck", opts("Edit"))
vim.keymap.set("n", "w", "gn", remap_opts("enter"))

vim.keymap.set("n", "r", "R", remap_opts("Rename"))
vim.keymap.set("n", "c", "<Plug>NetrwOpenFile", opts("New"))
vim.keymap.set("n", "d", "D", remap_opts("Delete"))
