#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Jump to Space
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.argument1 { "type": "text", "placeholder": "1-5" }
# @raycast.packageName Spaces

# Documentation:
# @raycast.description Quick jump to specific workspace
# @raycast.author keanu
# @raycast.authorURL https://raycast.com/708870622

# echo "Hello World! Argument1 value: "$1""

case "$1" in
  1) code=18 ;;
  2) code=19 ;;
  3) code=20 ;;
  4) code=21 ;;
  5) code=23 ;;
  *) echo "只支持 1-5" >&2; exit 1 ;;
esac

osascript -e "tell application \"System Events\" to key code $code using control down"