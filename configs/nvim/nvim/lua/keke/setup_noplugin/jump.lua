local DeferredStack = require("keke.utils.deferred_stack")

---@type string[]
local LABEL_CHARS = (function()
    local chars = "asdfjkl;:" .. "wer" .. "uio" .. "cv" .. "nm"
    chars = chars .. chars:upper()
    return vim.iter(chars:gmatch(".")):unique():totable()
end)()

---@generic T, K
---@param xs T[]
---@param f fun(x: T): K
---@return table<K, T[]>
local function group_by(xs, f)
    local result = {}

    for _, x in ipairs(xs) do
        local key = f(x)
        result[key] = result[key] or {}
        table.insert(result[key], x)
    end

    return result
end

---@class keke.jump.CandidateArea
---@field namespace_id integer
---@field winid integer
---@field bufid integer
---@field start_row integer
---@field end_row integer

---@class keke.jump.Candidate
---@field namespace_id integer
---@field winid integer
---@field bufid integer
---@field row integer
---@field col integer
---@field second_character string
---@field label? keke.jump.Label | nil

---@class keke.jump.Label
---@field label_text string | nil
---@field extmark_id integer
---@field selectable boolean

---@return keke.jump.CandidateArea[]
local function list_candate_areas()
    return vim.iter(vim.api.nvim_tabpage_list_wins(0))
        :map(function(winid)
            local namespace_id = vim.api.nvim_create_namespace("keke.jump." .. winid)
            vim.api.nvim__ns_set(namespace_id, { wins = { winid } })
            return {
                namespace_id = vim.api.nvim_create_namespace("keke.jump." .. winid),
                winid = winid,
                bufid = vim.api.nvim_win_get_buf(winid),
                start_row = vim.fn.line("w0", winid) - 1,
                end_row = vim.fn.line("w$", winid),
            }
        end)
        :totable()
end

---@param areas keke.jump.CandidateArea[]
---@return keke.jump.CandidateArea[]
local function prioritize_candidate_areas(areas)
    local current_winid = vim.api.nvim_get_current_win()
    local current_win_areas = {}
    local other_win_areas = {}
    for _, area in ipairs(areas) do
        if area.winid == current_winid then
            table.insert(current_win_areas, area)
        else
            table.insert(other_win_areas, area)
        end
    end

    return vim.iter({ current_win_areas, other_win_areas }):flatten():totable()
end

---@param first_character string
---@param line string
---@return { col: integer, second_character: string }
local function search_candidates_from_line(first_character, line)
    local candidates = {}

    local head = 1
    while true do
        local start_idx, last_idx = line:find(first_character, head, true)
        if start_idx == nil then
            break
        end

        head = last_idx + 1
        local second_character = " "
        if head <= #line then
            local second_character_last_idx = head + vim.str_utf_end(line, head)
            second_character = line:sub(head, second_character_last_idx)
        end
        table.insert(candidates, {
            col = start_idx - 1,
            second_character = second_character,
        })
    end

    return candidates
end

---@param first_character string
---@param area keke.jump.CandidateArea
---@return keke.jump.Candidate[]
local function search_candidates_in_area(first_character, area)
    if not vim.api.nvim_buf_is_valid(area.bufid) or not vim.api.nvim_win_is_valid(area.winid) then
        return {}
    end

    local lines = vim.api.nvim_buf_get_lines(area.bufid, area.start_row, area.end_row, true)
    return vim.iter(lines)
        :enumerate()
        :map(function(idx, line)
            local row = area.start_row + idx - 1
            return vim.iter(search_candidates_from_line(first_character, line))
                :map(function(candidate)
                    return {
                        namespace_id = area.namespace_id,
                        winid = area.winid,
                        bufid = area.bufid,
                        row = row,
                        col = candidate.col,
                        second_character = candidate.second_character,
                    }
                end)
                :totable()
        end)
        :flatten()
        :totable()
end

---@param first_character string
---@param areas keke.jump.CandidateArea[]
---@return keke.jump.Candidate[]
local function search_candidates(first_character, areas)
    return vim.iter(areas)
        :map(function(area)
            return search_candidates_in_area(first_character, area)
        end)
        :flatten()
        :totable()
end

---@param candidate keke.jump.Candidate
---@param extmark_text string
---@return integer extmark_id
local function show_extmark_from_candidate(candidate, extmark_text)
    return vim.api.nvim_buf_set_extmark(candidate.bufid, candidate.namespace_id, candidate.row, candidate.col, {
        id = (candidate.label and candidate.label.extmark_id),
        virt_text = { { extmark_text, "Error" } },
        virt_text_pos = "overlay",
    })
