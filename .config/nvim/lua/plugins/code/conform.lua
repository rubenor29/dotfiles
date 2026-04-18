vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

local conform = require("conform")

-- configura conform
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		java = { "google-java-format" },
		cs = { "csharpier" },
		python = { "ruff" },
	},
})

-- mapea la tecla para formatear
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 5000,
	})
end, { desc = "Formatear archivo o selección" })
