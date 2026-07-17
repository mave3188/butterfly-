# ============================================================
# DARK SHADOW - Makefile
# Author : XERXEZ
# Version : 1.3.8
# ============================================================

SHELL := /bin/bash
PYTHON := python3
SCRIPT := Spammer.py
BINARY := Spammer.bin
TARGET_PYTHON_VERSION := 3.13.13

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

.PHONY: help run install clean build binary check downgrade

help: ## Tampilkan bantuan
	@echo -e ""
	@echo -e "$(BOLD)$(CYAN)  DARK SHADOW - Spammer Toolkit$(RESET)"
	@echo -e "  Author : XERXEZ | Version 1.3.8"
	@echo -e ""
	@echo -e "$(BOLD)Available targets:$(RESET)"
	@echo -e "  $(GREEN)make run$(RESET)        - Jalankan Spammer.py (auto cek dependensi)"
	@echo -e "  $(GREEN)make binary$(RESET)     - Build binary Spammer.bin dari Spammer.py"
	@echo -e "  $(GREEN)make check$(RESET)      - Cek dependensi yang terinstall"
	@echo -e "  $(GREEN)make install$(RESET)    - Install semua dependensi"
	@echo -e "  $(GREEN)make clean$(RESET)      - Hapus file cache dan build"
	@echo -e "  $(GREEN)make downgrade$(RESET)  - Auto downgrade Python ke $(TARGET_PYTHON_VERSION)"
	@echo -e "  $(GREEN)make help$(RESET)       - Tampilkan bantuan ini"
	@echo -e ""

downgrade: ## Auto downgrade Python ke 3.13.13
	@echo -e "$(BLUE)[+] Mengecek Python version...$(RESET)"
	@CURRENT=$$($(PYTHON) --version 2>&1 | awk '{print $$2}'); \
	if [ "$$CURRENT" = "$(TARGET_PYTHON_VERSION)" ]; then \
		echo -e "$(GREEN)[✓] Python version sudah $(TARGET_PYTHON_VERSION)$(RESET)"; \
	else \
		echo -e "$(YELLOW)[!] Python version saat ini: $$CURRENT$(RESET)"; \
		echo -e "$(YELLOW)[!] Target: $(TARGET_PYTHON_VERSION)$(RESET)"; \
		echo -e "$(BLUE)[+] Menginstall Python $(TARGET_PYTHON_VERSION)...$(RESET)"; \
		if command -v apt &> /dev/null; then \
			echo -e "$(BLUE)[+] Menggunakan apt (Termux/Ubuntu/Debian)...$(RESET)"; \
			pkg install -y python3.13 2>/dev/null || apt update && apt install -y python3.13; \
		elif command -v pkg &> /dev/null; then \
			echo -e "$(BLUE)[+] Menggunakan pkg (Termux)...$(RESET)"; \
			pkg update -y && pkg install -y python3.13; \
		else \
			echo -e "$(RED)[!] Tidak ada package manager yang dikenali$(RESET)"; \
			echo -e "$(YELLOW)[!] Install Python $(TARGET_PYTHON_VERSION) secara manual$(RESET)"; \
			exit 1; \
		fi; \
		if command -v python3.13 &> /dev/null; then \
			echo -e "$(GREEN)[✓] Python $(TARGET_PYTHON_VERSION) berhasil diinstall!$(RESET)"; \
			echo -e "$(BLUE)[+] Mengganti default Python ke 3.13...$(RESET)"; \
			alias python3='python3.13' 2>/dev/null || true; \
		else \
			echo -e "$(RED)[!] Gagal menginstall Python $(TARGET_PYTHON_VERSION)$(RESET)"; \
			exit 1; \
		fi; \
	fi

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