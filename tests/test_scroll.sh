#!/usr/bin/env bash
# tests/test_scroll.sh — tests for scroll_text

PLAYER="$SCRIPT_DIR/../polybar-player"
MOCK="$SCRIPT_DIR/mock_ebusctl"

# Need mock in PATH so polybar-player can init
ln -sf "$MOCK" "$SCRIPT_DIR/ebusctl"
ln -sf "$MOCK" "$SCRIPT_DIR/busctl"
OLD_PATH="$PATH"
export PATH="$SCRIPT_DIR:$PATH"

TEST_STATE=$(mktemp -d)
export XDG_RUNTIME_DIR="$TEST_STATE"

# Test: short text (fits in max_length) is returned as-is
result=$(bash "$PLAYER" _scroll_text "Hello" 30 1 " ... ")
assert_equal "short text unchanged" "Hello" "$result"

# Test: long text — first call returns start of window
result=$(bash "$PLAYER" _scroll_text "This is a very long song title that should scroll" 20 1 " ... ")
assert_equal "first scroll window" "This is a very long " "$result"

# Test: second call advances by scroll_speed (offset is now 1)
result=$(bash "$PLAYER" _scroll_text "This is a very long song title that should scroll" 20 1 " ... ")
assert_equal "second scroll advances" "his is a very long s" "$result"

# Test: reset offset and verify speed=2 advances faster
echo "0" > "$TEST_STATE/polybar-player/scroll-offset"
result=$(bash "$PLAYER" _scroll_text "This is a very long song title that should scroll" 20 2 " ... ")
assert_equal "speed=2 first window" "This is a very long " "$result"
result=$(bash "$PLAYER" _scroll_text "This is a very long song title that should scroll" 20 2 " ... ")
assert_equal "speed=2 second window" "is is a very long so" "$result"

export PATH="$OLD_PATH"
rm -rf "$TEST_STATE"
rm -f "$SCRIPT_DIR/ebusctl" "$SCRIPT_DIR/busctl"
