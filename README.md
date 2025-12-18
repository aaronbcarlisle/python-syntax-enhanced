# Python Syntax Enhanced

**IDE-level Python syntax highlighting for Vim with comprehensive type annotation support.**

Vim's built-in Python syntax and existing plugins like `vim-python/python-syntax` don't properly handle modern Python type hints. The `->` return type arrow breaks highlighting, generic types aren't recognized, and typing module constructs are ignored. This plugin fixes all of that.

![enhanced-syntax-highlighting-demo](https://github.com/user-attachments/assets/4295c9fb-e658-472e-978c-923091fbc221)

## Features

- **Return type arrows** - `->` is properly highlighted (no more broken syntax!)
- **Full type annotation support** - Parameters, variables, return types
- **Generic types** - `List[int]`, `Dict[str, Any]`, `Tuple[int, ...]`
- **Union types** - `X | Y` (Python 3.10+)
- **typing module** - Optional, Callable, TypeVar, Protocol, Generic, etc.
- **Type comments** - `# type: int` (PEP 484 legacy style)
- **Python 3.12+ type syntax** - `def func[T](x: T) -> T:`
- **Enhanced f-strings** - Including debug specifier `f"{x=}"`
- **match/case statements** - Python 3.10+ pattern matching
- **Green docstrings** - Triple-quoted docstrings highlighted in green
- **Distinct color scheme** - Different colors for types, primitives, classes

## Color Scheme

| Element | Color |
|---------|-------|
| Class names | Cyan |
| `Optional`, `Callable`, `Generic`, etc. | Orange |
| `str`, `int`, `bool`, `list`, `dict` | Blue |
| `->` and `\|` (union) | Magenta |
| `self`, `cls` | Orange |
| Docstrings | Green |

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
```

For large files:
```vim
let g:python_slow_sync = 1                    " Better sync for large files
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

Override colors in your vimrc (after loading the plugin):

```vim
" Example: Make typing types cyan instead of orange
hi pythonTypingType     ctermfg=44  guifg=#00d7d7

" Example: Make primitives yellow
hi pythonPrimitiveType  ctermfg=220 guifg=#ffd700
```

## Commands

- `:PythonSyntaxEnableAll` - Enable all highlighting features
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
Check for old Python syntax files in `~/vimfiles/syntax/` or `~/.vim/syntax/` and remove them.

## License

MIT

## Credits

- Vim's built-in Python syntax (Zvezdan Petkovic)
- vim-python/python-syntax (for inspiration)
- Python typing PEPs (484, 526, 544, 585, 604, 612, 673, 695)
