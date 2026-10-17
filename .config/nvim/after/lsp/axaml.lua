vim.filetype.add({ extension = { axaml = "xml" } })

return {
	cmd = { "axsg-lsp" },
	filetypes = { "xml" },
	root_markers = { "*.csproj", "*.sln", ".git" },
}
