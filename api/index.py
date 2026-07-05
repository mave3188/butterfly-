import os
import hashlib
import json
from flask import Flask, request, render_template_string, session, redirect, url_for, jsonify

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'rahasia_dark_shy_default')

# Path file
WHITELIST_FILE = "/tmp/whitelist.txt"
PASS_FILE = "/tmp/admin_pass.txt"

# Fallback in-memory jika file tidak bisa ditulis
_memory_whitelist = []
_memory_password = None

def log(msg):
    print(f"[DARKSHY] {msg}")

def hash_password(pwd):
    return hashlib.sha256(pwd.encode()).hexdigest()

def get_admin_password():
    env_pwd = os.environ.get('ADMIN_PASSWORD')
    if env_pwd:
        return hash_password(env_pwd)
    return hash_password("admin123")

def setup_password():
    global _memory_password
    try:
        if not os.path.exists(PASS_FILE):
            pwd = get_admin_password()
            with open(PASS_FILE, 'w') as f:
                f.write(pwd)
            os.chmod(PASS_FILE, 0o600)
            log("Password file created")
        with open(PASS_FILE, 'r') as f:
            _memory_password = f.read().strip()
    except Exception as e:
        log(f"Error setup password: {e}")
        _memory_password = get_admin_password()

def check_password(pwd):
    global _memory_password
    if _memory_password is None:
        setup_password()
    return hash_password(pwd) == _memory_password

def get_whitelist():
    global _memory_whitelist
    try:
        if os.path.exists(WHITELIST_FILE):
            with open(WHITELIST_FILE, 'r') as f:
                ids = [line.strip() for line in f if line.strip()]
                _memory_whitelist = ids
                return ids
        else:
            return _memory_whitelist
    except Exception as e:
        log(f"Error reading whitelist: {e}")
        return _memory_whitelist

def save_whitelist(ids):
    global _memory_whitelist
    _memory_whitelist = ids
    try:
        with open(WHITELIST_FILE, 'w') as f:
            f.write('\n'.join(ids) + '\n')
        os.chmod(WHITELIST_FILE, 0o600)
        log(f"Whitelist saved: {len(ids)} entries")
        return True
    except Exception as e:
        log(f"Error saving whitelist: {e}")
        return False

def add_whitelist(device_id):
    ids = get_whitelist()
    if device_id not in ids:
        ids.append(device_id)
        save_whitelist(ids)
        return True
    return False

def delete_whitelist(device_id):
    ids = get_whitelist()
    if device_id in ids:
        ids.remove(device_id)
        save_whitelist(ids)
        return True
    return False

# HTML templates (sama seperti sebelumnya)
LOGIN_HTML = """
<!DOCTYPE html>
<html>
<head>
    <title>DARK SHY - Login</title>
    <style>
        body { background: #0d0d0d; color: #ccc; font-family: monospace; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .box { background: #1a1a1a; padding: 40px; border-radius: 8px; border: 1px solid #7a3b9e; width: 300px; }
        h1 { color: #a855f7; text-align: center; font-size: 24px; margin-top: 0; }
        input { width: 100%; padding: 10px; margin: 8px 0; background: #2a2a2a; border: 1px solid #555; color: #fff; border-radius: 4px; box-sizing: border-box; }
        input[type="submit"] { background: #7a3b9e; color: #fff; font-weight: bold; border: none; cursor: pointer; }
        .error { color: #ff4444; text-align: center; }
        .footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="box">
        <h1>⚡ DARK SHY</h1>
        <form method="POST">
            <input type="password" name="password" placeholder="Password Admin" required>
            <input type="submit" value="Login">
        </form>
        {% if error %}<p class="error">{{ error }}</p>{% endif %}
        <div class="footer">Admin only</div>
    </div>
</body>
</html>
"""

