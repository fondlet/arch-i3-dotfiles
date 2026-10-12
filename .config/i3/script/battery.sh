#!/bin/bash
# Battery level for i3blocks: picks a Nerd Font glyph matching the actual
# charge level (rounded to nearest 10%), so the icon visually reflects how
# full the battery is instead of always showing a static full-battery icon.

declare -A discharge
discharge[0]="󰂎"
discharge[10]="󰁺"
discharge[20]="󰁻"
discharge[30]="󰁼"
discharge[40]="󰁽"
discharge[50]="󰁾"
discharge[60]="󰁿"
discharge[70]="󰂀"
discharge[80]="󰂁"
discharge[90]="󰂂"
discharge[100]="󰁹"

declare -A charge
charge[0]="󰢟"
charge[10]="󰢜"
charge[20]="󰂆"
charge[30]="󰂇"
charge[40]="󰂈"
charge[50]="󰢝"
charge[60]="󰂉"
charge[70]="󰢞"
charge[80]="󰂊"
charge[90]="󰂋"
charge[100]="󰂅"

read -r status pct <<< "$(acpi -b | awk -F'[,:] *' '{gsub("%","",$3); print $2, $3}')"

if [ -z "$pct" ]; then
    exit 0
fi

decile=$(( ( (pct + 5) / 10 ) * 10 ))
[ "$decile" -gt 100 ] && decile=100
[ "$decile" -lt 0 ] && decile=0

if [ "$status" = "Charging" ]; then
    icon="${charge[$decile]}"
else
    icon="${discharge[$decile]}"
fi

echo "$icon ${pct}%"
