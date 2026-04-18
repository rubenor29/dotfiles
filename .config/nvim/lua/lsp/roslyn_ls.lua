-- Inicializar lsp
local log_dir = vim.fs.joinpath(vim.uv.os_tmpdir(), "roslyn_ls", "logs")
vim.fn.mkdir(log_dir, "p")

vim.lsp.config("roslyn_ls", {
	filetypes = { "cs" },
	root_markers = { ".sln", ".csproj", ".git" },
	capabilities = _G.LspCapabilities,
	cmd = {
		"roslyn-language-server",
		"--logLevel",
		"Error",
		"--extensionLogDirectory",
		log_dir,
		"--stdio",
	},
})
