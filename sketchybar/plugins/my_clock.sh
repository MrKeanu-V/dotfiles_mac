#!/usr/bin/env bash
# my_clock.sh —— 时间控件（默认 HH:MM）
sketchybar --set "$NAME" label="$(date '+%H:%M')"
# 想要「日期 + 星期」就换成下面这行：
# sketchybar --set "$NAME" label="$(date '+%m/%d %a %H:%M')"
