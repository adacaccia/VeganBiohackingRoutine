#!/bin/bash
cd "$(dirname "$0")/.."
sqlite3 01-Dati/FDC.sqlite ".dump my_diet my_nutrient_targets my_diet_nutrients" > 01-Dati/my_tables.sql
echo "✅ my_tables.sql aggiornato."
