-- =============================================================================
-- 1. REGISTRO DE TIPOS DE ARCHIVO (Antes de cargar LSPs)
-- =============================================================================
vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
    axaml = "xml", -- Reconocer Avalonia como XML inicialmente
  },
})

-- =============================================================================
-- 2. Instalación de dependencias
-- =============================================================================
vim.pack.add({
  -- Core LSP
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/williamboman/mason-lspconfig.nvim" }, -- Puente Mason-LSPConfig

  -- C# Ecosystem
  { src = "https://github.com/seblyng/roslyn.nvim" },
  { src = "https://github.com/tris203/rzls.nvim" },

  -- Capabilities & Dev
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" }, -- Autocompletado para LSP
  { src = "https://github.com/folke/lazydev.nvim" },  -- Mejor experiencia programando Lua en Nvim

  -- UI para code actions
  { src = "https://github.com/stevearc/dressing.nvim" },
})

-- =============================================================================
-- MEJORA VISUAL (Opcional pero recomendada para Code Actions)
-- =============================================================================
-- Si vienes de LazyVim, necesitas esto para ver el menú flotante en <leader>ca
-- Asegúrate de tener 'stevearc/dressing.nvim' en tu carpeta pack.
pcall(require, "dressing")

-- Configuración estética de diagnósticos
vim.diagnostic.config({
  float = { border = "rounded", source = "always" },
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- =============================================================================
-- 3. KEYMAPS GLOBALES (La solución para Nvim 0.12)
-- =============================================================================
-- En lugar de pasar 'on_attach' a cada servidor, usamos este evento global.
-- Esto asegura que <leader>ca funcione en Roslyn, Avalonia y LuaLS por igual.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf
    local k = vim.keymap

    local function opts(desc)
      return { buffer = bufnr, silent = true, desc = desc }
    end

    -- Navegación
    k.set("n", "<leader>gd", vim.lsp.buf.definition, opts("Ir a definición"))
    k.set("n", "<leader>gD", vim.lsp.buf.declaration, opts("Ir a declaración"))
    k.set("n", "<leader>gr", vim.lsp.buf.references, opts("Ir a referencias"))
    k.set("n", "<leader>gi", vim.lsp.buf.implementation, opts("Ir a implementación"))
    k.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Renombrar símbolo"))

    -- ACCIONES DE CÓDIGO (Tu error principal estaba aquí)
    k.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Acciones de código"))

    -- Diagnóstico
    k.set("n", "[d", vim.diagnostic.goto_prev, opts("Diagnóstico anterior"))
    k.set("n", "]d", vim.diagnostic.goto_next, opts("Siguiente diagnóstico"))

    -- Limpieza específica para Roslyn (Semantic tokens)
    if client.name == "roslyn" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

-- =============================================================================
-- 4. CAPABILITIES (Autocompletado)
-- =============================================================================
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- =============================================================================
-- 5. MASON & LSP STANDARD
-- =============================================================================
require("mason").setup()
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = {
    "ts_ls",
    "html",
    "cssls",
    "tailwindcss",
    "lua_ls",
    "rust_analyzer",
    "emmet_ls",
    -- Nota: NO incluyas 'csharp_ls' o 'omnisharp' si usas Roslyn
  },
  handlers = {
    -- Handler por defecto
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities,
        -- NOTA: Ya no pasamos on_attach aquí, lo maneja el LspAttach arriba
      })
    end,

    -- Handler específico para Lua
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      })
    end,

    -- Handler para Emmet
    ["emmet_ls"] = function()
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "razor" },
      })
    end,
  },
})

-- =============================================================================
-- 6. CONFIGURACIÓN DE ROSLYN (C#)
-- =============================================================================
local has_roslyn, roslyn = pcall(require, "roslyn")
if has_roslyn then
  -- Calcular rutas dinámicamente para evitar errores de path
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  local rzls_path = mason_path .. "/rzls/libexec"

  roslyn.setup({
    args = {
      "--stdio",
      "--logLevel=Information",
      "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
      "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
      "--razorDesignTimePath="
      .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
      "--extension",
      vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
    },
    config = {
      capabilities = capabilities,
      handlers = require("rzls.roslyn_handlers"), -- Importante para Razor
      settings = {
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
        ["csharp|code_lens"] = {
          dotnet_enable_references_code_lens = true,
        },
      },
    },
  })
end

-- =============================================================================
-- 7. CONFIGURACIÓN DE AVALONIA
-- =============================================================================
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.axaml" },
  callback = function()
    if vim.fn.executable("avalonia-ls") == 1 then
      vim.lsp.start({
        name = "avalonia",
        cmd = { "avalonia-ls" },
        root_dir = vim.fn.getcwd(),
        -- No pasamos on_attach aquí tampoco, se hereda del LspAttach global
      })
    end
  end,
})
