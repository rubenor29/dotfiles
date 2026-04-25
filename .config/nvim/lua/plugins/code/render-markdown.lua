vim.pack.add({
	"MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
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
})
