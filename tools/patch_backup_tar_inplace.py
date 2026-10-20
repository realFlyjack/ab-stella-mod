from pathlib import Path
import sys
import tarfile


BLOCK_SIZE = 512
REPLACEMENT_NAME = (
    "apps/com.rovio.angrybirdsstella/f/assets_service/"
    "unlocked_gift_bird_skins.dat"
)


def parse_octal(field: bytes, label: str) -> int:
    value = field.split(b"\0", 1)[0].strip()
    if not value:
        return 0
    try:
        return int(value, 8)
    except ValueError as exc:
        raise ValueError(f"invalid {label}: {field!r}") from exc


def find_file_header(archive: bytes, member: tarfile.TarInfo) -> int:
    name = member.name.encode("utf-8")
    search_start = max(0, member.offset_data - 4 * BLOCK_SIZE)
    search_end = member.offset_data

    for offset in range(search_start, search_end, BLOCK_SIZE):
        header = archive[offset : offset + BLOCK_SIZE]
        if len(header) != BLOCK_SIZE:
            continue
        stored_name = header[0:100].split(b"\0", 1)[0]
        stored_prefix = header[345:500].split(b"\0", 1)[0]
        full_name = stored_prefix + b"/" + stored_name if stored_prefix else stored_name
        if full_name == name:
            size = parse_octal(header[124:136], "size")
            if offset + BLOCK_SIZE + ((size + BLOCK_SIZE - 1) // BLOCK_SIZE) * BLOCK_SIZE != member.offset_data + (
                (member.size + BLOCK_SIZE - 1) // BLOCK_SIZE
            ) * BLOCK_SIZE:
                raise ValueError("tar header and parsed member data are inconsistent")
            return offset

    raise ValueError(f"could not locate tar header for {member.name}")


def build_header(old_header: bytes, new_size: int) -> bytes:
    header = bytearray(old_header)
    header[124:136] = f"{new_size:011o}\0".encode("ascii")
    header[148:156] = b"        "
    checksum = sum(header)
    header[148:156] = f"{checksum:06o}\0 ".encode("ascii")
    return bytes(header)


def main() -> None:
    if len(sys.argv) != 4:
        raise SystemExit(
            "usage: patch_backup_tar_inplace.py <source.tar> "
            "<replacement.dat> <output.tar>"
        )

    source_path = Path(sys.argv[1])
    replacement_path = Path(sys.argv[2])
    output_path = Path(sys.argv[3])
    source = source_path.read_bytes()
    replacement = replacement_path.read_bytes()

    with tarfile.open(source_path, "r:") as archive:
        try:
            member = archive.getmember(REPLACEMENT_NAME)
        except KeyError as exc:
            raise SystemExit(f"{REPLACEMENT_NAME} is not present in {source_path}") from exc

    old_blocks = (member.size + BLOCK_SIZE - 1) // BLOCK_SIZE
    new_blocks = (len(replacement) + BLOCK_SIZE - 1) // BLOCK_SIZE
    if old_blocks != new_blocks:
        raise SystemExit(
            f"replacement changes allocated blocks ({old_blocks} -> {new_blocks}); "
            "this in-place patcher only supports same-block replacements"
        )

    header_offset = find_file_header(source, member)
    data_offset = member.offset_data
    expected_data_offset = header_offset + BLOCK_SIZE
    if data_offset != expected_data_offset:
        raise ValueError(
            f"unexpected data offset {data_offset}, expected {expected_data_offset}"
        )

    output = bytearray(source)
    output[header_offset : header_offset + BLOCK_SIZE] = build_header(
        source[header_offset : header_offset + BLOCK_SIZE], len(replacement)
    )
    padded = replacement.ljust(old_blocks * BLOCK_SIZE, b"\0")
    output[data_offset : data_offset + old_blocks * BLOCK_SIZE] = padded

    output_path.write_bytes(output)
    if len(output) != len(source):
        raise SystemExit("output size changed unexpectedly")

    with tarfile.open(output_path, "r:") as check:
        patched = check.extractfile(REPLACEMENT_NAME)
        if patched is None or patched.read() != replacement:
            raise SystemExit("patched archive verification failed")

    print(
        f"patched {REPLACEMENT_NAME}: {member.size} -> {len(replacement)} bytes; "
        f"archive remains {len(source)} bytes"
    )


if __name__ == "__main__":
    main()
