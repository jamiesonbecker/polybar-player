#!/usr/bin/env bash
# tests/test_format.sh — tests for format_output and metadata extraction

PLAYER="$SCRIPT_DIR/../polybar-player"
MOCK="$SCRIPT_DIR/mock_ebusctl"

ln -sf "$MOCK" "$SCRIPT_DIR/ebusctl"
ln -sf "$MOCK" "$SCRIPT_DIR/busctl"
OLD_PATH="$PATH"
export PATH="$SCRIPT_DIR:$PATH"

TEST_STATE=$(mktemp -d)
export XDG_RUNTIME_DIR="$TEST_STATE"

# Test: default format produces output with artist and title
result=$(bash "$PLAYER" _format_output "org.mpris.MediaPlayer2.spotify")
assert_contains "format has artist" "Rick Astley" "$result"
assert_contains "format has title" "Never Gonna Give You Up" "$result"

# Test: output contains polybar click action tags
assert_contains "has click action open" "%{A1:" "$result"
assert_contains "has click action close" "%{A}" "$result"

# Test: quiet mode with paused player produces empty output
result=$(MOCK_STATUS="Paused" bash "$PLAYER" -q _format_output "org.mpris.MediaPlayer2.spotify")
assert_equal "quiet+paused = empty" "" "$result"

# Test: custom format
result=$(bash "$PLAYER" -f '{title}' _format_output "org.mpris.MediaPlayer2.spotify")
assert_contains "custom format title only" "Never Gonna" "$result"

# Test: prev/next hidden when player says CanGoNext=false
result=$(MOCK_CAN_NEXT="false" bash "$PLAYER" -f '{prev}|{next}' _format_output "org.mpris.MediaPlayer2.spotify")
# {next} should be empty, but {prev} should have content
assert_contains "prev visible when CanGoPrevious=true" "%{A1:" "$result"

export PATH="$OLD_PATH"
rm -rf "$TEST_STATE"
rm -f "$SCRIPT_DIR/ebusctl" "$SCRIPT_DIR/busctl"
