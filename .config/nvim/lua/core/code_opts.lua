vim.api.nvim_create_autocmd("FileType", {
	pattern = { "cs", "fsharp" },
	callback = function()
		vim.cmd("compiler dotnet")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "t" },
	callback = function()
		vim.cmd("compiler dotnet")
	end,
})
