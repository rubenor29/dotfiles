return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you use the mini.nvim suite
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		heading = {
			enabled = true,
			sign = true,
			style = "full",
			icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			left_pad = 1,
		},
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
			right_pad = 1,
			highlight = "render-markdownBullet",
		},
		-- For avante
		opts = {
			file_types = { "markdown", "Avante" },
		},
		ft = { "markdown", "Avante" },
	},
}
