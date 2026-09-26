" plugin/python-syntax-enhanced.vim - Plugin initialization
"
" Python Syntax Enhanced - Python syntax highlighting with type annotations
" Maintainer: Aaron Carlisle
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
" Optional color palette (off by default; survives :colorscheme)
" ---------------------------------------------------------------------------

function! PythonSyntaxEnhancedApplyColors() abort
  if !get(g:, 'python_enhanced_colors', 0)
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
  " Builtins (print, len, ...) - lavender, distinct from yellow function calls
  hi pythonBuiltin        ctermfg=139 guifg=#b294bb
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
" 'syntax' is not "python" under :syntax off / :syntax manual, or after
" Neovim's Tree-sitter highlighter cleared it: leave those buffers alone.
function! s:LoadSyntax(force) abort
  if !a:force && (&l:syntax !=# 'python' || s:OursLoaded())
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

" ON/OFF for g:python_highlight_{name}, as syntax/python.vim reads it
function! s:State(name, default) abort
  let l:all = a:name !=# 'space_errors' && (get(g:, 'python_enhanced_highlight_all', 0)
        \ || get(g:, 'python_highlight_all', 0))
  return l:all || get(g:, 'python_highlight_' . a:name, a:default) ? 'ON' : 'OFF'
endfunction

function! s:ShowInfo() abort
  echo "Python Syntax Enhanced v1.1.0"
  echo ""
  echo "Active features:"
  echo "  Type annotations: " . s:State('type_annotations', 1)
  echo "  Operators:        " . s:State('operators', 1)
  echo "  Function calls:   " . s:State('func_calls', 0)
  echo "  Class vars:       " . s:State('class_vars', 1)
  echo "  Builtins:         " . s:State('builtins', 1)
  echo "  Exceptions:       " . s:State('exceptions', 1)
  echo "  String format:    " . s:State('string_formatting', 1)
  echo "  Doctests:         " . s:State('doctests', 1)
  echo "  Space errors:     " . s:State('space_errors', 0)
  echo "  Enhanced colors:  " . (get(g:, 'python_enhanced_colors', 0) ? 'ON' : 'OFF')
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
