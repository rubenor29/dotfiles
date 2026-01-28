-- 1. Descarga de dependencias (Solo lo esencial)
vim.pack.add({
  -- Motor principal
  { src = "https://github.com/hrsh7th/nvim-cmp" },

  -- Fuentes (Sources)
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" }, -- LSP
  { src = "https://github.com/hrsh7th/cmp-buffer" },  -- Texto en el buffer actual
  { src = "https://github.com/hrsh7th/cmp-path" },    -- Rutas de archivos

  -- Snippets (Necesario para que cmp funcione bien)
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" }, -- Opcional, pero recomendado

  -- Iconos
  { src = "https://github.com/onsails/lspkind.nvim" },
})

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

-- Cargar snippets estilo VSCode (friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  -- Configuración de ventana (Bordes)
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  -- Motor de snippets
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- Fuentes habilitadas
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer",  keyword_length = 3 }, -- Solo sugerir texto tras 3 letras
    { name = "path" },
  }),

  -- Mappings
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  -- Íconos
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "...",
      menu = {
        buffer = "[Buf]",
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        path = "[Path]",
      },
    }),
  },
})
