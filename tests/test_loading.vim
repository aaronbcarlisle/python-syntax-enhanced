" tests/test_loading.vim - syntax loading via Vim's normal FileType machinery
" Run: vim -Nu NONE -S tests/test_loading.vim
"
" Exits Vim with code 0 on success, 1 on failure.

let s:root = expand('<sfile>:p:h:h')
let s:ours = tolower(substitute(s:root . '/syntax/python.vim', '\\', '/', 'g'))

" Like a real vimrc: 'syntax on' before plugins load, so Vim's synload
" autocommands are registered (and fire) before this plugin's.
let &runtimepath = s:root . ',' . &runtimepath
syntax on

" Count loads with the profiler: SourcePre does not fire for files sourced
" from inside the FileType/Syntax autocommands (autocommands do not nest).
let s:prof = tempname()
execute 'profile start' fnameescape(s:prof)
profile file */syntax/python.vim

execute 'source' fnameescape(s:root . '/plugin/python-syntax-enhanced.vim')

let s:failures = []
let s:passed = 0

function! s:Check(cond, label) abort
  if a:cond
    let s:passed += 1
  else
    call add(s:failures, 'FAIL ' . a:label)
  endif
endfunction

" Total times this plugin's syntax/python.vim has been sourced
function! s:OursSourced() abort
  profile dump
  let l:lines = readfile(s:prof)
  for l:i in range(max([0, len(l:lines) - 1]))
    let l:m = matchlist(l:lines[l:i], '^SCRIPT\s\+\(.*\)$')
    if !empty(l:m) && tolower(substitute(l:m[1], '\\', '/', 'g')) ==# s:ours
      return str2nr(matchstr(l:lines[l:i + 1], '^Sourced \zs\d\+'))
    endif
  endfor
  return 0
endfunction

" pythonDefColon exists only in this plugin's syntax file
function! s:OursActive() abort
  return execute('silent! syntax list pythonDefColon') =~# 'pythonDefColon'
endfunction

" 1. Plugin ahead of $VIMRUNTIME: synload loads ours; FileType must not
"    source it a second time
enew
let s:before = s:OursSourced()
setlocal filetype=python
call s:Check(s:OursActive(), 'ours active (plugin first in rtp)')
let s:loads = s:OursSourced() - s:before
call s:Check(s:loads == 1, 'sourced once on FileType, got ' . s:loads)

" 2. $VIMRUNTIME ahead of plugin: Vim's file wins the runtime! race, so the
"    plugin must force-load ours -- every time, not only the first time
let &runtimepath = $VIMRUNTIME . ',' . &runtimepath
enew
setlocal filetype=python
call s:Check(s:OursActive(), 'ours force-loaded (vimruntime first)')
setlocal filetype=
setlocal filetype=python
call s:Check(s:OursActive(), 'ours force-loaded again after reload')

call delete(s:prof)

if empty(s:failures)
  echo printf('PASS: %d assertions', s:passed)
  cquit! 0
else
  for s:f in s:failures
    echom s:f
  endfor
  echo printf('FAILED: %d failed, %d passed', len(s:failures), s:passed)
  cquit! 1
endif
