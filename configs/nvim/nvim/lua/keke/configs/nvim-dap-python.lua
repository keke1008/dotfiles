local dap_python = require("dap-python")
local mason_registry = require("mason-registry")
local remap = vim.keymap.set

local installed, debugpy = pcall(mason_registry.get_package, "debugpy")
if not installed then
    vim.notify("`debugpy` in not installed.", vim.log.levels.INFO)
    return
end

local debugpy_path = debugpy:get_install_path()
local python_path = debugpy_path .. "/venv/bin/python"
dap_python.setup(python_path)

local debug_opts = {
    test_runner = "unittest",
}

vim.api.nvim_create_user_command("DebugpyRunner", function(e) debug_opts.test_runner = e.args end, {
    nargs = 1,
    complete = function() return { "unittest", "pytest", "django" } end,
})

local function run_debug(f)
    return function() f(debug_opts) end
end

remap("n", "<leader>dm", run_debug(dap_python.test_method), { desc = "Debug test method" })
remap("n", "<leader>da", run_debug(dap_python.test_class), { desc = "Debug test class" })
