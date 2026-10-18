#!/usr/bin/env bash
# CPU 占用：数据由 stats_provider 通过 system_stats 事件注入 CPU_USAGE
if [ "$SENDER" = "mouse.clicked" ]; then
    open -a "Activity Monitor"
    exit 0
fi

[ -z "$CPU_USAGE" ] && exit 0

sketchybar --set "$NAME" label="${CPU_USAGE}%"
