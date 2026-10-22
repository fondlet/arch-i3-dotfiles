#!/bin/sh
# Netrunner lock screen: accent password ring in the active palette (i3lock-color), plus a
# battery-saving mode while locked: power-saver profile, media paused and the
# screen powered off after 10 s without input. Everything is restored on unlock.

pgrep -x i3lock >/dev/null && exit 0   # already locked

# Colours from the active palette (netrunner-theme) as bare lowercase hex,
# falling back to Netrunner if it has never been rendered
pal="${XDG_CONFIG_HOME:-$HOME/.config}/netrunner/current/colors.sh"
[ -r "$pal" ] && . "$pal"
hex() { printf '%s' "${1#\#}" | tr 'A-F' 'a-f'; }
bg=$(hex "${NR_BG:-#0A0B10}")
accent=$(hex "${NR_ACCENT:-#D0ED57}")
dim=$(hex "${NR_ACCENT_DIM:-#6B7A2E}")
dark=$(hex "${NR_ACCENT_DARK:-#2C3318}")
hi=$(hex "${NR_HI:-#5EF6FF}")
alert=$(hex "${NR_ALERT:-#FF2A4D}")

ac() { cat /sys/class/power_supply/AC/online 2>/dev/null; }
profile=$(powerprofilesctl get 2>/dev/null)
ac_before=$(ac)
dpms=$(xset q | awk '/Standby:/ {print $2, $4, $6}')

restore() {
    xset dpms $dpms
    if [ "$(ac)" = "$ac_before" ]; then
        [ -n "$profile" ] && powerprofilesctl set "$profile"
    elif [ "$(ac)" = 1 ]; then  # charger changed while locked: follow the udev rule
        powerprofilesctl set balanced
    else
        powerprofilesctl set power-saver
    fi
}
trap restore EXIT
trap 'exit 1' INT TERM

powerprofilesctl set power-saver 2>/dev/null
playerctl -a pause 2>/dev/null
xset dpms 10 10 10

# Strip --nofork if xss-lock passed it; we always stay in the foreground so
# the restore step runs after unlock.
for a; do shift; [ "$a" = --nofork ] || set -- "$@" "$a"; done

if ! i3lock --version 2>&1 | grep -q '\.c\.'; then
    set -- -c "$bg" "$@"
else

    font="Iosevka Nerd Font"
    set -- -c "$bg" \
    --indicator --clock \
    --radius 120 --ring-width 4 \
    --inside-color=00000000      --ring-color="$dark"ff \
    --insidever-color=00000000   --ringver-color="$hi"ff \
    --insidewrong-color=00000000 --ringwrong-color="$alert"ff \
    --line-color=00000000        --separator-color=00000000 \
    --keyhl-color="$accent"ff       --bshl-color="$alert"ff \
    --time-str="%H:%M"           --time-color="$accent"ff \
    --time-font="$font"          --time-size=40 \
    --date-str="%Y.%m.%d"        --date-color="$dim"ff \
    --date-font="$font"          --date-size=13 \
    --verif-text="DECRYPTING"    --verif-color="$hi"ff \
    --verif-font="$font"         --verif-size=16 \
    --wrong-text="ACCESS DENIED" --wrong-color="$alert"ff \
    --wrong-font="$font"         --wrong-size=16 \
    --noinput-text="NO INPUT"    --lock-text="LOCKING" \
    --modif-color="$alert"ff       --layout-color="$dim"ff \
    --greeter-text="// BREACH PROTOCOL :: ENTER ACCESS CODE" --greeter-color="$accent"ff \
    --greeter-font="$font"       --greeter-size=12 \
    --greeter-pos="ix:iy+150" \
    --ignore-empty-password --pass-media-keys \
    "$@"
fi

i3lock -n -e -f "$@" &
pid=$!
# i3lock inherited xss-lock's sleep-lock fd and releases it once the screen
# is locked; close our copy so it doesn't hold up suspend.
[ -n "$XSS_SLEEP_LOCK_FD" ] && eval "exec $XSS_SLEEP_LOCK_FD<&-"
wait $pid
