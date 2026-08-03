import subprocess
import sys
import os

# Warna ANSI
RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
BLUE = "\033[94m"
CYAN = "\033[96m"
RESET = "\033[0m"

print(f"{BLUE}[+] Update tools...{RESET}")

result = subprocess.run(["git", "pull"])

if result.returncode == 0:
    print(f"{GREEN}[✓] Repository berhasil diperbarui.{RESET}")


print(f"{YELLOW}[!] Tunggu 1–10 detik, proses sedang berlangsung...{RESET}")

os.execv(sys.executable, [sys.executable, "loly.py"])