vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
})

local configs = require("nvim-treesitter")

configs.setup({
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    "c_sharp",
    "razor",
    "json",
    "javascript",
    "typescript",
    "tsx",
    "toml",
    "yaml",
    "html",
    "xml",
    "css",
    "markdown",
    "markdown_inline",
    "bash",
    "lua",
    "vim",
    "dockerfile",
    "gitignore",
    "vimdoc",
    "c",
    "sql",
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})
