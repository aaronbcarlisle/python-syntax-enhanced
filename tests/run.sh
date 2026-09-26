#!/usr/bin/env sh
# Run the synID and loading test suites headlessly and print their results.
#
# Usage:  sh tests/run.sh                # uses `vim`
#         VIM_BIN=nvim sh tests/run.sh    # any Vim-compatible binary
#
# (Not $VIM: Vim itself reads that to find its runtime files.)
#
# Exits non-zero if any suite fails.

VIM_BIN="${VIM_BIN:-vim}"
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
out=$(mktemp)
status=0

# Git Bash/MSYS: a native Windows vim.exe cannot open /c/... style paths
native() {
    if command -v cygpath >/dev/null 2>&1; then cygpath -m "$1"; else printf '%s' "$1"; fi
}

for suite in test_syntax test_loading; do
    # -es is silent Ex mode, so capture the suites' messages with :redir
    "$VIM_BIN" -Nu NONE -es --cmd "redir! > $(native "$out")" \
        -S "$(native "$root/tests/$suite.vim")" </dev/null
    code=$?
    printf '%s: ' "$suite"
    # the suites end with "PASS: N assertions" or FAIL lines + a summary
    sed '/^$/d' "$out"
    echo
    [ "$code" -eq 0 ] || status=1
done

rm -f "$out"
exit "$status"
