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

# === CONFIGURAZIONE PER VBR ===
DB_PATH = Path("01-Dati/FDC.sqlite")
QUERY_FILE = Path("02-Schede/Nutrizione/nutrient_report.sql")
CSV_OUTPUT = Path("04-Report/Nutrizione/report_latest.csv")

# Assicurati che la cartella di output esista
CSV_OUTPUT.parent.mkdir(parents=True, exist_ok=True)

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

# === MAIN ===
def main():
    # Verifica presenza file
    if not DB_PATH.exists():
        raise FileNotFoundError(f"❌ Database non trovato: {DB_PATH}")
    if not QUERY_FILE.exists():
        raise FileNotFoundError(f"❌ Query file non trovato: {QUERY_FILE}")

    # Leggi ed esegui la query
    with open(QUERY_FILE, "r", encoding="utf-8") as f:
        query = f.read()

    conn = sqlite3.connect(str(DB_PATH))
    cursor = conn.cursor()
    cursor.execute(query)
    raw_rows = cursor.fetchall()
    conn.close()

    # Estrai dati (7 colonne attese: nutrient, unit, total, dri, opt, category, display_order)
    rows = []
    for r in raw_rows:
        nutrient = r[0] or ""
        unit = r[1] or ""
        total = float(r[2]) if r[2] is not None else 0.0
        dri = float(r[3]) if r[3] is not None else None
        opt = float(r[4]) if r[4] is not None else None
        category = r[5] or "other"
        rows.append((nutrient, unit, total, dri, opt, category))

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

if __name__ == "__main__":
    main()
