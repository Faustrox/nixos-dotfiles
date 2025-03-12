#!/usr/bin/env bash

if [[ ! $(pidof fuzzel) ]]; then
    uwsm app -s b -- fuzzel & # wofi --show drun --columns 2 -I
else
    pkill fuzzel
fi
