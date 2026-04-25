vim.pack.add({
	{ src = "saghen/blink.lib" },
	{ src = "saghen/blink.cmp", version = "v1" },
	{ src = "rafamadriz/friendly-snippets" },
})

local blink = require("blink.cmp")
-- blink.build():wait(60000)

blink.setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	keymap = {
		preset = "default",
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },

		["<A-k>"] = { "snippet_backward", "fallback" },
		["<A-j>"] = { "snippet_forward", "fallback" },

		["<CR>"] = { "select_and_accept", "fallback" },
		["<Tab>"] = { "select_and_accept", "fallback" },
	},
})
