#!/usr/bin/bash
dotnet tool install --global roslyn-language-server --prerelease
dotnet tool install --global XamlToCSharpGenerator.LanguageServer.Tool --prerelease
npm i -g tree-sitter-cli
