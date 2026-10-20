from pathlib import Path
import json

from Crypto.Cipher import AES


KEY = b"0xMizJJUh7BbwmYhqxpJ038x8YGvk6aU"
ROOT = Path(__file__).resolve().parents[1]
GIFT_BOX_NAMES = [
    "BUTTON_LEVELSELECT_GIFT_BOX_1",
    "BUTTON_LEVELSELECT_GIFT_BOX_2",
    "BUTTON_LEVELSELECT_GIFT_BOX_3",
    "BUTTON_LEVELSELECT_GIFT_BOX_4",
]


def main() -> None:
    payload = json.dumps({"data": GIFT_BOX_NAMES}, indent=2).encode("ascii")
    padding = 16 - (len(payload) % 16)
    encrypted = AES.new(KEY, AES.MODE_CBC, b"\0" * 16).encrypt(
        payload + bytes([padding]) * padding
    )

    (ROOT / "src" / "assets" / "gift_override.dat").write_bytes(encrypted)
    (
        ROOT
        / "src"
        / "assets"
        / "data"
        / "config"
        / "unlocked_gift_bird_skins.dat"
    ).write_bytes(encrypted)
    print(f"wrote {len(encrypted)}-byte encrypted gift configuration")


if __name__ == "__main__":
    main()

