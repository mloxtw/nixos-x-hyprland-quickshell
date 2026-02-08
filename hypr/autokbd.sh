#!/bin/bash
# wait a bit to ensure Hyprland has detected devices
sleep 2
# disable internal keyboard
hyprctl keyword "device:asus-keyboard enabled false"

