import re

with open("spammer.py", "r") as f:
    content = f.read()

# Cari SEMUA data = "..." (termasuk yang ada spasi/newline)
def fix(m):
    raw = m.group(1)
    raw += '=' * (-len(raw) % 4)
    return f'data = "{raw}"'

new_content = re.sub(r'data\s*=\s*"([^"]+)"', fix, content)

# Juga cari data = '...' (kutip tunggal)
new_content = re.sub(r"data\s*=\s*'([^']+)'", lambda m: f"data = '{m.group(1) + '=' * (-len(m.group(1)) % 4)}'", new_content)

with open("spammer.py", "w") as f:
    f.write(new_content)

print("✅ Fix selesai.")