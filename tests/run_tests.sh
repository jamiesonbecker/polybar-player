#!/usr/bin/env bash
# tests/run_tests.sh — lightweight test runner for polybar-player
set -euo pipefail

PASS=0
FAIL=0
ERRORS=()

assert_equal() {
    local label="$1" expected="$2" actual="$3"
    if [[ "$expected" == "$actual" ]]; then
        ((++PASS))
    else
        ((++FAIL))
        ERRORS+=("FAIL: $label"$'\n'"  expected: $(printf '%q' "$expected")"$'\n'"  actual:   $(printf '%q' "$actual")")
    fi
}

assert_exit_code() {
    local label="$1" expected="$2" actual="$3"
    if [[ "$expected" -eq "$actual" ]]; then
        ((++PASS))
    else
        ((++FAIL))
        ERRORS+=("FAIL: $label"$'\n'"  expected exit code: $expected"$'\n'"  actual exit code:   $actual")
    fi
}

assert_contains() {
    local label="$1" needle="$2" haystack="$3"
    if [[ "$haystack" == *"$needle"* ]]; then
        ((++PASS))
    else
        ((++FAIL))
        ERRORS+=("FAIL: $label"$'\n'"  expected to contain: $(printf '%q' "$needle")"$'\n'"  in: $(printf '%q' "$haystack")")
    fi
}

run_suite() {
    local suite="$1"
    echo "--- $suite ---"
    source "$suite"
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
for f in "$SCRIPT_DIR"/test_*.sh; do
    [[ -f "$f" ]] && run_suite "$f"
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
for err in "${ERRORS[@]}"; do
    echo ""
    echo "$err"
done

[[ "$FAIL" -eq 0 ]]
