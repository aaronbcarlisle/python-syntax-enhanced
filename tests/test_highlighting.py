#!/usr/bin/env python3
"""
Test file for Python Syntax Enhanced
=====================================

Open this file in Vim to verify all syntax highlighting features work correctly.
Each section demonstrates different highlighting capabilities.
"""

from __future__ import annotations

from typing import (
    Any, AnyStr, Callable, ClassVar, Final, Generic, Literal,
    Never, NewType, NoReturn, Optional, ParamSpec, Protocol,
    Self, Tuple, Type, TypeAlias, TypeGuard, TypeVar, Union,
)
from collections.abc import Sequence, Mapping, Iterator
from dataclasses import dataclass

# =============================================================================
# Basic Type Annotations
# =============================================================================

# Variable annotations - these should highlight the type
name: str = "Alice"
age: int = 30
balance: float = 100.50
is_active: bool = True
data: bytes = b"hello"
nothing: None = None


# =============================================================================
# Return Type Arrows (The Main Fix!)
# =============================================================================

def greet(name: str) -> str:
    """The -> should be highlighted as Operator, str as Type."""
    return f"Hello, {name}"


def process(data: bytes, count: int = 10) -> None:
    """Multiple parameters with types and a None return."""
    pass


def get_value() -> int | str | None:
    """Union return type with pipe operator (Python 3.10+)."""
    return 42


async def fetch_data(url: str) -> bytes:
    """Async function with type hints."""
    return b""


# =============================================================================
# Generic Types
# =============================================================================

def get_users() -> list[dict[str, Any]]:
    """Lowercase generic types (Python 3.9+)."""
    return []


def get_mapping() -> dict[str, list[int]]:
    """Nested generic types."""
    return {}


def find_item(id: int) -> Optional[str]:
    """Optional from typing module."""
    return None


def get_callback() -> Callable[[int, str], bool]:
    """Callable type with arguments and return."""
    return lambda x, y: True


def get_tuple() -> tuple[int, str, float]:
    """Tuple with specific types."""
    return (1, "a", 1.0)


def get_items() -> Sequence[int]:
    """Abstract base class types."""
    return []


# =============================================================================
# TypeVar and Generics
# =============================================================================

T = TypeVar('T')
K = TypeVar('K')
V = TypeVar('V')
T_co = TypeVar('T_co', covariant=True)
T_contra = TypeVar('T_contra', contravariant=True)


def first(items: list[T]) -> T:
    """Function using TypeVar."""
    return items[0]


def get_item(mapping: dict[K, V], key: K) -> V:
    """Multiple TypeVars."""
    return mapping[key]


class Stack(Generic[T]):
    """Generic class with TypeVar."""

    def __init__(self) -> None:
        self._items: list[T] = []

    def push(self, item: T) -> None:
        self._items.append(item)

    def pop(self) -> T:
        return self._items.pop()

    def peek(self) -> T | None:
        return self._items[-1] if self._items else None


# =============================================================================
# Protocol Classes
# =============================================================================

class Comparable(Protocol):
    """Protocol class for structural subtyping."""

    def __lt__(self, other: Self) -> bool: ...
    def __le__(self, other: Self) -> bool: ...


class Hashable(Protocol):
    def __hash__(self) -> int: ...


def sort_items(items: list[Comparable]) -> list[Comparable]:
    """Function accepting Protocol type."""
    return sorted(items)


# =============================================================================
# Type Aliases (Python 3.12+ syntax)
# =============================================================================

# Old-style type alias
UserId = NewType('UserId', int)
UserDict: TypeAlias = dict[str, Any]

# Note: Python 3.12+ "type" statement would be:
# type Point = tuple[int, int]
# type Vector[T] = list[T]


# =============================================================================
# ClassVar and Final
# =============================================================================

class Config:
    """Class with ClassVar and Final annotations."""

    VERSION: ClassVar[str] = "1.0.0"
    MAX_RETRIES: ClassVar[int] = 3

    name: Final[str]
    debug: Final[bool] = False

    def __init__(self, name: str) -> None:
        self.name = name


# =============================================================================
# Literal Types
# =============================================================================

Mode = Literal["read", "write", "append"]
StatusCode = Literal[200, 201, 400, 404, 500]


def open_file(path: str, mode: Mode) -> None:
    """Function with Literal type parameter."""
    pass


def check_status(code: StatusCode) -> bool:
    """Literal with multiple int values."""
    return code in (200, 201)


