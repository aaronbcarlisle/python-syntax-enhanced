" tests/test_syntax.vim - synID assertions for python-syntax-enhanced
" Run: vim -Nu NONE -S tests/test_syntax.vim
"
" Exits Vim with code 0 on success, 1 on failure.

let s:root = expand('<sfile>:p:h:h')
let &runtimepath = s:root . ',' . &runtimepath

execute 'source' fnameescape(s:root . '/plugin/python-syntax-enhanced.vim')

let g:python_enhanced_highlight_all = 1
let g:python_enhanced_colors = 1
let g:python_slow_sync = 1

let s:failures = []
let s:passed = 0

function! s:AssertGroup(lnum, col, expected, label) abort
  let l:name = synIDattr(synID(a:lnum, a:col, 1), 'name')
  if l:name ==# ''
    let l:name = synIDattr(synID(a:lnum, a:col, 0), 'name')
  endif
  if l:name !=# a:expected
    call add(s:failures,
          \ printf('FAIL %s: expected %s at %d:%d, got %s',
          \   a:label, a:expected, a:lnum, a:col, l:name))
  else
    let s:passed += 1
  endif
endfunction

function! s:AssertNotGroup(lnum, col, unexpected, label) abort
  let l:name = synIDattr(synID(a:lnum, a:col, 1), 'name')
  if l:name ==# a:unexpected
    call add(s:failures,
          \ printf('FAIL %s: did not expect %s at %d:%d',
          \   a:label, a:unexpected, a:lnum, a:col))
  else
    let s:passed += 1
  endif
endfunction

function! s:ColOf(lnum, needle) abort
  let l:idx = stridx(getline(a:lnum), a:needle)
  if l:idx < 0
    throw 'needle not found: ' . a:needle . ' in line ' . a:lnum
  endif
  return l:idx + 1
endfunction

enew
call setline(1, [
      \ '"""Module docstring."""',
      \ '',
      \ 'name: str = "Alice"',
      \ 'items = list(range(10))',
      \ '',
      \ 'def greet(name: str) -> str:',
      \ '    """Doc after header."""',
      \ '    return name',
      \ '',
      \ 'def get_value() -> int | str | None:',
      \ '    return 42',
      \ '',
      \ 'def nested(data: dict[str, list[int]]) -> list[User]:',
      \ '    return []',
      \ '',
      \ 'def multiline(',
      \ '    x: int,',
      \ '    y: str,',
      \ ') -> Comparable:',
      \ '    """Wrapped signature docstring."""',
      \ '    return x',
      \ '',
      \ 'def generic[T](x: T) -> T:',
      \ '    return x',
      \ '',
      \ 'type Point = tuple[int, int]',
      \ 'type Vector[T] = list[T]',
      \ '',
      \ 'class Stack(Generic[T]):',
      \ '    """Class docstring after header colon."""',
      \ '    pass',
      \ '',
      \ 'c = 1 & 2 | 3 ^ 4',
      \ '',
      \ 'try:',
      \ '    pass',
      \ 'except* ExceptionGroup:',
      \ '    pass',
      \ '',
      \ 'print(type(name))',
      \ '',
      \ 'def with_default(foo: Callable[[int], str] = None) -> None:',
      \ '    pass',
      \ '',
      \ 'from typing import Annotated, TypeIs, ReadOnly, NotRequired',
      \ 'flag: Annotated[int, "meta"] = 1',
      \ '',
      \ 'plain: int  # note stays a comment',
      \ 'def commented(x: int  # param note',
      \ '    ) -> str:  # return note unused',
      \ '    return ""',
      \ '',
      \ 'def blank_then_doc():',
      \ '',
      \ '    """Docstring after blank line (skipempty+skipnl)."""',
      \ '    pass',
      \ '',
      \ 'class Holder:',
      \ '    def __init__(self) -> None:',
      \ '        self._items: list[T] = []',
      \ '        self.name: str',
      \ '        obj.nested.attr: int = 0',
      \ ])
setlocal filetype=python
syntax sync fromstart

" Module docstring
call s:AssertGroup(1, s:ColOf(1, 'Module'), 'pythonDocstring', 'module docstring')

" Statement annotation: str is primitive type
call s:AssertGroup(3, s:ColOf(3, 'str'), 'pythonPrimitiveType', 'name: str')

