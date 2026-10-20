from pathlib import Path
import sys
import tempfile
import zipfile


TARGET = "files/assets_service/unlocked_gift_bird_skins.dat"


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("usage: patch_data_cfbe.py <data.cfbe> <gift.dat>")

    archive_path = Path(sys.argv[1])
    replacement = Path(sys.argv[2]).read_bytes()

    with tempfile.TemporaryDirectory(prefix="stella-cfbe-") as temp_name:
        output_path = Path(temp_name) / "data.cfbe"
        with zipfile.ZipFile(archive_path, "r") as source:
            entries = source.infolist()
            if TARGET not in source.namelist():
                raise SystemExit(f"{TARGET} is missing from {archive_path}")

            with zipfile.ZipFile(output_path, "w") as output:
                for entry in entries:
                    data = source.read(entry.filename)
                    if entry.filename == TARGET:
                        data = replacement

                    info = zipfile.ZipInfo(entry.filename, entry.date_time)
                    info.compress_type = entry.compress_type
                    info.external_attr = entry.external_attr
                    info.create_system = entry.create_system
                    info.comment = entry.comment
                    output.writestr(info, data)

        with zipfile.ZipFile(output_path, "r") as check:
            if check.read(TARGET) != replacement:
                raise SystemExit("patched data.cfbe verification failed")
            names = check.namelist()
            if "_manifest" in names:
                raise SystemExit("unexpected _manifest entry")

        archive_path.write_bytes(output_path.read_bytes())
        print(
            f"patched {TARGET} in {archive_path}: "
            f"{len(entries)} entries, {len(replacement)} replacement bytes"
        )


if __name__ == "__main__":
    main()
