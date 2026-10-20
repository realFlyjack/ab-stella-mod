param(
    [Parameter(Mandatory = $true)]
    [string]$BaseApk,
    [string]$OutputApk = "release/Stella_1.1.5_with_save_tools_unsigned.apk",
    [string]$Java = "java",
    [string]$PackageName = "com.rovio.angrybirdsstella.modtest"
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$build = Join-Path $root "build"
$decoded = Join-Path $build "apktool"
$apktool = Join-Path $PSScriptRoot "apktool.jar"

$basePath = (Resolve-Path $BaseApk).Path
$outputPath = Join-Path $root $OutputApk
$outputPath = [IO.Path]::GetFullPath($outputPath)

New-Item -ItemType Directory -Force -Path $build | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $outputPath) | Out-Null

Push-Location $root
try {
    & $Java -jar $apktool d -f $basePath -o $decoded
    if ($LASTEXITCODE -ne 0) { throw "apktool decode failed" }

    Copy-Item (Join-Path $root "src/AndroidManifest.xml") `
        (Join-Path $decoded "AndroidManifest.xml") -Force
    if ($PackageName) {
        $manifestPath = Join-Path $decoded "AndroidManifest.xml"
        $manifest = [IO.File]::ReadAllText($manifestPath)
        $manifest = $manifest.Replace(
            'package="com.rovio.angrybirdsstella"',
            ('package="' + $PackageName + '"')
        )
        $manifest = [regex]::Replace(
            $manifest,
            '\s*<permission android:name="com\.rovio\.angrybirdsstella\.permission\.C2D_MESSAGE"[^>]*/>',
            ''
        )
        $manifest = [regex]::Replace(
            $manifest,
            '\s*<uses-permission android:name="com\.rovio\.angrybirdsstella\.permission\.C2D_MESSAGE"\s*/>',
            ''
        )
        [IO.File]::WriteAllText(
            $manifestPath,
            $manifest,
            [Text.UTF8Encoding]::new($false)
        )
    }
    Copy-Item `
        (Join-Path $root "src/smali/com/rovio/angrybirdsstella/o4/app/StartActivity.smali") `
        (Join-Path $decoded "smali/com/rovio/angrybirdsstella/o4/app/StartActivity.smali") `
        -Force

    & (Join-Path $root "tools/bin/lua32float.exe") `
        (Join-Path $root "tests/test_settings_popup.lua")
    if ($LASTEXITCODE -ne 0) { throw "save-tool tests failed" }

    python (Join-Path $root "tools/pack_purple_script.py") `
        (Join-Path $root "src/lua/SettingsPopup.lua") `
        (Join-Path $decoded "assets/data/scripts/menus/SettingsPopup.lua")
    if ($LASTEXITCODE -ne 0) { throw "SettingsPopup.lua packing failed" }

    python (Join-Path $root "tools/pack_purple_script.py") `
        (Join-Path $root "src/lua/SettingsPopup.layout.lua") `
        (Join-Path $decoded "assets/data/scripts/menus/layouts/SettingsPopup.layout.lua")
    if ($LASTEXITCODE -ne 0) { throw "SettingsPopup layout packing failed" }

    Copy-Item (Join-Path $root "src/assets/gift_override.dat") `
        (Join-Path $decoded "assets/gift_override.dat") -Force
    Copy-Item (Join-Path $root "src/assets/cloud_override.dat") `
        (Join-Path $decoded "assets/cloud_override.dat") -Force
    Copy-Item `
        (Join-Path $root "src/assets/data/config/unlocked_gift_bird_skins.dat") `
        (Join-Path $decoded "assets/data/config/unlocked_gift_bird_skins.dat") `
        -Force

    python (Join-Path $root "tools/patch_data_cfbe.py") `
        (Join-Path $decoded "assets/data.cfbe") `
        (Join-Path $root "src/assets/data/config/unlocked_gift_bird_skins.dat")
    if ($LASTEXITCODE -ne 0) { throw "data.cfbe patching failed" }

    & $Java -jar $apktool b $decoded -o $outputPath
    if ($LASTEXITCODE -ne 0) { throw "apktool build failed" }

    Write-Host "Built unsigned APK: $outputPath"
} finally {
    Pop-Location
}

