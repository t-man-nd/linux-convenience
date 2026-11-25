# organize.sh — User Guide

A script that automatically sorts files from `~/Downloads` into corresponding folders based on their file extension.

## Requirements

- Operating System: Linux
- Shell: `bash` (version 4.0+, with associative array support)

## Installation

```bash
# Clone the repo
git clone https://github.com/t-man-nd/linux-convenience.git
cd linux-convenience

# Make the script executable
chmod +x organize.sh
```

## Usage

### Dry Run — recommended before first use

Preview which files would be moved **without actually moving anything**:

```bash
./organize.sh --dry-run
```

Example output:
```
🔍 DRY-RUN mode — nothing will be moved.

  [DRY-RUN]  photo.jpg      →  /home/user/Pictures/photo.jpg
  [DRY-RUN]  invoice.pdf    →  /home/user/Documents/invoice.pdf
  [DRY-RUN]  song.mp3       →  /home/user/Music/song.mp3

Preview done. Would move: 3 file(s). Skipped/unrecognized: 2 file(s).
Run without --dry-run to apply changes.
```

### Run for Real

```bash
./organize.sh
```

Example output:
```
  [MOVED]    photo.jpg      →  /home/user/Pictures/photo.jpg
  [MOVED]    invoice.pdf    →  /home/user/Documents/invoice.pdf
  [MOVED]    song.mp3       →  /home/user/Music/song.mp3

Done. Moved: 3 file(s). Skipped/unrecognized: 2 file(s).
```

## Destination Folders & Supported Formats

| Folder | File Formats |
|---|---|
| `~/Documents` | `.pdf` `.doc` `.docx` `.odt` `.rtf` `.txt` `.md` `.tex` `.xls` `.xlsx` `.ods` `.csv` `.tsv` `.ppt` `.pptx` `.odp` `.epub` `.mobi` `.azw3` |
| `~/Music` | `.mp3` `.wav` `.flac` `.aac` `.ogg` `.m4a` `.wma` `.opus` `.alac` `.aiff` |
| `~/Pictures` | `.jpg` `.jpeg` `.png` `.gif` `.bmp` `.webp` `.svg` `.tiff` `.tif` `.ico` `.raw` `.heic` `.psd` |
| `~/Videos` | `.mp4` `.mkv` `.avi` `.mov` `.wmv` `.flv` `.webm` `.m4v` `.3gp` `.mpeg` `.mpg` |

## Processing Rules

- **Scan scope:** Only scans top-level files in `~/Downloads` (does not recurse into subdirectories).
- **Hidden files:** Files starting with `.` (dotfiles) are ignored.
- **Case sensitivity:** Case-insensitive — `.JPG`, `.Jpg`, and `.jpg` are all treated the same.
- **Name conflicts:** If the destination file already exists, a suffix `_1`, `_2`, `_3`, … is automatically appended before the extension.
  - Example: `photo.png` → `photo_1.png` → `photo_2.png`
- **Unsupported formats:** Left untouched in `~/Downloads` — nothing is deleted or modified.
- **Auto-create folders:** If a destination folder (e.g. `~/Pictures`) does not exist, the script creates it with `mkdir -p`.

## Notes

> [!TIP]
> Always run `--dry-run` first to review the expected results, especially on first use or when `Downloads` contains important files.

> [!WARNING]
> The script uses `mv` (a real move), with no Recycle Bin. Moved files cannot be undone with Ctrl+Z.
