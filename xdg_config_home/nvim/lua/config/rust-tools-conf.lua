return function()
  require'rust-tools'.setup {}

  local inlay_hints = require'rust-tools.config'.options.tools.inlay_hints
  inlay_hints.highlight = 'Type'
  inlay_hints.parameter_hints_prefix = ' <-'
  inlay_hints.other_hints_prefix = ' =>'
end
