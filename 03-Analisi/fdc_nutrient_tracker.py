import sqlite3
import csv
from pathlib import Path
from datetime import date

# Percorsi
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
DB_PATH = PROJECT_ROOT / "01-Dati" / "FDC.sqlite"
QUERY_FILE = SCRIPT_DIR / "nutrient_query.sql"
CSV_OUTPUT = PROJECT_ROOT / "04-Report" / f"nutrient_report_{date.today()}.csv"

def main():
    if not DB_PATH.exists():
        raise FileNotFoundError(f"Database non trovato: {DB_PATH}")
    
    # Leggi la query
    with open(QUERY_FILE, "r", encoding="utf-8") as f:
        query = f.read()

    # Esegui la query
    conn = sqlite3.connect(str(DB_PATH))
    cursor = conn.cursor()
    cursor.execute(query)
    results = cursor.fetchall()
    column_names = [description[0] for description in cursor.description]
    conn.close()

    # === STAMPA A SCHERMO ===
    print("\n" + "=" * 100)
    header = f"{'Nutriente':<25} {'Unità':<6} {'Totale':>8} {'DRI':>8} {'%DRI':>8} {'Opt':>8} {'%Opt':>8}"
    print(header)
    print("-" * len(header))

    for row in results:
        nutrient       = row[0] or ""
        unit           = row[1] or ""
        total          = f"{row[2]:.1f}" if row[2] is not None else "0.0"
        dri_target     = f"{row[3]:.1f}" if row[3] is not None else ""
        pct_dri        = f"{row[4]:.1f}%" if row[4] is not None else ""
        optimal_target = f"{row[5]:.1f}" if row[5] is not None else ""
        pct_optimal    = f"{row[6]:.1f}%" if row[6] is not None else ""

        print(f"{nutrient:<25} {unit:<6} {total:>8} {dri_target:>8} {pct_dri:>8} {optimal_target:>8} {pct_optimal:>8}")

    # === ESPORTAZIONE CSV ===
    with open(CSV_OUTPUT, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(column_names)      # intestazioni
        writer.writerows(results)          # dati

    print(f"\n✅ Report salvato in: {CSV_OUTPUT}")

if __name__ == "__main__":
    main()
