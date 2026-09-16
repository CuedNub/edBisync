#!/usr/bin/env bash
# ============================================================
# push.sh - Git push helper dengan tampilan modern & bersih
# ============================================================

# --- WARNA & GAYA ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
INDENT="  "

PROJECT_DIR="$HOME/projects/edBisnyc"
BIN_DIR="$HOME/.local/bin"

cd "$PROJECT_DIR" || exit 1

# --- HEADER BERSIH ---
echo -e "\n${INDENT}${BOLD}${CYAN}🚀 edBisync Git Pusher${NC}\n"

# 1. AUTO-SYNC BACK
if [ -f "$BIN_DIR/edBisync" ]; then
    if ! cmp -s "$BIN_DIR/edBisync" "edBisync"; then
        echo -e "${INDENT}${YELLOW}⚠ Perubahan terdeteksi di script operasional (~/.local/bin/)${NC}"
        cp "$BIN_DIR/edBisync" "edBisync"
        echo -e "${INDENT}${GREEN}✔ File 'edBisync' di folder project berhasil diperbarui${NC}\n"
    fi
fi

# 2. STATUS GIT DENGAN INDENTASI
echo -e "${INDENT}${BOLD}Status Perubahan:${NC}"
if [ -z "$(git status --porcelain)" ]; then
    echo -e "${INDENT}${DIM}  (Tidak ada perubahan file)${NC}"
else
    # Indentasi output git status agar sejajar rapi
    git status -s | sed "s/^/${INDENT}  /"
fi
echo ""

# 3. CEK APAKAH ADA YANG PERLU DI-PUSH
if git diff --exit-code --quiet && git diff --cached --exit-code --quiet; then
    if [ -z "$(git status --porcelain)" ]; then
        echo -e "${INDENT}${GREEN}✔ Semua bersih! Tidak ada yang perlu di-push.${NC}\n"
        exit 0
    fi
fi

# 4. INPUT COMMIT MESSAGE INTERAKTIF
echo -e "${INDENT}${BOLD}${CYAN}➜ Pesan Commit${NC} (Kosongkan untuk 'update: edBisync script'):"
echo -ne "${INDENT}  ✍  "
read -r commit_msg

if [ -z "$commit_msg" ]; then
    commit_msg="update: edBisync script"
fi

# 5. KONFIRMASI PUSH
echo -e -n "\n${INDENT}${BOLD}${YELLOW}➜ Lanjutkan push ke GitHub?${NC} [y/N]: "
read -r confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "\n${INDENT}${RED}✖ Proses dibatalkan.${NC}\n"
    exit 0
fi

# 6. EKSEKUSI GIT DENGAN INDENTASI
echo -e "\n${INDENT}${DIM}➜ Menjalankan Git...${NC}"

git add .
git commit -m "$commit_msg" | sed "s/^/${INDENT}  /"

# Eksekusi push dan tangkap hasilnya
echo -e "${INDENT}${DIM}➜ Mengirim ke GitHub...${NC}"
git push origin main 2>&1 | sed "s/^/${INDENT}  /"
push_status=${PIPESTATUS[0]}

# 7. NOTIFIKASI HASIL AKHIR
if [ $push_status -eq 0 ]; then
    echo -e "\n${INDENT}${GREEN}✔ SUKSES! Perubahan telah tersimpan di GitHub.${NC}\n"
else
    echo -e "\n${INDENT}${RED}✖ GAGAL! Terjadi kesalahan saat push.${NC}\n"
fi
