.PHONY: run setup

run: setup
	@echo "🔄 Menarik update terbaru..."
	@git pull 2>/dev/null || echo "ℹ️  Bukan repo git, skip pull."
	@echo "⏳ Memuat VORTHIX..."
	@bash -c 'for i in {1..10}; do printf "█"; sleep 0.1; done; echo " 100%"'
	@echo "🚀 Menjalankan spammer.py..."
	@python3 spammer.py

setup:
	@echo "🔧 Memeriksa dependensi..."
	@command -v python3 >/dev/null 2>&1 || { echo "❌ Python3 tidak ditemukan. Install: pkg install python"; exit 1; }
	@command -v pip3 >/dev/null 2>&1 || { echo "❌ pip3 tidak ditemukan. Install: pkg install python-pip"; exit 1; }
	@if [ -f requirements.txt ]; then \
		echo "📦 Menginstall dari requirements.txt..."; \
		pip3 install -r requirements.txt; \
	else \
		echo "⚠️  requirements.txt tidak ditemukan, install manual requests & urllib3"; \
		pip3 install requests urllib3; \
	fi
	@echo "✅ Semua dependensi siap."