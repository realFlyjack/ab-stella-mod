# Angry Birds Stella 1.1.5 - 加入了存档修改工具的版本

[English](README.md) | [简体中文](README-CN.md)

An unofficial **Angry Birds Stella 1.1.5** build with an in-game save and
progression menu.

This repository provides the modified APK together with the Lua source,
resource payloads and build scripts used to produce it. The original APK,
user save files and signing private key are intentionally not included.

## Features

Open the in-game map, select the gear button, then choose **SAVE TOOLS**.

- **UNLOCK ALL MAIN LEVELS**: sets all 131 Chapter 1 and Chapter 2 main/gate
  levels to one-star completion, fills map progress, and unlocks Luca, Willow,
  Dahlia and Gale.
- **CLAIM GIFTS**: unlocks the four Beach gift outfits:
  Sweet Tunes Stella, Artistic Willow, Scientist Dahlia and Princess Gale.
- **PURPLE STAR LEVEL +5**: raises island-event experience level by five,
  capped at the game's maximum level of 35. Experience is set to the target
  level threshold and `PlayerState` is refreshed so Piggypedia unlocks update.

The menu also displays the current purple-star level, progress within that
level, and the main-story yellow-star total.

The APK has no `android.permission.INTERNET` permission, so the obsolete
server-time check cannot cause a post-2015 startup crash.

## Release files

The finished APKs are attached to GitHub Releases rather than committed to
the Git repository:

- `Stella_1.1.5_with_save_tools.apk`: side-by-side package
  `com.rovio.angrybirdsstella.modtest`.
- `release/SHA256SUMS.txt`: hash for the APK.

For the current build:

```text
62903F6B8F147B17E526BB9CC5B5B79088C2D1B874AAA01784677B1C152649B1  Stella_1.1.5_with_save_tools.apk
```

The release uses its own package ID and signing certificate, so it can be
installed alongside the official game without replacing or uninstalling the
official package. The official game and its save data remain untouched.

The side-by-side build uses a separate save path:

```text
/data/user/0/com.rovio.angrybirdsstella.modtest/files/settings.lua
```

## Build

Requirements:

- Windows with PowerShell 7.
- Java 17 for v1+v2 APK signing.
- Python 3 with `pycryptodome`.
- 7-Zip available as `7z` or via `SEVEN_ZIP`.
- A legally obtained Angry Birds Stella 1.1.5 APK in `base/Stella.apk`.

Build an unsigned APK:

```powershell
pwsh ./tools/build.ps1 -BaseApk ./base/Stella.apk
```

Sign and verify it with your own key:

```powershell
pwsh ./tools/sign.ps1 `
  -InputApk ./release/Stella_1.1.5_with_save_tools_unsigned.apk `
  -OutputApk ./release/Stella_1.1.5_with_save_tools.apk `
  -Keystore C:/path/to/release.keystore `
  -StorePass YOUR_PASSWORD `
  -KeyAlias YOUR_ALIAS `
  -JavaHome C:/path/to/jdk-17
```

`tools/apktool.jar` and `tools/lib/apksig-2.3.0.jar` are included. The bundled
`tools/bin/luac32float.exe` is a Windows 32-bit Lua 5.1.5 compiler configured
for 4-byte `lua_Number`, matching the game's bytecode format.

The build script defaults to the side-by-side package name
`com.rovio.angrybirdsstella.modtest`.

Run the save-tool logic tests:

```powershell
./tools/bin/lua32float.exe ./tests/test_settings_popup.lua
```

## Project layout

```text
src/lua/                    Human-editable Lua sources
src/smali/                  Modified StartActivity smali
src/AndroidManifest.xml     Manifest with INTERNET permission removed
src/assets/                 Built Lua assets, gift config and initial payload
tests/                      Sandboxed Lua tests for the save menu
tools/                      Build, pack, unpack and signing tools
third_party/                Lua 5.1.5 source and license
docs/                       Modding and texture notes
release/                    Release checksums
base/                       Put your own original Stella.apk here
```

## Notes

- The two gift-related assets are the same 176-byte encrypted configuration:
  the normal APK asset, the first-install `data.cfbe` entry, and the startup
  override used by `StartActivity`.
- The mod does not include or modify any user save in this repository.
- This is a fan modification. The release APK contains code and assets from
  the original game; redistribute it only if you have the necessary rights.

## License

The MIT license in `LICENSE` covers the project's original tooling, source
changes and documentation. It does not relicense Angry Birds Stella or any
Rovio code, artwork, audio or other game assets. Those remain the property of
their respective owners.

