#!/usr/bin/env bash
# ============================================================
#  Vegan Biohacking Routine / Functional Human Project
#  SYSTEM CHECK SCRIPT
#  Verifica la struttura e la consistenza dei file principali.
# ------------------------------------------------------------
#  Versione: 1.2.0 (ottobre 2025)
#  Autore:   Functional Human Project
#  Licenza:  CC-BY-NC 4.0
# ============================================================

# --- Colori terminale ---
GREEN="\e[32m"; YELLOW="\e[33m"; RED="\e[31m"; RESET="\e[0m"

echo -e "\n🔍 ${YELLOW}Verifica struttura Vegan Biohacking Routine...${RESET}\n"

# --- Directory attese ---
declare -a MAIN_DIRS=("00-Docs" "01-Dati" "02-Schede" "03-Analisi" "10-Episodi")

for dir in "${MAIN_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo -e "✅ Dir presente: ${GREEN}$dir${RESET}"
  else
    echo -e "❌ Manca dir: ${RED}$dir${RESET}"
  fi
done

echo ""

# --- File chiave attesi ---
declare -A KEY_FILES=(
  ["00-Docs/Manifesto_VBR_2025.md"]="Manifesto del progetto"
  ["00-Docs/Consuntivo_Integrato_2025-09.md"]="Consuntivo Settembre"
  ["00-Docs/Consuntivo_Integrato_2025-10.md"]="Consuntivo Ottobre"
  ["02-Schede/Scheda_Palestra_Uomo50+.md"]="Scheda base Full Body"
  ["02-Schede/Scheda_Allenamento_Casa_RSC_Ottobre2025.md"]="Scheda Casa + RSC"
  ["03-Analisi/README.md"]="Indice sezione Analisi"
  ["SystemCheck.sh"]="Script di verifica struttura"
)

for path in "${!KEY_FILES[@]}"; do
  if [ -f "$path" ]; then
    echo -e "✅ File presente: ${GREEN}$path${RESET} — ${KEY_FILES[$path]}"
  else
    echo -e "⚠️  Mancante: ${YELLOW}$path${RESET} — ${KEY_FILES[$path]}"
  fi
done

echo ""

# --- Controllo eventuali duplicati .docx / .md ---
DUPLICATES=$(find . -type f \( -name "*.docx" -o -name "*.md" \) -printf "%f\n" | sort | uniq -d)

if [ -n "$DUPLICATES" ]; then
  echo -e "⚠️  File con nomi duplicati trovati (possibile doppione tra DOCX/MD):"
  echo "$DUPLICATES" | while read -r dup; do echo -e "   → ${YELLOW}$dup${RESET}"; done
else
  echo -e "✅ Nessun duplicato rilevato tra DOCX e MD."
fi

echo ""

# --- Verifica presenza README root ---
if [ -f "README.md" ]; then
  echo -e "✅ README root presente."
else
  echo -e "⚠️  Nessun README.md nella root."
fi

echo ""

# --- Report finale ---
echo -e "📋 ${YELLOW}Verifica completata.${RESET}"
echo -e "Se vedi solo simboli ✅ e ⚙️, la struttura è coerente.\n"
