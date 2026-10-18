#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# my_inbox.sh —— 未读消息汇总（零权限 · 只读 Dock 角标）
#
# 数据源：lsappinfo info -only StatusLabel <bundle-id>
#         · 有未读   → "StatusLabel"={ "label"="3" }
#         · 已运行无未读 → "StatusLabel"={ "label"="" }
#         · 未运行   → 无输出
#
# 事件：update_freq=10 / mouse.clicked
# ─────────────────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/my_colors.sh"

ICON="󰇮"          # U+F01EE 信封

# 白名单：bundle id（数组顺序 = 点击打开时的优先级）
INBOX_APPS=(
    "com.tencent.xinWeChat"     # 微信
    "com.tencent.qq"            # QQ
    "com.electron.lark"         # 飞书
    "com.hnc.Discord"           # Discord
    "com.apple.MobileSMS"       # 信息
    "com.apple.mail"            # 邮件
)

count_unread() {    # $1 = bundle id → 打印未读数（读不到则 0）
    local raw n
    raw="$(lsappinfo info -only StatusLabel "$1" 2>/dev/null)"
    n="$(printf '%s' "$raw" | sed -n 's/.*"label"="\([0-9][0-9]*\)".*/\1/p')"
    printf '%s' "${n:-0}"
}

total=0
first=""
for b in "${INBOX_APPS[@]}"; do
    c="$(count_unread "$b")"
    case "$c" in ''|*[!0-9]*) continue ;; esac
    [ "$c" -gt 0 ] || continue
    total=$(( total + c ))
    [ -z "$first" ] && first="$b"
done

# 点击 → 打开第一个有未读的 App
if [ "$SENDER" = "mouse.clicked" ]; then
    [ -n "$first" ] && open -b "$first" >/dev/null 2>&1
fi

if [ "$total" -gt 0 ]; then
    sketchybar --set "$NAME" \
        drawing=on \
        icon="$ICON" \
        icon.color=$RED \
        label="$total" \
        label.color=$WHITE
else
    sketchybar --set "$NAME" drawing=off icon="" label=""
fi
