return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.preview_scrolling_up,
						["<C-j>"] = actions.preview_scrolling_down,
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local k = vim.keymap -- for conciseness

		k.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Buscar archivos en el directorio actual" })
		k.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Buscar archivos recientes" })
		k.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Buscar una cadena en el directorio actual" })
		k.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Buscar la cadena bajo el cursor" })
		k.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Buscar todos los 'TODOS'" })

		k.set("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { desc = "Buscar referencias" })
		k.set("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Buscar definiciones" })
		k.set("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Buscar buscar implementaciones" })
	end,
}
