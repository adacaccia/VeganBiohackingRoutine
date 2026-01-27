#!/bin/bash
set -e  # Exit on error

DB="../../01-Dati/FDC.sqlite"
BACKUP="../../01-Dati/my_tables.sql"

echo "🔄 Ripristino tabelle personalizzate da $BACKUP..."

# DROP in ordine inverso alle dipendenze (my_diet_nutrients → my_diet → my_nutrient_targets)
sqlite3 "$DB" <<SQL
DROP TABLE IF EXISTS my_diet_nutrients;
DROP TABLE IF EXISTS my_diet;
DROP TABLE IF EXISTS my_nutrient_targets;
.read $BACKUP
SQL

echo "✅ Tabelle my:* ripristinate con successo"
