# ============================================================
# DARK SHADOW - Makefile
# Author : XERXEZ
# Version : 1.3.8
# ============================================================

SHELL := /bin/bash

PYTHON := python
SCRIPT := Spammer.py
TARGET_PYTHON_VERSION := 3.13.5

# ==================== WARNA ====================
RED    := \033[91m
GREEN  := \033[92m
YELLOW := \033[93m
BLUE   := \033[94m
RESET  := \033[0m

# ==================== DEPENDENSI ====================
REQUIRED_PACKAGES := requests phonenumbers rich

.PHONY: install downgrade check run help

# ==================== DOWNGRADE PYTHON ====================

downgrade:
	@echo "[*] Menggunakan Python 3.13.5..."
	@if ! command -v pyenv >/dev/null 2>&1; then \
		echo "[!] pyenv belum terpasang."; \
		exit 1; \
	fi
	@pyenv install -s 3.13.5
	@pyenv global 3.13.5
	@pyenv rehash
	@echo "[✓] Python aktif:"
	@python --version
	@pip --version

# ==================== INSTALL DEPENDENSI ====================

install:
	@echo -e "$(BLUE)[+] Install dependency...$(RESET)"
	@pip install --upgrade pip
	@pip install $(REQUIRED_PACKAGES)
	@echo -e "$(GREEN)[✓] Selesai!$(RESET)"


# ==================== CHECK ====================

check:
	@echo -e "$(BLUE)[+] Mengecek dependency...$(RESET)"
	@for pkg in $(REQUIRED_PACKAGES); do \
		if python -c "import $$pkg" 2>/dev/null; then \
			echo -e "$(GREEN)[✓] $$pkg$(RESET)"; \
		else \
			echo -e "$(RED)[✗] $$pkg belum ada$(RESET)"; \
		fi; \
	done


# ==================== RUN ====================

run: downgrade check
	@clear
	@echo -e "$(GREEN)[+] Menjalankan $(SCRIPT)...$(RESET)"
	@if [ ! -f "$(SCRIPT)" ]; then \
		echo -e "$(RED)[!] File $(SCRIPT) tidak ditemukan$(RESET)"; \
		exit 1; \
	fi
	@python $(SCRIPT)


