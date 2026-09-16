# edBisync

Wrapper script untuk `rclone bisync` yang dirancang untuk melakukan sinkronisasi dua arah (bidirectional) antara folder lokal dan Google Drive secara aman, stabil, dan terpantau.

## Fitur Utama

- **Preview secara Default (Dry-Run)** — Menjalankan `edBisync` tanpa argumen hanya akan mensimulasikan perubahan. Tidak ada data yang diubah sebelum Anda yakin.
- **Transfer Berurutan (`--transfers 1`)** — Mengupload/mendownload file satu per satu. Sangat aman jika koneksi tidak stabil, mencegah file menggantung setengah jadi, dan memudahkan penyelamatan progres (resume).
- **Proteksi Rate Limit (`--checkers 4`)** — Membatasi proses pengecekan paralel untuk menghindari error `userRateLimitExceeded` dari API Google Drive (sangat krusial jika menggunakan shared Google Client ID).
- **Notifikasi Desktop** — Terintegrasi dengan `notify-send` untuk memberikan pemberitahuan visual saat proses sinkronisasi selesai atau gagal (sangat cocok untuk Hyprland/Wayland).
- **Sistem Lock File** — Mencegah proses sinkronisasi ganda berjalan bersamaan yang dapat merusak cache dan database rclone.
- **Manajemen Log Terpusat** — Mencatat riwayat sinkronisasi secara detail dan rapi dengan format ukuran yang mudah dibaca (*human-readable*) di `~/.local/share/edBisync/edBisync.log`.
- **Deteksi Cache Otomatis** — Otomatis mendeteksi jika ini adalah sinkronisasi pertama kali dan akan menyarankan mode `--resync`.

## Prasyarat

- **OS:** Linux (Arch Linux / Omarchy / distro lainnya)
- **Shell:** Bash
- **rclone:** Versi 1.58 atau yang lebih baru (teruji di v1.75.1)
- **Remote rclone:** Google Drive remote sudah dikonfigurasi (contoh: `8bpCued411:`)
- **notify-send:** Opsional (untuk notifikasi desktop)

## Instalasi

Clone repository ini dan jalankan script installer:

```bash
git clone git@github.com:CuedNub/edBisync.git
cd edBisync
./install.sh
```

Installer otomatis akan:
1. Menyalin file `edBisync` ke `~/.local/bin/`
2. Memberikan hak akses eksekusi (`chmod +x`)
3. Membuat direktori log di `~/.local/share/edBisync/`
4. Memeriksa apakah `~/.local/bin` sudah terdaftar di `$PATH` Anda.

## Konfigurasi

Sebelum mulai, pastikan variabel konfigurasi di bagian atas script `~/.local/bin/edBisync` sudah sesuai dengan path lokal dan nama remote rclone Anda:

```bash
# --- KONFIGURASI ---
LOCAL_PATH="/home/tobdeuc/GoogleDrive/8bpCued411/"
REMOTE="8bpCued411:"
REMOTE_NAME="8bpCued411"
```

## Penggunaan

```
edBisync          Preview perubahan (dry-run, default, aman)
edBisync sync     Jalankan sinkronisasi sungguhan (Sequential)
edBisync resync   Inisialisasi pertama kali / reset total
edBisync verify   Cek apakah lokal dan remote sudah identik
edBisync check    Bandingkan isi file byte-level (lambat)
edBisync help     Tampilkan bantuan ini
```

### Alur Kerja Harian yang Direkomendasikan

```bash
1. edBisync          # Preview dulu, cek file apa saja yang akan disync/dihapus
2. edBisync sync     # Jika preview dirasa aman, eksekusi sync sungguhan
3. edBisync verify   # Opsional, pastikan kedua sisi sudah benar-benar sinkron
```

### Inisialisasi Pertama (First Run)

Gunakan perintah `resync` untuk membuat database cache awal rclone. Mode ini akan menganggap isi folder lokal sebagai sumber kebenaran (Path1):

```bash
edBisync resync
```

## Struktur File & Direktori

```
~/.local/bin/edBisync              # Executable script utama
~/.local/share/edBisync/
├── edBisync.log                   # Log aktivitas sinkronisasi
└── edBisync.lock                  # Lock file (mencegah double-run)
~/.cache/rclone/bisync/            # Direktori database cache asli rclone
```

## Uninstall

Untuk menghapus `edBisync` beserta log dan file cache rclone-nya secara bersih, jalankan uninstaller dari folder repository:

```bash
cd edBisync
./uninstall.sh
```

## Lisensi

[MIT](LICENSE)
