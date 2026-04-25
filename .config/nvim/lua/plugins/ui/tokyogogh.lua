vim.pack.add({
	{ src = "cesaralvarod/tokyogogh.nvim" },
})

require("tokyogogh").setup()

vim.cmd("colorscheme tokyogogh-storm")
