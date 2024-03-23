#!/usr/bin/env bash

if [[ ! $(pidof waybar) ]]; then
    waybar
else
    pkill waybar
fi