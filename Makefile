.PHONY: run

run:
	@python3 -c "import sys,re,time,os,socket,json,smtplib,requests,platform; from rich.live import Live; from rich.table import Table; from email.mime.text import MIMEText; from email.mime.multipart import MIMEMultipart; from concurrent.futures import ThreadPoolExecutor, as_completed" || { \
		echo ""; \
		echo "[!] Library belum terinstall!"; \
		echo "Install dengan:"; \
		echo "pip install requests rich"; \
		exit 1; \
	}

	@git pull --quiet
	@printf "Loading"
	@for i in 1 2 3 4 5; do printf "."; sleep 0.4; done
	@echo
	@echo "Starting..."
	@chmod +x Spammer.bin
	@./Spammer.bin