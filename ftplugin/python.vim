" ftplugin/python.vim - Python filetype settings for enhanced syntax
"
" Folding is left to the user / other ftplugins. Syntax sync is controlled
" by g:python_slow_sync in syntax/python.vim.

if exists("b:did_ftplugin_python_enhanced")
  finish
endif
let b:did_ftplugin_python_enhanced = 1

" Allow undoing this ftplugin's buffer-local state
if exists("b:undo_ftplugin")
  let b:undo_ftplugin .= " | unlet! b:did_ftplugin_python_enhanced b:python_syntax_enhanced"
else
  let b:undo_ftplugin = "unlet! b:did_ftplugin_python_enhanced b:python_syntax_enhanced"
endif

" vim:set sw=2 sts=2 ts=8 noet:
