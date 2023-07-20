#!/usr/bin/env bash

width=2240
gappx=20
barheight=30

base01=#3c3836
base03=#665c54
base05=#d5c4a1

dwm-msg --ignore-reply subscribe client_focus_change_event |
    jq --unbuffered '.client_focus_change_event.new_win_id' |
    while IFS=$'\n' read -r winid
    do
        if [[ $winid == "null" ]]
        then
            echo
        else
            class=$(xprop -id "$winid" | grep ^WM_CLASS | sed 's/^.* = ".*", "\(.*\)"$/\1/')
            echo "%{c}$class" | awk 'length > 20{$0=substr($0,0,21)"..."}1'
        fi
    done |
    lemonbar -d -g "400x$barheight+$gappx+$gappx" \
             -o eDP -f "RobotoMono Nerd Font:size=9:weight=200" \
             -B "$base01" -F "$base05" &

dwm-msg --ignore-reply subscribe tag_change_event |
    jq --unbuffered '.tag_change_event.new_state | .selected, .occupied' |
    while IFS=$'\n' read -r selected && read -r occupied
    do
        out=""

        for tag in {0..8}
        do
            bit=$((1 << tag))

            if [[ $((selected & bit)) -ne 0 && $((occupied & bit)) -ne 0 ]]
            then
                out="${out}%{F$base05}  \uf192  "
            elif [[ $((selected & bit)) -ne 0 ]]
            then
                out="${out}%{F$base05}  \uf111  "
            elif [[ $((occupied & bit)) -ne 0 ]]
            then
                out="${out}%{F$base03}  \uf192  "
            else
                out="${out}%{F$base03}  \uf111  "
            fi
        done

        echo -e "%{F-}%{B-}%{c}$out%{F-}%{B-}"
    done |
    lemonbar -d -g "300x$barheight+$((width / 2 - 150))+$gappx" \
             -o eDP -f "Font Awesome 5 Free:size=7:style=solid" \
             -B "$base01" -F "$base05" &

while true
do
    amixin=$(amixer sget Master)

    if [[ $(awk -F" " '/Left:/ { print $6 }' <<< "$amixin") == "[off]" ]]
    then
        vol="\uf6a9 Mute"
    else
        vol="\uf027 $(awk -F"[][]" '/Left:/ { print $2 }' <<< "$amixin")"
    fi

    bat="\uf240$(acpi --battery | cut -d, -f2)"

    echo -e "%{c}$vol  $bat"
    sleep 5
done |
    lemonbar -d -g "200x$barheight+$((width - 300 - gappx * 2))+$gappx" \
             -o eDP -f "RobotoMono Nerd Font:size=9:weight=200" \
             -f "Font Awesome 5 Free:size=12:style=solid" \
             -B "$base01" -F "$base05" &

while true
do
    echo "%{c}$(date +'%I:%M')"
    sleep 60
done |
    lemonbar -d -g "100x$barheight+$((width - 100 - gappx))+$gappx" \
             -o eDP -f "RobotoMono Nerd Font:size=9:weight=200" \
             -B "$base01" -F "$base05" &
