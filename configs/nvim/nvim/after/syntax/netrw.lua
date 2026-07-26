vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = "nv"

-- netrw の構文読み込みが完了した直後に確実にルールを追加
vim.cmd([[syntax match netrwTreeBarPipe /|/ containedin=ALL conceal cchar=│]])
