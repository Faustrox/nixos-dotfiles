#!/usr/bin/env bash

# Use "hyprctl -j monitors" to determine the parameters for the lock and unlock positions.
unlockedMonitorYPositions=(0 360)
lockedMonitorYPositions=(1500 1500)

monitors=$(hyprctl -j monitors)
tailMonitorIndex=$(($(echo "$monitors" | jq length)-1))
monitorIndices=$(seq 0 $tailMonitorIndex)

if [ "$1" == "" ]; then
	monitorUnlocked=0
	for monitorIndex in $monitorIndices; do
		monitor=$(echo "$monitors" | jq -c ".[$monitorIndex]")
		
		unlockedMonitorYPosition=${unlockedMonitorYPositions[$monitorIndex]}
	
		if [ $(echo "$monitor" | jq -j ".y") -eq $unlockedMonitorYPosition ]; then continue; fi
	
		hyprctl keyword monitor $(echo "$monitor" | jq -j ".name"),$(echo "$monitor" | jq -j ".width")x$(echo "$monitor" | jq -j ".height")@$(echo "$monitor" | jq -j ".refreshRate"),$(echo "$monitor" | jq -j ".x")x$unlockedMonitorYPosition,$(echo "$monitor" | jq -j ".scale") > /dev/null
		
		monitorUnlocked=1
		
		echo Unlocked monitor $monitorIndex
	done

	if [ $monitorUnlocked -eq 1 ]; then exit; fi

	for monitorIndex in $monitorIndices; do
		monitor=$(echo "$monitors" | jq -c ".[$monitorIndex]")
		
		if [ $(echo "$monitor" | jq -j ".focused") == "false" ]; then continue; fi
		
		hyprctl keyword monitor $(echo "$monitor" | jq -j ".name"),$(echo "$monitor" | jq -j ".width")x$(echo "$monitor" | jq -j ".height")@$(echo "$monitor" | jq -j ".refreshRate"),$(echo "$monitor" | jq -j ".x")x${lockedMonitorYPositions[$monitorIndex]},$(echo "$monitor" | jq -j ".scale") > /dev/null
		
		echo Locked monitor $monitorIndex
		exit
	done
elif [ "$1" == "status" ]; then
	for monitorIndex in $monitorIndices; do
		if [ $(echo "$monitors" | jq -j ".[$monitorIndex].y") -eq ${unlockedMonitorYPositions[$monitorIndex]} ];
			then echo Monitor $monitorIndex: Unlocked
			else echo Monitor $monitorIndex: Locked;
		fi
	done
	exit
elif [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "-help" ] || [ "$1" == "--help" ]; then
	echo Usage:
	echo -e "\thyprlock status"
	echo -e "\thyprlock [monitor_id]"
	exit
fi

if ! [[ $1 =~ ^[0-9]+$ ]]; then
	echo "Error: Invalid parameter value was provided."
	echo "[monitor_id] must be an integer."
	exit 1
fi

if [ $1 -lt 0 ] || [ $tailMonitorIndex -lt $1 ]; then
	echo "Error: The provided [monitor_id] is out of range."
	echo "[monitor_id] must be an integer from 0 to $tailMonitorIndex."
	exit 2
fi

monitor=$(echo "$monitors" | jq -c ".[$1]")

unlockedMonitorYPosition=${unlockedMonitorYPositions[$1]}

if [ $(echo "$monitor" | jq -j ".y") -eq $unlockedMonitorYPosition ]; then
	hyprctl keyword monitor $(echo "$monitor" | jq -j ".name"),$(echo "$monitor" | jq -j ".width")x$(echo "$monitor" | jq -j ".height")@$(echo "$monitor" | jq -j ".refreshRate"),$(echo "$monitor" | jq -j ".x")x${lockedMonitorYPositions[$monitorIndex]},$(echo "$monitor" | jq -j ".scale") > /dev/null
		
	echo Locked monitor $1
	exit
fi
	
hyprctl keyword monitor $(echo "$monitor" | jq -j ".name"),$(echo "$monitor" | jq -j ".width")x$(echo "$monitor" | jq -j ".height")@$(echo "$monitor" | jq -j ".refreshRate"),$(echo "$monitor" | jq -j ".x")x$unlockedMonitorYPosition,$(echo "$monitor" | jq -j ".scale") > /dev/null
	
echo Unlocked monitor $1