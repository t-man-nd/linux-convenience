# update-antigravity.sh — User Guide

A script that updates a standalone (non-package-manager) installation of Antigravity IDE on Linux. It automatically finds the latest downloaded archive, backs up the current version, extracts the new one, and rolls back if anything goes wrong.

## Requirements

- Operating System: Linux
- Shell: `bash`
- An existing Antigravity IDE installation at `~/apps/AntigravityIDE` (or running the script for the first time to create it)

## Key Paths

| Path | Purpose |
|---|---|
| `~/apps/AntigravityIDE` | The application directory where Antigravity IDE is installed |
| `~/apps/AntigravityIDE.bak` | Temporary backup created during the update (auto-deleted on success) |
| `~/Downloads` | Where the script looks for the `.tar.gz` installer |

## Installation

```bash
# Clone the repo
git clone https://github.com/t-man-nd/linux-convenience.git
cd linux-convenience

# Make the script executable
chmod +x "Antigravity-IDE standalone update/update-antigravity.sh"
```

## Usage

### Step 1 — Download the latest release

Download the latest Antigravity IDE `.tar.gz` archive and save it to `~/Downloads`. The file name must contain `Antigravity` or `antigravity` (case-insensitive match) and end with `.tar.gz`.

Examples of valid file names:
- `AntigravityIDE-linux-x64-1.2.3.tar.gz`
- `antigravity-ide-2.0.0.tar.gz`

### Step 2 — Close Antigravity IDE

Make sure Antigravity IDE is **not running**. The script checks for a running `antigravity-ide` process and will refuse to continue if one is found.

### Step 3 — Run the script

```bash
./update-antigravity.sh
```

The script will:

1. **Find** the newest matching `.tar.gz` in `~/Downloads`.
2. **Check** that Antigravity IDE is not currently running.
3. **Back up** the existing `~/apps/AntigravityIDE` directory to `~/apps/AntigravityIDE.bak`.
4. **Extract** the new archive into `~/apps/AntigravityIDE`.
5. **Verify** the update by checking for the `antigravity-ide` binary.
6. On success: delete the backup and optionally clean up the downloaded archive.
7. On failure: automatically **roll back** to the backup.

### Example output (success)

```
📦 Found installer: /home/user/Downloads/AntigravityIDE-linux-x64-2.0.0.tar.gz
🔄 Backing up current version to /home/user/apps/AntigravityIDE.bak...
🚀 Extracting new version to /home/user/apps/AntigravityIDE...
✅ Update successful!
🗑️  Do you want to delete the installer '...' from Downloads? (y/n): y
🧹 Downloaded archive cleaned up.
```

## Troubleshooting

### "No Antigravity installer (.tar.gz) found"

The script could not find any `.tar.gz` file containing "Antigravity" or "antigravity" in `~/Downloads`.

- Verify the file is in `~/Downloads` (not a subdirectory).
- Check the file name contains `Antigravity` or `antigravity` and ends with `.tar.gz`.

```bash
ls ~/Downloads/*ntigravit*.tar.gz
```

### "Antigravity IDE is currently running"

Close all Antigravity IDE windows and processes before running the script.

```bash
# Check what's running
pgrep -af antigravity-ide

# Force-kill if needed
pkill -f antigravity-ide
```

### "Extraction failed — rolling back"

The extracted archive did not contain the expected `antigravity-ide` binary. The script automatically restores your previous installation from `~/apps/AntigravityIDE.bak`.

- Make sure you downloaded the correct archive (Linux version, not macOS or Windows).
- Try downloading the archive again — it may have been corrupted.

### Finding the backup

If the update fails mid-way and the backup still exists:

```bash
# Check if the backup directory exists
ls -la ~/apps/AntigravityIDE.bak

# Manually restore if needed
rm -rf ~/apps/AntigravityIDE
mv ~/apps/AntigravityIDE.bak ~/apps/AntigravityIDE
```

### Changing the app directory

If your Antigravity IDE is installed elsewhere, edit the variables at the top of the script:

```bash
APP_DIR="$HOME/apps/AntigravityIDE"       # ← change this
BACKUP_DIR="$HOME/apps/AntigravityIDE.bak" # ← and this
DOWNLOAD_DIR="$HOME/Downloads"             # ← or this
```

## Notes

> [!TIP]
> If you have multiple `.tar.gz` archives in Downloads, the script picks the **newest** one (by modification time). Remove old archives to avoid confusion.

> [!WARNING]
> On a successful update, the backup (`~/apps/AntigravityIDE.bak`) is automatically deleted. If you want to keep the previous version, copy it elsewhere before running the script.
