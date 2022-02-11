-- You should not install 'rust_analyzer' with nvim-lsp-installer,
-- because rust-tools will automatically enable this lsp.

vim.cmd[[highligh rustInlayHints guifg=#3467af]]

require'rust-tools'.setup {
    tools = {
        inlay_hints = {
            parameter_hints_prefix = '', -- \uf54d
            highlight = 'rustInlayHints',
            other_hints_prefix = ' ', -- \uf554
        }
    }
}
