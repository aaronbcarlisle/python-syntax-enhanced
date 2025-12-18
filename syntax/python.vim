" Vim syntax file
" Language:     Python (Enhanced with Type Annotations)
" Maintainer:   Aaron Carlisle / ABC-Terminal
" Last Change:  2025 Dec 18
" Version:      1.0.0
"
" Description:
"   Enhanced Python syntax highlighting with comprehensive type annotation
"   support. Designed to compete with IDE-level highlighting.
"
" Features:
"   - Full type annotation support (PEP 484, 526, 544, 585, 604, 612, 673, 695)
"   - Return type arrows (->)
"   - Generic types (List[T], Dict[K, V])
"   - Union types (X | Y)
"   - typing module builtins
"   - TypeVar, ParamSpec, TypeVarTuple
"   - Protocol and Generic classes
"   - Type comments (# type: ...)
"   - Modern Python 3.10+ match/case
"   - Python 3.12+ type parameter syntax
"   - Enhanced f-string support
"   - Operator highlighting
"   - Function call detection
"
" Configuration Options:
"   let g:python_enhanced_highlight_all = 1       " Enable all features
"   let g:python_highlight_type_annotations = 1   " Type annotations (default: 1)
"   let g:python_highlight_operators = 1          " Operators (default: 1)
"   let g:python_highlight_func_calls = 1         " Function calls (default: 0)
"   let g:python_highlight_class_vars = 1         " self, cls (default: 1)
"   let g:python_highlight_builtins = 1           " Builtins (default: 1)
"   let g:python_highlight_exceptions = 1         " Exceptions (default: 1)
"   let g:python_highlight_string_formatting = 1  " String formatting (default: 1)
"   let g:python_highlight_doctests = 1           " Doctests (default: 1)
"   let g:python_highlight_space_errors = 0       " Space errors (default: 0)
"   let g:python_slow_sync = 1                    " Better sync for large files

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" We need nocompatible mode in order to continue lines with backslashes
let s:cpo_save = &cpo
set cpo&vim

" ============================================================================
" Configuration
" ============================================================================

" Enable all highlighting
if get(g:, 'python_enhanced_highlight_all', 0) || get(g:, 'python_highlight_all', 0)
  let g:python_highlight_type_annotations = 1
  let g:python_highlight_operators = 1
  let g:python_highlight_func_calls = 1
  let g:python_highlight_class_vars = 1
  let g:python_highlight_builtins = 1
  let g:python_highlight_exceptions = 1
  let g:python_highlight_string_formatting = 1
  let g:python_highlight_doctests = 1
endif

" Set defaults for unset options
let s:type_annotations = get(g:, 'python_highlight_type_annotations', 1)
let s:operators = get(g:, 'python_highlight_operators', 1)
let s:func_calls = get(g:, 'python_highlight_func_calls', 0)
let s:class_vars = get(g:, 'python_highlight_class_vars', 1)
let s:builtins = get(g:, 'python_highlight_builtins', 1)
let s:exceptions = get(g:, 'python_highlight_exceptions', 1)
let s:string_fmt = get(g:, 'python_highlight_string_formatting', 1)
let s:doctests = get(g:, 'python_highlight_doctests', 1)
let s:space_errors = get(g:, 'python_highlight_space_errors', 0)
let s:slow_sync = get(g:, 'python_slow_sync', 0)

" ============================================================================
" Keywords and Statements
" ============================================================================

" Python keywords (alphabetical within groups)
syn keyword pythonStatement     False None True
syn keyword pythonStatement     as assert break continue del global
syn keyword pythonStatement     lambda nonlocal pass return with yield
syn keyword pythonStatement     class nextgroup=pythonClass skipwhite
syn keyword pythonStatement     def nextgroup=pythonFunction skipwhite
syn keyword pythonConditional   elif else if
syn keyword pythonRepeat        for while
syn keyword pythonOperator      and in is not or
syn keyword pythonException     except finally raise try
syn keyword pythonInclude       from import
syn keyword pythonAsync         async await

" Soft keywords (Python 3.10+ match/case, Python 3.12+ type)
syn match   pythonConditional   "^\s*\zscase\%(\s\+.*:.*$\)\@="
syn match   pythonConditional   "^\s*\zsmatch\%(\s\+.*:\s*\%(#.*\)\=$\)\@="
syn match   pythonStatement     "\<type\ze\s\+\h\w*" nextgroup=pythonTypeAlias skipwhite

