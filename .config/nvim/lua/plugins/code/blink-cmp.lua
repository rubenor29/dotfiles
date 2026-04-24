vim.pack.add({
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp", version = "1.*" },
	{ src = "rafamadriz/friendly-snippets" },
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpBuild",
	callback = function()
		vim.notify("BlinkCmp build completed!")
	end,
})

local blink = require("blink.cmp")

blink.build()

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
