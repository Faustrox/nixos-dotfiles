#!/usr/bin/env bash

pkill eww
uwsm app -- eww daemon
eww open bar0
eww open topside-edge
eww open leftside-edge
eww open rightside-edge
eww open topbgcorner-left
eww open topbgcorner-right
eww open notifications_popup
# eww open taskbar-left
# eww open corner1
# eww open corner2
# python3 ~/.config/eww/scripts/notifications.py &
eww open bgcorner-right
eww open bgcorner-left

eww open bar1
eww open topside-edge --screen 1 --id topside-edge1
eww open leftside-edge --screen 1 --id leftside-edge1
eww open rightside-edge --screen 1 --id rightside-edge1
eww open topbgcorner-left --screen 1 --id topbgcorner-left1
eww open topbgcorner-right --screen 1 --id topbgcorner-right1 
eww open notifications_popup --screen 1 --id notifications_popup1
# eww open taskbar-left
# eww open corner1
# eww open corner2
# python3 ~/.config/eww/scripts/notifications.py &
eww open bgcorner-right --screen 1 --id bgcorner-right1
eww open bgcorner-left --screen 1 --id bgcorner-left1