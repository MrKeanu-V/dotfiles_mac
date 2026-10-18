#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# space_watch.sh —— 工作区区域（space.1..5）的**唯一**事件汇聚点
#
# 语义：
#   icon  = 「桌面编号 + 职责图标」，表示工作区桌面编号和职能
#   label = 当前工作区活跃APP，非活跃工作区则隐藏
#
# 数据流：
#   space_change          → 记录当前桌面 → 立即渲染（读缓存）→ 触发全量重扫
#   space_windows_change  → 更新该桌面缓存；若正是当前桌面则重绘
#
# 缓存（~/.cache/sketchybar/）：
#   space_apps.N    该桌面 App 名，一行一个（字典序，保证 label 顺序稳定不抖动）
#   space_strip.N   渲染好的图标串（惰性生成；apps 变化时显式删除）
#   space_current   当前桌面号
#
# 调试：touch ~/.cache/sketchybar/DEBUG  → 事件详情写入 ~/.cache/sketchybar/watch.log
# ─────────────────────────────────────────────────────────────

set -u

CONFIG_DIR="$HOME/.config/sketchybar"
CACHE_DIR="$HOME/.cache/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/my_colors.sh"
source "$PLUGIN_DIR/my_icon_map.sh"      # 提供 ICON_MODE / map_icon

SPACES=(1 2 3 4 5)
mkdir -p "$CACHE_DIR" 2>/dev/null

DEBUG_FLAG="$CACHE_DIR/DEBUG"
dbg() {
    [ -f "$DEBUG_FLAG" ] || return 0
    printf -- '--- %s SENDER=%s SID=%s INFO=%s\n' \
        "$(date '+%F %T')" "${SENDER:-}" "${SID:-}" "${INFO:-}" \
        >> "$CACHE_DIR/watch.log"
}

write_atomic() {                        # $1 = 目标文件；stdin = 内容
    local tmp="$CACHE_DIR/.$(basename "$1").$$"
    if cat > "$tmp"; then
        mv -f "$tmp" "$1"
    else
        rm -f "$tmp"; return 1
    fi
}

# ── 缓存：App 名 ──────────────────────────────────────────────
update_apps() {                         # $1 = space 号  $2 = space_windows_change 的 $INFO
    local idx="$1" payload="$2" f="$CACHE_DIR/space_apps.$1" rows

    # 没有 apps 字段 = 载荷异常（例如该 desktop 已被移除）→ 保持旧缓存，
    # 绝不用空数据覆盖（旧实现会写出 1 字节的 "\n"，导致 label 莫名变空）。
    printf '%s' "$payload" | jq -e 'has("apps")' >/dev/null 2>&1 || return 1

    rows="$(printf '%s' "$payload" | jq -r '(.apps // {}) | keys[]' 2>/dev/null)"

    # 有内容时**必须带行尾换行**：否则 `while IFS= read -r x` 读到没有换行的
    # 最后一行时会返回非 0，循环体不执行，单 App 的桌面就会渲染出空 label。
    # 无内容时写 0 字节（而不是 "\n"），这样 `[ -s ]` 能正确判定「无 App」。
    local data
    [ -n "$rows" ] && data="$rows"$'\n' || data=""

    # 内容没变就不写：既避免刷新 mtime，也避免无谓重建 strip。
    # 用 cmp 做逐字节比较（不能用 `$(cat f) = $rows`：命令替换会吃掉行尾换行，
    # 于是旧实现留下的 1 字节 "\n" 会被误判为「等价于空」，永远清理不掉）。
    if [ -f "$f" ] && printf '%s' "$data" | cmp -s - "$f"; then
        return 0
    fi

    printf '%s' "$data" | write_atomic "$f" || return 1
    rm -f "$CACHE_DIR/space_strip.$idx"  # 显式失效，比依赖 mtime 精度可靠
    return 0
}

# ── 渲染：图标串（惰性生成 + 缓存）───────────────────────────
strip_of() {                            # $1 = space 号 → stdout 图标串（无 App 则空）
    local idx="$1" apps="$CACHE_DIR/space_apps.$1" strip="$CACHE_DIR/space_strip.$1"
    [ -s "$apps" ] || return 0

    if [ ! -f "$strip" ]; then
        local out="" name
        # `|| [ -n "$name" ]`：兼容「最后一行没有换行」的文件（bash read 的经典坑）
        while IFS= read -r name || [ -n "$name" ]; do
            [ -n "$name" ] || continue
            out+="$(map_icon "$name") "
        done < "$apps"
        printf '%s' "${out% }" | write_atomic "$strip" || return 0   # 裁掉行尾多余空格
    fi
    cat "$strip"
}

# ── 渲染：5 个 item 一次性重绘（单次 IPC，无中间态闪烁）──────
render() {                              # $1 = 当前桌面号（省略则读缓存）
    local cur="${1:-}" n strip
    if [ -n "$cur" ]; then
        printf '%s' "$cur" | write_atomic "$CACHE_DIR/space_current"
    else
        cur="$(cat "$CACHE_DIR/space_current" 2>/dev/null || true)"
    fi
    [ -n "$cur" ] || return 0

    local args=()
    for n in "${SPACES[@]}"; do
        if [ "$n" = "$cur" ]; then
            strip="$(strip_of "$n")"
            if [ -n "$strip" ]; then
                args+=(--set "space.$n"
                       background.color=$BG_SPACE_ACTIVE
                       icon.color=$FG_ACTIVE
                       label.drawing=on
                       label="$strip")
            else
                args+=(--set "space.$n"
                       background.color=$BG_SPACE_ACTIVE
                       icon.color=$FG_ACTIVE
                       label.drawing=off
                       label="")
            fi
        else
            args+=(--set "space.$n"
                   background.color=$TRANSPARENT
                   icon.color=$FG_IDLE
                   label.drawing=off
                   label="")
        fi
    done
    sketchybar "${args[@]}"
}

# ── 事件入口 ─────────────────────────────────────────────────
case "${SENDER:-}" in
    space_change)
        dbg
        prev="$(cat "$CACHE_DIR/space_current" 2>/dev/null || true)"
        # $INFO = {"display-1": 3}（bar 为 display=main，单屏时只有 1 个 key）
        cur="$(printf '%s' "${INFO:-}" | jq -r 'to_entries | first | .value // empty' 2>/dev/null)"
        # 只接受 1..5；异常值（例如 reload 瞬间拿到 0）退回上次记录
        case "${cur:-}" in
            1|2|3|4|5) ;;
            *) cur="$prev" ;;
        esac
        render "${cur:-}"
        # 关键补丁：换桌面后强制重扫全部桌面，让 5 份缓存始终新鲜。
        # 不重扫的话，只有「窗口数量发生变化」的桌面才会更新缓存。
        # 仅在实际换桌面时触发：reload 时 sketchybar 常连发两次 space_change，
        # 不去重就会白跑两轮全量重扫（10 次 fork）。
        [ -n "${cur:-}" ] && [ "$cur" != "$prev" ] && sketchybar --trigger space_windows_change
        ;;

    space_windows_change)
        dbg
        idx="$(printf '%s' "${INFO:-}" | jq -r '.space // empty' 2>/dev/null)"
        [ -n "$idx" ] || exit 0
        update_apps "$idx" "${INFO:-}" || exit 0
        # 只有当前桌面的数据变了才重绘；其他桌面的 strip 留到下次进入时惰性生成
        if [ "$idx" = "$(cat "$CACHE_DIR/space_current" 2>/dev/null || true)" ]; then
            render
        fi
        ;;

    *)
        dbg
        render
        ;;
esac


