---
name: Bug Report
about: Something highlighted wrong, or not highlighted at all
title: '[BUG] '
labels: bug
assignees: ''
---

## What Happened
What is highlighted wrong (or not at all)?

## Python Code
The smallest snippet that shows it:

```python

```

## Expected Highlighting
What you expected instead, e.g. "`str` should be colored as a type".

## Syntax Group
Put the cursor on the wrong-looking text and run:

```vim
:echo synIDattr(synID(line('.'), col('.'), 1), 'name')
```

Group shown:

## Screenshot
If it helps, a screenshot of the highlighting.

## Environment
- **Editor + version:** (first line of `vim --version` / `nvim --version`)
- **OS:**
- **Colorscheme:**
- **Output of `:PythonSyntaxInfo`:**
- **Other Python syntax plugins installed?** (e.g. vim-python/python-syntax, nvim-treesitter highlighting for Python)
