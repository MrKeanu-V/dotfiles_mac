#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# space_click.sh —— 点击 space.$N 切换到对应桌面
#
# 日志：~/.cache/sketchybar/click.log（rc + osascript stderr）
# ─────────────────────────────────────────────────────────────

set -u

CACHE_DIR="$HOME/.cache/sketchybar"
mkdir -p "$CACHE_DIR" 2>/dev/null

# 
[ "${SENDER:-}" = "mouse.clicked" ] || exit 0

[ "${BUTTON:-}" = "left" ] || exit 0

[ "${SELECTED:-}" = "true" ] && exit 0

# SID 由 sketchybar 注入
sid="${SID:-}"
[ -n "$sid" ] || sid="${NAME##*.}"

case "$sid" in
    1) kc=18 ;;   # Ctrl+1
    2) kc=19 ;;   # Ctrl+2
    3) kc=20 ;;   # Ctrl+3
    4) kc=21 ;;   # Ctrl+4
    5) kc=23 ;;   # Ctrl+5  ← 23；22 是 Ctrl+6
    *) exit 0 ;;
esac

err="$(/usr/bin/osascript \
        -e "tell application \"System Events\" to key code $kc using control down" 2>&1)"
rc=$?

printf '%s SID=%s kc=%s rc=%s %s\n' \
    "$(date '+%F %T')" "$sid" "$kc" "$rc" "${err:-OK}" >> "$CACHE_DIR/click.log"

exit 0
