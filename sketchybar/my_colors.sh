#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# my_colors.sh —— 本配置自用调色板（Catppuccin Macchiato 派生）
# 只被 sketchybarrc 与 plugins/my_*.sh 引用；
# 故意不命名为 colors.sh，以免改变 FelixKratz 原版插件的行为。
# ─────────────────────────────────────────────────────────────

# 基础色
BLACK=0xff181926
WHITE=0xffcad3f5
GREY=0xff939ab7
RED=0xffed8796
GREEN=0xffa6da95
YELLOW=0xffeed49f
ORANGE=0xfff5a97f
BLUE=0xff8aadf4
MAGENTA=0xffc6a0f6
CYAN=0xff91d7e3
TRANSPARENT=0x00000000

# 语义色（本配置使用）
BG_BAR=0xff1e1e2e             # 底栏底色
BG_SPACE_ACTIVE=0x33f5a97f    # 当前 space 底色（20% 橙）
FG_ACTIVE=$ORANGE             # 当前 space 图标色
FG_IDLE=$GREY                 # 非当前 space 图标色
FG_LABEL=$WHITE               # 常规文字色

# 兼容命名（若将来照抄原版插件，其变量名也能对上）
BACKGROUND_1=0xff24273a
BACKGROUND_2=0xff363a4f
FOREGROUND=$WHITE
ICON_COLOR_ACTIVE=$FG_ACTIVE
ICON_COLOR_INACTIVE=$FG_IDLE
