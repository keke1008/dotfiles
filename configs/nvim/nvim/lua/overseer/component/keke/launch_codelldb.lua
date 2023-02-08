return {
    desc = "Launch codelldb",
    params = {
        program = {
            type = "string",
        },
    },
    constructor = function(params)
        return {
            on_complete = function(_, _, status, _)
                if status ~= "SUCCESS" then return end

                local dap = require("dap")
                dap.run({
                    name = "Launch codelldb by overseer",
                    type = "codelldb",
                    request = "launch",
                    program = params.program,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                })
            end,
        }
    end,
}
