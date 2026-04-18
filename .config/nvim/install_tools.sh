#!/usr/bin/bash
npm install -g typescript typescript-language-server vscode-langservers-extracted @tailwindcss/language-server svelte-language-server emmet-ls prettier pyright tree-sitter-cli &&
rustup component add rust-analyzer &&
cargo install stylua &&
curl -LsSf https://astral.sh/ruff/install.sh | sh &&
dotnet tool install --global roslyn-language-server --prerelease &&
dotnet tool install --global csharpier &&
sudo apt update && sudo apt install clangd -y
