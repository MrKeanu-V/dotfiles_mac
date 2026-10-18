#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# my_icon_map.sh —— App 名称 → 图标（双模自适应）
#  模式 A：本机装了 sketchybar-app-font → 输出 :字形: 连字（真 App logo）
#  模式 B：没装 → 输出 Nerd 字形（Hack Nerd Font，逐码点核对过覆盖率）
#
# 实测结论（sketchybar v2.24.0：源码 + 二进制 + 官方文档三方核对）：
#  ① icon.font 只接受「单个」字体 "family:style:size"，逗号字体链会被静默丢弃
#     （src/font.c font_set 用 sscanf("%254[^:]:%254[^:]:%f") 解析）
#     → 连字字形与 Nerd 字形不能同时出现在一个 item 上，必须按状态切换 icon.font。
#  ② 本字体只有 Regular 字重；连字名 == 输入串本身（如 :google_chrome:）。
#  ③ :default: 兜底字形确实存在 → 认不出的 App 用它，可避免「混字体 tofu」。
# 用法：source 后调用 map_icon "App Name"；或 bash my_icon_map.sh "App Name" 手动调试
# 注意：对 plugins/icon_map.sh 只做「只读调用」，绝不修改原版文件。
# ─────────────────────────────────────────────────────────────

CONFIG_DIR="$HOME/.config/sketchybar"

# 该字体必须对 CoreText（macOS 应用）可见，所以检查字体文件而不只是 fc-list
app_font_installed() {
    find "$HOME/Library/Fonts" "/Library/Fonts" -maxdepth 2 -iname '*sketchybar-app-font*' \
        -print -quit 2>/dev/null | grep -q .
}

if app_font_installed; then ICON_MODE=A; else ICON_MODE=B; fi

# 各模式应配的 icon.font（单字体字符串；由调用方设置，见 plugins/my_space.sh）
ICON_FONT_NERD="Hack Nerd Font:Bold:15.0"
ICON_FONT_APP="sketchybar-app-font:Regular:17.0"

# ── 模式 A 第一来源：已验证的 App → :字形: ──
# 生成方式：读字体 post 表 636 个字形名反向核对（temp/_gen_aliases.py），只收录确实存在的
curated_icon() {
    case "$1" in
        "Finder")                printf '%s' ":finder:" ;;
        "Terminal")              printf '%s' ":terminal:" ;;
        "iTerm2")                printf '%s' ":iterm:" ;;
        "Warp")                  printf '%s' ":warp:" ;;
        "Ghostty")               printf '%s' ":ghostty:" ;;
        "Alacritty")             printf '%s' ":alacritty:" ;;
        "kitty")                 printf '%s' ":kitty:" ;;
        "Visual Studio Code")    printf '%s' ":code:" ;;
        "Cursor")                printf '%s' ":cursor:" ;;
        "Zed")                   printf '%s' ":zed:" ;;
        "Xcode")                 printf '%s' ":xcode:" ;;
        "Sublime Text")          printf '%s' ":sublime_text:" ;;
        "Google Chrome")         printf '%s' ":google_chrome:" ;;
        "Safari")                printf '%s' ":safari:" ;;
        "Firefox")               printf '%s' ":firefox:" ;;
        "Microsoft Edge")        printf '%s' ":microsoft_edge:" ;;
        "Arc")                   printf '%s' ":arc:" ;;
        "Brave")                 printf '%s' ":brave_browser:" ;;
        "Brave Browser")         printf '%s' ":brave_browser:" ;;
        "Notes")                 printf '%s' ":notes:" ;;
        "TextEdit")              printf '%s' ":textedit:" ;;
        "Preview")               printf '%s' ":preview:" ;;
        "Photos")                printf '%s' ":photos:" ;;
        "QuickTime Player")      printf '%s' ":quicktime:" ;;
        "Calendar")              printf '%s' ":calendar:" ;;
        "Messages")              printf '%s' ":messages:" ;;
        "Mail")                  printf '%s' ":mail:" ;;
        "Reminders")             printf '%s' ":reminders:" ;;
        "Maps")                  printf '%s' ":maps:" ;;
        "System Settings")       printf '%s' ":system_information:" ;;
        "System Preferences")    printf '%s' ":system_information:" ;;
        "Activity Monitor")      printf '%s' ":activity_monitor:" ;;
        "Calculator")            printf '%s' ":calculator:" ;;
        "App Store")             printf '%s' ":app_store:" ;;
        "Music")                 printf '%s' ":music:" ;;
        "Spotify")               printf '%s' ":spotify:" ;;
        "Podcasts")              printf '%s' ":podcasts:" ;;
        "TV")                    printf '%s' ":apple_tv:" ;;
        "iTunes")                printf '%s' ":music:" ;;
        "网易云音乐")                 printf '%s' ":netease_music:" ;;
        "QQ音乐")                  printf '%s' ":qqmusic:" ;;
        "QQ")                    printf '%s' ":qq:" ;;
        "WeChat")                printf '%s' ":wechat:" ;;
        "微信")                    printf '%s' ":wechat:" ;;
        "Telegram")              printf '%s' ":telegram:" ;;
        "Discord")               printf '%s' ":discord:" ;;
        "Slack")                 printf '%s' ":slack:" ;;
        "Zoom")                  printf '%s' ":zoom:" ;;
        "Notion")                printf '%s' ":notion:" ;;
        "Obsidian")              printf '%s' ":obsidian:" ;;
        "Figma")                 printf '%s' ":figma:" ;;
        "Sketch")                printf '%s' ":sketch:" ;;
        "Docker")                printf '%s' ":docker:" ;;
        "Fork")                  printf '%s' ":fork:" ;;
        "Tower")                 printf '%s' ":tower:" ;;
        "Postman")               printf '%s' ":postman:" ;;
        "Insomnia")              printf '%s' ":insomnia:" ;;
        "Excel")                 printf '%s' ":microsoft_excel:" ;;
        "Word")                  printf '%s' ":microsoft_word:" ;;
        "Numbers")               printf '%s' ":numbers:" ;;
        "Pages")                 printf '%s' ":pages:" ;;
        "Keynote")               printf '%s' ":keynote:" ;;
        "VLC")                   printf '%s' ":vlc:" ;;
        "IINA")                  printf '%s' ":iina:" ;;
        "Transmission")          printf '%s' ":transmission:" ;;
        "Alfred")                printf '%s' ":alfred:" ;;
        "Raycast")               printf '%s' ":raycast:" ;;
        "1Password")             printf '%s' ":one_password:" ;;
        "Dropbox")               printf '%s' ":dropbox:" ;;
        "Google Drive")          printf '%s' ":google_drive:" ;;
        "Adobe Photoshop")       printf '%s' ":photoshop:" ;;
        "Adobe Illustrator")     printf '%s' ":illustrator:" ;;
        "Blender")               printf '%s' ":blender:" ;;
        "Unity")                 printf '%s' ":unity:" ;;
        "Godot")                 printf '%s' ":godot:" ;;
        "PyCharm")               printf '%s' ":pycharm:" ;;
        "IntelliJ IDEA")         printf '%s' ":idea:" ;;
        "GoLand")                printf '%s' ":goland:" ;;
        "Rider")                 printf '%s' ":rider:" ;;
        "Neovim")                printf '%s' ":neovim:" ;;
        "Vim")                   printf '%s' ":vim:" ;;
        "钉钉")                    printf '%s' ":dingtalk:" ;;
        "飞书")                    printf '%s' ":feishu:" ;;
        "百度网盘")                  printf '%s' ":baidunetdisk:" ;;
        "访达")                    printf '%s' ":finder:" ;;
        "终端")                    printf '%s' ":terminal:" ;;
        "系统设置")                  printf '%s' ":system_information:" ;;
        "活动监视器")                 printf '%s' ":activity_monitor:" ;;
        "预览")                    printf '%s' ":preview:" ;;
        "照片")                    printf '%s' ":photos:" ;;
        "音乐")                    printf '%s' ":music:" ;;
        "日历")                    printf '%s' ":calendar:" ;;
        "备忘录")                   printf '%s' ":notes:" ;;
        *)  printf '' ;;
    esac
}