end

---@param candidates keke.jump.Candidate[]
---@return keke.jump.Candidate[]
local function label_candidates(candidates)
    local grouped_candidate_map = group_by(candidates, function(candidate)
        return candidate.second_character
    end)

    return vim.iter(vim.tbl_values(grouped_candidate_map))
        :map(function(grouped_candidates)
            return vim.iter(grouped_candidates)
                :enumerate()
                :map(function(idx, candidate) ---@param candidate keke.jump.Candidate
                    local label_text = LABEL_CHARS[idx]
                    local selectable = label_text ~= nil
                    local extmark_id = show_extmark_from_candidate(candidate, label_text or ".")
                    return vim.tbl_extend("force", candidate, {
                        label = { ---@type keke.jump.Label
                            label_text = label_text,
                            extmark_id = extmark_id,
                            selectable = selectable,
                        },
                    })
                end)
                :totable()
        end)
        :flatten()
        :totable()
end

---@param candidate keke.jump.Candidate
local function delete_extmark_from_candidate(candidate)
    if vim.api.nvim_buf_is_valid(candidate.bufid) then
        vim.api.nvim_buf_del_extmark(candidate.bufid, candidate.namespace_id, candidate.label.extmark_id)
    end
end

---@param candidates keke.jump.Candidate[]
---@return keke.jump.Candidate[]
local function drop_selectable_candidates(candidates)
    return vim.iter(candidates)
        :filter(function(candidate) ---@param candidate keke.jump.Candidate
            if not candidate.label or not candidate.label.selectable then
                return true
            end

            delete_extmark_from_candidate(candidate)
            return false
        end)
        :totable()
end

---@param second_character string
---@param candidates keke.jump.Candidate[]
---@return keke.jump.Candidate[]
local function remove_unmatched_candidates(second_character, candidates)
    return vim.iter(candidates)
        :filter(function(candidate) ---@param candidate keke.jump.Candidate
            if candidate.second_character == second_character then
                return true
            end

            delete_extmark_from_candidate(candidate)
            return false
        end)
        :totable()
end

local function jump_to_candidate(label_character, candidates)
    ---@type keke.jump.Candidate | nil
    local candidate = vim.iter(candidates):find(function(candidate_)
        return candidate_.label.label_text == label_character
    end)

    if candidate ~= nil then
        vim.api.nvim_set_current_win(candidate.winid)
        vim.api.nvim_win_set_cursor(candidate.winid, { candidate.row + 1, candidate.col })
    end
end

---@param areas keke.jump.CandidateArea[]
local function cleanup_labels(areas)
    for _, area in ipairs(areas) do
        if vim.api.nvim_buf_is_valid(area.bufid) then
            vim.api.nvim_buf_clear_namespace(area.bufid, area.namespace_id, 0, -1)
        end
    end
end

---@param areas keke.jump.CandidateArea[]
local function show_backdrop(areas)
    for _, area in ipairs(areas) do
        vim.api.nvim_buf_set_extmark(area.bufid, area.namespace_id, area.start_row, 0, {
            end_line = area.end_row,
            end_col = 0,
            hl_group = "Comment",
        })
    end
end

---@return string | nil
local function get_input()
    local ok, ch = pcall(vim.fn.getcharstr, -1, { cursor = "keep" })
    if not ok or ch == "\27" then --- "\27": ESC
        return nil
    end

    return ch
end

local function start()
    DeferredStack.scope(function(defer)
        local areas = prioritize_candidate_areas(list_candate_areas())
        defer(function()
            cleanup_labels(areas)
        end)
        show_backdrop(areas)
        vim.cmd.redraw()

        local first_character = get_input()
        if first_character == nil then
            return
        end
        local candidates = search_candidates(first_character, areas)
        if #candidates == 0 then
            return
        end
        candidates = label_candidates(candidates)
        vim.cmd.redraw()

        local second_character = get_input()
        if second_character == nil then
            return
        end
        candidates = remove_unmatched_candidates(second_character, candidates)
        vim.cmd.redraw()

        while #candidates > 0 do
            local label_character = get_input()
            if label_character == nil then
                return
            end
            if label_character == " " then
                candidates = drop_selectable_candidates(candidates)
                candidates = label_candidates(candidates)
                vim.cmd.redraw()
            else
                jump_to_candidate(label_character, candidates)
                break
            end
        end
    end)
end

vim.keymap.set({ "n", "v", "o" }, ",", start, { desc = "jump" })
