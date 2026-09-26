# Python Syntax Enhanced

**IDE-level Python syntax highlighting for Vim with comprehensive type annotation support.**

Vim's built-in Python syntax and existing plugins like `vim-python/python-syntax` don't properly handle modern Python type hints. The `->` return type arrow breaks highlighting, generic types aren't recognized, and typing module constructs are ignored. This plugin fixes all of that.

![enhanced-syntax-highlighting-demo](https://github.com/user-attachments/assets/4295c9fb-e658-472e-978c-923091fbc221)

## Features

- **Return type arrows** - `->` is properly highlighted (no more broken syntax!)
- **Type expressions only in annotations** - Parameters, returns, assignments, class bases, PEP 695 type params
- **Generic types** - `list[int]`, `dict[str, Any]`, `tuple[int, ...]`
- **Union types** - `X | Y` (Python 3.10+), only inside type regions (bitwise `|` stays an operator)
- **typing module** - Optional, Callable, Annotated, TypeIs, ReadOnly, NotRequired, Protocol, etc.
- **User / CapWords types** - `User`, `Comparable`, and other aliases color inside annotations
- **Type comments** - `# type: int` (PEP 484 legacy style)
- **Python 3.12+ type syntax** - `def func[T](x: T) -> T:`, `type Point = tuple[int, int]`
- **Enhanced f-strings** - Including debug specifier `f"{x=}"`
- **match/case** and **except\*** - Python 3.10+ / 3.11+
- **Green docstrings** - Via nextgroup after the header colon (`skipnl`/`skipempty`, including wrapped signatures and blank lines)
- **Comments in annotations** - Trailing `# ...` notes stay comments, not fake type names
- **Distinct color scheme** - Different colors for types, primitives, classes (optional)

## Color Scheme

| Element | Color | Highlight group |
|---------|-------|-----------------|
| Class names | Cyan | `pythonClass` |
| `Optional`, `Callable`, `Generic`, etc. | Orange | `pythonTypingType` |
| `str`, `int`, `bool`, `list`, `dict` | Blue | `pythonPrimitiveType` |
| CapWords / aliases in annotations | Type link | `pythonTypeName` |
| `->` and `\|` (union) | Magenta | `pythonReturnArrow`, `pythonTypeUnion` |
| `self`, `cls` | Orange | `pythonSelfRef` |
| Builtins in code (`print`, `len`, `str(...)`) | Lavender | `pythonBuiltin` |
| Docstrings | Green | `pythonDocstring` |

## Installation

### vim-plug
```vim
Plug 'aaronbcarlisle/python-syntax-enhanced'
```

### Manual
Copy to `~/.vim/plugged/python-syntax-enhanced/` or your preferred plugin location.

## Configuration

Add to your vimrc **BEFORE** `syntax on`:

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
let g:python_enhanced_colors = 1              " Built-in palette (default: 1; 0 = hi def link only)
```

For large files:
```vim
let g:python_slow_sync = 1                    " syntax sync fromstart
```

## Type Annotations Supported

### Return Types
```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

### Parameter Annotations
```python
def process(data: bytes, count: int = 10) -> None:
    pass
```

### Variable Annotations
```python
users: list[User] = []
config: Final[dict[str, Any]] = {}
self._items: list[T] = []   # dotted attribute targets
```

### Generic Types
```python
from typing import List, Dict, Optional, Callable

def get_users() -> List[Dict[str, Any]]: ...
def find(id: int) -> Optional[User]: ...
def apply(func: Callable[[int], str]) -> None: ...
```

### Union Types (Python 3.10+)
```python
def parse(value: str | int | None) -> dict:
    pass
```

### TypeVar & Generic Classes
```python
from typing import TypeVar, Generic

T = TypeVar('T')

class Stack(Generic[T]):
    def push(self, item: T) -> None: ...
    def pop(self) -> T: ...
```

### Protocol Classes
```python
from typing import Protocol, Self

class Comparable(Protocol):
    def __lt__(self, other: Self) -> bool: ...
```

### Type Aliases (Python 3.12+)
```python
type Point = tuple[int, int]
type Vector[T] = list[T]
```

## Customizing Colors

By default the plugin applies a small palette on syntax load and on `ColorScheme`.
Set `let g:python_enhanced_colors = 0` to keep only `hi def link` defaults so your
colorscheme owns the groups.

Override colors in your vimrc (after loading the plugin / colorscheme):

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
This plugin force-loads its own `syntax/python.vim` on `FileType python`. Disable other
Python syntax plugins (like `vim-python/python-syntax`) to avoid conflicts.

## Testing

Visual fixture:
```
tests/test_highlighting.py
```

Automated synID checks (recommended):
```bash
vim -Nu NONE -S tests/test_syntax.vim
vim -Nu NONE -S tests/test_loading.vim
```

## License

[MIT](LICENSE)

## Credits

See [AUTHORS](AUTHORS) for full attribution.

- Vim's built-in Python syntax (Zvezdan Petkovic)
- vim-python/python-syntax (for inspiration)
- Python typing PEPs (484, 526, 544, 585, 604, 612, 673, 695)
