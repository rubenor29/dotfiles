-- =============================================================================
-- 1. REGISTRO DE TIPOS DE ARCHIVO
-- =============================================================================
-- Es importante hacer esto antes de cargar los LSPs para que detecten bien los buffers
vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
    axaml = "xml",
  },
})

-- =============================================================================
-- 2. DESCARGA DE PLUGINS (LSP y Complementos)
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
})

-- Configurar lazydev para que el LSP de Lua entienda la API de Neovim
require("lazydev").setup()

-- =============================================================================
-- 3. FUNCIONES AUXILIARES (on_attach y capabilities)
-- =============================================================================
local k = vim.keymap

-- Función que se ejecuta cuando un LSP se conecta a un buffer
local on_attach = function(client, bufnr)
  -- Helper para crear opciones de mapeo limpias
  local function opts(desc)
    return { buffer = bufnr, silent = true, desc = desc }
  end

  -- Navegación
  k.set("n", "<leader>gd", vim.lsp.buf.definition, opts("Ir a definición"))
  k.set("n", "<leader>gD", vim.lsp.buf.declaration, opts("Ir a declaración"))
  k.set("n", "<leader>gr", vim.lsp.buf.references, opts("Ir a referencias"))
  k.set("n", "<leader>gi", vim.lsp.buf.implementation, opts("Ir a implementación"))

  -- Acciones
  k.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Acciones de código"))
  k.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Renombrar símbolo"))

  -- Diagnóstico
  k.set("n", "[d", vim.diagnostic.goto_prev, opts("Diagnóstico anterior"))
  k.set("n", "]d", vim.diagnostic.goto_next, opts("Siguiente diagnóstico"))
end

-- Capabilities mejoradas para nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- =============================================================================
-- 4. CONFIGURACIÓN DE MASON-LSPCONFIG
-- =============================================================================
-- Nota: 'ensure_installed' aquí solo maneja servidores.
-- Los formatters (prettier) y debuggers (netcoredbg) van en 'mason.lua'.
local lspconfig = require("lspconfig")

require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls",
    "html",
    "cssls",
    "tailwindcss",
    "lua_ls",
    "rust_analyzer",
    "clangd",
    "emmet_ls",
  },
  automatic_installation = true,

  -- Handlers automáticos para setup de servidores
  handlers = {
    -- 1. Handler por defecto
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,

    -- 2. Handler específicos
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } }, -- (Redundante con lazydev, pero seguro)
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
    end,
  },
})

-- =============================================================================
-- 5. CONFIGURACIÓN DE C# (Roslyn & Razor)
-- =============================================================================
-- Ruta segura a los paquetes de Mason
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
local rzls_path = mason_path .. "/rzls/libexec"

-- Verificamos que roslyn.nvim esté cargado
local has_roslyn, roslyn = pcall(require, "roslyn")

if has_roslyn then
  roslyn.setup({
    -- Argumentos para apuntar a las DLLs de Razor instaladas por Mason
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
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Desactivar coloreado de LSP y dejar solo el de treesitter
        client.server_capabilities.semanticTokensProvider = nil
      end,
      capabilities = capabilities,
      handlers = require("rzls.roslyn_handlers"), -- Handlers especiales para Razor
      settings = {
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
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
-- 6. CONFIGURACIÓN DE AVALONIA (UI Framework)
-- =============================================================================
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.axaml" },
  callback = function()
    -- Solo intentar iniciar si el comando existe
    if vim.fn.executable("avalonia-ls") == 1 then
      vim.lsp.start({
        name = "avalonia",
        cmd = { "avalonia-ls" },
        root_dir = vim.fn.getcwd(),
      })
    end
  end,
})

-- =============================================================================
-- 7. CONFIGURACIÓN DE DIAGNÓSTICO (Estética)
-- =============================================================================
vim.diagnostic.config({
  virtual_text = true, -- Mostrar texto de error al lado de la línea
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰠠 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})
