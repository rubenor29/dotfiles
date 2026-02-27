-- Keymaps
vim.g.mapleader = " " -- Espacio como letra leader

-- General
vim.keymap.set("n", "<leader>so", ":update<CR> :source<CR>", { desc = "recargar configuración de nvim" })
vim.keymap.set("n", "<leader>ww", ":w<CR>", { desc = "guardar" })
vim.keymap.set("n", "<leader>qq", ":q<CR>", { desc = "salir" })
vim.keymap.set("n", "<leader>Qq", ":q!<CR>", { desc = "salir sin guardar" })
vim.keymap.set("n", "<leader>ee", "<cmd>Oil<CR>", { desc = "Explorador de archivos" })
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Eliminar subrayado" })

-- División de pantalla
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Dividir la pantalla verticalmente" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Dividir la pantalla horizontalmente" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Dimensionar equitativamente las divisiones" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Cerrar la division actual" })

-- Tabs
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Nueva pestaña" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Cerrar pestaña actual" })
vim.keymap.set("n", "<TAB>", "<cmd>tabn<CR>", { desc = "Pestaña siguiente" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Pestaña siguiente" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Pestaña anterior" })
vim.keymap.set("n", "<S-TAB>", "<cmd>tabp<CR>", { desc = "Pestaña anterior" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Archivo actual en nueva pestaña" })

-- Código
vim.keymap.set("n", "<leader>mc", ":compiler ", { desc = "elegir compilador" })
vim.keymap.set("n", "<leader>mm", ":make ", { desc = "compilar" })
vim.keymap.set("n", "<leader>xq", ":copen<CR>", { desc = "quickfix list" })
vim.keymap.set("n", "<leader>dd", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Mostrar diagnosticos" })
-- vim.keymap.set("n", "<leader>mp", vim.lsp.buf.format, { desc = "Formatear archivo" })
