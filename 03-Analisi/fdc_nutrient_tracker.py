#!/usr/bin/env python3
import sqlite3
import csv
from datetime import date
from pathlib import Path

# Percorsi
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
DB_PATH = PROJECT_ROOT / "01-Dati" / "FDC.db"
QUERY_FILE = SCRIPT_DIR / "nutrient_query.sql"
CSV_OUTPUT = PROJECT_ROOT / "04-Report" / f"nutrient_report_{date.today()}.csv"

def main():
    if not DB_PATH.exists():
        raise FileNotFoundError(f"Database non trovato: {DB_PATH}")
    
    with open(QUERY_FILE, "r", encoding="utf-8") as f:
        query = f.read()

    conn = sqlite3.connect(str(DB_PATH))
    cursor = conn.cursor()
    cursor.execute(query)
    results = cursor.fetchall()
    column_names = [description[0] for description in cursor.description]
    conn.close()

    # Stampa a schermo (tutte le colonne)
    print("\n" + "="*100)
    print(f"{'Nutriente':<25} {'Unità':<6} {'Totale':<8} {'% DRI':<8} {'% Opt':<8} {'Obiettivo':<10}")
    print("-"*100)
    for row in results:
        nutrient      = row[0] or ""
        unit          = row[1] or ""
        total         = f"{row[2]:.1f}" if row[2] is not None else ""
        pct_dri       = f"{row[3]:.1f}%" if row[3] is not None else ""
        pct_optimal   = f"{row[4]:.1f}%" if row[4] is not None else ""
        optimal_target= f"{row[5]:.1f}" if row[5] is not None else ""
        print(f"{nutrient:<25} {unit:<6} {total:<8} {pct_dri:<8} {pct_optimal:<8} {optimal_target:<10}")

    # Salva CSV con tutte le colonne
    CSV_OUTPUT.parent.mkdir(exist_ok=True)
    with open(CSV_OUTPUT, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(column_names)  # intestazioni dinamiche
        writer.writerows(results)

    print(f"\n✅ Report salvato in: {CSV_OUTPUT}")

if __name__ == "__main__":
    main()
