local remap = require("keke.remap")
local set_keymap = remap.set_keymap

set_keymap("n", "*", "<Plug>(asterisk-z*)")
set_keymap("n", "#", "<Plug>(asterisk-z#)")
set_keymap("n", "g*", "<Plug>(asterisk-gz*)")
set_keymap("n", "g#", "<Plug>(asterisk-gz#)")
