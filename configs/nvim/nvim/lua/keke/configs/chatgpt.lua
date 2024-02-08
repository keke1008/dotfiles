local M = {}

function M.setup()
    local mode = { "n", "v" }
    local function opts(desc) return { noremap = true, silent = true, desc = desc } end

    local function set_keymap(key, cmd, desc)
        local lhs = "<leader>c" .. key
        local rhs = "<CMD>ChatGPTRun " .. cmd .. "<CR>"
        vim.keymap.set(mode, lhs, rhs, opts(desc))
    end

    vim.keymap.set({ "i", "s" }, "<C-q>", "<CMD>ChatGPTCompleteCode<CR>", opts("Complete Code"))
    set_keymap("c", "ChatGPTCompleteCode", "CompleteCode")
    set_keymap("e", "ChatGPTEditWithInstruction", "Edit with instruction")
    set_keymap("g", "ChatGPTRun grammar_correction", "Grammar Correction")
    set_keymap("t", "ChatGPTRun translate", "Translate")
    set_keymap("k", "ChatGPTRun keywords", "Keywords")
    set_keymap("d", "ChatGPTRun docstring", "Docstring")
    set_keymap("a", "ChatGPTRun add_tests", "Add Tests")
    set_keymap("o", "ChatGPTRun optimize_code", "Optimize Code")
    set_keymap("s", "ChatGPTRun summarize", "Summarize")
    set_keymap("f", "ChatGPTRun fix_bugs", "Fix Bugs")
    set_keymap("x", "ChatGPTRun explain_code", "Explain Code")
    set_keymap("r", "ChatGPTRun roxygen_edit", "Roxygen Edit")
    set_keymap("l", "ChatGPTRun code_readability_analysis", "Code Readability Analysis")
end

function M.config() require("chatgpt").setup() end

return M
