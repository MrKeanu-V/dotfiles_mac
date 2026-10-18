#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# my_battery.sh —— 电量控件（图标随电量变化 · 颜色区分状态）
# 事件：update_freq=60 / system_woke（在 sketchybarrc 里订阅）
# 说明：原版 plugins/laptop/battery.sh 保持原样不动（约定见设计文档 §5.4）；
#       本脚本是它的自研替代：纯 bash 3.2 兼容、五档图标、充电/低电用颜色区分。
# 字形（码点名取自 Nerd Fonts v3.2.1 官方 glyphnames.json；已用
#       `fc-list ":charset=0x…"` 逐码点确认被本机 Hack Nerd Font 覆盖）：
#   󰂂 md-battery_90 U+F0082    󰂀 md-battery_70 U+F0080
#   󰁾 md-battery_50 U+F007E    󰁼 md-battery_30 U+F007C
#   󰁺 md-battery_10 U+F007A
# 设计取舍：原版「充电时把图标换成闪电」会遮掉电量图标；
#           这里改为「图标永远反映电量 + 用颜色表示状态」，更符合「图标随电量变化」的诉求。
# ⚠️ 图标必须与电量档位一一对应：md-battery_10/30/50/70/90 是「数字越大越满」，
#    不要写成 md-battery_40 之类错位档（本文件初版就踩过这个坑，2026-10-15 修正）。
# ─────────────────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/my_colors.sh"

BATT="$(pmset -g batt 2>/dev/null)"
PERCENTAGE="$(printf '%s' "$BATT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
[ -z "$PERCENTAGE" ] && exit 0          # 无电池（台式机/读不到）→ 保持上一次显示

# 充电状态：pmset 输出形如
#   充电中  `79%; charging; 0:45 remaining`      满电  `100%; charged; 0:00 remaining`
#   接电不充 `79%; AC attached; not charging`    用电池 `79%; discharging; 3:00 remaining`
# 所以不能用 `grep 'AC Power'`（那会把「接了电源但未充电」也当成充电中，
# 因为此时并不显示"; charging"）；精确匹配「分号 + 空格 + charging/charged」。
CHARGING=0
case "$BATT" in
    *"; charging"*|*"; charged"*) CHARGING=1 ;;
esac

# ── 档 1：图标（五档，随电量变化） ──
if   [ "$PERCENTAGE" -ge 80 ]; then ICON="󰂂"
elif [ "$PERCENTAGE" -ge 60 ]; then ICON="󰂀"
elif [ "$PERCENTAGE" -ge 40 ]; then ICON="󰁾"
elif [ "$PERCENTAGE" -ge 20 ]; then ICON="󰁼"
else                                    ICON="󰁺"
fi

# ── 档 2：颜色（状态） ──
if   [ "$CHARGING" = "1" ];      then ICON_COLOR=$YELLOW    # 充电中
elif [ "$PERCENTAGE" -le 15 ];   then ICON_COLOR=$RED       # 危险
elif [ "$PERCENTAGE" -le 30 ];   then ICON_COLOR=$ORANGE    # 偏低
else                                  ICON_COLOR=$GREEN    # 正常
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$ICON_COLOR" \
    label="${PERCENTAGE}%"
