#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Motore di report nutrizionale per VeganBiohackingRoutine (VBR)
Genera output testuale e CSV basati su FDC.sqlite + my_tables personalizzate.
"""

import sqlite3
import csv
from pathlib import Path
from collections import defaultdict
from datetime import datetime

# === CONFIGURAZIONE PER VBR ===
DB_PATH = Path("01-Dati/FDC.sqlite")
QUERY_FILE = Path("02-Schede/Nutrizione/nutrient_report.sql")
CSV_OUTPUT = Path("04-Report/Nutrizione/report_latest.csv")

# Assicurati che la cartella di output esista
CSV_OUTPUT.parent.mkdir(parents=True, exist_ok=True)

# === MAIN ===
def main():
    # Verifica presenza file
    if not DB_PATH.exists():
        raise FileNotFoundError(f"❌ Database non trovato: {DB_PATH}")
    if not QUERY_FILE.exists():
        raise FileNotFoundError(f"❌ Query file non trovato: {QUERY_FILE}")

    # Carica i dati dal DB
    rows = load_nutrition_data(DB_PATH, QUERY_FILE)
    
    # Stampa testuale (sempre)
    print_text_report(rows)
    
    # Genera HTML (sempre, o su richiesta)
    print_html_report(rows)

# === FUNZIONI DI FORMATTAZIONE ===
def format_row(row):
    nutrient, unit, total, dri, opt = row[:5]
    total_str = f"{total:.1f}" if total is not None else "0.0"
    
    # DRI e %DRI
    if dri is not None and dri > 0:
        pct_dri = 100 * total / dri
        dri_str = f"{dri:.1f}"
        pct_dri_str = f"{pct_dri:.1f}%"
    else:
        dri_str = ""
        pct_dri_str = ""
    
    # Opt e %Opt
    if opt is not None and opt > 0:
        pct_opt = 100 * total / opt
        opt_str = f"{opt:.1f}"
        pct_opt_str = f"{pct_opt:.1f}%"
    else:
        opt_str = ""
        pct_opt_str = ""
    
    return (
        f"{nutrient:<45} {unit:<6} {total_str:>8} "
        f"{dri_str:>8} {pct_dri_str:>8} {opt_str:>8} {pct_opt_str:>8}"
    )

def print_section(title, rows):
    if not rows:
        return
    print(f"\n{title}")
    print("=" * len(title))
    for row in rows:
        print(format_row(row))

def load_nutrition_data(DB_PATH, QUERY_FILE):
    # Leggi ed esegui la query
    with open(QUERY_FILE, "r", encoding="utf-8") as f:
        query = f.read()

    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row  # ← QUESTA È LA CHIAVE
    cursor = conn.cursor()
    cursor.execute(query)
    columns = [desc[0] for desc in cursor.description]  # ← nomi delle colonne
    raw_rows = cursor.fetchall()
    conn.close()

    # Estrai dati (7 colonne attese: nutrient, unit, total, dri, opt, category, display_order)
    dict_rows = []
    for r in raw_rows:
        row_dict = dict(zip(columns, r))
        dict_rows.append(row_dict)

    # Ora elabora SOLO i dizionari
    rows = []  # questa sarà la nuova lista di tuple (output finale)
    for row in dict_rows:
        nutrient = row['nutrient_name']
        total = float(row['total_amount']) if row['total_amount'] is not None else 0.0
        unit = row['unit_name']
        dri = row['dri_value']
        opt = row['optimal_value']
        category = row['category']
        display_order = row['display_order']
        rows.append((nutrient, unit, total, dri, opt, category))
    return rows

def print_text_report(rows):
    # Separa Energy e sezioni
    energy_row = None
    water_row = None
    sections = defaultdict(list)

    for row in rows:
        nutrient, unit, total, dri, opt, category = row
        if category == "energy":
            energy_row = (nutrient, unit, total, dri, opt)
        elif category == "hydration":
            water_row = (nutrient, unit, total, dri, opt)
        else:
            sections[category].append((nutrient, unit, total, dri, opt))

    # === STAMPA A SCHERMO ===
    print("\n" + "=" * 100)
    header = f"{'Nutriente':<45} {'Unità':<6} {'Totale':>8} {'DRI':>8} {'%DRI':>8} {'Opt':>8} {'%Opt':>8}"
    print(header)
    print("-" * 100)

    if energy_row:
        print(format_row(energy_row))
    if water_row:
        print(format_row(water_row))
    if energy_row or water_row:
        print("-" * 100)

    # Ordine delle sezioni
    section_order = [
        ("vitamins", "VITAMINE & FITONUTRIENTI"),
        ("minerals", "SALI MINERALI & OLIGOELEMENTI"),
        ("fats", "GRASSI ESSENZIALI"),
        ("amino_acids", "AMMINOACIDI ESSENZIALI"),
    ]

    for key, title in section_order:
        print_section(title, sections[key])

    # === ESPORTAZIONE CSV ===
    with open(CSV_OUTPUT, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Nutriente", "Unità", "Totale", "DRI", "%DRI", "Opt", "%Opt"])
        
        if energy_row:
            nutrient, unit, total, dri, opt = energy_row
            pct_dri = 100 * total / dri if dri else ""
            pct_opt = 100 * total / opt if opt else ""
            writer.writerow([nutrient, unit, total, dri, pct_dri, opt, pct_opt])
        
        for key, _ in section_order:
            for row in sections[key]:
                nutrient, unit, total, dri, opt = row
                pct_dri = 100 * total / dri if dri else ""
                pct_opt = 100 * total / opt if opt else ""
                writer.writerow([nutrient, unit, total, dri, pct_dri, opt, pct_opt])

    print(f"\n✅ Report salvato in: {CSV_OUTPUT.relative_to(Path('.'))}")

def print_html_report(rows, output_file="my_diet_report.html"):
    """Genera un report HTML dai dati già caricati."""
    from datetime import datetime

    # Raggruppa per categoria
    categories = {}
    for nutrient, unit, total, dri, opt, category in rows:
        cat = category or "Altro"
        if cat not in categories:
            categories[cat] = []
        categories[cat].append((nutrient, unit, total, dri, opt))

    date_str = datetime.now().strftime("%d %B %Y")
    
    print("\n🔍 DEBUG CATEGORIE:")
    for cat, items in categories.items():
        print(f"  {cat}: {len(items)} nutrienti")
        for item in items[:2]:  # primi 2
            print(f"    → {item[0]}")


    html = f"""<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Diet Report — {date_str}</title>
  <style>
    body {{
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      line-height: 1.6;
      max-width: 900px;
      margin: 0 auto;
      padding: 20px;
      color: #333;
    }}
    h1 {{ color: #2e7d32; }}
    table {{
      width: 100%;
      border-collapse: collapse;
      margin: 16px 0;
    }}
    th, td {{
      padding: 8px 12px;
      text-align: right;
      border-bottom: 1px solid #eee;
    }}
    th:first-child, td:first-child {{
      text-align: left;
    }}
    tr.low {{ background-color: #fff8e1; }}       /* <80% DRI */
    tr.critical {{ background-color: #ffebee; }}   /* <50% DRI */
    tr.high {{ background-color: #e8f5e9; }}       /* >150% Opt */
    th {{
      background-color: #f5f5f5;
      font-weight: bold;
    }}
    h2 {{
      margin-top: 32px;
      padding-bottom: 8px;
      border-bottom: 2px solid #4caf50;
      color: #2e7d32;
    }}
  </style>
</head>
<body>
  <h1>📊 My Diet Report</h1>
  <p><em>Generato il {date_str}</em></p>
"""

    category_order = [
        "energy",
        "hydration",
        "vitamins",
        "minerals",
        "amino_acids",
        "fats"
    ]

    CATEGORY_LABELS = {
        "energy": "Energia & Idrobalance",
        "hydration": "Energia & Idrobalance",
        "vitamins": "VITAMINE & FITONUTRIENTI",
        "minerals": "SALI MINERALI & OLIGOELEMENTI",
        "amino_acids": "AMMINOACIDI ESSENZIALI",
        "fats": "GRASSI ESSENZIALI",
    }

    for cat_key in category_order:
        if cat_key == "Altro":
            continue
        if cat_key in categories:
            title = CATEGORY_LABELS.get(cat_key, cat_key)
            html += f'  <section>\n    <h2>{title}</h2>\n    <table>\n      <thead>\n        <tr>\n          <th>Nutriente</th><th>Unità</th><th>Totale</th><th>DRI</th><th>%DRI</th><th>Opt</th><th>%Opt</th>\n        </tr>\n      </thead>\n      <tbody>\n'
            
            for nutrient, unit, total, dri, opt in categories[cat]:
                # --- Calcolo percentuali ---
                pct_dri = ""
                if dri is not None and dri > 0:
                    pct_dri = f"{(total / dri * 100):.1f}%"
                
                pct_opt = ""
                if opt is not None and opt > 0:
                    pct_opt = f"{(total / opt * 100):.1f}%"

                # --- Classe per evidenziazione ---
                row_class = ""
                if dri is not None and dri > 0:
                    ratio = total / dri
                    if ratio < 0.5:
                        row_class = "critical"
                    elif ratio < 0.8:
                        row_class = "low"
                if opt is not None and total > opt * 1.5:
                    row_class = "high"

                class_attr = f' class="{row_class}"' if row_class else ''

                # --- Formattazione sicura (gestisce None) ---
                total_fmt = f"{total:.1f}"
                dri_fmt = f"{dri:.1f}" if dri is not None else ""
                opt_fmt = f"{opt:.1f}" if opt is not None else ""

                html += f'        <tr{class_attr}>\n'
                html += f'          <td>{nutrient}</td>\n'
                html += f'          <td>{unit}</td>\n'
                html += f'          <td>{total_fmt}</td>\n'
                html += f'          <td>{dri_fmt}</td>\n'
                html += f'          <td>{pct_dri}</td>\n'
                html += f'          <td>{opt_fmt}</td>\n'
                html += f'          <td>{pct_opt}</td>\n'
                html += f'        </tr>\n'

            html += '      </tbody>\n    </table>\n  </section>\n'

    html += "</body>\n</html>"

    with open(output_file, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"📄 HTML report salvato in: {output_file}")

if __name__ == "__main__":
    main()
