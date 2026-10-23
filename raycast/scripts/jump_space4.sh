#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Jump to Space 4
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💾
# @raycast.packageName Spaces

# Documentation:
# @raycast.description Quick jump to Program workspace
# @raycast.author keanu
# @raycast.authorURL https://raycast.com/708870622

code=21 # 4
osascript -e "tell application \"System Events\" to key code $code using control down"