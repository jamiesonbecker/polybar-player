#!/usr/bin/env bash
# tests/test_discover.sh — tests for discover_players

PLAYER="$SCRIPT_DIR/../polybar-player"
MOCK="$SCRIPT_DIR/mock_ebusctl"

# Symlink mock as both "ebusctl" and "busctl" so polybar-player finds it
ln -sf "$MOCK" "$SCRIPT_DIR/ebusctl"
ln -sf "$MOCK" "$SCRIPT_DIR/busctl"
OLD_PATH="$PATH"
export PATH="$SCRIPT_DIR:$PATH"

# Test: discover_players finds MPRIS2 services
result=$(bash "$PLAYER" _discover)
assert_contains "discover finds spotify" "org.mpris.MediaPlayer2.spotify" "$result"
assert_contains "discover finds firefox" "org.mpris.MediaPlayer2.firefox" "$result"

# Test: discover returns empty when no players
result=$(MOCK_PLAYERS="" bash "$PLAYER" _discover)
assert_equal "discover empty when no players" "" "$result"

export PATH="$OLD_PATH"
rm -f "$SCRIPT_DIR/ebusctl" "$SCRIPT_DIR/busctl"
