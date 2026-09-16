#!/usr/bin/env bash
# ============================================================
# push.sh - Mempermudah push update edBisync ke GitHub
# ============================================================

# --- WARNA ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

PROJECT_DIR="$HOME/projects/edBisnyc"
BIN_DIR="$HOME/.local/bin"

cd "$PROJECT_DIR" || exit 1

echo -e "${BOLD}${CYAN}======================================${NC}"
echo -e "${BOLD}${CYAN}       Git Push Helper - edBisync     ${NC}"
echo -e "${BOLD}${CYAN}======================================${NC}"

# 1. AUTO-SYNC BACK: Ambil versi terbaru dari ~/.local/bin/ jika ada perubahan
if [ -f "$BIN_DIR/edBisync" ]; then
    if ! cmp -s "$BIN_DIR/edBisync" "edBisync"; then
        echo -e "${YELLOW}ℹ️  Mendeteksi perubahan pada script operasional di ~/.local/bin/edBisync${NC}"
        cp "$BIN_DIR/edBisync" "edBisync"
        echo -e "${GREEN}✅ Berhasil memperbarui file 'edBisync' di folder project.${NC}"
    fi
fi

# 2. Tampilkan status git saat ini
echo -e "\n${BOLD}Status Git saat ini:${NC}"
git status -s

# 3. Cek apakah ada perubahan yang perlu di-push
if git diff --exit-code --quiet && git diff --cached --exit-code --quiet; then
    # Cek juga untracked files
    if [ -z "$(git status --porcelain)" ]; then
        echo -e "\n${GREEN}✅ Tidak ada perubahan yang perlu di-push. Clean!${NC}"
        exit 0
    fi
fi

# 4. Input Commit Message secara interaktif
echo -e "\n${BOLD}${YELLOW}Masukkan pesan commit Anda (kosongkan untuk default 'update: edBisync script'):${NC}"
read -r commit_msg

if [ -z "$commit_msg" ]; then
    commit_msg="update: edBisync script"
fi

# 5. Konfirmasi Push
echo -e -n "\n${BOLD}Lanjutkan melakukan push ke GitHub? (y/N): ${NC}"
read -r confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo -e "${RED}Dibatalkan.${NC}"
    exit 0
fi

# 6. Eksekusi Git
echo -e "\n${CYAN}Memulai proses Git...${NC}"
git add .
git commit -m "$commit_msg"
git push origin main

if [ $? -eq 0 ]; then
    echo -e "\n${BOLD}${GREEN}🎉 Berhasil di-push ke GitHub!${NC}"
else
    echo -e "\n${BOLD}${RED}❌ Gagal melakukan push. Periksa koneksi atau konflik git.${NC}"
fi
