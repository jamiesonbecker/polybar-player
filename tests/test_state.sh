#!/usr/bin/env bash
# tests/test_state.sh — tests for active player state management

PLAYER="$SCRIPT_DIR/../polybar-player"
MOCK="$SCRIPT_DIR/mock_ebusctl"

ln -sf "$MOCK" "$SCRIPT_DIR/ebusctl"
ln -sf "$MOCK" "$SCRIPT_DIR/busctl"
OLD_PATH="$PATH"
export PATH="$SCRIPT_DIR:$PATH"

TEST_STATE=$(mktemp -d)
export XDG_RUNTIME_DIR="$TEST_STATE"

# Test: active_player returns first player when no state
result=$(bash "$PLAYER" _active_player)
assert_contains "default active player is first discovered" "spotify" "$result"

# Test: after selecting a player, it persists
bash "$PLAYER" _set_active "org.mpris.MediaPlayer2.firefox.instance_1234"
result=$(bash "$PLAYER" _active_player)
assert_contains "persisted player is firefox" "firefox" "$result"

# Test: if persisted player is gone, falls back to first available
bash "$PLAYER" _set_active "org.mpris.MediaPlayer2.gone"
result=$(bash "$PLAYER" _active_player)
assert_contains "falls back when persisted player gone" "spotify" "$result"

export PATH="$OLD_PATH"
rm -rf "$TEST_STATE"
rm -f "$SCRIPT_DIR/ebusctl" "$SCRIPT_DIR/busctl"
