-- Buscador en archivos, iconos, atajos lsp
vim.pack.add({
	{ src = "echasnovski/mini.nvim" },
})

require("mini.pick").setup()
require("mini.extra").setup()
require("mini.icons").setup()

MiniIcons.mock_nvim_web_devicons() -- Hacer pasar a mini.icons por nvim-web-devicons (oil y otros)

vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>fs", "<cmd>Pick grep_live<cr>", { desc = "Grep en vivo" })
vim.keymap.set("n", "<leader>fr", "<cmd>Pick oldfiles<cr>", { desc = "Archivos recientes" })
vim.keymap.set("n", "<leader>fc", function()
	require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Buscar palabra bajo el cursor" })

-- 3. LSP (Requieren mini.extra)
vim.keymap.set("n", "<leader>fR", "<cmd>Pick lsp scope='references'<cr>", { desc = "Referencias LSP" })
vim.keymap.set("n", "<leader>fd", "<cmd>Pick lsp scope='definition'<cr>", { desc = "Definición LSP" })
vim.keymap.set("n", "<leader>fi", "<cmd>Pick lsp scope='implementation'<cr>", { desc = "Implementación LSP" })
