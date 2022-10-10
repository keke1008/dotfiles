local M = {}

---@class Rect
---@field col number
---@field row number
---@field width number
---@field height number

--  {
--      filer: AbstractFiler,
--      layout?: {
--          filer?: fun(): Rect,
--          previewer?: fun(): Rect,
--          rename?: fun(): Rect,
--      }
--  }

---@alias LayoutConfig { filer: (fun(): Rect), previewer: (fun(): Rect), rename: (fun(): Rect) }
---@alias LayoutOption { filer?: (fun(): Rect), previewer?: (fun(): Rect), rename: (fun(): Rect) }

---@alias FlfilerConfig { filer: AbstractFiler, layout: LayoutConfig }
---@alias FlfilerOption { filer: AbstractFiler, layout?: LayoutConfig }
---@alias DefaultFlfilerConfig { layout: LayoutConfig }

---@param config FlfilerConfig
function M.validate_config(config)
    vim.validate({
        filer = { config.filer, "table" },
        layout = { config.layout, "table" },
        ["layout.filer"] = { config.layout.filer, "function" },
        ["layout.previewer"] = { config.layout.previewer, "function" },
        ["layout.rename"] = { config.layout.rename, "function" },
    })
end

local function layout()
    local editor_width = vim.go.columns
    local editor_height = vim.go.lines

    local container_row = math.floor(editor_height * 0.1)
    local container_col = math.floor(editor_width * 0.1)
    local container_width = editor_width - 2 * container_col
    local container_height = editor_height - 3 * container_row

    local filer = {
        row = container_row,
        col = container_col,
        width = math.min(50, math.floor(container_width * 0.3)),
        height = container_height,
        border = "single"
    }

    local previewer = {
        col = container_col + filer.width + 2,
        row = container_row,
        width = container_width - filer.width,
        height = container_height,
    }

    local rename_width = math.floor(editor_width / 2)
    local rename_height = math.floor(editor_height / 2)

    local rename = {
        col = math.floor(rename_width / 2),
        row = math.floor(rename_height / 2),
        width = rename_width,
        height = rename_height,
    }


    return {
        filer = filer,
        previewer = previewer,
        rename = rename,
    }
end

---@return DefaultFlfilerConfig
function M.default()
    return {
        layout = {
            filer = function()
                return layout().filer
            end,
            previewer = function()
                return layout().previewer
            end,
            rename = function()
                return layout().rename
            end
        }
    }
end

return M
