#!/bin/bash
# Uso: ./restore_my_data.sh 01-Dati/backups/my_tables_20260126.sql

if [ $# -eq 0 ]; then
  echo "UsageId: $0 <percorso_file_backup.sql>"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."
DB_PATH="$ROOT_DIR/01-Dati/FDC.sqlite"

echo "🔄 Ripristino da $1..."
sqlite3 "$DB_PATH" ".read $1"
echo "✅ Ripristino completato."