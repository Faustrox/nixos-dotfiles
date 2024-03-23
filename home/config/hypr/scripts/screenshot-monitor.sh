#!/usr/bin/env bash

grim -o "$(hyprctl activeworkspace -j | jq -r '.monitor')" - | wl-copy -t image/png