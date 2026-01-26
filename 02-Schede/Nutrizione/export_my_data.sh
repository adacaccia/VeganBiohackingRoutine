#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/../.."
DB_PATH="$ROOT_DIR/01-Dati/FDC.sqlite"
BACKUP_PATH="$ROOT_DIR/01-Dati/my_tables.sql"

echo "🔄 Esportazione tabelle personalizzate..."
sqlite3 "$DB_PATH" <<EOF
.output $BACKUP_PATH
.dump my_diet
.dump my_nutrient_targets
.dump my_diet_nutrients
.output stdout
EOF

echo "✅ Salvato: $BACKUP_PATH"
