#!/usr/bin/env bash
# A simple array of icons that look like a rotating Nix logo or snowflake
# You can use different Nerd Font icons here
frames=("" "" "" "") 

while true; do
  for frame in "${frames[@]}"; do
    echo "$frame"
    sleep 0.5
  done
done
