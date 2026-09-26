" plugin/python-syntax-enhanced.vim - Plugin initialization
"
" Python Syntax Enhanced - IDE-level Python syntax highlighting for Vim
" Maintainer: Aaron Carlisle / ABC-Terminal
" Version: 1.1.0

if exists('g:loaded_python_syntax_enhanced')
  finish
endif
let g:loaded_python_syntax_enhanced = 1

let s:save_cpo = &cpo
set cpo&vim

" Absolute plugin root (parent of plugin/)
let s:plugin_root = expand('<sfile>:p:h:h')

" ---------------------------------------------------------------------------
" Color palette (survives :colorscheme; optional opt-out)
" ---------------------------------------------------------------------------

function! PythonSyntaxEnhancedApplyColors() abort
  if !get(g:, 'python_enhanced_colors', 1)
    return
  endif

  " Class names - cyan
  hi pythonClass          ctermfg=44  guifg=#00d7d7
  " Typing module types - orange
  hi pythonTypingType     ctermfg=173 guifg=#de935f
  " Primitive types - blue
  hi pythonPrimitiveType  ctermfg=75  guifg=#5fafff
  " Return arrow - magenta
  hi pythonReturnArrow    ctermfg=170 guifg=#d75fd7
  " Union operator - same as arrow
  hi pythonTypeUnion      ctermfg=170 guifg=#d75fd7
  " self / cls - orange
  hi pythonSelfRef        ctermfg=209 guifg=#ff875f
  " Docstrings - green
  hi pythonDocstring      ctermfg=71  guifg=#5faf5f
endfunction

" ---------------------------------------------------------------------------
" Force-load our syntax file for Python buffers
" ---------------------------------------------------------------------------

" True when the buffer's current syntax came from our syntax/python.vim.
" Probes a group only we define rather than a buffer flag, which would go
" stale when Vim's own python syntax is loaded again later.
function! s:OursLoaded() abort
  return get(b:, 'current_syntax', '') ==# 'python'
        \ && execute('silent! syntax list pythonDefColon') =~# 'pythonDefColon'
endfunction

" Normally Vim's FileType/Syntax machinery has already sourced our file by
" the time this runs; only take over when another python syntax won.
function! s:LoadSyntax(force) abort
  if !a:force && s:OursLoaded()
    return
  endif

  syntax clear
  unlet! b:current_syntax

  " The syntax file applies the palette itself
  execute 'source' fnameescape(s:plugin_root . '/syntax/python.vim')
endfunction

function! s:EnableAll() abort
  let g:python_enhanced_highlight_all = 1
  if &filetype ==# 'python'
    call s:LoadSyntax(1)
  endif
endfunction

function! s:ShowInfo() abort
  echo "Python Syntax Enhanced v1.1.0"
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
  echo "  Enhanced colors:  " . (get(g:, 'python_enhanced_colors', 1) ? 'ON' : 'OFF')
  echo ""
  echo "Use :PythonSyntaxEnableAll to enable all features"
endfunction

command! PythonSyntaxEnableAll call s:EnableAll()
command! PythonSyntaxInfo call s:ShowInfo()

augroup python_syntax_enhanced
  autocmd!
  autocmd FileType python call s:LoadSyntax(0)
  autocmd ColorScheme * call PythonSyntaxEnhancedApplyColors()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set sw=2 sts=2 ts=8 noet:
