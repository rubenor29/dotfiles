" Vite compiler for Neovim

if exists("current_compiler")
  finish
endif
let current_compiler = "vite"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" Error format for Vite/Vue/TypeScript errors
CompilerSet errorformat=%f(%l\\,%c):\ %m

" Build command
CompilerSet makeprg=bun\ run\ build
