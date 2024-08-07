#!/usr/bin/env bash

swww-daemon &
dunst &
waybar &

wl-paste --type text --watch cliphist store & #Stores only text data
wl-paste --type image --watch cliphist store & #Stores only text data
wl-clip-persist --clipboard regular &

easyeffects --gapplication-service &