return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			registries = {
				"github:mason-org/mason-registry",
				"github:crashdummyy/mason-registry",
			},
		})

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"eslint_d",
				"clang-format",
				"ruff",

				-- PHP Tools
				"intelephense", -- LSP principal
				"phpactor", -- Soporte adicional
				"php-cs-fixer", -- Formateador
				"phpcs", -- Análisis de calidad
				"phpstan", -- Análisis estático avanzado
				"pint", -- Formateador Laravel

				-- .NET Tools
				"roslyn",
				"rzls",
				"netcoredbg",
				"html-lsp", -- Needed for formatting razor
				"csharpier",
			},
		})
	end,
}
