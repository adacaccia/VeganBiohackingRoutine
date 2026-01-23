#!/usr/bin/env python3
import sqlite3
import csv
from datetime import date
from pathlib import Path

# Percorsi usando pathlib (robusto su tutti i sistemi)
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
DB_PATH = PROJECT_ROOT / "01-Dati" / "FDC.db"
QUERY_FILE = SCRIPT_DIR / "nutrient_query.sql"
CSV_OUTPUT = PROJECT_ROOT / "04-Report" / f"nutrient_report_{date.today()}.csv"

def main():
    # Verifica che il DB esista
    if not DB_PATH.exists():
        raise FileNotFoundError(f"Database non trovato: {DB_PATH}")

    # Leggi la query
    with open(QUERY_FILE, "r", encoding="utf-8") as f:
        query = f.read()

    # Esegui
    conn = sqlite3.connect(str(DB_PATH))  # sqlite3 accetta solo stringhe
    cursor = conn.cursor()
    cursor.execute(query)
    results = cursor.fetchall()
    conn.close()

    # Stampa
    print(f"\n{'Nutriente':<30} {'Unità':<8} {'Totale'}")
    print("-" * 50)
    for row in results:
        print(f"{row[0]:<30} {row[1]:<8} {row[2]}")

    # Salva CSV
    CSV_OUTPUT.parent.mkdir(exist_ok=True)  # crea 04-Report se non esiste
    with open(CSV_OUTPUT, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["Nutriente", "Unità", "Totale_giornaliero"])
        writer.writerows(results)

    print(f"\n✅ Report salvato in: {CSV_OUTPUT}")

if __name__ == "__main__":
    main()