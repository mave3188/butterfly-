import subprocess
import sys
import os
import shutil

# Warna ANSI
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
CYAN = "\033[96m"
RESET = "\033[0m"

# Minimal lebar terminal
MIN_WIDTH = 64

def cek_ukuran():
    cols = shutil.get_terminal_size(fallback=(80, 24)).columns

    if cols < MIN_WIDTH:
        print(f"{RED}╭──────────────────────────────────────────────────────────────╮{RESET}")
        print(f"{RED}│      Ukuran terminal terlalu kecil!                         │{RESET}")
        print(f"{RED}│                                                              │{RESET}")
        print(f"{RED}│ Silakan cubit layar (zoom out) hingga tampil penuh.          │{RESET}")
        print(f"{RED}│ Lebar minimal: {MIN_WIDTH} kolom (saat ini: {cols}){' ' * max(0, 16-len(str(cols)))}│{RESET}")
        print(f"{RED}╰──────────────────────────────────────────────────────────────╯{RESET}")
        sys.exit(1)

cek_ukuran()

print(f"{BLUE}[+] Update tools...{RESET}")

result = subprocess.run(["git", "pull"])

if result.returncode == 0:
    print(f"{GREEN}[✓] Repository berhasil diperbarui.{RESET}")

print(f"{YELLOW}[!] Tunggu 1–10 detik, proses sedang berlangsung...{RESET}")

os.execv(sys.executable, [sys.executable, "loly.py"])