#!/usr/bin/env bash

if [[ ! $(pidof gpu-screen-recorder) ]]; then
  notify-send "Enable Replay Mode first"  
else
  killall -SIGUSR1 gpu-screen-recorder &

  sleep 1 && wait $!

  notify-send "Clip saved"
  killall -SIGINT gpu-screen-recorder

  exit $?
fi