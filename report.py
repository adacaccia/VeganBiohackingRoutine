#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Motore di report nutrizionale per VeganBiohackingRoutine (VBR)
Versione 2.3 - Corretto calcolo calorie e layout uniforme tabelle.
"""

import sqlite3
from pathlib import Path
from datetime import datetime

# === CONFIGURAZIONE ===
DB_PATH = Path("01-Dati/FDC.sqlite")
QUERY_FILE = Path("02-Schede/Nutrizione/nutrient_report.sql")
OUTPUT_FILE = Path("docs/index.html")

def calculate_analysis(rows):
    """Calcola Macro e Ratio dai dati estratti usando i nomi delle colonne."""
    data = {r['nutrient_name']: r['total_amount'] for r in rows}
    
    results = {
        'macros': {'p': 0, 'c': 0, 'f': 0, 'total_cal': 0},
        'ratios': []
    }
    
    # --- 1. MACRO (Nomi standard USDA) ---
    prot = data.get('Protein', 0) or 0
    carb = data.get('Carbohydrate, by difference', 0) or 0
    fat = data.get('Total lipid (fat)', 0) or 0
    
    p_cal, c_cal, f_cal = prot * 4, carb * 4, fat * 9
    total = p_cal + c_cal + f_cal
    
    if total > 0:
        results['macros'] = {
            'p': (p_cal / total) * 100,
            'c': (c_cal / total) * 100,
            'f': (f_cal / total) * 100,
            'total_cal': total
        }

    # --- 2. RATIO ---
    la = data.get('18:2 n-6', 0) or 0
    ala = data.get('18:3 n-3', 0) or 0
    if ala > 0: results['ratios'].append(("Ratio Omega 6/3", la/ala, "1:1 - 4:1"))

    zn = data.get('Zinc, Zn', 0) or 0
    cu = data.get('Copper, Cu', 0) or 0
    if cu > 0: results['ratios'].append(("Ratio Zinco/Rame", zn/cu, "8:1 - 12:1"))
        
    k = data.get('Potassium, K', 0) or 0
    na = data.get('Sodium, Na', 0) or 0
    if na > 0: results['ratios'].append(("Ratio Potassio/Sodio", k/na, "> 2:1"))
        
    return results

def print_html_report(rows):
    """Genera il report HTML con layout responsive professionale."""
    date_str = datetime.now().strftime("%d %B %Y")
    analisi = calculate_analysis(rows)
    m = analisi['macros']
    
    # CORREZIONE 1: Usa il valore Energy dalla tabella invece di calcolarlo dai macro
    data = {r['nutrient_name']: r['total_amount'] for r in rows}
    energy_val = data.get('Energy', m['total_cal'])  # Fallback al calcolo se Energy non esiste
    
    # Raggruppiamo i nutrienti per categoria
    categories = {}
    for r in rows:
        cat = r['category']
        if not cat: continue
        
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(r)

    # Inizio HTML
    html = f"""<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>VBR Report — {date_str}</title>
    <style>
        body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; max-width: 900px; margin: 0 auto; padding: 20px; color: #333; background: #fafafa; }}
        h1, h2 {{ color: #2e7d32; text-align: center; border-bottom: 2px solid #4caf50; padding-bottom: 10px; margin-top: 40px; }}
        h1 {{ margin-top: 20px; }}
        
        /* Donut Chart - CORRETTO: usa energy_val dal database */
        .pie-chart {{
            position: relative; width: 220px; height: 220px; border-radius: 50%; margin: 20px auto;
            background: conic-gradient(#4caf50 0% {m['p']}%, #ffeb3b {m['p']}% {m['p']+m['c']}%, #f44336 {m['p']+m['c']}% 100%);
            display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }}
        .pie-chart::after {{
            content: "{energy_val:.0f} kcal"; position: absolute; width: 160px; height: 160px;
            background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-weight: bold; font-size: 1.2em; color: #444;
        }}

        .legend {{ display: flex; justify-content: center; gap: 20px; list-style: none; padding: 0; margin-bottom: 40px; flex-wrap: wrap; }}
        .legend li {{ display: flex; align-items: center; gap: 8px; font-weight: bold; }}
        .legend li::before {{ content: ""; width: 14px; height: 14px; border-radius: 3px; }}
        .prot::before {{ background-color: #4caf50; }}
        .carb::before {{ background-color: #ffeb3b; }}
        .fat::before {{ background-color: #f44336; }}

        /* Wrapper per scroll orizzontale su mobile */
        .table-wrapper {{
            overflow-x: auto;
            margin-bottom: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            background: white;
            -webkit-overflow-scrolling: touch;
        }}
        
        table {{ 
            width: 100%; 
            border-collapse: collapse; 
            background: white; 
            min-width: 600px;
        }}

        th, td {{ padding: 12px; text-align: right; border-bottom: 1px solid #eee; }}
        th:first-child, td:first-child {{ text-align: left; }}
        th {{ background: #f1f8e9; color: #2e7d32; font-size: 0.85em; text-transform: uppercase; font-weight: 600; }}
        tr:hover {{ background-color: #f5f5f5; }}
        
        /* Colori Condizionali */
        tr.critical {{ background-color: #ffebee !important; }}
        tr.critical:hover {{ background-color: #ffcdd2 !important; }}
        tr.low {{ background-color: #fff8e1 !important; }}
        tr.low:hover {{ background-color: #ffecb3 !important; }}
        tr.optimal {{ background-color: #e8f5e9 !important; }}
        tr.optimal:hover {{ background-color: #c8e6c9 !important; }}
        
        /* CORREZIONE 2: Rimossa max-width per uniformità con altre tabelle */
        .ratio-table {{ 
            margin: 0 auto; 
            border: 2px solid #2e7d32; 
            border-radius: 8px; 
            overflow: hidden;
            /* Rimosso: max-width: 500px; */
        }}
        .ratio-table table {{ min-width: auto; }}
        
        /* Responsive adjustments */
        @media (max-width: 600px) {{
            body {{ padding: 10px; }}
            h1 {{ font-size: 1.5em; }}
            h2 {{ font-size: 1.2em; }}
            th, td {{ padding: 8px; font-size: 0.9em; }}
            .pie-chart {{ width: 180px; height: 180px; }}
            .pie-chart::after {{ width: 130px; height: 130px; font-size: 1em; }}
        }}
    </style>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <h1>🌱 Vegan Biohacking Report</h1>
    <p style="text-align: center; color: #666;">Data Analisi: {date_str}</p>

    <section>
        <div class="pie-chart"></div>
        <ul class="legend">
            <li class="prot">Proteine: {m['p']:.1f}%</li>
            <li class="carb">Carbo: {m['c']:.1f}%</li>
            <li class="fat">Grassi: {m['f']:.1f}%</li>
        </ul>
    </section>
"""

    # Sezioni da visualizzare in ordine
    order = ["energy", "hydration", "vitamins", "minerals", "amino_acids", "fats"]
    
    for key in order:
        if key not in categories: continue
        
        html += f"<h2>{key.replace('_', ' ').upper()}</h2>"
        html += '<div class="table-wrapper"><table><thead><tr><th>Nutriente</th><th>Totale</th><th>Unità</th><th>%DRI</th><th>%Opt</th></tr></thead><tbody>'
        
        for r in categories[key]:
            val = r['total_amount'] or 0
            dri = r['dri_value']
            opt = r['optimal_value']
            
            p_dri_val = (val / dri * 100) if (dri and dri > 0) else None
            p_opt_val = (val / opt * 100) if (opt and opt > 0) else None
            
            p_dri_str = f"{p_dri_val:.1f}%" if p_dri_val is not None else "-"
            p_opt_str = f"{p_opt_val:.1f}%" if p_opt_val is not None else "-"
            
            row_class = ""
            if p_dri_val is not None:
                if p_dri_val < 50: row_class = "critical"
                elif p_dri_val < 80: row_class = "low"
            if p_opt_val is not None and p_opt_val >= 100 and not row_class:
                row_class = "optimal"
            
            class_attr = f" class='{row_class}'" if row_class else ""
            
            html += f"<tr{class_attr}><td>{r['nutrient_name']}</td><td>{val:.1f}</td><td>{r['unit_name']}</td><td>{p_dri_str}</td><td>{p_opt_str}</td></tr>"
        
        html += "</tbody></table></div>"

    # Ratio Finali - CORRETTO: aggiunto wrapper per uniformità
    if analisi['ratios']:
        html += "<h2 style='margin-top:50px;'>🧠 BIOHACKING RATIOS</h2>"
        html += '<div class="table-wrapper ratio-table"><table><thead><tr><th>Ratio</th><th>Valore</th><th>Target</th></tr></thead><tbody>'
        for name, val, target in analisi['ratios']:
            html += f"<tr><td>{name}</td><td style='font-weight:bold;'>{val:.2f}</td><td style='color:#666;'>{target}</td></tr>"
        html += "</tbody></table></div>"

    html += "</body></html>"
    
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        f.write(html)
    print(f"✅ Report creato con successo: {OUTPUT_FILE}")

def load_data():
    """Carica i dati usando sqlite3.Row."""
    if not DB_PATH.exists(): raise FileNotFoundError(f"Database non trovato in: {DB_PATH}")
    
    conn = sqlite3.connect(str(DB_PATH))
    conn.row_factory = sqlite3.Row
    
    with open(QUERY_FILE, "r") as f:
        query = f.read()
    
    cursor = conn.cursor()
    cursor.execute(query)
    rows = cursor.fetchall()
    conn.close()
    return rows

if __name__ == "__main__":
    try:
        data = load_data()
        print_html_report(data)
    except Exception as e:
        print(f"❌ Errore critico: {e}")
