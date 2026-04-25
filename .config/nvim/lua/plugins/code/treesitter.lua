vim.pack.add({
	{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
})

require("tree-sitter-manager").setup({
	auto_install = true,
	highlight = true,
	ensure_installed = {
		"c_sharp",
		"razor",
		"json",
		"javascript",
		"typescript",
		"tsx",
		"toml",
		"yaml",
		"html",
		"xml",
		"css",
		"markdown",
		"markdown_inline",
		"bash",
		"lua",
		"vim",
		"dockerfile",
		"gitignore",
		"vimdoc",
		"c",
		"sql",
		"svelte",
	},
})
