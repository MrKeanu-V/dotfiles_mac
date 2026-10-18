// 通过「系统设置 → 控制中心 → 自动隐藏和显示菜单栏」切换菜单栏
// 用法: osascript -l JavaScript menubar_ui.js <0|1|2>
//   0 = 始终（菜单栏自动隐藏）
//   1 = 仅在桌面视图下
//   2 = 仅在全屏幕视图下（菜单栏常驻显示）
//
// 为什么不用 defaults：
//   macOS 26 上写 NSGlobalDomain _HIHideMenuBar 后，WindowServer 不会重读，
//   菜单栏状态不会改变（实测）；而「系统设置」内部走 WindowServer 私有接口，
//   切换即刻生效，所以这里驱动它的 UI。
// 退出码：0 成功（含已是目标状态）；1 失败。
function run(argv) {
  var target = parseInt(argv[0], 10);
  if (isNaN(target) || target < 0 || target > 2) {
    console.log("ERR: target must be 0|1|2");
    return 1;
  }

  var se = Application("System Events");
  var p = se.processes.byName("System Settings");

  // 等「系统设置」窗口就绪（最多 8 秒，脚本已被 open 唤起）
  var i, w, n;
  for (i = 0; i < 80; i++) {
    try {
      if (p.exists() && p.windows.length > 0) break;
    } catch (e) {}
    delay(0.1);
  }

  var TITLE = ["自动隐藏和显示菜单栏", "Automatically hide and show the menu bar"];
  // 下拉三档，顺序固定：0=始终 1=仅在桌面视图下 2=仅在全屏幕视图下
  var LABELS_ZH = ["始终", "仅在桌面视图下", "仅在全屏幕视图下"];
  var LABELS_EN = ["Always", "Only on Desktop", "Only in Full Screen"];

  function findButton() {
    var wins;
    try {
      wins = p.windows();
    } catch (e) {
      return null;
    }
    for (w = 0; w < wins.length; w++) {
      var all;
      try {
        all = wins[w].entireContents();
      } catch (e2) {
        continue;
      }
      for (n = 0; n < all.length; n++) {
        try {
          if (all[n].role() !== "AXPopUpButton") continue;
          var name = all[n].name() || "";
          for (var t = 0; t < TITLE.length; t++) {
            if (name === TITLE[t]) return all[n];
          }
        } catch (e3) {}
      }
    }
    return null;
  }

  var btn = findButton();
  if (!btn) {
    console.log("ERR: 找不到「自动隐藏和显示菜单栏」下拉框");
    return 1;
  }

  var value = btn.value() || "";
  var cur = LABELS_ZH.indexOf(value);
  if (cur < 0) cur = LABELS_EN.indexOf(value);
  if (cur < 0) {
    console.log("ERR: 无法识别的当前值: " + value);
    return 1;
  }

  if (cur === target) {
    console.log("noop: 已是目标状态 (" + value + ")");
    return 0;
  }

  // 打开下拉后用方向键走到目标项再回车（SwiftUI 的菜单项不在 AX 树里）
  var delta = target - cur;
  btn.click();
  delay(0.7);
  for (i = 0; i < Math.abs(delta); i++) {
    se.keyCode(delta > 0 ? 125 : 126); // 125=↓ 126=↑
    delay(0.18);
  }
  se.keyCode(36); // Return
  delay(0.9);

  console.log("ok: " + value + " -> " + (btn.value() || "?"));
  return 0;
}