" Class, function, and type alias names (contained - highlighted when following keywords)
syn match   pythonClass         "\h\w*" display contained
syn match   pythonFunction      "\h\w*" display contained
syn match   pythonTypeAlias     "\h\w*" display contained

" ============================================================================
" Type Annotations - The Main Feature
" ============================================================================

if s:type_annotations
  " ==========================================================================
  " TYPING MODULE TYPES - These highlight GLOBALLY (like IDEs)
  " ==========================================================================

  " Typing module special types - NOT contained, match everywhere
  syn keyword pythonTypingType
        \ Any AnyStr
        \ Callable ClassVar Concatenate
        \ Final ForwardRef
        \ Generic
        \ Literal LiteralString
        \ Never NewType NoReturn
        \ Optional
        \ ParamSpec ParamSpecArgs ParamSpecKwargs Protocol
        \ Required
        \ Self
        \ Tuple Type TypeAlias TypeGuard TypeVar TypeVarTuple
        \ Union Unpack
        \ Awaitable Coroutine AsyncIterable AsyncIterator AsyncGenerator
        \ Iterable Iterator Generator
        \ Reversible Container Collection
        \ Hashable Sized
        \ Mapping MutableMapping
        \ Sequence MutableSequence
        \ AbstractSet MutableSet
        \ MappingView KeysView ItemsView ValuesView
        \ ContextManager AsyncContextManager
        \ Pattern Match
        \ IO TextIO BinaryIO
        \ NamedTuple TypedDict
        \ SupportsInt SupportsFloat SupportsComplex SupportsBytes
        \ SupportsAbs SupportsRound SupportsIndex

  " Container types from typing (List, Dict, etc.) - highlight globally
  syn keyword pythonTypingContainer
        \ List Dict Set FrozenSet Tuple
        \ Deque DefaultDict OrderedDict Counter ChainMap

  " ==========================================================================
  " RETURN TYPE ARROW
  " ==========================================================================

  " The -> arrow for return types - highlight as Operator
  syn match   pythonReturnArrow     "->" display

  " ==========================================================================
  " UNION TYPE OPERATOR
  " ==========================================================================

  " Union type: X | Y (Python 3.10+) - needs to not conflict with bitwise or
  " Only match | when surrounded by type-like context
  syn match   pythonTypeUnion       "\s|\s" display

  " ==========================================================================
  " TYPE COMMENTS
  " ==========================================================================

  " Type comments: # type: ... (PEP 484)
  syn match   pythonTypeComment     "#\s*type:\s*.*$"

endif

" ============================================================================
" Class Variables (self, cls, mcs)
" ============================================================================

if s:class_vars
  syn keyword pythonClassVar    self cls mcs
endif

" ============================================================================
" Operators
" ============================================================================

if s:operators
  " Arithmetic operators
  syn match   pythonOperatorSymbol  "\%(+\|-\|\*\|@\|/\|%\|\*\*\|//\)" display

  " Comparison operators
  syn match   pythonOperatorSymbol  "\%(==\|!=\|<>\|<=\|>=\|<\|>\)" display

  " Bitwise operators
  syn match   pythonOperatorSymbol  "\%(\~\|&\||\|\^\|<<\|>>\)" display

  " Assignment operators
  syn match   pythonOperatorSymbol  "\%(=\|+=\|-=\|\*=\|/=\|//=\|%=\|\*\*=\)" display
  syn match   pythonOperatorSymbol  "\%(&=\||=\|\^=\|>>=\|<<=\|@=\)" display

  " Walrus operator (Python 3.8+)
  syn match   pythonOperatorSymbol  ":=" display

  " Don't highlight -> as operator (it's a return type arrow)
  " Don't highlight : as operator in most contexts (it's structural)
endif

" ============================================================================
" Function Calls
" ============================================================================

if s:func_calls
  " Function call: name(
  syn match   pythonFunctionCall    "\h\w*\ze\s*(" display
        \ contains=pythonBuiltin,pythonTypingType
endif

" ============================================================================
" Decorators
" ============================================================================

