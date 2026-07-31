import subprocess
import os
import sys

print("Update tools...")
subprocess.run(["git", "pull"])

print("Udah versi terbaru, lanjut run seperti biasa.")

os.execv(sys.executable, [sys.executable, "app.py"])