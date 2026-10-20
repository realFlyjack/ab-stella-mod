# Angry Birds Stella 1.1.5 - 加入了存档修改工具的版本

[English](README.md) | [简体中文](README-CN.md)

这是一个内置存档与进度修改菜单的非官方 **Angry Birds Stella 1.1.5** 改版。

仓库包含修改后的 APK、可编辑 Lua 源码、资源文件和构建脚本。原版 APK、用户
存档和签名私钥均未包含在仓库中。

## 功能

进入游戏选关界面，点击齿轮按钮，然后选择 **SAVE TOOLS**。

- **UNLOCK ALL MAIN LEVELS**：将第一、二章全部 131 个主线和闸门关卡设为一星，
  补齐地图进度，并解锁 Luca、Willow、Dahlia、Gale。
- **CLAIM GIFTS**：解锁四个海滩礼包装扮：Sweet Tunes Stella、
  Artistic Willow、Scientist Dahlia、Princess Gale。
- **PURPLE STAR LEVEL +5**：将岛上活动紫星等级提升 5 级，最高 35 级。经验值会
  同步设置为目标等级起点，并调用 `PlayerState` 刷新图鉴解锁。

工具页还会显示当前紫星等级、本级经验进度和主线黄星数。

APK 已移除 `android.permission.INTERNET` 权限，因此旧服务器时间检查不会导致
2015 年后的启动闪退。

## 发布文件

成品 APK 通过 GitHub Releases 发布，不直接提交到 Git 仓库：

- [GitHub Releases](https://github.com/realFlyjack/ab-stella-mod/releases/tag/v1.1.5)
- `Stella_1.1.5_with_save_tools.apk`：并行安装包，包名为
  `com.rovio.angrybirdsstella.modtest`。
- `release/SHA256SUMS.txt`：APK 的 SHA-256 校验值。

当前版本的 SHA-256：

```text
62903F6B8F147B17E526BB9CC5B5B79088C2D1B874AAA01784677B1C152649B1  Stella_1.1.5_with_save_tools.apk
```

该版本使用独立包名和签名证书，可与官方游戏同时安装，不需要卸载或替换官方
版本。官方游戏及其存档数据不会被修改。

并行版使用独立存档路径：

```text
/data/user/0/com.rovio.angrybirdsstella.modtest/files/settings.lua
```

## 构建

环境要求：

- Windows 与 PowerShell 7。
- Java 17，用于 v1+v2 APK 签名。
- Python 3 与 `pycryptodome`。
- 可通过 `7z` 或 `SEVEN_ZIP` 调用的 7-Zip。
- 一份合法获取的 Angry Birds Stella 1.1.5 APK，放在
  `base/Stella.apk`。

构建未签名 APK：

```powershell
pwsh ./tools/build.ps1 -BaseApk ./base/Stella.apk
```

构建脚本默认使用并行包名 `com.rovio.angrybirdsstella.modtest`。

使用自己的密钥签名并验证：

```powershell
pwsh ./tools/sign.ps1 `
  -InputApk ./release/Stella_1.1.5_with_save_tools_unsigned.apk `
  -OutputApk ./release/Stella_1.1.5_with_save_tools.apk `
  -Keystore C:/path/to/release.keystore `
  -StorePass YOUR_PASSWORD `
  -KeyAlias YOUR_ALIAS `
  -JavaHome C:/path/to/jdk-17
```

仓库包含 `tools/apktool.jar` 和 `tools/lib/apksig-2.3.0.jar`。
`tools/bin/luac32float.exe` 是针对游戏字节码格式配置的 Windows 32 位
Lua 5.1.5 编译器，使用 4 字节 `lua_Number`。

运行存档菜单逻辑测试：

```powershell
./tools/bin/lua32float.exe ./tests/test_settings_popup.lua
```

## 项目结构

```text
src/lua/                    可编辑的 Lua 源码
src/smali/                  修改后的 StartActivity smali
src/AndroidManifest.xml     已移除 INTERNET 权限的清单
src/assets/                 打包后的 Lua 资源、礼包配置和初始载荷
tests/                      存档菜单的沙箱 Lua 测试
tools/                      构建、打包、解包和签名工具
third_party/                Lua 5.1.5 源码与许可证
docs/                       改包与贴图说明
release/                    发布校验文件
base/                       放置自行准备的原版 Stella.apk
```

## 说明

- 两个礼包配置是相同的 176 字节加密数据，分别用于 APK asset、初次安装的
  `data.cfbe` 条目，以及 `StartActivity` 启动时写入的覆写文件。
- 本改版不包含、也不修改仓库中的任何用户存档。
- 这是非官方改版。发布 APK 包含原版游戏的代码和素材，请在具备相应权利的前提下
  分发。

## 许可证

`LICENSE` 中的 MIT 许可证仅覆盖本项目原创的工具、源码修改和文档，不包含
Angry Birds Stella 或任何 Rovio 代码、美术、音频及其他游戏素材的再授权。
相关素材仍归其权利人所有。
