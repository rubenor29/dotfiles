vim.pack.add({
	-- Explorador de archivos
	{ src = "https://github.com/stevearc/oil.nvim" },
	-- Cerrado automatico de parentesis, llaves y corchetes
	{ src = "https://github.com/windwp/nvim-autopairs" },
	-- Atajos estilo tmux
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	-- Mostrar posibles comandos
	{ src = "https://github.com/folke/which-key.nvim" },
})

require("oil").setup()
require("nvim-autopairs").setup()
require("which-key").setup()
