import subprocess
import sys
import os
import shutil
import time

# Warna ANSI
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
CYAN = "\033[96m"
RESET = "\033[0m"

MIN_WIDTH = 64

def clear():
    os.system("clear")

while True:
    cols = shutil.get_terminal_size(fallback=(80, 24)).columns
    clear()

    if cols >= MIN_WIDTH:
        print(f"""{GREEN}
╭──────────────────────────────────────────────────────────────╮
│                  ✓ UKURAN TERMINAL SUDAH PAS                 │
├──────────────────────────────────────────────────────────────┤
│ Status : SIAP                                                │
│ Lebar  : {cols} / {MIN_WIDTH} kolom{" " * max(0, 26-len(str(cols)))}│
│                                                              │
│ Tekan ENTER untuk melanjutkan...                             │
╰──────────────────────────────────────────────────────────────╯
{RESET}""")
        input()
        break

    print(f"""{RED}
╭──────────────────────────────────────────────────────────────╮
│                 ✗ UKURAN TERMINAL TERLALU KECIL              │
├──────────────────────────────────────────────────────────────┤
│ Status : BELUM SESUAI                                        │
│ Lebar  : {cols} / {MIN_WIDTH} kolom{" " * max(0, 26-len(str(cols)))}│
│                                                              │
│ Cubit layar (zoom out) hingga status berubah HIJAU.          │
╰──────────────────────────────────────────────────────────────╯
{RESET}""")

    time.sleep(0.5)

print(f"{BLUE}[+] Update tools...{RESET}")

result = subprocess.run(["git", "pull"])

if result.returncode == 0:
    print(f"{GREEN}[✓] Repository berhasil diperbarui.{RESET}")
else:
    print(f"{RED}[✗] Gagal memperbarui repository.{RESET}")

print(f"{YELLOW}[!] Tunggu 1–10 detik, proses sedang berlangsung...{RESET}")

os.execv(sys.executable, [sys.executable, "loly.py"])