vim.pack.add({
  { src = "https://github.com/ellisonleao/gruvbox.nvim" },
})

require("gruvbox").setup({
  contrast = "hard",
  terminal_colors = true,
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  transparent_mode = false,
})

-- vim.cmd("colorscheme gruvbox")
