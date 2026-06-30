.PHONY: run

run:
	@echo "🔄 Menarik update terbaru dari repository..."
	@git pull 2>/dev/null || echo "ℹ️  Bukan repo git, skip pull."
	@echo "⏳ Memuat VORTHIX..."
	@bash -c 'for i in {1..10}; do printf "█"; sleep 0.1; done; echo " 100%"'
	@echo "🚀 Menjalankan VORTHIX OTP Spammer..."
	@python3 spammer.p,