#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title White Noise
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔊

if pgrep -f "afplay.*white-noise.mp3" >/dev/null; then
  pkill -f "afplay.*white-noise.mp3"
  echo "White noise stopped"
else
  while true; do
    afplay ~/RaycastScripts/white-noise.mp3
  done &
  disown
  echo "White noise started"
fi
