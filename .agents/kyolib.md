# LIB_KyoLib 首选 API（AI）

何时读：在 `LIB_KyoLib` 新增/改工具、加载、延时、存档 IO、按钮工具，或不确定该用哪套类。包落点见下文；通用模块入口见 [`modules.md`](modules.md)。

---

## MUST

| # | 域 | 首选 | 说明 |
|---|----|------|------|
| 1 | 文本/字节 HTTP | `KyoURLoader` | GET/POST、二进制；**不要**用 `AJAX` 写新代码 |
| 2 | 显示对象加载 | `KyoLoaderLite` | `load` / `loadLoader`；二进制可再委托 URLoader |
| 3 | 游戏内延时 | `KyoTimeout` | 须先 `init`；帧同步（`setFrameout` / 毫秒转帧） |
| 4 | 广告/可暂停延时 | `KyoTimerUtils` | 真实 `Timer`；支持 `pauseAllTimer` / `resumeAllTimer` |
| 5 | AIR 本地文件 | `FileUtils` | **仅 AIR**（`flash.filesystem`）；壳存档读写 |
| 6 | SharedObject 快照 | `net.play5d.kyo.storage.KyoSharedObject` | 简单 load/save |
| 7 | 媒体容器播放 | `net.play5d.kyo.media.SuperPlayer` | ppt/页内播放器 |

## NEVER

- 合并 `KyoTimeout` 与 `KyoTimerUtils`（时钟与暂停语义不同）
- 合并 `KyoURLoader` 与 `KyoLoaderLite`（URLLoader ≠ Display Loader）
- 合并游戏 `BtnUtils` 与库 `KyoBtnUtils`（见下节）
- 新代码依赖 `AJAX`、未标注用途的根包杂类

---

## 延时对照

| | `KyoTimeout` | `KyoTimerUtils` |
|--|--------------|-----------------|
| 驱动 | `ENTER_FRAME` | `flash.utils.Timer` |
| 典型 | 战斗/UI/关卡节奏 | Mob 广告 SDK、应用暂停需冻结 |
| 本仓 | `MainGame`、`MusouUI`、`GameOverStage`、`LANClientCtrl` | `launch`、ads |

---

## 按钮：评估结论 — **不要合并**

| | `net.play5d.game.bvn.utils.BtnUtils` | `net.play5d.kyo.utils.KyoBtnUtils` |
|--|--------------------------------------|-----------------------------------|
| 层 | 游戏内核 | KyoLib（壳 LAN UI） |
| 能力 | 触控 + `SoundCtrl` 点击音 + 色变 | TweenLite 按下变暗/弹性；`initSampleBtn` |
| 依赖 | `GameConfig` / `SoundCtrl` | Greensock |

两套签名与依赖不同；并入会把游戏音效/触控拖进库，或让 LAN 失去 Tween 效果。**保持双轨**：玩法 UI → `BtnUtils`；Pc LAN 对话框 → `KyoBtnUtils`。

---

## 包落点（根包已归位）

| 包 | 放什么 |
|----|--------|
| `kyo.loader` | URLoader / LoaderLite 等 |
| `kyo.utils` | 静态工具（含 AIR `FileUtils`） |
| `kyo.storage` | SharedObject 相关 |
| `kyo.media` | `SuperPlayer` |
| `kyo.cache` | `KyoCacheManager` |
| `kyo.display.*` | 显示与 UI 组件 |

---

## 速查

```actionscript
// 加载
KyoURLoader.load(url, onText);
KyoLoaderLite.loadLoader(url, onLoader, onFail, onProg);

// 延时
KyoTimeout.init(root);
KyoTimeout.setFrameout(fn, frames);
KyoTimerUtils.setTimeout(fn, ms); // 可 pauseAllTimer
```
