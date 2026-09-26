## Summary

<!-- Brief description of what this PR does and why -->

## Changes

<!-- List key changes -->

---

## Required Checks

### Tests
- [ ] This PR does **not** change `syntax/` or `plugin/` (skip below)
- [ ] Added or updated assertions in `tests/test_syntax.vim` (or `tests/test_loading.vim`) that fail without the change
- [ ] `sh tests/run.sh` passes locally

### Docs
- [ ] This PR does **not** change user-visible behavior or options (skip below)
- [ ] README and `doc/python-syntax-enhanced.txt` updated (options, commands, color table)
- [ ] Changelog entry added in `doc/python-syntax-enhanced.txt`

### Fork PR Guard (if workflows changed)
- [ ] This PR does **not** modify `.github/workflows/` (skip below)
- [ ] Any PR-write action (labels, comments, assignees) has a fork guard:
  ```yaml
  if: github.event.pull_request.head.repo.full_name == github.repository
  ```

### General
- [ ] `git diff --check` passes (no whitespace errors)
- [ ] CI passes on Vim (Linux, macOS, Windows) and Neovim
