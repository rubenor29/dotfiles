-- Adaptando la paleta a los colores del tema
local themes = {
  tokyonight = {
    bg = "#11121D",
    fg = "#A0A8CD",
    blue = "#7199EE",
    green = "#95C561",
    purple = "#A485DD",
    yellow = "#D7A65F",
    red = "#EE6D85",
    inactive_bg = "#353945",
  },
  retrobox = {
    bg = "#282828",
    fg = "#ebdbb2",
    blue = "#83a598",
    green = "#b8bb26",
    purple = "#d3869b",
    yellow = "#fabd2f",
    red = "#fb4934",
    inactive_bg = "#3c3836",
  },
}

-- Selecciona el tema activo aquí
local colors = themes["retrobox"]

vim.pack.add({
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

local lualine = require("lualine")

local my_lualine_theme = {
  normal = {
    a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  insert = {
    a = { bg = colors.green, fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  visual = {
    a = { bg = colors.purple, fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  command = {
    a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  replace = {
    a = { bg = colors.red, fg = colors.bg, gui = "bold" },
    b = { bg = colors.bg, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  inactive = {
    a = { bg = colors.inactive_bg, fg = colors.fg, gui = "bold" },
    b = { bg = colors.inactive_bg, fg = colors.fg },
    c = { bg = colors.inactive_bg, fg = colors.fg },
  },
}

-- Configurar lualine con el tema adaptado
lualine.setup({
  options = {
    theme = my_lualine_theme,
  },
  sections = {
    lualine_x = {
      {
        color = { fg = colors.yellow },
      },
    },
  },
})
