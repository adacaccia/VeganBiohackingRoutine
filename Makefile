# Makefile per VBR
.PHONY: report check clean

report:
	@echo "🚀 Generazione report nutrizionale..."
	python3 report.py
	@echo "✅ Report pronto per il deploy in docs/index.html"

check:
	./SystemCheck.sh
