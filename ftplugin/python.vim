" ftplugin/python.vim - Python filetype settings for enhanced syntax
"
" This file sets up optimal settings for Python type annotation highlighting

if exists("b:did_ftplugin_python_enhanced")
  finish
endif
let b:did_ftplugin_python_enhanced = 1

" Ensure syntax syncs from the start for accurate highlighting in large files
" This prevents highlighting from breaking mid-file
if !exists("g:python_no_sync_fix")
  syntax sync fromstart
endif

" Optional: Set up folding for type-annotated functions
if !exists("g:python_no_type_folding")
  setlocal foldmethod=indent
  setlocal foldnestmax=3
  setlocal nofoldenable
endif

" vim:set sw=2 sts=2 ts=8 noet:
