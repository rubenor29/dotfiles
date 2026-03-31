vim.pack.add({
	-- Mejores errores en pantalla
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
})

require("tiny-inline-diagnostic").setup({
	preset = "minimal", -- Opciones: "modern", "classic", "minimal", "powerline"
	hi = {
		error = "DiagnosticError",
		warn = "DiagnosticWarn",
		info = "DiagnosticInfo",
		hint = "DiagnosticHint",
		arrow = "NonText", -- Color de la flecha que apunta al error
		background = "CursorLine", -- Color de fondo de la burbuja
		mixing_color = "None", -- Si quieres que mezcle el color del texto con el fondo
	},
	options = {
		-- Muestra el código del error (ej: [CS0103])
		show_source = false,

		-- Añade una línea que conecta el error con el código
		add_vertical_line = true,

		-- Estilo de los bordes (thinner, thick, rounded, single, double)
		border = "rounded",

		-- Elige el punto de anclaje (en la columna de signos o al final de la línea)
		softwrap = 30, -- Ajusta el texto si es muy largo
	},
})
