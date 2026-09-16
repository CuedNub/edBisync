#!/usr/bin/env bash
# ============================================================
# uninstall.sh - Uninstaller untuk edBisync
# ============================================================

# --- WARNA ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

BIN_DIR="$HOME/.local/bin"
DATA_DIR="$HOME/.local/share/edBisync"
CACHE_DIR="$HOME/.cache/rclone/bisync"
SCRIPT_NAME="edBisync"

echo -e "${BOLD}${RED}======================================${NC}"
echo -e "${BOLD}${RED}      Uninstalling edBisync           ${NC}"
echo -e "${BOLD}${RED}======================================${NC}"

# 1. Hapus binary
if [ -f "$BIN_DIR/$SCRIPT_NAME" ]; then
    rm "$BIN_DIR/$SCRIPT_NAME"
    echo -e "${GREEN}✅ Berhasil menghapus executable dari $BIN_DIR/$SCRIPT_NAME${NC}"
else
    echo -e "${YELLOW}ℹ️  Executable sudah tidak ada di $BIN_DIR/$SCRIPT_NAME${NC}"
fi

# 2. Tanya hapus logs/locks
if [ -d "$DATA_DIR" ]; then
    echo -e -n "\n${BOLD}${YELLOW}Apakah Anda ingin menghapus log dan lock file di $DATA_DIR? (y/N): ${NC}"
    read -r confirm_data
    if [[ "$confirm_data" =~ ^[Yy]$ ]]; then
        rm -rf "$DATA_DIR"
        echo -e "${GREEN}✅ Berhasil menghapus folder $DATA_DIR${NC}"
    else
        echo "Menjaga folder $DATA_DIR"
    fi
fi

# 3. Tanya hapus cache rclone bisync
CACHE_FILES=$(find "$CACHE_DIR" -name "*8bpCued411*" 2>/dev/null)
if [ -n "$CACHE_FILES" ]; then
    echo -e -n "\n${BOLD}${YELLOW}Apakah Anda ingin menghapus rclone bisync cache di $CACHE_DIR? (y/N): ${NC}"
    read -r confirm_cache
    if [[ "$confirm_cache" =~ ^[Yy]$ ]]; then
        find "$CACHE_DIR" -name "*8bpCued411*" -delete 2>/dev/null
        echo -e "${GREEN}✅ Berhasil menghapus cache file rclone bisync.${NC}"
    else
        echo "Menjaga file cache rclone."
    fi
fi

echo -e "\n${BOLD}${GREEN}✨ Proses uninstall selesai!${NC}"
