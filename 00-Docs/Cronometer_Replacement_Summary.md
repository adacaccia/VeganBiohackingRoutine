# Sistema Nutrizionale Open-Source (alternativa a Cronometer Gold)

## ✅ Componenti chiave
1. **Database**: 
   - Dataset USDA FoodData Central (`FDC.db`), 4.2 GB
   - Tabelle personalizzate: `my_diet`, `my_diet_nutrients`, `dri_values`
2. **Query SQL**:
   - `nutrient_query.sql`: calcolo nutrienti + confronto con DRI/Greger
   - `energy_audit.sql`: verifica sanità dati per energia
3. **Script Python**:
   - `fdc_nutrient_tracker.py`: genera report CSV in 0.3 secondi
4. **Backup**: 
   - Google Drive con script `backup_db.sh`

## ⚙️ Configurazione ottimale
- **Indici SQLite**: 3 indici critici per velocità
- **Valori manuali** in `my_diet_nutrients` per:
  - Energia (solo alimenti senza dati USDA)
  - Colina, Biotina, Triptofano
- **Obiettivi Greger** in `dri_values`:
  ```sql
  optimal_target per Calcium, Ca = 1200 MG
  optimal_target per Choline, total = 700 MG