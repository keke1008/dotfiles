return function()
  local hop = require'hop'
  local vimp = require'vimp'

  hop.setup {
    keys = 'asdfghjklwertyuiopzxcvbnm',
    quit_key = '<Esc>'
  }

  local hop_prefix = ','

  vimp.nnoremap(hop_prefix .. 'c', hop.hint_char1)
  vimp.nnoremap(hop_prefix .. 's', hop.hint_char2)
  vimp.nnoremap(hop_prefix .. 'l', hop.hint_lines)
  vimp.onoremap(hop_prefix .. 'c', hop.hint_char1)
  vimp.onoremap(hop_prefix .. 's', hop.hint_char2)
  vimp.onoremap(hop_prefix .. 'l', hop.hint_lines)
end
