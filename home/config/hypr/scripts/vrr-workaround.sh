#!/usr/bin/env bash

sleep 3 &

hyprctl keyword monitor DP-1, disable, 1920x0, 1, vrr, 1

hyprctl keyword monitor DP-1, highres, 1920x0, 1, vrr, 1

sleep 1 & hyprctl reload