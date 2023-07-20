#!/bin/sh

while :; do
    xsetroot -name "| $(brightnessctl g)/$(brightnessctl m) | B:$(acpi --battery | cut -d, -f2) | V: $(amixer get Master | awk -F'[][]' 'END{ print $2 }') | $(date "+%b %d (%a) %I:%M%p") |" | tr "\n" " "
    sleep 1m
done