# 模式 A 第二来源：上游 plugins/icon_map.sh（覆盖本表没收录的名字）
shortcode_icon() {
    local sc
    sc="$(/bin/bash "$CONFIG_DIR/plugins/icon_map.sh" "$1" 2>/dev/null)"
    [ -n "$sc" ] && printf '%s' "$sc"
}

# ── 模式 B：Nerd 字形表 ──
# 注：下方字形码点均由 Nerd Fonts v3.2.1 glyphnames.json 反查确认，勿手打（U+E7FC=Arc 属 v2 遗留码点，Hack Nerd Font 仍有字形）
nerd_icon() {
    case "$1" in
        *Arc*)                                                     printf %s "" ;;
        *Safari*|*Chrome*|*Firefox*|*Brave*|*Edge*)                printf %s "" ;;
        *Code*|*Cursor*|*Zed*)                                     printf %s "󰨞" ;;
        *Terminal*|*iTerm*|*Warp*|*Ghostty*|*kitty*|*Alacritty*)   printf %s "" ;;
        Finder)                                                    printf %s "󰀶" ;;
        *网易*|*Netease*|Music|Spotify)                            printf %s "" ;;
        *WeChat*|*微信*)                                           printf %s "" ;;
        QQ)                                                        printf %s "" ;;
        *Message*|*Telegram*|*Discord*)                            printf %s "" ;;
        *Mail*|*邮件*)                                             printf %s "" ;;
        *Calendar*|*日历*)                                         printf %s "" ;;
        *Notion*|*Obsidian*|*Note*|*备忘录*)                       printf %s "" ;;
        *Slack*|*Zoom*|*Teams*)                                    printf %s "" ;;
        *"System Settings"*|*"System Preferences"*|*设置*)         printf %s "" ;;
        *Preview*|*预览*)                                          printf %s "" ;;
        *)                                                         printf %s "󰣆" ;;
    esac
}

map_icon() {
    if [ "$ICON_MODE" = A ]; then
        local out
        out="$(curated_icon "$1")"
        [ -z "$out" ] && out="$(shortcode_icon "$1")"
        [ -z "$out" ] && out=":default:"     # 字体自带兜底字形 → 不会出现 tofu
        printf '%s' "$out"
    else
        nerd_icon "$1"
    fi
}

# 作为独立脚本执行时（而非被 source）才输出，方便手动调试
if [ "${BASH_SOURCE[0]}" = "$0" ]; then map_icon "$1"; fi
