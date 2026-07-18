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
	@echo -e "$(BLUE)[+] Menyiapkan Python $(TARGET_PYTHON_VERSION)...$(RESET)"
	@pkg install -y openssl libffi zlib clang make curl

	@if [ ! -d "$$HOME/.pyenv" ]; then \
		echo -e "$(YELLOW)[+] Install pyenv...$(RESET)"; \
		curl https://pyenv.run | bash; \
	fi

	@export PYENV_ROOT="$$HOME/.pyenv"; \
	export PATH="$$PYENV_ROOT/bin:$$PATH"; \
	eval "$$(pyenv init -)"; \
	if ! pyenv versions --bare | grep -qx "$(TARGET_PYTHON_VERSION)"; then \
		echo -e "$(YELLOW)[+] Install Python $(TARGET_PYTHON_VERSION)...$(RESET)"; \
		pyenv install $(TARGET_PYTHON_VERSION); \
	fi; \
	pyenv global $(TARGET_PYTHON_VERSION)

	@echo -e "$(GREEN)[✓] Python aktif:$(RESET)"
	@python --version


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

run: downgrade install check
	@clear
	@echo -e "$(GREEN)[+] Menjalankan $(SCRIPT)...$(RESET)"
	@if [ ! -f "$(SCRIPT)" ]; then \
		echo -e "$(RED)[!] File $(SCRIPT) tidak ditemukan$(RESET)"; \
		exit 1; \
	fi
	@python $(SCRIPT)


