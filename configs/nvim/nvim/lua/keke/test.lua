local l = require("lspconfig.util")

put("cwd: " .. vim.fn.getcwd())

local guard = 100
for path in l.path.iterate_parents(vim.fn.getcwd() .. "/dummy") do
    guard = guard - 1
    if guard == 0 then return end

    put(path)

    -- local target_path = l.path.join(path, "init.lua")
    -- print(target_path)
    -- if l.path.exists(target_path) then put(target_path) end
end
