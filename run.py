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
RESET = "\033[0m"

MIN_WIDTH = 64

def clear():
    os.system("clear")

def banner_ok(cols):
    print(f"""{GREEN}
==============================================================
                  ✓ UKURAN TERMINAL SUDAH PAS
==============================================================

 Status : SIAP
 Lebar  : {cols}/{MIN_WIDTH} kolom

 Tekan ENTER untuk melanjutkan...

==============================================================
{RESET}""")

def banner_error(cols):
    print(f"""{RED}
==============================================================
                ✗ UKURAN TERMINAL TERLALU KECIL
==============================================================

 Status : BELUM SESUAI
 Lebar  : {cols}/{MIN_WIDTH} kolom

 Cubit layar (zoom out) hingga ukuran pas.
 Tunggu sampai status berubah menjadi HIJAU.

==============================================================
{RESET}""")

# Cek ukuran terminal
while True:
    cols = shutil.get_terminal_size(fallback=(80, 24)).columns
    clear()

    if cols >= MIN_WIDTH:
        banner_ok(cols)
        input()
        break

    banner_error(cols)
    time.sleep(0.5)

# Update repository
clear()
print(f"{BLUE}[+] Update tools...{RESET}")

result = subprocess.run(["git", "pull"])

if result.returncode == 0:
    print(f"{GREEN}[✓] Repository berhasil diperbarui.{RESET}")
else:
    print(f"{RED}[✗] Gagal memperbarui repository.{RESET}")

print(f"{YELLOW}[!] Tunggu 1–10 detik, proses sedang berlangsung...{RESET}")

time.sleep(2)

# Jalankan tools utama
os.execv(sys.executable, [sys.executable, "loly.py"])