" A dot must be allowed because of @MyClass.myfunc decorators
syn match   pythonDecorator         "@" display contained
syn match   pythonDecoratorName     "@\s*\h\%(\w\|\.\)*" display contains=pythonDecorator

" Matrix multiplication: handle @ used as operator (PEP 465)
syn match   pythonMatrixMultiply
      \ "\%(\w\|[])]\)\s*@"
      \ contains=ALLBUT,pythonDecoratorName,pythonDecorator,pythonClass,pythonFunction,pythonTypeAlias,pythonDoctestValue
      \ transparent

" ============================================================================
" Comments
" ============================================================================

syn match   pythonComment           "#.*$" contains=pythonTodo,pythonTypeComment,@Spell
syn keyword pythonTodo              FIXME NOTE NOTES TODO XXX HACK BUG OPTIMIZE REVIEW contained

" ============================================================================
" Strings
" ============================================================================

" Regular strings
syn region  pythonString matchgroup=pythonQuotes
      \ start=+[uU]\=\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=pythonEscape,pythonUnicodeEscape,@Spell

" Triple-quoted strings (can contain doctests)
syn region  pythonString matchgroup=pythonTripleQuotes
      \ start=+[uU]\=\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonEscape,pythonUnicodeEscape,pythonSpaceError,pythonDoctest,@Spell

