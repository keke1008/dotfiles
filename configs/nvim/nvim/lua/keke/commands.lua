vim.api.nvim_create_user_command("WipeInvisibleBuffers", function()
    local buffer_infos = vim.fn.getbufinfo({ buflisted = true }) or {}

    for _, buffer_info in ipairs(buffer_infos) do
        if buffer_info.changed == 0 and #buffer_info.windows == 0 then
            vim.api.nvim_buf_delete(buffer_info.bufnr, { force = false, unload = false })
        end
    end
end, { desc = "Wipe invisible buffers" })