" list( outside annotation stays builtin
call s:AssertGroup(4, s:ColOf(4, 'list'), 'pythonBuiltin', 'list() call')

" Param + return annotation
call s:AssertGroup(6, s:ColOf(6, 'str)'), 'pythonPrimitiveType', 'param str')
let s:line6 = getline(6)
let s:ret_str = stridx(s:line6, 'str', stridx(s:line6, 'str') + 1) + 1
call s:AssertGroup(6, s:ret_str, 'pythonPrimitiveType', 'return str')
call s:AssertGroup(6, s:ColOf(6, '->'), 'pythonReturnArrow', 'return arrow')

" Function docstring via nextgroup
call s:AssertGroup(7, s:ColOf(7, 'Doc'), 'pythonDocstring', 'func docstring')

" Union | and None inside return type
call s:AssertGroup(10, s:ColOf(10, '|'), 'pythonTypeUnion', 'union pipe')
call s:AssertGroup(10, s:ColOf(10, 'None'), 'pythonTypeNone', 'return None type')

" Nested generics + custom CapWords return
call s:AssertGroup(13, s:ColOf(13, 'dict'), 'pythonPrimitiveType', 'dict[ in annot')
call s:AssertGroup(13, s:ColOf(13, 'User'), 'pythonTypeName', 'custom User return')

" Multiline header
call s:AssertGroup(19, s:ColOf(19, 'Comparable'), 'pythonTypeName', 'Comparable return')
call s:AssertGroup(20, s:ColOf(20, 'Wrapped'), 'pythonDocstring', 'wrapped docstring')

" PEP 695 type params
call s:AssertGroup(23, s:ColOf(23, 'T'), 'pythonTypeName', 'def f[T]')

" type statement
call s:AssertGroup(26, s:ColOf(26, 'type'), 'pythonStatement', 'type statement kw')
call s:AssertGroup(26, s:ColOf(26, 'tuple'), 'pythonPrimitiveType', 'type alias RHS')
call s:AssertGroup(27, s:ColOf(27, 'list'), 'pythonPrimitiveType', 'type Vector RHS')

" Class bases + class docstring on next line (skipnl)
call s:AssertGroup(29, s:ColOf(29, 'Generic'), 'pythonTypingType', 'class base Generic')
call s:AssertGroup(30, s:ColOf(30, 'Class'), 'pythonDocstring', 'class docstring skipnl')

" Bitwise | is NOT type union
call s:AssertNotGroup(33, s:ColOf(33, '|'), 'pythonTypeUnion', 'bitwise |')
call s:AssertGroup(33, s:ColOf(33, '|'), 'pythonOperatorSymbol', 'bitwise | op')

" except*
call s:AssertGroup(37, s:ColOf(37, 'except*'), 'pythonException', 'except*')

" type() call is builtin
call s:AssertGroup(40, s:ColOf(40, 'type'), 'pythonBuiltin', 'type() builtin')

" Annotated
call s:AssertGroup(46, s:ColOf(46, 'Annotated'), 'pythonTypingType', 'Annotated')

" Trailing comments in annotations must stay comments (not pythonTypeName)
call s:AssertGroup(48, s:ColOf(48, 'int'), 'pythonPrimitiveType', 'annot before comment')
call s:AssertGroup(48, s:ColOf(48, 'note'), 'pythonComment', 'stmt annot trailing comment')
call s:AssertNotGroup(48, s:ColOf(48, 'note'), 'pythonTypeName', 'comment word not type')
call s:AssertGroup(49, s:ColOf(49, 'param'), 'pythonComment', 'param annot trailing comment')

" Docstring after blank line following header colon (skipempty + skipnl)
call s:AssertGroup(55, s:ColOf(55, 'Docstring'), 'pythonDocstring', 'docstring after blank line')

" Dotted attribute statement annotations (self._items: list[T], etc.)
call s:AssertGroup(60, s:ColOf(60, 'list'), 'pythonPrimitiveType', 'self._items: list')
call s:AssertGroup(60, s:ColOf(60, 'T'), 'pythonTypeName', 'self._items: list[T]')
call s:AssertGroup(61, s:ColOf(61, 'str'), 'pythonPrimitiveType', 'self.name: str')
call s:AssertGroup(62, s:ColOf(62, 'int'), 'pythonPrimitiveType', 'obj.nested.attr: int')

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