# =============================================================================
# TypeGuard
# =============================================================================

def is_string_list(val: list[object]) -> TypeGuard[list[str]]:
    """TypeGuard for type narrowing."""
    return all(isinstance(x, str) for x in val)


# =============================================================================
# ParamSpec (for decorators)
# =============================================================================

P = ParamSpec('P')
R = TypeVar('R')


def logged(func: Callable[P, R]) -> Callable[P, R]:
    """Decorator preserving type signatures."""
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
        print(f"Calling {func.__name__}")
        return func(*args, **kwargs)
    return wrapper


@logged
def add(a: int, b: int) -> int:
    return a + b


# =============================================================================
# NoReturn / Never
# =============================================================================

def fatal_error(message: str) -> NoReturn:
    """Function that never returns normally."""
    raise SystemExit(message)


def infinite_loop() -> Never:
    """Never type (Python 3.11+)."""
    while True:
        pass


# =============================================================================
# Complex Nested Types
# =============================================================================

def complex_function(
    data: dict[str, list[tuple[int, Optional[str]]]],
    callback: Callable[[int, str], bool] | None = None,
    *args: int,
    **kwargs: str,
) -> dict[str, Any] | None:
    """Complex nested type annotations."""
    return None


# =============================================================================
# Class with Many Type Annotations
# =============================================================================

@dataclass
class User:
    """Dataclass with type annotations."""

    id: int
    name: str
    email: str | None = None
    tags: list[str] | None = None
    metadata: dict[str, Any] | None = None

    def to_dict(self) -> dict[str, Any]:
        """Method with return type."""
        return {"id": self.id, "name": self.name}

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> Self:
        """Classmethod returning Self."""
        return cls(**data)

    @staticmethod
    def validate_email(email: str) -> bool:
        """Staticmethod with type hints."""
        return "@" in email


# =============================================================================
# Match/Case Statements (Python 3.10+)
# =============================================================================

def handle_command(command: str | list[str] | dict[str, Any]) -> str:
    """Pattern matching with type hints."""
    match command:
        case str() as s:
            return f"String: {s}"
        case [first, *rest]:
            return f"List starting with {first}"
        case {"action": action, **rest}:
            return f"Dict with action: {action}"
        case _:
            return "Unknown"


# =============================================================================
# F-strings with Debug (Python 3.8+)
# =============================================================================

x = 42
y = "hello"

# Debug specifier
print(f"{x=}")
print(f"{y=!r}")
print(f"{x + 1=}")

# Complex f-string
result = f"x is {x}, doubled is {x * 2}, and y is {y!r}"


# =============================================================================
# Type Comments (Legacy PEP 484)
# =============================================================================

def legacy_function(name, age):
    # type: (str, int) -> str
    """Function with type comment."""
    return f"{name} is {age}"


old_variable = []  # type: list[int]


# =============================================================================
# Operators
# =============================================================================

# Arithmetic
a = 1 + 2 - 3 * 4 / 5 // 6 % 7 ** 8

# Comparison
b = 1 < 2 <= 3 > 4 >= 5 == 6 != 7

# Bitwise
c = 1 & 2 | 3 ^ 4 << 5 >> 6

# Walrus operator (Python 3.8+)
if (n := len("hello")) > 3:
    print(n)


# =============================================================================
# Builtins and Exceptions
# =============================================================================

# Builtins
items = list(range(10))
items = sorted(items, key=lambda x: -x)
total = sum(items)
maximum = max(items)
minimum = min(items)

# Exceptions
try:
    result = 1 / 0
except ZeroDivisionError as e:
    print(f"Error: {e}")
except (TypeError, ValueError):
    pass
except Exception:
    raise
finally:
    print("Done")


# =============================================================================
# All the typing module types
# =============================================================================

def type_showcase(
    a: Any,
    b: AnyStr,
    c: Callable[..., Any],
    d: ClassVar[int],
    e: Final[str],
    f: Generic,
    g: Literal["x"],
    h: Never,
    i: NewType,
    j: NoReturn,
    k: Optional[int],
    l: Protocol,
    m: Self,
    n: Tuple[int, ...],
    o: Type[Exception],
    p: TypeAlias,
    q: TypeGuard[str],
    r: TypeVar,
    s: Union[int, str],
) -> None:
    """Showcase of all typing module types."""
    pass


if __name__ == "__main__":
    # Test the functions
    print(greet("World"))
    stack: Stack[int] = Stack()
    stack.push(1)
    stack.push(2)
    print(stack.pop())
