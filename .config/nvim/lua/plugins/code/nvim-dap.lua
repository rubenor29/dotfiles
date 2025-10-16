return {
	-- For auto dll picker
	-- {
	-- 	"ramboe/ramboe-dotnet-utils",
	-- 	dependencies = { "mfussenegger/nvim-dap" },
	-- },
	-- Stuffs for debuggin unit test
	{ "nvim-neotest/nvim-nio" },
	{
		"nvim-neotest/neotest",
		requires = {
			{
				"Issafalcon/neotest-dotnet",
			},
		},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-dotnet"),
				},
			})
		end,
	},
	{
		"Issafalcon/neotest-dotnet",
		lazy = false,
		dependencies = {
			"nvim-neotest/neotest",
		},
	},
	{
		-- Debug Framework
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			local dap = require("dap")

			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"

			local netcoredbg_adapter = {
				type = "executable",
				command = mason_path,
				args = { "--interpreter=vscode" },
			}

			dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
			dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						-- return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/src/", "file")
						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
						-- return require("dap-dll-autopicker").build_dll_path()
					end,

					-- justMyCode = false,
					-- stopAtEntry = false,
					-- -- program = function()
					-- --   -- todo: request input from ui
					-- --   return "/path/to/your.dll"
					-- -- end,
					env = {
					   ASPNETCORE_ENVIRONMENT = function()
					     -- todo: request input from ui
					     return "Development"
					   end,
					--   ASPNETCORE_URLS = function()
					--     -- todo: request input from ui
					--     return "http://localhost:5050"
					--   end,
					-- },
					-- cwd = function()
					--   -- todo: request input from ui
					--   return vim.fn.getcwd()
					-- end,
          }
				},
			}

			local map = vim.keymap.set

			local opts = { noremap = true, silent = true }

			map(
				"n",
				"<leader><F5>",
				"<Cmd>lua require'dap'.continue()<CR>",
				{ noremap = true, silent = true, desc = "dap continue" }
			)
			map(
				"n",
				"<leader><F6>",
				"<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
				{ noremap = true, silent = true, desc = "dap neotest" }
			)
			map(
				"n",
				"<leader><F9>",
				"<Cmd>lua require'dap'.toggle_breakpoint()<CR>",
				{ noremap = true, silent = true, desc = "dap toggle breakpoint" }
			)
			map(
				"n",
				"<leader><F10>",
				"<Cmd>lua require'dap'.step_over()<CR>",
				{ noremap = true, silent = true, desc = "dap step over" }
			)
			map(
				"n",
				"<leader><F11>",
				"<Cmd>lua require'dap'.step_into()<CR>",
				{ noremap = true, silent = true, desc = "dap step into" }
			)
			map(
				"n",
				"<leader><F8>",
				"<Cmd>lua require'dap'.step_out()<CR>",
				{ noremap = true, silent = true, desc = "dap step out" }
			)
			-- map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true, desc = "" })
			map(
				"n",
				"<leader>dr",
				"<Cmd>lua require'dap'.repl.open()<CR>",
				{ noremap = true, silent = true, desc = "dap open" }
			)
			map(
				"n",
				"<leader>dl",
				"<Cmd>lua require'dap'.run_last()<CR>",
				{ noremap = true, silent = true, desc = "dap run last" }
			)
			map(
				"n",
				"<leader>dt",
				"<Cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>",
				{ noremap = true, silent = true, desc = "debug nearest test" }
			)
		end,
		event = "VeryLazy",
	},
	{
		-- UI for debugging
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local dapui = require("dapui")
			local dap = require("dap")

			--- open ui immediately when debugging starts
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- default configuration
			dapui.setup()
		end,
	},
}
