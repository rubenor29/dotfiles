vim.pack.add({
	-- Explorador de archivos
	{ src = "stevearc/oil.nvim" },
	-- Cerrado automatico de parentesis, llaves y corchetes
	{ src = "windwp/nvim-autopairs" },
	-- Atajos estilo tmux
	{ src = "christoomey/vim-tmux-navigator" },
	-- Mostrar posibles comandos
	{ src = "folke/which-key.nvim" },
})

require("oil").setup()
require("nvim-autopairs").setup()
require("which-key").setup()
