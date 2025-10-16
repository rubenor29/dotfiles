-- Estilo de Netrw (explorador de archivos)
-- Muestra archivos en formato de árbol jerárquico (tree view).
vim.cmd("let g:ntrw_liststyle=3")

-- Variable shortcut para opciones
local o = vim.opt

-- Mostrar numero de linea
o.number = true -- Muestra números de línea absolutos
o.relativenumber = true -- Mostrar numero de linea relativo a la linea actual

-- Impedir que una linea se divida en varias si no cabe en pantalla
o.wrap = false

-- tabs e identacion
o.tabstop = 2 -- Dos espacios como tabs (prettier default)
o.shiftwidth = 2 -- 2 espacios como largo de identacion
o.expandtab = true -- Expandir tabs como espacios
o.autoindent = true -- Copiar indentacion de la linea actual cuando se crea una nueva

-- Ajustes de busqueda
o.ignorecase = true -- Ignorar mayusculas o minusculas al buscar
o.smartcase = true -- Si intercalamos mayusculas y minusculas entonces se asume el case-sensisitve
o.cursorline = true -- Colocar una linea que resalta la linea donde se encuentra el cursor

-- Interfaz visual
o.termguicolors = true -- Habilita colores RGB (24-bit)
o.background = "dark" -- Fondo oscuro para temas
o.signcolumn = "yes" -- Columna lateral siempre visible. Espacio para iconos de plugins (diagnósticos, git, etc.)

-- Comportamiento de Backspace
-- Permite borrar
-- indent: Espacios de indentación.
-- eol: Saltos de línea (une líneas).
-- start: Caracteres antes del punto de inserción.
o.backspace = "indent,eol,start"

-- Portapapeles
o.clipboard:append("unnamedplus") -- Sincroniza el portapapeles de Neovim ("*/"+) con el portapapeles del sistema.

-- División de Ventanas
o.splitright = true -- :vsplit abre a la derecha
o.splitbelow = true -- :split abre abajo

o.winborder = "rounded"
