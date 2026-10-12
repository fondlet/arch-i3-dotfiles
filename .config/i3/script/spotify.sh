#!/bin/bash
# Now-playing info for i3blocks, via MPRIS (playerctl). Outputs nothing when
# Spotify isn't running, so the block stays blank instead of showing an error.

status=$(playerctl -p spotify status 2>/dev/null)
[ -z "$status" ] && exit 0

artist=$(playerctl -p spotify metadata artist 2>/dev/null)
title=$(playerctl -p spotify metadata title 2>/dev/null)
[ -z "$title" ] && exit 0

text="$artist - $title"

# character-aware truncation so long titles don't blow out the bar
max_len=35
text=$(printf '%s' "$text" | awk -v max="$max_len" '{
    if (length($0) > max) print substr($0, 1, max - 1) "…"
    else print $0
}')

if [ "$status" = "Paused" ]; then
    printf '%s %s\n' "" "$text"
else
    printf '%s\n' "$text"
fi
