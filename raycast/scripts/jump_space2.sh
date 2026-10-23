#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Jump to Space 2
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌐
# @raycast.packageName Spaces

# Documentation:
# @raycast.description Quick jump to Browser workspace
# @raycast.author keanu
# @raycast.authorURL https://raycast.com/708870622

code=19 # 2
osascript -e "tell application \"System Events\" to key code $code using control down"