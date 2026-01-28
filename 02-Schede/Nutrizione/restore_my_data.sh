#!/bin/bash
set -e

# Calcola automaticamente la directory radice del repo VBR
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VBR_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

DB="${VBR_ROOT}/01-Dati/FDC.sqlite"
BACKUP="${VBR_ROOT}/01-Dati/my_tables.sql"

echo "🔄 Ripristino tabelle personalizzate da ${BACKUP}..."

# Verifica esistenza file (sicurezza VBR)
if [ ! -f "$DB" ]; then
    echo "❌ ERRORE: database non trovato: $DB"
    exit 1
fi
if [ ! -f "$BACKUP" ]; then
    echo "❌ ERRORE: backup non trovato: $BACKUP"
    exit 1
fi

sqlite3 "$DB" <<SQL
DROP TABLE IF EXISTS my_diet_nutrients;
DROP TABLE IF EXISTS my_diet;
DROP TABLE IF EXISTS my_nutrient_targets;
.read ${BACKUP}
SQL

echo "✅ Tabelle my:* ripristinate con successo"
