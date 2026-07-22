SHELL := /bin/bash

TARGET := dark.bin

# ==================== WARNA ====================
RED    := \033[91m
GREEN  := \033[92m
BLUE   := \033[94m
RESET  := \033[0m

REQUIRED_PACKAGES := requests phonenumbers rich pycryptodome

.PHONY: install check run help

install:
	@echo -e "$(BLUE)[+] Menginstall dependency...$(RESET)"
	@python -m pip install -q pycryptodome
	@python -m pip install -q $(REQUIRED_PACKAGES)
	@echo -e "$(GREEN)[✓] Install selesai!$(RESET)"

check:
	@echo -e "$(BLUE)[+] Mengecek dependency...$(RESET)"
	@for pkg in $(REQUIRED_PACKAGES); do \
		if python -c "import $$pkg" >/dev/null 2>&1; then \
			echo -e "$(GREEN)[✓] $$pkg$(RESET)"; \
		else \
			echo -e "$(RED)[✗] $$pkg belum terpasang, menginstall...$(RESET)"; \
			python -m pip install -q $$pkg; \
		fi; \
	done

run: install check
	@clear
	@echo -e "$(BLUE)[+] Mengupdate repository...$(RESET)"
	@git stash push --include-untracked -m "auto-stash" >/dev/null 2>&1 || true
	@git pull --rebase --autostash || true
	@git stash pop >/dev/null 2>&1 || true

	@echo -e "$(BLUE)[+] Menggunakan Python system...$(RESET)"
	@pyenv global system >/dev/null 2>&1 || true

	@echo -e "$(GREEN)[+] Menjalankan $(TARGET)...$(RESET)"
	@if [ ! -f "$(TARGET)" ]; then \
		echo -e "$(RED)[!] File $(TARGET) tidak ditemukan$(RESET)"; \
		exit 1; \
	fi
	@chmod +x $(TARGET)
	@./$(TARGET)