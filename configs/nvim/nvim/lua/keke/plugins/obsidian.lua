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

    local title = vim.fn.input("Title: ")
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
        { "<leader>oc", create_child_page },
        { "<leader>oo", "<CMD>ObsidianOpen<CR>" },
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
