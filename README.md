# edBisync

Bidirectional sync antara folder lokal dan Google Drive menggunakan `rclone bisync`.

## Deskripsi

`edBisync` adalah wrapper script untuk `rclone bisync` yang menyinkronkan folder lokal dengan Google Drive secara dua arah (bidirectional). Dirancang untuk penggunaan manual (bukan cron) dengan fokus pada keamanan data dan kemudahan preview sebelum eksekusi.

## Prasyarat

- **OS:** Linux (Arch Linux / Omarchy)
- **Shell:** Bash
- **rclone:** ≥ 1.58 (teruji di v1.75.1)
- **Remote rclone:** Sudah dikonfigurasi (tipe `drive`)
- **notify-send:** Opsional, untuk notifikasi desktop (Hyprland/Wayland)

## Instalasi

```bash
git clone git@github.com:CuedNub/edBisync.git
cd edBisync
cp edBisync ~/.local/bin/edBisync
chmod +x ~/.local/bin/edBisync
```

Pastikan `~/.local/bin` ada di `$PATH` Anda.

## Konfigurasi

Edit variabel di bagian atas script sesuai kebutuhan:

```bash
LOCAL_PATH="/home/tobdeuc/GoogleDrive/8bpCued411/"
REMOTE="8bpCued411:"
REMOTE_NAME="8bpCued411"
```

### Parameter Default

| Parameter | Nilai | Alasan |
|-----------|-------|--------|
| `--transfers` | `1` | Upload/download satu per satu. Aman untuk file besar dan koneksi tidak stabil. Memudahkan resume. |
| `--checkers` | `4` | Mencegah rate limit Google Drive (terutama shared client_id). |
| `--stats` | `2s` | Update progress setiap 2 detik. |
| `--human-readable` | aktif | Menampilkan ukuran dalam GB/MB/KB. |

## Penggunaan

```
edBisync          Preview perubahan (dry-run, default, aman)
edBisync sync     Jalankan sinkronisasi sungguhan
edBisync resync   Inisialisasi pertama / reset total
edBisync verify   Cek apakah lokal dan remote sudah sinkron
edBisync check    Bandingkan isi file byte-level (lambat)
edBisync help     Tampilkan bantuan
```

### Alur Kerja Rutin

```
1. edBisync          # Lihat dulu apa yang akan berubah
2. edBisync sync     # Jika aman, jalankan sync
3. edBisync verify   # Pastikan sudah sinkron
```

### Inisialisasi Pertama Kali

```bash
edBisync resync
```

> **Peringatan:** `--resync` memaksa kedua sisi menjadi identik. Path1 (lokal) menjadi sumber kebenaran. Jalankan `edBisync` (preview) terlebih dahulu untuk memastikan tidak ada data yang akan hilang.

## Fitur

- **Preview by default** — Menjalankan `edBisync` tanpa argumen = dry-run. Tidak ada file yang berubah.
- **Sequential transfer** — File diproses satu per satu (`--transfers 1`). Jika koneksi terputus, hanya 1 file yang terdampak.
- **Rate limit protection** — `--checkers 4` mencegah error `userRateLimitExceeded` dari Google Drive API.
- **Lock file** — Mencegah 2 instance berjalan bersamaan yang bisa merusak data.
- **Logging** — Semua aktivitas dicatat ke `~/.local/share/edBisync/edBisync.log`.
- **Notifikasi desktop** — Notifikasi via `notify-send` saat sync selesai/gagal (kompatibel Hyprland).
- **Auto-detect first run** — Otomatis menambahkan `--resync` jika cache belum ada.
- **Progress bar** — Menampilkan persentase, kecepatan, dan ETA secara real-time.

## Struktur File

```
~/.local/bin/edBisync              # Script utama
~/.local/share/edBisync/
├── edBisync.log                   # Log aktivitas
└── edBisync.lock                  # Lock file (otomatis)
~/.cache/rclone/bisync/            # Cache rclone (otomatis)
```

## Contoh Output

### Preview (dry-run)
```
══════════════════════════════════════
  PREVIEW (Dry-Run)
══════════════════════════════════════
ℹ️  Mode ini TIDAK mengubah file apapun

  Lokal  : /home/tobdeuc/GoogleDrive/8bpCued411/
  Remote : 8bpCued411:
  Exclude: _BACKUP_remote-only/**
  Mode   : transfers=1, checkers=4 (Sequential Upload)

✅ Preview selesai.
ℹ️  Jika aman, jalankan: edBisync sync
```

### Verify (sudah sinkron)
```
══════════════════════════════════════
  VERIFY (Cek Sinkronisasi)
══════════════════════════════════════

Transferred:    0 B / 0 B, -, 0 B/s, ETA -
Checks:       458 / 458, 100%
No changes found
Bisync successful

✅ LOKAL DAN REMOTE SUDAH SINKRON!
```

## Troubleshooting

### Cache tidak terdeteksi
```bash
ls ~/.cache/rclone/bisync/
```
Periksa apakah nama file cache sesuai dengan pattern di fungsi `is_first_run()`.

### Lock file tersisa setelah crash
```bash
rm ~/.local/share/edBisync/edBisync.lock
```

### Error rate limit Google Drive
Tunggu beberapa menit, lalu coba lagi. Jika sering terjadi, buat [client_id sendiri](https://rclone.org/drive/#making-your-own-client-id).

### Shared client_id warning
```
NOTICE: This remote uses rclone's shared Google Drive client_id,
which is being retired and will stop working during 2026.
```
Solusi: Buat client_id sendiri di [Google Cloud Console](https://rclone.org/drive/#making-your-own-client-id).

## Lisensi

MIT
