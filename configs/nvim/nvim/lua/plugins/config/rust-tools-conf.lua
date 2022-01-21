require'rust-tools'.setup {}

vim.cmd[[highligh rustInlayHints guifg=#3467af ]]
local inlay_hints = require'rust-tools.config'.options.tools.inlay_hints
inlay_hints.highlight = 'rustInlayHints'
inlay_hints.parameter_hints_prefix = '  '
inlay_hints.other_hints_prefix = '  '
