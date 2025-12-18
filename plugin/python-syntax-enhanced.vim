" plugin/python-syntax-enhanced.vim - Plugin initialization
"
" Python Syntax Enhanced - IDE-level Python syntax highlighting for Vim
" Maintainer: Aaron Carlisle / ABC-Terminal
" Version: 1.0.0

if exists('g:loaded_python_syntax_enhanced')
  finish
endif
let g:loaded_python_syntax_enhanced = 1

" Preserve compatibility
let s:save_cpo = &cpo
set cpo&vim

" Commands for toggling features
command! PythonSyntaxEnableAll let g:python_enhanced_highlight_all = 1 | syntax off | syntax on
command! PythonSyntaxInfo call s:ShowInfo()

function! s:ShowInfo()
  echo "Python Syntax Enhanced v1.0.0"
  echo ""
  echo "Active features:"
  echo "  Type annotations: " . (get(g:, 'python_highlight_type_annotations', 1) ? 'ON' : 'OFF')
  echo "  Operators:        " . (get(g:, 'python_highlight_operators', 1) ? 'ON' : 'OFF')
  echo "  Function calls:   " . (get(g:, 'python_highlight_func_calls', 0) ? 'ON' : 'OFF')
  echo "  Class vars:       " . (get(g:, 'python_highlight_class_vars', 1) ? 'ON' : 'OFF')
  echo "  Builtins:         " . (get(g:, 'python_highlight_builtins', 1) ? 'ON' : 'OFF')
  echo "  Exceptions:       " . (get(g:, 'python_highlight_exceptions', 1) ? 'ON' : 'OFF')
  echo "  String format:    " . (get(g:, 'python_highlight_string_formatting', 1) ? 'ON' : 'OFF')
  echo "  Doctests:         " . (get(g:, 'python_highlight_doctests', 1) ? 'ON' : 'OFF')
  echo "  Space errors:     " . (get(g:, 'python_highlight_space_errors', 0) ? 'ON' : 'OFF')
  echo ""
  echo "Use :PythonSyntaxEnableAll to enable all features"
endfunction

" Restore compatibility
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set sw=2 sts=2 ts=8 noet:
