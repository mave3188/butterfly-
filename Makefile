# ============================================================
# DARK SHADOW - Makefile
# Author : XERXEZ
# Version : 1.3.8
# ============================================================

SHELL := /bin/bash
PYTHON := python3
SCRIPT := Spammer.py
BINARY := Spammer.bin
TARGET_PYTHON_VERSION := 3.13.5

# ==================== WARNA ====================
RED    := \033[91m
GREEN  := \033[92m
YELLOW := \033[93m
BLUE   := \033[94m
CYAN   := \033[96m
RESET  := \033[0m
BOLD   := \033[1m

# ==================== DEPENDENSI ====================
REQUIRED_PACKAGES := requests phonenumbers rich

.PHONY:  run install build check downgrade

downgrade:
	@echo "[+] Menyiapkan Python $(TARGET_PYTHON_VERSION)..."
	@pkg install -y openssl libffi
	@if ! command -v pyenv >/dev/null 2>&1; then \
		echo "[!] pyenv belum terinstall."; \
		exit 1; \
	fi
	@if ! pyenv versions --bare | grep -qx "$(TARGET_PYTHON_VERSION)"; then \
		echo "[+] Menginstall Python $(TARGET_PYTHON_VERSION)..."; \
		pyenv install $(TARGET_PYTHON_VERSION); \
	fi
	@pyenv global $(TARGET_PYTHON_VERSION)
	@hash -r
	@echo "[✓] Python aktif:"
	@python --version

check: ## Cek dependensi
	@echo -e "$(BLUE)[+] Mengecek dependensi...$(RESET)"
	@MISSING=""; \
	for pkg in $(REQUIRED_PACKAGES); do \
		if $(PYTHON) -c "import $$pkg" 2>/dev/null; then \
			echo -e "$(GREEN)[✓] $$pkg$(RESET)"; \
		else \
			echo -e "$(RED)[✗] $$pkg (belum terinstall)$(RESET)"; \
			MISSING="$$MISSING $$pkg"; \
		fi; \
	done; \
	if [ -n "$$MISSING" ]; then \
		echo ""; \
		echo -e "$(RED)[!] Dependensi yang kurang:$$MISSING$(RESET)"; \
		echo -e "$(YELLOW)[!] Jalankan 'make install' untuk menginstall semua dependensi$(RESET)"; \
		exit 1; \
	fi
	@echo -e "$(GREEN)[✓] Semua dependensi terinstall!$(RESET)"

run: downgrade check
	@clear
	@echo -e "$(GREEN)[+] Menjalankan $(SCRIPT)...$(RESET)"
	@if [ ! -f "./$(SCRIPT)" ]; then \
		echo -e "$(RED)[!] $(SCRIPT) tidak ditemukan.$(RESET)"; \
		exit 1; \
	fi
	@chmod +x "./$(SCRIPT)"
	@$(PYTHON) "./$(SCRIPT)"

install: ## Install semua dependensi (tanpa pyinstaller error)
	@echo -e "$(BLUE)[+] Menginstall dependensi...$(RESET)"
	@pip install $(REQUIRED_PACKAGES)
	@echo -e "$(GREEN)[+] Selesai!$(RESET)"
# ==================== DEFAULT ====================
.DEFAULT_GOAL := help