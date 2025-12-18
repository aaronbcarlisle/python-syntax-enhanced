" after/syntax/python.vim - Type annotation highlighting additions
" This file loads AFTER any Python syntax file to add/enhance type support

" Clear pythonParameters if it exists - it incorrectly captures return types
silent! syn clear pythonParameters

" ==========================================================================
" Custom highlight colors for better visual distinction
" ==========================================================================

" Class names - cyan (swapped with types)
hi pythonClass          ctermfg=44  guifg=#00d7d7

" Typing module types - orange/yellow (swapped with class)
hi pythonTypingType     ctermfg=173 guifg=#de935f

" Primitive types - blue for basic types
hi pythonPrimitiveType  ctermfg=75  guifg=#5fafff

" Return arrow - magenta to stand out
hi pythonReturnArrow    ctermfg=170 guifg=#d75fd7

" Union operator - same as arrow for consistency
hi pythonTypeUnion      ctermfg=170 guifg=#d75fd7

" Self/cls - distinct identifier color
hi pythonSelfRef        ctermfg=209 guifg=#ff875f

" ==========================================================================
" Return type arrow: ->
" ==========================================================================
syn match   pythonReturnArrow     "->" display

" ==========================================================================
" Typing module types (abstract/generic types) - CYAN
" ==========================================================================
syn match pythonTypingType "\<\(Any\|AnyStr\|Callable\|ClassVar\|Concatenate\)\>"
syn match pythonTypingType "\<\(Final\|ForwardRef\|Generic\|Literal\|LiteralString\)\>"
syn match pythonTypingType "\<\(Never\|NewType\|NoReturn\|Optional\)\>"
syn match pythonTypingType "\<\(ParamSpec\|ParamSpecArgs\|ParamSpecKwargs\|Protocol\)\>"
syn match pythonTypingType "\<\(Required\|Self\|TypeAlias\|TypeGuard\|TypeVar\|TypeVarTuple\)\>"
syn match pythonTypingType "\<\(Union\|Unpack\)\>"
syn match pythonTypingType "\<\(Awaitable\|Coroutine\|AsyncIterable\|AsyncIterator\|AsyncGenerator\)\>"
syn match pythonTypingType "\<\(Iterable\|Iterator\|Generator\|Reversible\|Container\|Collection\)\>"
syn match pythonTypingType "\<\(Hashable\|Sized\|Mapping\|MutableMapping\)\>"
syn match pythonTypingType "\<\(Sequence\|MutableSequence\|AbstractSet\|MutableSet\)\>"
syn match pythonTypingType "\<\(MappingView\|KeysView\|ItemsView\|ValuesView\)\>"
syn match pythonTypingType "\<\(ContextManager\|AsyncContextManager\|Pattern\|Match\)\>"
syn match pythonTypingType "\<\(IO\|TextIO\|BinaryIO\|NamedTuple\|TypedDict\)\>"
syn match pythonTypingType "\<\(SupportsInt\|SupportsFloat\|SupportsComplex\|SupportsBytes\)\>"
syn match pythonTypingType "\<\(SupportsAbs\|SupportsRound\|SupportsIndex\)\>"

" Capitalized container types from typing (List, Dict, Tuple, etc.)
syn match pythonTypingType "\<\(List\|Dict\|Set\|FrozenSet\|Tuple\)\>"
syn match pythonTypingType "\<\(Deque\|DefaultDict\|OrderedDict\|Counter\|ChainMap\)\>"

" ==========================================================================
" Primitive/builtin types - BLUE (distinct from typing module types)
" ==========================================================================
syn match pythonPrimitiveType "\<\(str\|int\|float\|bool\|bytes\|bytearray\)\>"
syn match pythonPrimitiveType "\<\(list\|dict\|set\|frozenset\|tuple\)\>"
syn match pythonPrimitiveType "\<\(object\|type\|complex\)\>"
syn match pythonPrimitiveType "\<\(memoryview\|range\|slice\)\>"

" ==========================================================================
" Self and cls references - ORANGE
" ==========================================================================
syn keyword pythonSelfRef self cls mcs

" ==========================================================================
" Union type operator: X | Y (Python 3.10+)
" ==========================================================================
syn match   pythonTypeUnion       "\s|\s" display

" ==========================================================================
" Type comments
" ==========================================================================
syn match   pythonTypeComment     "#\s*type:\s*.*$"
hi def link pythonTypeComment     SpecialComment

" ==========================================================================
" Docstrings - GREEN
" ==========================================================================
" Match triple-quoted strings that appear after def/class or at start of file
hi pythonDocstring      ctermfg=71  guifg=#5faf5f

" Docstrings after function/class definitions
syn region pythonDocstring start=+\(def\s.*:\s*\n\s*\|class\s.*:\s*\n\s*\)\@<="""+ end=+"""+ keepend
syn region pythonDocstring start=+\(def\s.*:\s*\n\s*\|class\s.*:\s*\n\s*\)\@<='''+ end=+'''+ keepend

" Module-level docstrings (at the very start of file, possibly after comments/blank lines)
syn region pythonDocstring start=+\%^\(\s*\n\|\s*#.*\n\)*\s*\zs"""+ end=+"""+ keepend
syn region pythonDocstring start=+\%^\(\s*\n\|\s*#.*\n\)*\s*\zs'''+ end=+'''+ keepend

" vim:set sw=2 sts=2 ts=8 noet:
