local jdtls = require'jdtls'
local dap = require'dap'
local fn = vim.fn

local root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml' })
if root_dir == nil then
    print('Root dir not found')
    return
end

local data_path = fn.stdpath('data')

local bundles = {
    fn.glob(
        fn.glob(data_path .. '/debuggers/java-debug-*') 
        ..'/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'
    )
}

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

        '-jar', fn.glob(data_path .. '/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),

        '-configuration', data_path .. '/lsp_servers/jdtls/config_linux',

        '-data ', root_dir .. '/workspace',
    },

    root_dir = root_dir,

    init_options = {
        bundles = bundles,
    },
}

dap.configurations.java = {{
    modulePaths = { root_dir .. '/workspace' },
    javaExec = "java",
    vmArgs = '--enable-preview',
    mainClass = "Main",
    name = "Launch Main",
    request = "launch",
    type = "java"
}}

jdtls.start_or_attach(config)
jdtls.setup_dap()
jdtls.setup.add_commands()
