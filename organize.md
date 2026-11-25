# organize.sh — Hướng dẫn sử dụng

Script tự động phân loại file từ thư mục `~/Downloads` vào các thư mục tương ứng dựa theo định dạng (phần mở rộng) của file.

## Yêu cầu

- Hệ điều hành: Linux
- Shell: `bash` (phiên bản 4.0+, hỗ trợ associative array)

## Cài đặt

```bash
# Clone repo về máy
git clone https://github.com/t-man-nd/linux-convenience.git
cd linux-convenience

# Cấp quyền thực thi
chmod +x organize.sh
```

## Cách dùng

### Chạy thử (Dry-run) — khuyến nghị dùng trước

Xem trước danh sách file sẽ bị di chuyển mà **không thực sự di chuyển gì**:

```bash
./organize.sh --dry-run
```

Ví dụ output:
```
🔍 DRY-RUN mode — nothing will be moved.

  [DRY-RUN]  photo.jpg      →  /home/user/Pictures/photo.jpg
  [DRY-RUN]  invoice.pdf    →  /home/user/Documents/invoice.pdf
  [DRY-RUN]  song.mp3       →  /home/user/Music/song.mp3

Preview done. Would move: 3 file(s). Skipped/unrecognized: 2 file(s).
Run without --dry-run to apply changes.
```

### Chạy thật

```bash
./organize.sh
```

Ví dụ output:
```
  [MOVED]    photo.jpg      →  /home/user/Pictures/photo.jpg
  [MOVED]    invoice.pdf    →  /home/user/Documents/invoice.pdf
  [MOVED]    song.mp3       →  /home/user/Music/song.mp3

Done. Moved: 3 file(s). Skipped/unrecognized: 2 file(s).
```

## Thư mục đích & Định dạng hỗ trợ

| Thư mục | Định dạng file |
|---|---|
| `~/Documents` | `.pdf` `.doc` `.docx` `.odt` `.rtf` `.txt` `.md` `.tex` `.xls` `.xlsx` `.ods` `.csv` `.tsv` `.ppt` `.pptx` `.odp` `.epub` `.mobi` `.azw3` |
| `~/Music` | `.mp3` `.wav` `.flac` `.aac` `.ogg` `.m4a` `.wma` `.opus` `.alac` `.aiff` |
| `~/Pictures` | `.jpg` `.jpeg` `.png` `.gif` `.bmp` `.webp` `.svg` `.tiff` `.tif` `.ico` `.raw` `.heic` `.psd` |
| `~/Videos` | `.mp4` `.mkv` `.avi` `.mov` `.wmv` `.flv` `.webm` `.m4v` `.3gp` `.mpeg` `.mpg` |

## Quy tắc xử lý

- **Nguồn quét:** Chỉ quét file ở cấp 1 của `~/Downloads` (không đệ quy vào thư mục con).
- **File ẩn:** Bỏ qua các file bắt đầu bằng dấu `.` (dotfiles).
- **Phân biệt hoa thường:** Không phân biệt — `.JPG`, `.Jpg`, `.jpg` đều được nhận diện như nhau.
- **Trùng tên:** Nếu file đích đã tồn tại, tự động thêm hậu tố `_1`, `_2`, `_3`,... trước phần mở rộng.
  - Ví dụ: `photo.png` → `photo_1.png` → `photo_2.png`
- **Định dạng không hỗ trợ:** Giữ nguyên trong `~/Downloads`, không bị xóa hay thay đổi.
- **Tạo thư mục tự động:** Nếu thư mục đích (`~/Pictures`, v.v.) chưa tồn tại, script tự tạo bằng `mkdir -p`.

## Lưu ý

> [!TIP]
> Luôn chạy `--dry-run` trước để kiểm tra kết quả dự kiến, đặc biệt khi lần đầu sử dụng hoặc khi `Downloads` có nhiều file quan trọng.

> [!WARNING]
> Script dùng lệnh `mv` (di chuyển thật), không có thùng rác (Recycle Bin). File sau khi di chuyển không thể Ctrl+Z để hoàn tác.
