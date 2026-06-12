vim.cmd("packadd netrw")

vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_liststyle = 3 -- Tree format
vim.g.netrw_winsize = 40

vim.keymap.set("n", "<Space>se", "<CMD>Lexplore<CR>")
vim.keymap.set("n", "<Space>shl", "<CMD>Lexplore<CR>")
