
.PHONY: run setup

run: setup
	@echo "🔄 Menarik update terbaru dari repository..."
	@git pull 2>/dev/null || echo "ℹ️  Bukan repo git, skip pull."
	@echo "⏳ Memuat VORTHIX..."
	@bash -c 'for i in {1..10}; do printf "█"; sleep 0.1; done; echo " 100%"'
	@echo "🚀 Menjalankan VORTHIX OTP Spammer..."
	@python3 spammer.py

setup:
	@echo "🔧 Memeriksa dependensi..."
	@command -v python3 >/dev/null 2>&1 || { echo "❌ Python3 tidak ditemukan. Install dengan: pkg install python"; exit 1; }
	@command -v pip3 >/dev/null 2>&1 || { echo "❌ pip3 tidak ditemukan. Install dengan: pkg install python-pip"; exit 1; }
	@pip3 show requests >/dev/null 2>&1 || { echo "📦 Menginstall requests..."; pip3 install requests; }
	@pip3 show urllib3 >/dev/null 2>&1 || { echo "📦 Menginstall urllib3..."; pip3 install urllib3; }
	@echo "✅ Semua dependensi sudah siap."