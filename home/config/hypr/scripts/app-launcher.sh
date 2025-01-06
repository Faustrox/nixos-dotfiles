#!/usr/bin/env bash

if [[ ! $(pidof fuzzel) ]]; then
    fuzzel # wofi --show drun --columns 2 -I
else
    pkill fuzzel
fi