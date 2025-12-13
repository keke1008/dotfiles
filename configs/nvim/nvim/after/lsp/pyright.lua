local lsp = require("keke.utils.lsp")

return {
    root_dir = lsp.any_root_dir({
        lsp.root_dir(".git"),

        --- In monorepo structures like uv workspace, both the root and subdirectories may contain pyproject.toml,
        --- so prioritize the root one.
        lsp.root_dir_recursive({
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "manage.py",
        }),
    }),
}
