run:
	@clear
	@printf "\033[1;36m"
	@echo "        Dark Shadow"
	@printf "\033[0m"
	@echo
	@echo "Checking repository..."
	@git pull --quiet
	@echo "Repository updated"
	@echo
	@printf "Loading"
	@for i in 1 2 3 4 5; do \
		printf "."; \
		sleep 0.4; \
	done
	@echo
	@echo "Launching Spammer.py"
	@sleep 0.5
	@python3 Spammer.py