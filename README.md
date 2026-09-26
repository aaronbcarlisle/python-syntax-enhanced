# Python Syntax Enhanced

[![Tests](https://github.com/aaronbcarlisle/python-syntax-enhanced/actions/workflows/test.yml/badge.svg)](https://github.com/aaronbcarlisle/python-syntax-enhanced/actions/workflows/test.yml)

Python syntax highlighting for Vim that understands type annotations.

Vim's built-in Python syntax has no notion of annotations: `->`, `list[int]`
and `Optional[User]` are colored like any other code, and `str` looks the same
in `name: str` as in `str(x)`. This plugin replaces `syntax/python.vim` with
one that colors types only where they are types: parameter and return
annotations, `x: T` and `self.attr: T`, class bases, and PEP 695 type
parameters and `type` aliases.

![Before and after: Vim's built-in Python syntax next to python-syntax-enhanced, colorscheme retrobox](https://github.com/user-attachments/assets/e3f130c2-17f7-454b-95ce-0d3ebe375438)

## Features

- Return arrows, generics (`dict[str, list[int]]`), unions (`X | Y`) and
  forward references (`"User"`) inside annotations
- `list(...)` in regular code stays a builtin, and `key: value` lines in a
  multi-line dict or call are not mistaken for annotations
- `|` is a union only inside a type; elsewhere it is the bitwise operator
- `typing` names (`Optional`, `Callable`, `Annotated`, `Protocol`, `TypeIs`,
  ...) and user types (`User`, `T`) inside annotations
- Python 3.12 type parameters and aliases: `def f[T](x: T) -> T:`,
  `type Point = tuple[int, int]`
- `# type: int` comments (`# type: ignore` stays a plain comment)
- Docstrings, including after wrapped signatures and comment lines
- f-strings (including `f"{x=}"`), `match`/`case`, `except*`
- An optional color palette for the new groups (see below)

## Colors

By default every group is linked to a standard group (`Type`, `Operator`,
`String`, ...), so your colorscheme decides the colors, as in the screenshot
above. The plugin also has its own palette, which you can turn on with:

```vim
let g:python_enhanced_colors = 1
```

| Element | Palette color | Highlight group |
|---------|---------------|-----------------|
| Class names | Cyan | `pythonClass` |
| `Optional`, `Callable`, `Generic`, etc. | Orange | `pythonTypingType` |
| `str`, `int`, `bool`, `list`, `dict` in annotations | Blue | `pythonPrimitiveType` |
| `->` and `\|` (union) | Magenta | `pythonReturnArrow`, `pythonTypeUnion` |
| Builtins in code (`print`, `len`, `str(...)`) | Lavender | `pythonBuiltin` |
| Docstrings | Green | `pythonDocstring` |
| User types in annotations (`User`, `T`) | colorscheme `Type` | `pythonTypeName` |
| `self`, `cls` | colorscheme `Identifier` | `pythonClassVar` |

## Installation

### vim-plug
```vim
Plug 'aaronbcarlisle/python-syntax-enhanced'
```

### Vundle
```vim
Plugin 'aaronbcarlisle/python-syntax-enhanced'
```

### Vim packages (no plugin manager)
```sh
git clone https://github.com/aaronbcarlisle/python-syntax-enhanced.git \
    ~/.vim/pack/plugins/start/python-syntax-enhanced
```
On Windows, use `~/vimfiles/pack/plugins/start/python-syntax-enhanced`.
Run `:helptags ALL` once afterwards to enable `:help python-syntax-enhanced`.

### Neovim (lazy.nvim)
```lua
{ "aaronbcarlisle/python-syntax-enhanced" }
```

### Compatibility

Tested in CI on Vim 9.1 (Linux), Vim 9.2 (macOS, Windows) and Neovim 0.12.
It replaces Vim's built-in `syntax/python.vim`, so disable other Python syntax
plugins (see [Troubleshooting](#troubleshooting)).

In Neovim this is a regular syntax file: it applies when Python is highlighted
by the syntax engine (Neovim's default). If Tree-sitter highlighting is enabled
for Python, the plugin does not load.

## Configuration

Options are read when a Python buffer's syntax is loaded, so set them in your
vimrc (after changing one, reopen the file with `:e`).

```vim
" Enable all features
let g:python_enhanced_highlight_all = 1
```

Or configure individually:

```vim
let g:python_highlight_type_annotations = 1   " Type annotations (default: 1)
let g:python_highlight_operators = 1          " Operators (default: 1)
let g:python_highlight_func_calls = 1         " Function calls (default: 0)
let g:python_highlight_class_vars = 1         " self, cls (default: 1)
let g:python_highlight_builtins = 1           " Builtins (default: 1)
let g:python_highlight_exceptions = 1         " Exceptions (default: 1)
let g:python_highlight_string_formatting = 1  " String formatting (default: 1)
let g:python_highlight_doctests = 1           " Doctests (default: 1)
let g:python_highlight_space_errors = 0       " Space errors (default: 0)
let g:python_enhanced_colors = 1              " Built-in palette (default: 0)
```

For large files:
```vim
let g:python_slow_sync = 1                    " syntax sync fromstart
```

## What counts as a type

Type colors apply inside these positions only; everywhere else the same names
keep their normal highlighting:

```python
def find[T](items: list[T], key: Callable[[T], str] | None = None) -> T | None: ...

class Stack(Generic[T], Protocol): ...

users: dict[str, "User"] = {}
self._items: list[T] = []
type Pair[K] = tuple[K, K]
x = []  # type: list[int]
```

## Customizing Colors

To change single colors, override the groups in your vimrc after your
colorscheme (with the palette on, a later `:colorscheme` re-applies it):

Brackets, commas and colons inside annotations are not colored, like the rest
of Python's punctuation. To color them, link `pythonTypeBracket`,
`pythonTypeComma`, `pythonTypeColon`, `pythonParams` or `pythonDefColon`, e.g.
`hi link pythonTypeBracket Delimiter`.

```vim
" Example: Make typing types cyan instead of orange
hi pythonTypingType     ctermfg=44  guifg=#00d7d7

" Example: Make primitives yellow
hi pythonPrimitiveType  ctermfg=220 guifg=#ffd700
```

## Commands

- `:PythonSyntaxEnableAll` - Enable all highlighting features and reload syntax in the **current** Python buffer
- `:PythonSyntaxInfo` - Show current configuration

## Troubleshooting

**Syntax breaks in long files:**
```vim
let g:python_slow_sync = 1
```

**Manual resync:**
```vim
:syntax sync fromstart
" Or add a mapping:
nnoremap <leader>ss :syntax sync fromstart<CR>
```

**Old syntax file interfering:**
Disable other Python syntax plugins (like `vim-python/python-syntax`). If one
of them wins the runtimepath lookup, this plugin clears it and loads its own
`syntax/python.vim` on `FileType python`, so the other one is loaded for nothing.

## Limitations

- Types are recognized by position, not by analysis: any name inside an
  annotation is colored as a type, and `typing` names are matched by name.
- Statement annotations (`x: int = 1`) are recognized at the start of a line
  only, not after `;`.
- The file replaces Vim's `syntax/python.vim`, whose `python_no_*_highlight`
  options are not read (`python_highlight_all` is).

## Testing

Visual fixture:
```
tests/test_highlighting.py
```

Automated checks (`synID` assertions plus a syntax-loading test), run in CI on every push and PR:
```bash
sh tests/run.sh                  # uses vim
VIM_BIN=/path/to/vim sh tests/run.sh
```

## License

[MIT](LICENSE)

## Credits

See [AUTHORS](AUTHORS) for full attribution.

- Vim's built-in Python syntax (Zvezdan Petkovic)
- vim-python/python-syntax (for inspiration)
- Python typing PEPs (484, 526, 544, 585, 604, 612, 673, 695, 742)
