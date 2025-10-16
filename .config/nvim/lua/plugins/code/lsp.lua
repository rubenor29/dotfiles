return {
	-- For C# and Razor support
	{
		"seblyng/roslyn.nvim",
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		ft = { "cs", "razor" },
		opts = {
			-- your configuration comes here; leave empty for default settings
		},

		-- ADD THIS:

		dependencies = {
			{
				-- By loading as a dependencies, we ensure that we are available to set
				-- the handlers for Roslyn.
				"tris203/rzls.nvim",
				config = true,
			},
		},
		lazy = false,
		config = function()
			-- Use one of the methods in the Integration section to compose the command.
			local mason_registry = require("mason-registry")

			local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
			local cmd = {
				"roslyn",
				"--stdio",
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
				"--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
				"--razorDesignTimePath="
					.. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
				"--extension",
				vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
			}

			vim.lsp.config("roslyn", {
				cmd = cmd,
				handlers = require("rzls.roslyn_handlers"),
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
			})
			vim.lsp.enable("roslyn")
		end,
		init = function()
			-- We add the Razor file types before the plugin loads.
			vim.filetype.add({
				extension = {
					razor = "razor",
					cshtml = "razor",
				},
			})
		end,
	},
	{
		-- General LSP
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp", -- Necesario para las capacidades mejoradas
			{
				"folke/lazydev.nvim",
				ft = "lua",
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local k = vim.keymap

			-- 1. Capacidades base de Neovim
			local base_capabilities = vim.lsp.protocol.make_client_capabilities()

			-- 2. Mejorar con capacidades de nvim-cmp
			local capabilities = cmp_nvim_lsp.default_capabilities(base_capabilities)

			-- 3. Personalización adicional (opcional)
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Configuración de signos de diagnóstico
			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰠠",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})

			k.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Ir a la definicion" })
			k.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Ir a las declaraciones" })
			k.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Ir a las referencias" })

			local on_attach = function(client)
				print("[LSP] Attached to", client.name)
			end

			mason_lspconfig.setup({
				ensure_installed = {
					"ts_ls",
					"html",
					"cssls",
					"tailwindcss",
					"lua_ls",
					"prismals",
					"rust_analyzer",
					"clangd",
					"intelephense",
					"phpactor",
					"kotlin_language_server",
					"emmet_ls",
				},
				automatic_installation = true,
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
							on_attach = on_attach,
						})
					end,

					["lua_ls"] = function()
						lspconfig.lua_ls.setup({
							capabilities = capabilities,
							on_attach = on_attach,
							settings = {
								Lua = {
									runtime = { version = "LuaJIT" },
									diagnostics = { globals = { "vim" } },
									workspace = {
										library = vim.api.nvim_get_runtime_file("", true),
										checkThirdParty = false,
									},
									telemetry = { enable = false },
								},
							},
						})
					end,

					["emmet_ls"] = function()
						-- configure emmet language server
						lspconfig["emmet_ls"].setup({
							capabilities = capabilities,
							filetypes = {
								"html",
								"typescriptreact",
								"javascriptreact",
								"css",
								"sass",
								"scss",
								"less",
								"svelte",
							},
						})
					end,
				},
			})
		end,
	},
}
