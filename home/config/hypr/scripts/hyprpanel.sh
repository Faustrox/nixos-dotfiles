#!/usr/bin/env bash

if [[ ! $(pidof hyprpanel) ]]; then
    uwsm-app -- hyprpanel
else
    hyprpanel -q
fi