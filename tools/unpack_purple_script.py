from pathlib import Path
import os
import shutil
import subprocess
import sys
import tempfile

from Crypto.Cipher import AES


KEY = b"4FzZOae60yAmxTClzdgfcr4BAbPIgj7X"


def find_7zip() -> str:
    configured = os.environ.get("SEVEN_ZIP")
    if configured:
        return configured
    discovered = shutil.which("7z")
    if discovered:
        return discovered
    raise SystemExit("7-Zip was not found; set the SEVEN_ZIP environment variable")


def decrypt(data: bytes) -> bytes:
    plain = AES.new(KEY, AES.MODE_CBC, b"\0" * 16).decrypt(data)
    padding = plain[-1]
    if not 1 <= padding <= 16 or plain[-padding:] != bytes([padding]) * padding:
        raise ValueError("invalid PKCS#7 padding")
    return plain[:-padding]


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: unpack_purple_script.py <asset.lua> <output.luac>")

    source = Path(sys.argv[1])
    destination = Path(sys.argv[2])
    seven_zip = find_7zip()

    with tempfile.TemporaryDirectory(prefix="stella-lua-") as temp_name:
        archive = Path(temp_name) / "script.7z"
        archive.write_bytes(decrypt(source.read_bytes()))
        data = subprocess.run(
            [seven_zip, "x", "-so", str(archive)],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        ).stdout

    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(data)
    print(f"{source} -> {destination}: {len(data)} bytes")


if __name__ == "__main__":
    main()

