SHELL := /bin/bash

TARGET := loly.py

# ==================== WARNA ====================
RED    := \033[91m
GREEN  := \033[92m
BLUE   := \033[94m
RESET  := \033[0m

REQUIRED_PACKAGES := requests phonenumbers rich beautifulsoup4 pycryptodome fake-useragent

.PHONY: install check run help

install:
	@echo -e "$(BLUE)[+] Menginstall dependency...$(RESET)"
	@python -m pip install -q $(REQUIRED_PACKAGES)
	@echo -e "$(GREEN)[✓] Install selesai!$(RESET)"

check:
	@echo -e "$(BLUE)[+] Mengecek dependency...$(RESET)"
	@python -c "import requests" >/dev/null 2>&1 && echo -e "$(GREEN)[✓] requests$(RESET)" || { echo -e "$(RED)[✗] requests$(RESET)"; python -m pip install -q requests; }
	@python -c "import phonenumbers" >/dev/null 2>&1 && echo -e "$(GREEN)[✓] phonenumbers$(RESET)" || { echo -e "$(RED)[✗] phonenumbers$(RESET)"; python -m pip install -q phonenumbers; }
	@python -c "import rich" >/dev/null 2>&1 && echo -e "$(GREEN)[✓] rich$(RESET)" || { echo -e "$(RED)[✗] rich$(RESET)"; python -m pip install -q rich; }
	@python -c "import bs4" >/dev/null 2>&1 && echo -e "$(GREEN)[✓] bs4$(RESET)" || { echo -e "$(RED)[✗] bs4$(RESET)"; python -m pip install -q beautifulsoup4; }
	@python -c "from Crypto import Cipher" >/dev/null 2>&1 && echo -e "$(GREEN)[✓] pycryptodome$(RESET)" || { echo -e "$(RED)[✗] pycryptodome$(RESET)"; python -m pip install -q pycryptodome; }

run: install check
	@python run.py