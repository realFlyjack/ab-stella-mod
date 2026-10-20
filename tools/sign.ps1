param(
    [Parameter(Mandatory = $true)]
    [string]$InputApk,
    [Parameter(Mandatory = $true)]
    [string]$OutputApk,
    [Parameter(Mandatory = $true)]
    [string]$Keystore,
    [Parameter(Mandatory = $true)]
    [string]$StorePass,
    [Parameter(Mandatory = $true)]
    [string]$KeyAlias,
    [Parameter(Mandatory = $true)]
    [string]$JavaHome
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$classes = Join-Path $root "build/signclasses"
$apksig = Join-Path $root "tools/lib/apksig-2.3.0.jar"
$java = Join-Path $JavaHome "bin/java.exe"
$javac = Join-Path $JavaHome "bin/javac.exe"

$inputPath = if ([IO.Path]::IsPathRooted($InputApk)) {
    $InputApk
} else {
    Join-Path $root $InputApk
}
$outputPath = if ([IO.Path]::IsPathRooted($OutputApk)) {
    $OutputApk
} else {
    Join-Path $root $OutputApk
}

New-Item -ItemType Directory -Force -Path $classes | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $outputPath) | Out-Null

Push-Location $root
try {
    & $javac -cp $apksig -d $classes `
        (Join-Path $root "tools/SignApk.java") `
        (Join-Path $root "tools/VerifyApk.java")
    if ($LASTEXITCODE -ne 0) { throw "signing tools failed to compile" }

    & $java `
        --add-exports=java.base/sun.security.x509=ALL-UNNAMED `
        --add-exports=java.base/sun.security.pkcs=ALL-UNNAMED `
        -cp "$classes;$apksig" SignApk `
        $inputPath $outputPath $StorePass $Keystore $KeyAlias
    if ($LASTEXITCODE -ne 0) { throw "APK signing failed" }

    & $java `
        --add-exports=java.base/sun.security.x509=ALL-UNNAMED `
        --add-exports=java.base/sun.security.pkcs=ALL-UNNAMED `
        --add-exports=java.base/sun.security.util=ALL-UNNAMED `
        -cp "$classes;$apksig" VerifyApk $outputPath
    if ($LASTEXITCODE -ne 0) { throw "APK verification failed" }
} finally {
    Pop-Location
}

