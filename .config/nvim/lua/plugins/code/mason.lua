vim.pack.add({
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

-- 1. Setup de Mason
require("mason").setup({
	registries = {
		"github:crashdummyy/mason-registry", -- Necesario para Roslyn
		"github:mason-org/mason-registry",
	},
})

-- 2. Setup de Mason Tool Installer
-- Aquí defines herramientas que no son LSPs (Formatters, Linters, DAP)
require("mason-tool-installer").setup({
	ensure_installed = {

		"stylua", -- Formatter para Lua
		"prettier", -- Formatter para Web
		"html-lsp", -- Requerido para formatear razor
		"eslint_d", -- Linter JS (opcional)
		"ruff",

		"roslyn", -- Es un lsp pero necesitamos definirlo aquí para que se instale
		"rzls", -- Necesario para Roslyn, aunque no lo configuremos en handlers
		"netcoredbg", -- Debugger para .NET

		"jdtls",
		"google-java-format",
	},
	auto_update = true,
	run_on_start = true,
})
