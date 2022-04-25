_G.java = {}
_G.java.install_debugger = function()
    local debuggers_path = vim.fn.stdpath('data') .. '/debuggers'

    local java_debugger_version = '0.36.0'
    local download_file_name = java_debugger_version .. '.tar.gz'
    local download_url = 'https://github.com/microsoft/java-debug/archive/refs/tags/' .. download_file_name
    local extracted_directory_name = 'java-debug-' .. java_debugger_version

    local download_path = debuggers_path .. '/java-debugger.tar.gz'
    local extracted_path = debuggers_path .. '/java-debug-' .. java_debugger_version

    if vim.fn.isdirectory(extracted_path) == 1 then
        print('Java debugger is already installed.')
        return
    end

    pcall(vim.fn.mkdir, debuggers_path)

    local script = 
        'cd ' .. debuggers_path .. ' && \\\n' ..
        'wget ' .. download_url .. ' && \\\n' ..
        'tar -zxvf ' .. download_file_name .. ' && \\\n' ..
        'cd ' .. extracted_directory_name .. ' && \\\n' ..
        './mvnw clean install && \\\n' ..
        'rm ../' .. download_file_name

    local output = vim.fn.system(script)
    print(output)
    print('Finished installing java debugger.')
end

vim.cmd[[
    command! JavaDebuggerInstall lua _G.java.install_debugger()
]]
