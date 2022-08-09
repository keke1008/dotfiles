local jdtls = require 'jdtls'

local root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml' })
if root_dir == nil then
    print('Root dir not found')
    return
end

local lsp_path = vim.fn.stdpath 'data' .. '/mason/packages/jdtls'

if vim.fn.isdirectory(lsp_path) == 0 then
    print 'LSP is not installed'
end

local config = {
    cmd = {
        'java',


        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        '-jar', vim.fn.glob(lsp_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),

        '-configuration', lsp_path .. '/config_linux',

        '-data ', root_dir .. '/workspace',
    },

    root_dir = root_dir,

    init_options = {},
}

jdtls.start_or_attach(config)
jdtls.setup.add_commands()
