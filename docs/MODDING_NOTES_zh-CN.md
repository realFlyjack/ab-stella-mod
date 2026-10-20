# Angry Birds Stella 存档工具改造说明

## 修改内容

- 设置菜单增加英文 `SAVE TOOLS` 入口。
- `UNLOCK ALL MAIN LEVELS`：第一、二章全部主线和闸门关卡设为一星，
  补齐地图进度，并解锁 Luca、Willow、Dahlia、Gale 角色本体。
- `CLAIM GIFTS`：直接解锁四个海滩礼包装扮。
- `PURPLE STAR LEVEL +5`：岛上活动紫色星星等级增加 5，最高 35。
- 工具页显示当前紫星等级、本级经验进度和主线黄星数。
- APK 清单移除了 `android.permission.INTERNET`，避免旧服务器时间检查闪退。

## 礼包说明

工具页底部英文说明对应 2014 年 11 月原定开放的海滩礼包：

```text
CLAIM GIFTS: The four Beach gifts were originally scheduled to unlock in
November 2014, each corresponding to one outfit.
They can no longer be obtained through the normal in-game flow.
```

## 关键实现

- 游戏 Lua 是标准 Lua 5.1 字节码，但使用 4 字节 `lua_Number`。
- 每个脚本资源先用 7z 压缩，再用 AES-256-CBC 加密。
- 脚本沙箱不会直接暴露标准全局函数，Lua 源码通过 `_G.ipairs`、
  `_G.pairs`、`_G.pcall` 等访问标准库。
- 礼包配置同时存在于普通 APK asset、初次安装的 `data.cfbe` 和
  `StartActivity` 启动覆写文件中。
- 紫星等级修改后调用 `PlayerState.init()`，图鉴解锁按正常等级规则刷新。

## 存档路径

```text
/data/user/0/com.rovio.angrybirdsstella/files/settings.lua
/data/user/0/com.rovio.angrybirdsstella/files/highscores.lua
/data/user/0/com.rovio.angrybirdsstella/files/bi_data.lua
/data/user/0/com.rovio.angrybirdsstella/files/assets_service/unlocked_gift_bird_skins.dat
```

