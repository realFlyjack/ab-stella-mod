# Publishing a Release

The signed APK files are intentionally excluded from Git. Publish them as
assets on the GitHub Releases page.

1. Run the build tests:

   ```powershell
   ./tools/bin/lua32float.exe ./tests/test_settings_popup.lua
   ```

2. Build and sign the normal and test APKs with
   `tools/build.ps1` and `tools/sign.ps1`.

3. Verify the package names, remove the Internet permission, and confirm both
   APK signatures.

4. Update `release/SHA256SUMS.txt` with:

   ```powershell
   Get-FileHash -Algorithm SHA256 `
     ./release/Stella_1.1.5_with_save_tools.apk
   ```

5. Create a GitHub Release, then upload the side-by-side APK and
   `SHA256SUMS.txt` as release assets.
