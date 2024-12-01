local VAULT_DIR = os.getenv("HOME") .. "/Documents/Obsidian"

local function get_vault_path()
    local vaults = {}
    for name, entry_type in vim.fs.dir(VAULT_DIR) do
        if name:sub(1, 1) ~= "." and entry_type == "directory" then
            table.insert(vaults, {
                name = name,
                path = VAULT_DIR .. "/" .. name,
            })
        end
    end

    return vaults
end

---@param bytes number
---@return string
local function generate_random_id(bytes)
    local id = ""
    for _ = 1, bytes do
        local random = math.random(0, 255)
        id = id .. string.format("%02x", random)
    end
    return id
end

local function create_child_page()
    local client = require("obsidian").get_client()
    local current_note = client:current_note()
    if not current_note then
        return
    end
    if #current_note.aliases == 0 then
        vim.notify("Current note has no aliases", vim.log.levels.ERROR)
        return
    end
    local current_note_link = client:format_link(current_note, { label = current_note.aliases[1] })

    local title = vim.fn.input("Child Title: ")
    if not title or title == "" then
        return
    end

    local note = client:create_note({
        title = title,
        no_write = true,
    })
    note:add_field("links", { current_note_link })

    client:open_note(note, { sync = true })
    client:write_note_to_buffer(note)
end

local function create_sibling_page()
    local client = require("obsidian").get_client()
    local current_note = client:current_note()
    if not current_note then
        return
    end

    local title = vim.fn.input("Sibling Title: ")
    if not title or title == "" then
        return
    end

    local note = client:create_note({
        title = title,
        no_write = true,
    })
    note:add_field("links", current_note.metadata.links)

    client:open_note(note, { sync = true })
    client:write_note_to_buffer(note)
end

local function copy_current_note_link()
    local client = require("obsidian").get_client()
    client:resolve_link_async(nil, function(link)
        local note = link and link.note or client:current_note()
        if not note then
            return
        end

        if #note.aliases == 0 then
            vim.notify("Current note has no aliases", vim.log.levels.ERROR)
            return
        end

        local link_str = client:format_link(note, { label = note.aliases[1] })
        vim.schedule(function()
            vim.fn.setreg("+", link_str)
            vim.notify("Copied '" .. link_str .. "' to register +", vim.log.levels.INFO)
        end)
    end)
end

local function copy_current_note_path()
    local client = require("obsidian").get_client()
    client:resolve_link_async(nil, function(link)
        local path = link and link.path or client:current_note().path
        if not path then
            return
        end

        local path_str = tostring(client:vault_relative_path(path, { strict = true }))
        vim.schedule(function()
            vim.fn.setreg("+", path_str)
            vim.notify("Copied '" .. path_str .. "' to register +", vim.log.levels.INFO)
        end)
    end)
end

local function open_parent_note()
    local async = require("plenary.async")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    local client = require("obsidian").get_client()
    local current_note = client:current_note()
    if not current_note then
        return
    end

    ---@type string[]
    local parent_links = current_note.metadata.links or {}
    if #parent_links == 0 then
        return
    end

    local resolve_link = async.wrap(client.resolve_link_async, 3)
    local resolve_link_funcs = vim.tbl_map(function(link)
        return function()
            ---@type obsidian.ResolveLinkResult
            local result = resolve_link(client, link)
            return result.note
        end
    end, parent_links)

    async.void(function()
        ---@type obsidian.Note[]
        local parent_notes = vim.tbl_filter(
            function(v)
                return v ~= nil
            end, --
            vim.tbl_map(
                function(v)
                    return v[1]
                end, --
                async.util.join(resolve_link_funcs)
            )
        )
        if #parent_notes == 0 then
            return
        end
        if #parent_notes == 1 then
            client:open_note(parent_notes[1])
            return
        end

        vim.schedule(function()
            pickers
                .new({}, {
                    prompt_title = "Parent Notes",
                    finder = finders.new_table({
                        results = parent_notes,
                        entry_maker = function(note)
                            return {
                                value = note,
                                display = note.title,
                                ordinal = note.title,
                                path = tostring(note.path),
                            }
                        end,
                    }),
                    sorter = conf.generic_sorter({}),
                    previewer = conf.file_previewer({}),
                })
                :find()
        end)
    end)()
end

local vaults = get_vault_path()

return {
    "epwalsh/obsidian.nvim",
    version = "*",
    cond = #vaults ~= 0,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope.nvim", optional = true },
    },
    keys = {
        { "<leader>ob", "<CMD>ObsidianBacklinks<CR>" },
        { "<leader>on", "<CMD>ObsidianNew<CR>" },
        { "<leader>oc", create_child_page, desc = "Create Child Page" },
        { "<leader>os", create_sibling_page, desc = "Create Sibling Page" },
        { "<leader>ol", copy_current_note_link, desc = "Copy Current Note Link" },
        { "<leader>oL", copy_current_note_path, desc = "Copy Current Note Path" },
        { "<leader>oo", "<CMD>ObsidianOpen<CR>" },
        { "<leader>op", open_parent_note, desc = "Open Parent Note" },
        { "<leader>of", "<CMD>ObsidianSearch<CR>" },
        { "<leader>ow", "<CMD>ObsidianWorkspace<CR>" },
        { "<leader>o0", "<CMD>ObsidianToday<CR>" },
        { "<leader>o1", "<CMD>ObsidianToday 1<CR>" },
    },
    config = function()
        require("obsidian").setup({
            workspaces = vaults,
            preferred_link_style = "markdown",
            notes_subdir = "notes",
            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },
            daily_notes = {
                folder = "notes/daily",
            },
            note_id_func = function()
                local bytes = 8
                return generate_random_id(bytes)
            end,
            note_frontmatter_func = function(note)
                note:add_alias(note.title)
                local links = (note.metadata or {}).links or {}
                local out = { id = note.id, aliases = note.aliases, links = links }

                return vim.tbl_extend("force", out, note.metadata or {})
            end,
        })
    end,
}
