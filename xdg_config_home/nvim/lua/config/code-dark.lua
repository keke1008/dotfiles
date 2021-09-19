return function()
  vim.cmd [[
    colorscheme  codedark
    highlight NormalFloat       ctermbg=236 guibg=#333333
    highlight Normal            ctermbg=232 guibg=#111111
    highlight EndOfBuffer       ctermbg=232 guibg=#111111
    highlight SignColumn        ctermbg=232 guibg=#111111
    highlight LineNr            ctermbg=232 guibg=#111111
    highlight LspDiagnosticsDefaultError ctermfg=9 guifg=red
    highlight LspDiagnosticsDefaultWarning ctermfg=208 guifg=orange
    highlight LspDiagnosticsDefaultHint ctermfg=11 guifg=yellow
    highlight LspDiagnosticsDefaultInformation ctermfg=6 guifg=lightblue
  ]]
end