" Raw strings
syn region  pythonRawString matchgroup=pythonQuotes
      \ start=+[rR]\z(['"]\)+ end="\z1" skip="\\\\\|\\\z1"
      \ contains=@Spell
syn region  pythonRawString matchgroup=pythonTripleQuotes
      \ start=+[rR]\z('''\|"""\)+ end="\z1" keepend
      \ contains=pythonSpaceError,pythonDoctest,@Spell

" F-strings (formatted string literals)
syn region  pythonFString matchgroup=pythonQuotes
      \ start=+\c[fF]\z(['"]\)+
      \ end="\z1"
      \ skip="\\\\\|\\\z1"
      \ contains=pythonFStringField,pythonFStringSkip,pythonEscape,pythonUnicodeEscape,@Spell

syn region  pythonFString matchgroup=pythonTripleQuotes
      \ start=+\c[fF]\z('''\|"""\)+
      \ end="\z1"
      \ keepend
      \ contains=pythonFStringField,pythonFStringSkip,pythonEscape,pythonUnicodeEscape,pythonSpaceError,pythonDoctest,@Spell

" Raw f-strings
syn region  pythonRawFString matchgroup=pythonQuotes
      \ start=+\c\%(FR\|RF\)\z(['"]\)+
      \ end="\z1"
      \ skip="\\\\\|\\\z1"
      \ contains=pythonFStringField,pythonFStringSkip,@Spell

syn region  pythonRawFString matchgroup=pythonTripleQuotes
      \ start=+\c\%(FR\|RF\)\z('''\|"""\)+
      \ end="\z1"
      \ keepend
      \ contains=pythonFStringField,pythonFStringSkip,pythonSpaceError,pythonDoctest,@Spell

" Byte strings
syn region  pythonBytes matchgroup=pythonQuotes
      \ start=+\c[bB]\z(['"]\)+
      \ end="\z1"
      \ skip="\\\\\|\\\z1"
      \ contains=pythonBytesEscape

syn region  pythonBytes matchgroup=pythonTripleQuotes
      \ start=+\c[bB]\z('''\|"""\)+
      \ end="\z1"
      \ keepend
      \ contains=pythonBytesEscape

" Raw byte strings
syn region  pythonRawBytes matchgroup=pythonQuotes
      \ start=+\c\%(BR\|RB\)\z(['"]\)+
      \ end="\z1"
      \ skip="\\\\\|\\\z1"

syn region  pythonRawBytes matchgroup=pythonTripleQuotes
      \ start=+\c\%(BR\|RB\)\z('''\|"""\)+
      \ end="\z1"
      \ keepend

" F-string replacement fields with enhanced support
syn region  pythonFStringField
      \ matchgroup=pythonFStringDelimiter
      \ start=/{/
      \ end=/\%(=\s*\)\=\%(!\a\s*\)\=\%(:\%({\_[^}]*}\|[^{}]*\)\+\)\=}/
      \ contained
      \ contains=ALLBUT,pythonFStringField,pythonClass,pythonFunction,pythonTypeAlias,pythonDoctest,pythonDoctestValue,@Spell

" Skip matched parentheses, brackets, braces inside f-string fields
syn match   pythonFStringFieldSkip  /(\_[^()]*)\|\[\_[^][]*]\|{\_[^{}]*}/
      \ contained
      \ contains=ALLBUT,pythonFStringField,pythonClass,pythonFunction,pythonTypeAlias,pythonDoctest,pythonDoctestValue,@Spell

" Doubled braces are not replacement fields
syn match   pythonFStringSkip       /{{/ transparent contained contains=NONE
syn match   pythonFStringSkip       /}}/ transparent contained contains=NONE

" F-string debug specifier (Python 3.8+): f"{expr=}"
syn match   pythonFStringDebug      /\h\w*=\ze[}:!]/ contained containedin=pythonFStringField

" ============================================================================
" String Escapes
" ============================================================================

syn match   pythonEscape            +\\[abfnrtv'"\\]+ contained
syn match   pythonEscape            "\\\o\{1,3}" contained
syn match   pythonEscape            "\\x\x\{2}" contained
syn match   pythonUnicodeEscape     "\%(\\u\x\{4}\|\\U\x\{8}\)" contained
syn match   pythonUnicodeEscape     "\\N{\a\+\%(\%(\s\a\+[[:alnum:]]*\)\|\%(-[[:alnum:]]\+\)\)*}" contained
syn match   pythonEscape            "\\$"

" Byte string escapes (no unicode)
syn match   pythonBytesEscape       +\\[abfnrtv'"\\]+ contained
syn match   pythonBytesEscape       "\\\o\{1,3}" contained
syn match   pythonBytesEscape       "\\x\x\{2}" contained

" ============================================================================
" String Formatting
" ============================================================================

if s:string_fmt
  " %-formatting: %s, %d, %f, %(name)s, etc.
  syn match   pythonStrFormatting   "%\%(([^)]\+)\)\=[#0\-+ ]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrsab%]" contained containedin=pythonString,pythonRawString

  " .format() style: {}, {0}, {name}, {0:format}, {name!r:format}
  syn match   pythonStrFormat       "{\%(\%(\d\+\|[[:alpha:]_][[:alnum:]_]*\)\%(\.[[:alpha:]_][[:alnum:]_]*\|\[\%(\d\+\|[^]]*\)\]\)*\)\=\%(![rsa]\)\=\%(:\%([^{}]\|{[^}]*}\)*\)\=}" contained containedin=pythonString,pythonRawString

  " Template strings: $name, ${name}
  syn match   pythonStrTemplate     "\$\$\|\$\h\w*\|\${\h\w*}" contained containedin=pythonString,pythonRawString
endif

" ============================================================================
" Numbers
" ============================================================================

" Numbers (including underscore separators for Python 3.6+)
syn match   pythonNumber    "\<0[oO]\%(_\=\o\)\+\>"
syn match   pythonNumber    "\<0[xX]\%(_\=\x\)\+\>"
syn match   pythonNumber    "\<0[bB]\%(_\=[01]\)\+\>"
syn match   pythonNumber    "\<\%([1-9]\%(_\=\d\)*\|0\+\%(_\=0\)*\)\>"
syn match   pythonNumber    "\<\d\%(_\=\d\)*[jJ]\>"
syn match   pythonNumber    "\<\d\%(_\=\d\)*[eE][+-]\=\d\%(_\=\d\)*[jJ]\=\>"
syn match   pythonNumber
      \ "\<\d\%(_\=\d\)*\.\%([eE][+-]\=\d\%(_\=\d\)*\)\=[jJ]\=\%(\W\|$\)\@="
syn match   pythonNumber
      \ "\%(^\|\W\)\@1<=\%(\d\%(_\=\d\)*\)\=\.\d\%(_\=\d\)*\%([eE][+-]\=\d\%(_\=\d\)*\)\=[jJ]\=\>"

" None literal (also a type)
syn keyword pythonNone      None

" ============================================================================
" Builtins
" ============================================================================

if s:builtins
  " Built-in constants
  syn keyword pythonBuiltin     False True None
  syn keyword pythonBuiltin     NotImplemented Ellipsis __debug__
  syn keyword pythonBuiltin     quit exit copyright credits license

  " Built-in functions
  syn keyword pythonBuiltin     abs all any ascii bin bool breakpoint bytearray
  syn keyword pythonBuiltin     bytes callable chr classmethod compile complex
  syn keyword pythonBuiltin     delattr dict dir divmod enumerate eval exec
  syn keyword pythonBuiltin     filter float format frozenset getattr globals
  syn keyword pythonBuiltin     hasattr hash help hex id input int isinstance
  syn keyword pythonBuiltin     issubclass iter len list locals map max
  syn keyword pythonBuiltin     memoryview min next object oct open ord pow
  syn keyword pythonBuiltin     print property range repr reversed round set
  syn keyword pythonBuiltin     setattr slice sorted staticmethod str sum super
  syn keyword pythonBuiltin     tuple type vars zip __import__

  " Ellipsis literal
  syn match   pythonEllipsis    "\.\@1<!\.\.\.\ze\.\@!" display

  " Avoid highlighting attributes as builtins
  syn match   pythonAttribute   /\.\h\w*/hs=s+1
        \ contains=ALLBUT,pythonBuiltin,pythonClass,pythonFunction,pythonTypeAlias,pythonAsync,pythonTypingType,pythonTypingContainer,pythonTypePrimitive
        \ transparent
endif

" ============================================================================
" Exceptions
" ============================================================================

if s:exceptions
  " Base exceptions
  syn keyword pythonExceptions  BaseException Exception
  syn keyword pythonExceptions  ArithmeticError BufferError LookupError

  " Built-in exceptions
  syn keyword pythonExceptions  AssertionError AttributeError EOFError
  syn keyword pythonExceptions  FloatingPointError GeneratorExit ImportError
  syn keyword pythonExceptions  IndentationError IndexError KeyError
  syn keyword pythonExceptions  KeyboardInterrupt MemoryError
  syn keyword pythonExceptions  ModuleNotFoundError NameError
  syn keyword pythonExceptions  NotImplementedError OSError OverflowError
  syn keyword pythonExceptions  RecursionError ReferenceError RuntimeError
  syn keyword pythonExceptions  StopAsyncIteration StopIteration SyntaxError
  syn keyword pythonExceptions  SystemError SystemExit TabError TypeError
  syn keyword pythonExceptions  UnboundLocalError UnicodeDecodeError
  syn keyword pythonExceptions  UnicodeEncodeError UnicodeError
  syn keyword pythonExceptions  UnicodeTranslateError ValueError
  syn keyword pythonExceptions  ZeroDivisionError

  " OS exception aliases
  syn keyword pythonExceptions  EnvironmentError IOError WindowsError

  " OS exceptions (Python 3.3+)
  syn keyword pythonExceptions  BlockingIOError BrokenPipeError
  syn keyword pythonExceptions  ChildProcessError ConnectionAbortedError
  syn keyword pythonExceptions  ConnectionError ConnectionRefusedError
  syn keyword pythonExceptions  ConnectionResetError FileExistsError
  syn keyword pythonExceptions  FileNotFoundError InterruptedError
  syn keyword pythonExceptions  IsADirectoryError NotADirectoryError
  syn keyword pythonExceptions  PermissionError ProcessLookupError TimeoutError

  " Exception groups (Python 3.11+)
  syn keyword pythonExceptions  ExceptionGroup BaseExceptionGroup

  " Warnings
  syn keyword pythonExceptions  BytesWarning DeprecationWarning EncodingWarning
  syn keyword pythonExceptions  FutureWarning ImportWarning
  syn keyword pythonExceptions  PendingDeprecationWarning ResourceWarning
  syn keyword pythonExceptions  RuntimeWarning SyntaxWarning UnicodeWarning
  syn keyword pythonExceptions  UserWarning Warning
endif

" ============================================================================
" Space Errors
" ============================================================================

if s:space_errors
  " Trailing whitespace
  syn match   pythonSpaceError  display excludenl "\s\+$"
  " Mixed tabs and spaces
  syn match   pythonSpaceError  display " \+\t"
  syn match   pythonSpaceError  display "\t\+ "
endif

" ============================================================================
" Doctests
" ============================================================================

if s:doctests
  syn region  pythonDoctest
        \ start="^\s*>>>\s" end="^\s*$"
        \ contained contains=ALLBUT,pythonDoctest,pythonEllipsis,pythonClass,pythonFunction,pythonTypeAlias,@Spell

  syn region  pythonDoctestValue
        \ start=+^\s*\%(>>>\s\|\.\.\.\s\|"""\|'''\)\@!\S\++ end="$"
        \ contained contains=pythonEllipsis

  syn match   pythonDoctestEllipsis "\%(^\s*\)\@<!\.\@1<!\zs\.\.\.\ze\.\@!" display
        \ contained containedin=pythonDoctest
endif

" ============================================================================
" Shebang and Encoding
" ============================================================================

syn match   pythonShebang       "\%^#!.*$"
syn match   pythonEncoding      "^#.*\%(coding[:=]\s*\)\@<=\S\+" display

" ============================================================================
" Synchronization
" ============================================================================

if s:slow_sync
  syn sync minlines=2000
else
  " Fast sync at function/class definitions
  syn sync match pythonSync grouphere NONE "^\%(def\|class\|async\s\+def\)\s\+\h\w*\s*[(:\[]"
endif

" ============================================================================
" Highlight Links
" ============================================================================

" Core syntax
hi def link pythonStatement         Statement
hi def link pythonConditional       Conditional
hi def link pythonRepeat            Repeat
hi def link pythonOperator          Operator
hi def link pythonException         Exception
hi def link pythonInclude           Include
hi def link pythonAsync             Statement
hi def link pythonDecorator         Define
hi def link pythonDecoratorName     Function
hi def link pythonClass             Structure
hi def link pythonFunction          Function
hi def link pythonTypeAlias         Type
hi def link pythonComment           Comment
hi def link pythonTodo              Todo
hi def link pythonShebang           Comment
hi def link pythonEncoding          Comment

" Strings
hi def link pythonString            String
hi def link pythonRawString         String
hi def link pythonFString           String
hi def link pythonRawFString        String
hi def link pythonBytes             String
hi def link pythonRawBytes          String
hi def link pythonQuotes            String
hi def link pythonTripleQuotes      pythonQuotes
hi def link pythonEscape            Special
hi def link pythonUnicodeEscape     pythonEscape
hi def link pythonBytesEscape       Special
hi def link pythonFStringDelimiter  Special
hi def link pythonFStringDebug      Special

" String formatting
if s:string_fmt
  hi def link pythonStrFormatting   Special
  hi def link pythonStrFormat       Special
  hi def link pythonStrTemplate     Special
endif

" Numbers
hi def link pythonNumber            Number
hi def link pythonNone              Constant

" Builtins
if s:builtins
  hi def link pythonBuiltin         Function
  hi def link pythonEllipsis        pythonBuiltin
endif

" Exceptions
if s:exceptions
  hi def link pythonExceptions      Structure
endif

" Class variables
if s:class_vars
  hi def link pythonClassVar        Identifier
endif

" Operators
if s:operators
  hi def link pythonOperatorSymbol  Operator
endif

" Function calls
if s:func_calls
  hi def link pythonFunctionCall    Function
endif

" Type annotations - THE KEY HIGHLIGHTING
if s:type_annotations
  hi def link pythonReturnArrow     Operator
  hi def link pythonTypeColon       Operator
  hi def link pythonTypingType      Type
  hi def link pythonTypingContainer Type
  hi def link pythonTypePrimitive   Type
  hi def link pythonTypeUnion       Operator
  hi def link pythonTypeBracket     Delimiter
  hi def link pythonTypeComment     SpecialComment
  hi def link pythonTypeVar         Identifier
  hi def link pythonTypeVarBound    Type
  hi def link pythonTypeAnnotation  Type
  hi def link pythonReturnType      Type
endif

" Doctests
if s:doctests
  hi def link pythonDoctest         Special
  hi def link pythonDoctestValue    Define
  hi def link pythonDoctestEllipsis pythonBuiltin
endif

" Space errors
if s:space_errors
  hi def link pythonSpaceError      Error
endif

" ============================================================================
" Cleanup
" ============================================================================

let b:current_syntax = "python"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim:set sw=2 sts=2 ts=8 noet:
