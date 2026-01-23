# VBR Nutrient Tracker

Strumento open-source per il tracciamento nutrizionale vegano, senza abbonamenti.

## Dipendenze
- Python 3.x
- Database SQLite `FDC.db` (USDA Full Dataset)

## Configurazione
1. Popola `01-Dati/setup_my_diet.sql` con i tuoi FDC ID e porzioni
2. Assicurati che `FDC.db` sia nella root del progetto (o modifica lo script)

## Uso
```bash
cd 03-Analisi
python3 fdc_nutrient_tracker.py
