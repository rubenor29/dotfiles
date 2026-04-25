vim.pack.add({
	{ src = "https://github.com/stevearc/dressing.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
})

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

pcall(require, "dressing")

vim.diagnostic.config({
	float = { border = "rounded", source = "always" },
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

vim.keymap.set("n", "<leader>lsr", "<cmd>lsp restart<CR>", { desc = "Reiniciar LSP" })

-- LspAttach: keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(event)
		local bufnr = event.buf
		local k = vim.keymap
		local function opts(desc)
			return { buffer = bufnr, silent = true, desc = desc }
		end

		k.set("n", "<leader>gd", vim.lsp.buf.definition, opts("Ir a definición"))
		k.set("n", "<leader>gD", vim.lsp.buf.declaration, opts("Ir a declaración"))
		k.set("n", "<leader>gr", vim.lsp.buf.references, opts("Ir a referencias"))
		k.set("n", "<leader>gi", vim.lsp.buf.implementation, opts("Ir a implementación"))
		k.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Renombrar símbolo"))
		k.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Acciones de código"))
		k.set("n", "[d", vim.diagnostic.goto_prev, opts("Diagnóstico anterior"))
		k.set("n", "]d", vim.diagnostic.goto_next, opts("Siguiente diagnóstico"))
	end,
})

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- Herramientas, linters y formateadores
		"tree-sitter-cli",
		"prettier",
		"stylua",
		"google-java-format",
		"prettier",
		"eslint_d",
		"ruff",
		"csharpier",

		-- Lsps que por alguna razón debo instalar desde mason tool
		"svelte-language-server",
		"docker-compose-language-service",
		"docker-language-server",
		"dockerfile-language-server",
		"markdown-oxide",
	},
	auto_update = true,
	run_on_start = true,
})

require("mason-lspconfig").setup({
	ensure_installed = {
		-- Lsps
		"lua_ls",
		"clangd",
		"cssls",
		"emmet_ls",
		"html",
		"rust_analyzer",
		"pyright",
		"jdtls",
		"jsonls",
		"taplo",
		"lemminx",
	},
	automatic_installation = true,
})

vim.lsp.enable("roslyn_ls")
