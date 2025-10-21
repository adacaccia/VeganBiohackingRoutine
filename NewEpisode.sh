#!/usr/bin/env bash
# ============================================================
#  Functional Human / Vegan Biohacking Routine
#  NEW EPISODE SETUP SCRIPT
# ------------------------------------------------------------
#  Crea struttura episodio Markdown pronta per GitHub.
#  Versione: 1.3.0 – Ottobre 2025
# ============================================================

set -euo pipefail

CODE="${1:-}"
TITLE="${2:-}"

if [[ -z "$CODE" || -z "$TITLE" ]]; then
  echo "uso: $0 EPxx \"Titolo episodio\"" >&2
  exit 1
fi

TEMPLATE="00-Docs/NewEpisode_Template.md"
if [[ ! -f "$TEMPLATE" ]]; then
  echo "❌ Template episodio non trovato: $TEMPLATE" >&2
  exit 1
fi

# --- funzione slugify ---
slugify() {
  if command -v iconv >/dev/null 2>&1; then
    printf '%s' "$1" \
      | iconv -f UTF-8 -t ASCII//TRANSLIT \
      | tr '[:upper:]' '[:lower:]' \
      | sed -E 's/[[:space:]]+/-/g; s/[^a-z0-9_-]+//g; s/-+/-/g; s/^-|-$//g'
  else
    printf '%s' "$1" \
      | tr '[:upper:]' '[:lower:]' \
      | sed -E 's/[[:space:]]+/-/g; s/[^a-z0-9_-]+//g; s/-+/-/g; s/^-|-$//g'
  fi
}

SLUG="$(slugify "$TITLE")"
EP_DIR="10-Episodi/${CODE}-${SLUG}"
EP_FILE="${EP_DIR}/${CODE}-${SLUG}.md"

# --- crea dir principali ---
mkdir -p "${EP_DIR}/assets" "${EP_DIR}/notes"

# --- crea placeholder .gitkeep in ogni cartella ---
for sub in "." "assets" "notes"; do
  : > "${EP_DIR}/${sub}/.gitkeep"
done

# --- copia template e sostituisce placeholder ---
DATE_FMT="$(date +%Y-%m-%d)"
sed -e "s/{{CODE}}/${CODE}/g" \
    -e "s/{{TITLE}}/${TITLE}/g" \
    -e "s/{{DATE}}/${DATE_FMT}/g" \
    "$TEMPLATE" > "$EP_FILE"

# --- output finale ---
echo -e "✅ Creato episodio ${CODE}: ${TITLE}"
echo -e "📁 Cartella: ${EP_DIR}"
echo -e "📄 File:     ${EP_FILE}"
echo -e "🧩 Sottocartelle: assets/, notes/ (+ .gitkeep)\n"
