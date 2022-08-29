local ls = require 'luasnip'
local s = ls.s
local t = ls.t
local i = ls.i

ls.add_snippets('rust', {
    s('fn', {
        t('fn '), i(1), t('('), i(2), t(') '), i(3, '-> '), t({ ' {', '' }),
        t('    '), i(4), t({ '', '' }),
        t('}'), i(0)
    })
})
