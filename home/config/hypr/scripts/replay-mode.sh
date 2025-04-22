#!/usr/bin/env bash

MONITOR=${1:-DP-1}

if [[ ! $(pidof gpu-screen-recorder) ]]; then
  notify-send "Replay mode on"
  gpu-screen-recorder -w "$MONITOR" -s 1920x1080 -a "default_output|default_input" -k hevc -bm cbr -q 8000 -f 60 -r 120 -c mp4 -o ~/Videos/Clips &

  wait $!

  exit $?
else
  notify-send "Replay mode off"
  killall -SIGINT gpu-screen-recorder
fi
