vim.pack.add({
	{ src = "rachartier/tiny-inline-diagnostic.nvim" },
})

require("tiny-inline-diagnostic").setup({
	preset = "modern", -- "modern", "classic", "minimal", "powerline"
	hi = {
		error = "DiagnosticError",
		warn = "DiagnosticWarn",
		info = "DiagnosticInfo",
		hint = "DiagnosticHint",
		arrow = "NonText",
		background = "CursorLine",
		mixing_color = "None",
	},
	options = {
		show_source = false,
		add_vertical_line = true,
		border = "rounded",
		softwrap = 30,
	},
})
