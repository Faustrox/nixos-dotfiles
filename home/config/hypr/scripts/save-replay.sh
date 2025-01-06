#!/usr/bin/env bash

if [[ ! $(pidof gpu-screen-recorder) ]]; then
  notify-send "Enable Replay Mode first"  
else
  notify-send "Saving replay"
  killall -SIGUSR1 gpu-screen-recorder
fi