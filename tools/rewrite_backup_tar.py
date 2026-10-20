from pathlib import Path
import io
import sys
import tarfile


def main() -> None:
    source_path = Path(sys.argv[1])
    replacement_path = Path(sys.argv[2])
    output_path = Path(sys.argv[3])
    replacement = replacement_path.read_bytes()
    replacement_name = (
        "apps/com.rovio.angrybirdsstella/f/assets_service/"
        "unlocked_gift_bird_skins.dat"
    )

    with tarfile.open(source_path, "r:") as source:
        with tarfile.open(output_path, "w", format=tarfile.PAX_FORMAT) as output:
            for member in source.getmembers():
                if member.isdir():
                    continue
                data = source.extractfile(member).read()
                if member.name == replacement_name:
                    data = replacement
                info = tarfile.TarInfo(member.name)
                info.mode = member.mode
                info.uid = member.uid
                info.gid = member.gid
                info.mtime = member.mtime
                info.size = len(data)
                info.pax_headers = {}
                output.addfile(info, io.BytesIO(data))

    print(f"wrote {output_path} ({output_path.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
