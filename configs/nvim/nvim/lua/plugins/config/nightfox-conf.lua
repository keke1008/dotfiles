vim.cmd [[
     autocmd VimEnter * highlight! link NvimTreeNormal Normal
     autocmd VimEnter * highlight! link NvimTreeWindowPicker Normal
     highlight LineNr guifg=#525566
     highlight Visual guibg=#3b4e6b
]]

require('nightfox').load('nightfox')