DASHBOARD_HTML = """
<!DOCTYPE html>
<html>
<head>
    <title>DARK SHY - Dashboard</title>
    <style>
        body { background: #0d0d0d; color: #ccc; font-family: monospace; padding: 20px; }
        .container { max-width: 800px; margin: auto; }
        h1 { color: #a855f7; }
        .card { background: #1a1a1a; padding: 20px; border-radius: 8px; margin: 15px 0; border-left: 3px solid #7a3b9e; }
        .id-item { background: #2a2a2a; padding: 8px 12px; margin: 5px 0; border-radius: 4px; display: flex; justify-content: space-between; align-items: center; }
        .id-item .id-text { color: #a855f7; }
        .id-item .btn-delete { background: #b91c1c; color: #fff; border: none; padding: 4px 12px; border-radius: 4px; cursor: pointer; font-size: 12px; }
        .id-item .btn-delete:hover { background: #ff4444; }
        input[type="text"] { padding: 10px; width: 70%; background: #2a2a2a; border: 1px solid #555; color: #fff; border-radius: 4px; }
        input[type="submit"] { padding: 10px 20px; background: #7a3b9e; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
        .btn { display: inline-block; padding: 8px 16px; background: #333; color: #fff; text-decoration: none; border-radius: 4px; margin-top: 10px; }
        .btn-logout { background: #b91c1c; }
        .msg { color: #4ade80; }
        .error-msg { color: #ff4444; }
        .footer { margin-top: 30px; color: #666; font-size: 12px; text-align: center; }
    </style>
</head>
<body>
    <div class="container">
        <h1>⚡ DARK SHY - DASHBOARD</h1>
        <div class="card">
            <p>Total terdaftar: <strong>{{ total }}</strong></p>
            <a href="/logout" class="btn btn-logout">Logout</a>
        </div>
        <div class="card">
            <h3>Tambah Device ID</h3>
            <form method="POST" action="/add">
                <input type="text" name="device_id" placeholder="Masukkan device ID" required>
                <input type="submit" value="Tambah">
            </form>
            {% if msg %}<p class="msg">{{ msg }}</p>{% endif %}
            {% if err %}<p class="error-msg">{{ err }}</p>{% endif %}
        </div>
        <div class="card">
            <h3>Daftar Device</h3>
            {% if ids %}
                {% for id in ids %}
                <div class="id-item">
                    <span class="id-text">🔮 {{ id }}</span>
                    <form method="POST" action="/delete" style="display:inline;">
                        <input type="hidden" name="device_id" value="{{ id }}">
                        <input type="submit" class="btn-delete" value="Hapus" onclick="return confirm('Yakin hapus ID {{ id }}?')">
                    </form>
                </div>
                {% endfor %}
            {% else %}
                <p style="color:#666;">Belum ada device terdaftar.</p>
            {% endif %}
        </div>
        <div class="footer">DARK SHY - Only the chosen</div>
    </div>
</body>
</html>
"""

@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        pwd = request.form.get('password', '')
        if check_password(pwd):
            session['logged_in'] = True
            return redirect(url_for('dashboard'))
        return render_template_string(LOGIN_HTML, error="Password salah")
    return render_template_string(LOGIN_HTML, error=None)

@app.route('/dashboard')
def dashboard():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    ids = get_whitelist()
    return render_template_string(DASHBOARD_HTML, ids=ids, total=len(ids), msg=None, err=None)

@app.route('/add', methods=['POST'])
def add_device():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    device_id = request.form.get('device_id', '').strip()
    msg = None
    err = None
    if device_id:
        if add_whitelist(device_id):
            msg = f"✅ {device_id} berhasil ditambahkan"
        else:
            err = f"⚠️ {device_id} sudah terdaftar atau gagal simpan"
    ids = get_whitelist()
    return render_template_string(DASHBOARD_HTML, ids=ids, total=len(ids), msg=msg, err=err)

@app.route('/delete', methods=['POST'])
def delete_device():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    device_id = request.form.get('device_id', '').strip()
    msg = None
    err = None
    if device_id:
        if delete_whitelist(device_id):
            msg = f"🗑️ {device_id} berhasil dihapus"
        else:
            err = f"⚠️ {device_id} tidak ditemukan atau gagal hapus"
    ids = get_whitelist()
    return render_template_string(DASHBOARD_HTML, ids=ids, total=len(ids), msg=msg, err=err)

@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    return redirect(url_for('login'))

@app.route('/whitelist')
def whitelist():
    ids = get_whitelist()
    return jsonify({'ids': ids})

@app.route('/status')
def status():
    """Cek status file dan isi whitelist"""
    info = {
        'file_exists': os.path.exists(WHITELIST_FILE),
        'is_writable': os.access(WHITELIST_FILE, os.W_OK) if os.path.exists(WHITELIST_FILE) else False,
        'memory_count': len(get_whitelist()),
        'ids': get_whitelist(),
        'env': {
            'ADMIN_PASSWORD_SET': bool(os.environ.get('ADMIN_PASSWORD'))
        }
    }
    return jsonify(info)