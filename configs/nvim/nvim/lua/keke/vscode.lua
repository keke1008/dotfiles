local vscode = require("vscode-neovim")

vim.notify = vscode.notify
vim.g.clipboard = vim.g.vscode_clipboard

local function run_action(cmd, opts)
    return function()
        vscode.action(cmd, opts)
    end
end

vim.keymap.set("i", "<C-w>", run_action("deleteWordLeft"))
vim.keymap.set("i", "<C-e>", run_action("editor.action.insertLineAfter"))

vim.keymap.set("n", "<Esc>", "<CMD>Write<CR>")
vim.keymap.set("n", "<C-w><C-s>", run_action("workbench.action.splitEditorDown"))
vim.keymap.set("n", "[e", run_action("editor.action.marker.prevInFiles"))
vim.keymap.set("n", "]e", run_action("editor.action.marker.nextInFiles"))
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd.noh()
    vscode.action("closeMarkersNavigation") -- hide '[e' and ']e' popup
    vscode.action("notifications.hideToasts")
end)

vim.keymap.set("n", "/", run_action("actions.find"))
vim.keymap.set({ "n", "v" }, "*", run_action("actions.findWithSelection"))
vim.keymap.set({ "n", "v" }, "n", run_action("editor.action.nextMatchFindAction"))
vim.keymap.set({ "n", "v" }, "N", run_action("editor.action.previousMatchFindAction"))

vim.keymap.set("n", "<leader>ff", run_action("workbench.action.quickOpen"))
vim.keymap.set("n", "<leader>fl", run_action("workbench.action.findInFiles"))
vim.keymap.set("n", "<leader>se", run_action("workbench.view.explorer"))
vim.keymap.set("n", "<leader>sd", run_action("workbench.view.debug"))
vim.keymap.set("n", "<leader>st", run_action("workbench.view.testing.focus"))
vim.keymap.set("n", "<leader>shl", run_action("workbench.action.closeSidebar"))

vim.keymap.set("n", "<leader>dc", function()
    local is_debugging = vscode.eval("return vscode.debug.activeDebugSession !== undefined")
    if is_debugging then
        vscode.action("workbench.action.debug.continue")
    else
        vscode.action("workbench.action.debug.start")
    end
end)
vim.keymap.set("n", "<leader>dh", run_action("editor.debug.action.runToCursor"))
vim.keymap.set("n", "<leader>dk", run_action("editor.debug.action.showDebugHover"))
vim.keymap.set("n", "<leader>db", run_action("editor.debug.action.toggleBreakpoint"))
vim.keymap.set("n", "<leader>dB", run_action("editor.debug.action.toggleInlineBreakpoint"))
vim.keymap.set("n", "<leader>di", run_action("workbench.action.debug.stepInto"))
vim.keymap.set("n", "<leader>do", run_action("workbench.action.debug.stepOver"))
vim.keymap.set("n", "<leader>dp", run_action("workbench.action.debug.stepOut"))
vim.keymap.set("n", "<leader>dq", run_action("workbench.action.debug.disconnect"))

vim.keymap.set("n", "<leader>tt", run_action("testing.runAtCursor"))
vim.keymap.set("n", "<leader>tf", run_action("testing.runCurrentFile"))
vim.keymap.set("n", "<leader>td", run_action("testing.debugAtCursor"))
vim.keymap.set("n", "<leader>tl", run_action("testing.reRunLastRun"))
