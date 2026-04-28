# polybar-player

An MPRIS2 media control module for [Polybar](https://github.com/polybar/polybar).
Auto-discovers any MPRIS2-compatible media player on D-Bus, with scrolling
text display and player selection via rofi/dmenu.

Written in pure bash. No Python, no Node, no runtime dependencies.

## Dependencies

**Required:**
- `bash` (>= 4.0)
- `busctl` or [`ebusctl`](https://github.com/user/ebusctl) — D-Bus CLI tool

**Optional (for player selection menu):**
- `rofi` (preferred) or `dmenu`
- Without either, left-clicking the player icon cycles through available players

## Installation

```bash
make install              # /usr/local/bin
make PREFIX=~/.local install   # ~/.local/bin
```

## Polybar Configuration

```ini
[module/player]
type = custom/script
interval = 1
exec = polybar-player
exec-if = ebusctl list --acquired | grep -q org.mpris.MediaPlayer2
```

### With custom format and scrolling

```ini
[module/player]
type = custom/script
interval = 1
exec = polybar-player -f '{prev} {icon} {artist} - {title} {play_pause} {next}' -l 25 -s 1
exec-if = ebusctl list --acquired | grep -q org.mpris.MediaPlayer2
```

### Spotify only

```ini
[module/spotify]
type = custom/script
interval = 1
exec = polybar-player --player org.mpris.MediaPlayer2.spotify -q
exec-if = pgrep -x spotify
```

## Usage

```
polybar-player [OPTIONS]

Display options:
  -f, --format FORMAT        Output format (default: {prev} {icon} {artist}: {title} {play_pause} {next})
  -l, --max-length N         Max display length for scrolling text (default: 30)
  -s, --scroll-speed N       Characters per tick (default: 1)
  --scroll-separator STR     Wrap separator (default: " ... ")
  --no-scroll                Disable scrolling, truncate instead
  -q, --quiet                No output when paused
  --icons PREV PLAY PAUSE NEXT  Override icons
  --player NAME              Force specific player

Actions (used by polybar click handlers):
  --play-pause               Toggle play/pause
  --next                     Next track
  --prev                     Previous track
  --select                   Open player selector
```

## Format Placeholders

| Placeholder | Description |
|-------------|-------------|
| `{prev}` | Previous track button |
| `{next}` | Next track button |
| `{play_pause}` | Play/pause toggle |
| `{icon}` | Player icon (auto-detected) |
| `{artist}` | Artist name |
| `{title}` | Track title |
| `{album}` | Album name |
| `{status}` | Playback status text |

`{prev}` and `{next}` are automatically hidden when the player
doesn't support those actions.

## Supported Players

Any MPRIS2-compatible player, including:
Spotify, Firefox, Chrome/Chromium, VLC, mpd, Rhythmbox, Clementine,
Audacious, GNOME Music, Lollypop, Strawberry, and many more.

## License

MIT
