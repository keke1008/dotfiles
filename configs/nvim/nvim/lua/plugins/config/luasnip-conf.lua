local ls = require'luasnip'
local ex = require'luasnip.extras'
local s = ls.s
local t = ls.t
local i = ls.i
local rep = ex.rep

ls.snippets = {
    c = {
        s('if', {
            t('if ( '), i(1), t(' ) {'),
                i(0),
            t('}'),
        }),
        s('while', {
            t('while ( '), i(1), t(' ) {'),
                i(0),
            t('}'),
        }),
        s('for' , {
            t('for ( int '), i(1), t(' = 0; '), rep(1), t(' < '), i(2), t('; '), rep(1), t('++) {'),
                i(0),
            t('}'),
        }),
    }
}
