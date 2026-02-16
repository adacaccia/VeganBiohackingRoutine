# Makefile per VBR
.PHONY: report check clean

report:
	@echo "🚀 Generazione report nutrizionale..."
	python3 report.py
	@mv my_diet_report.html 04-Report/Nutrizione/index.html
	@echo "✅ Report pronto in 04-Report/Nutrizione/index.html"

check:
	./SystemCheck.sh
