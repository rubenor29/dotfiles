vim.pack.add({
	{ src = "https://github.com/stevearc/dressing.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/folke/lazydev.nvim" },
})

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

-- Mejorar UI de Code actions
pcall(require, "dressing")

-- Configuración estética de diagnósticos
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

-- Atajos :lsp
vim.keymap.set("n", "<leader>lsr", ":lsp restart<CR>", { desc = "Reiniciar LSP" })

-- Configuración lsp attach para habilitar ir a definiciones y code actions
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

local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.enable({
	"lua_ls",
	"clangd",
	"cssls",
	"emmet_ls",
	"html",
	"roslyn_native",
	"rust_analyzer",
	"svelte",
	"tailwindcss",
	"ts_ls",
	"pyright",
})
