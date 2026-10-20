from pathlib import Path
import os
import shutil
import subprocess
import sys
import tempfile

from Crypto.Cipher import AES


KEY = b"4FzZOae60yAmxTClzdgfcr4BAbPIgj7X"
ROOT = Path(__file__).resolve().parents[1]
LUAC = ROOT / "tools" / "bin" / "luac32float.exe"


def find_7zip() -> str:
    configured = os.environ.get("SEVEN_ZIP")
    if configured:
        return configured
    discovered = shutil.which("7z")
    if discovered:
        return discovered
    raise SystemExit("7-Zip was not found; set the SEVEN_ZIP environment variable")


def encrypt(data: bytes) -> bytes:
    padding = 16 - (len(data) % 16)
    return AES.new(KEY, AES.MODE_CBC, b"\0" * 16).encrypt(
        data + bytes([padding]) * padding
    )


def decrypt(data: bytes) -> bytes:
    plain = AES.new(KEY, AES.MODE_CBC, b"\0" * 16).decrypt(data)
    padding = plain[-1]
    if not 1 <= padding <= 16 or plain[-padding:] != bytes([padding]) * padding:
        raise ValueError("invalid PKCS#7 padding")
    return plain[:-padding]


def pack(source: Path, destination: Path) -> None:
    seven_zip = find_7zip()
    with tempfile.TemporaryDirectory(prefix="stella-lua-") as temp_name:
        temp = Path(temp_name)
        compiled = temp / "script.luac"
        archive = temp / "script.7z"

        subprocess.run(
            [str(LUAC), "-s", "-o", str(compiled), str(source)],
            check=True,
        )
        subprocess.run(
            [
                seven_zip,
                "a",
                "-t7z",
                "-mx=9",
                str(archive),
                compiled.name,
            ],
            cwd=temp,
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
        )

        encrypted = encrypt(archive.read_bytes())
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(encrypted)

        payload = decrypt(destination.read_bytes())
        check_archive = temp / "check.7z"
        check_archive.write_bytes(payload)
        unpacked = subprocess.run(
            [seven_zip, "x", "-so", str(check_archive)],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        ).stdout
        if unpacked != compiled.read_bytes():
            raise ValueError("packed script verification failed")

        print(
            f"{source} -> {destination}: "
            f"{len(compiled.read_bytes())} bytes bytecode, "
            f"{len(encrypted)} bytes encrypted asset"
        )


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(
            "usage: pack_purple_script.py <source.lua> <destination.lua>"
        )
    pack(Path(sys.argv[1]), Path(sys.argv[2]))


if __name__ == "__main__":
    main()

