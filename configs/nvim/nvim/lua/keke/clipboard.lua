-- In WSL, `$PATH` inherits the Windows PATH, which makes `vim.fn.executable` very slow.
-- However, the vim script file `/usr/share/nvim/runtime/autoload/provider/clipboard.vim`
-- loaded at neovim startup calls `vim.fn.executable` many times.
-- This slows down the neovim startup time in WSL.
--
-- Writing the configs to `/etc/wsl.conf` will disable PATH inheritans, but that is inconvenient.
-- So, in this file, the clipboard is set manually.

if vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
        name = "xclip",
        copy = {
            ["+"] = { "xclip", "-i", "-selection", "clipboard" },
            ["*"] = { "xclip", "-i", "-selection", "primary" },
        },
        paste = {
            ["+"] = { "xclip", "-o", "-selection", "clipboard" },
            ["*"] = { "xclip", "-o", "-selection", "primary" },
        },
    }
elseif vim.fn.executable("win32yank.exe") == 1 then
    -- https://github.com/neovim/neovim/issues/9570#issuecomment-626275405
    vim.g.clipboard = {
        name = "win32yank",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
    }
end

vim.o.clipboard = "unnamedplus"
