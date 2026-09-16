#!/usr/bin/env bash
# ============================================================
# install.sh - Installer untuk edBisync
# ============================================================

# --- WARNA ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

BIN_DIR="$HOME/.local/bin"
DATA_DIR="$HOME/.local/share/edBisync"
SCRIPT_NAME="edBisync"

echo -e "${BOLD}${CYAN}======================================${NC}"
echo -e "${BOLD}${CYAN}       Installing edBisync            ${NC}"
echo -e "${BOLD}${CYAN}======================================${NC}"

# 1. Cek keberadaan file script utama di folder saat ini
if [ ! -f "$SCRIPT_NAME" ]; then
    echo -e "${RED}❌ Error: File '$SCRIPT_NAME' tidak ditemukan di folder ini!${NC}"
    echo "Pastikan Anda menjalankan install.sh dari dalam direktori git repo."
    exit 1
fi

# 2. Buat direktori tujuan jika belum ada
mkdir -p "$BIN_DIR"
mkdir -p "$DATA_DIR"

# 3. Copy script ke ~/.local/bin
cp "$SCRIPT_NAME" "$BIN_DIR/$SCRIPT_NAME"
chmod +x "$BIN_DIR/$SCRIPT_NAME"
echo -e "${GREEN}✅ Berhasil menyalin '$SCRIPT_NAME' ke $BIN_DIR/${NC}"

# 4. Buat folder data/log
echo -e "${GREEN}✅ Folder log & data siap di $DATA_DIR${NC}"

# 5. Cek apakah ~/.local/bin sudah terdaftar di $PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo -e "\n${YELLOW}⚠️  Peringatan: $BIN_DIR belum terdaftar di PATH Anda!${NC}"
    echo "Tambahkan baris berikut di akhir file shell profile Anda (~/.bashrc atau ~/.zshrc):"
    echo -e "  ${BOLD}${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
    echo "Setelah ditambahkan, jalankan 'source ~/.bashrc' atau 'source ~/.zshrc'."
else
    echo -e "${GREEN}✅ $BIN_DIR sudah terdaftar di PATH Anda.${NC}"
fi

echo -e "\n${BOLD}${GREEN}🎉 Instalasi selesai!${NC}"
echo "Anda sekarang bisa menjalankan perintah 'edBisync' di terminal."
