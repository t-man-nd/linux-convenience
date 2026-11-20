#!/usr/bin/env bash
# organize.sh - Automatically organize files from ~/Downloads into categorized folders.
# Folders: ~/Documents, ~/Music, ~/Pictures, ~/Videos
# Rules:
#   - Case-insensitive extension matching
#   - Duplicate handling: append _1, _2, _3, ... before the extension
#   - Only processes regular files at the root of ~/Downloads (no subdirs, no hidden files)
#   - Unrecognized formats remain in ~/Downloads untouched

set -uo pipefail   
# ─── Flags ─────────────────────────────────────────────────────────────────────
DRY_RUN=false
for arg in "$@"; do
    [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

# ─── Directories ───────────────────────────────────────────────────────────────
SOURCE_DIR="$HOME/Downloads"
DOCS_DIR="$HOME/Documents"
MUSIC_DIR="$HOME/Music"
PICS_DIR="$HOME/Pictures"
VIDEOS_DIR="$HOME/Videos"

# ─── Extension maps ────────────────────────────────────────────────────────────
declare -A EXT_MAP=(
    # Documents
    [pdf]="$DOCS_DIR"   [doc]="$DOCS_DIR"   [docx]="$DOCS_DIR"
    [odt]="$DOCS_DIR"   [rtf]="$DOCS_DIR"   [txt]="$DOCS_DIR"
    [md]="$DOCS_DIR"    [tex]="$DOCS_DIR"
    [xls]="$DOCS_DIR"   [xlsx]="$DOCS_DIR"  [ods]="$DOCS_DIR"
    [csv]="$DOCS_DIR"   [tsv]="$DOCS_DIR"
    [ppt]="$DOCS_DIR"   [pptx]="$DOCS_DIR"  [odp]="$DOCS_DIR"
    [epub]="$DOCS_DIR"  [mobi]="$DOCS_DIR"  [azw3]="$DOCS_DIR"
    # Music
    [mp3]="$MUSIC_DIR"  [wav]="$MUSIC_DIR"  [flac]="$MUSIC_DIR"
    [aac]="$MUSIC_DIR"  [ogg]="$MUSIC_DIR"  [m4a]="$MUSIC_DIR"
    [wma]="$MUSIC_DIR"  [opus]="$MUSIC_DIR" [alac]="$MUSIC_DIR"
    [aiff]="$MUSIC_DIR"
    # Pictures
    [jpg]="$PICS_DIR"   [jpeg]="$PICS_DIR"  [png]="$PICS_DIR"
    [gif]="$PICS_DIR"   [bmp]="$PICS_DIR"   [webp]="$PICS_DIR"
    [svg]="$PICS_DIR"   [tiff]="$PICS_DIR"  [tif]="$PICS_DIR"
    [ico]="$PICS_DIR"   [raw]="$PICS_DIR"   [heic]="$PICS_DIR"
    [psd]="$PICS_DIR"
    # Videos
    [mp4]="$VIDEOS_DIR" [mkv]="$VIDEOS_DIR" [avi]="$VIDEOS_DIR"
    [mov]="$VIDEOS_DIR" [wmv]="$VIDEOS_DIR" [flv]="$VIDEOS_DIR"
    [webm]="$VIDEOS_DIR" [m4v]="$VIDEOS_DIR" [3gp]="$VIDEOS_DIR"
    [mpeg]="$VIDEOS_DIR" [mpg]="$VIDEOS_DIR"
)

# ─── Helpers ───────────────────────────────────────────────────────────────────

ensure_dirs() {
    if [[ "$DRY_RUN" == false ]]; then
        mkdir -p "$DOCS_DIR" "$MUSIC_DIR" "$PICS_DIR" "$VIDEOS_DIR"
    fi
}

# resolve_dest <dest_dir> <filename>
# Prints the final destination path, with _1/_2/... suffix if needed.
resolve_dest() {
    local dest_dir="$1"
    local filename="$2"
    local ext base dest_path counter new_name

    ext="${filename##*.}"
    base="${filename%.*}"
    dest_path="$dest_dir/$filename"

    if [[ ! -e "$dest_path" ]]; then
        echo "$dest_path"
        return
    fi

    counter=1
    while true; do
        new_name="${base}_${counter}.${ext}"
        dest_path="$dest_dir/$new_name"
        if [[ ! -e "$dest_path" ]]; then
            echo "$dest_path"
            return
        fi
        counter=$((counter + 1))   # safe: no (( )) pitfall
    done
}

# ─── Main ──────────────────────────────────────────────────────────────────────
main() {
    ensure_dirs

    local moved=0 skipped=0 filepath filename ext_lower dest_dir final_dest

    if [[ "$DRY_RUN" == true ]]; then
        echo "🔍 DRY-RUN mode — nothing will be moved."
        echo ""
    fi

    while IFS= read -r -d '' filepath; do
        filename="$(basename "$filepath")"

        # Skip hidden files
        if [[ "$filename" == .* ]]; then
            continue
        fi

        # Skip files with no extension
        ext_lower="${filename##*.}"
        if [[ "$ext_lower" == "$filename" ]]; then
            skipped=$((skipped + 1))
            continue
        fi
        ext_lower="${ext_lower,,}"   # lowercase

        # Lookup destination
        dest_dir="${EXT_MAP[$ext_lower]:-}"
        if [[ -z "$dest_dir" ]]; then
            skipped=$((skipped + 1))
            continue
        fi

        # Resolve final path (handle duplicates)
        final_dest="$(resolve_dest "$dest_dir" "$filename")"

        if [[ "$DRY_RUN" == true ]]; then
            echo "  [DRY-RUN]  $filename  →  $final_dest"
        else
            mv -- "$filepath" "$final_dest"
            echo "  [MOVED]    $filename  →  $final_dest"
        fi

        moved=$((moved + 1))

    done < <(find "$SOURCE_DIR" -maxdepth 1 -type f -print0)

    echo ""
    if [[ "$DRY_RUN" == true ]]; then
        echo "Preview done. Would move: $moved file(s). Skipped/unrecognized: $skipped file(s)."
        echo "Run without --dry-run to apply changes."
    else
        echo "Done. Moved: $moved file(s). Skipped/unrecognized: $skipped file(s)."
    fi
}

main "$@"
