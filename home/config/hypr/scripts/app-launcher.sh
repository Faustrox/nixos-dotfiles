#!/usr/bin/env bash

if [[ ! $(pidof wofi) ]]; then
    wofi --show drun --columns 2 -I
else
    pkill wofi
fi