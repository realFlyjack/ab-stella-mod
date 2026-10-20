from pathlib import Path
import sys

from Crypto.Cipher import AES


KEY = b"Bll3qkcy5fKrNVxZqtkFH19Ojn2sdJFu"


for arg in sys.argv[1:]:
    data = Path(arg).read_bytes()
    plain = AES.new(KEY, AES.MODE_CBC, b"\0" * 16).decrypt(data)
    text = plain[:-plain[-1]].decode("utf-8", "replace")
    print(f"--- {arg} ({len(data)} bytes)")
    for line in text.splitlines():
        if any(
            key in line
            for key in (
                "Chapter02",
                "lastVisitedMapScreen",
                "mapAreaProgress",
                "Beach",
                "unlockedBirdSkins",
            )
        ):
            print(line)
