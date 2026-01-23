-- 1. Alimenti: nutrienti mancanti (colina, biotina)
INSERT INTO my_diet_nutrients (fdc_id, nutrient_name, unit_name, amount_per_100g) VALUES
-- Spinaci crudi
(1750353, 'Choline, total', 'MG', 19.3),
(1750353, 'Biotin', 'UG', 2.4),
-- Ceci cotti
(173801, 'Choline, total', 'MG', 36.5),
(173801, 'Biotin', 'UG', 6.0),
-- Arachidi tostate
(172431, 'Choline, total', 'MG', 124.0),
(172431, 'Biotin', 'UG', 28.0),
-- Avena
(2346396, 'Choline, total', 'MG', 17.8),
(2346396, 'Biotin', 'UG', 5.6),
-- Noci
(2346394, 'Choline, total', 'MG', 55.6),
(2346394, 'Biotin', 'UG', 27.8),
-- Passata pomodoro
(1106360, 'Choline, total', 'MG', 5.0),
(1106360, 'Biotin', 'UG', 0.6),
-- Proteina vegana
(553795, 'Choline, total', 'MG', 156.25),
(553795, 'Biotin', 'UG', 15.625);

-- 2. Integratori (con FDC ID fittizi)
INSERT INTO my_diet_nutrients (fdc_id, nutrient_name, unit_name, amount_per_100g) VALUES
-- Colina bitartrato (146 mg → 14600 mg/100g)
(999001, 'Choline, total', 'MG', 14600.0),
-- Calcio citrato (300 mg Ca → 30000 mg/100g)
(999002, 'Calcium, Ca', 'MG', 30000.0),
-- Vitamina D3 (50 µg → 5000 µg/100g)
(999003, 'Vitamin D (D2 + D3)', 'UG', 5000.0),
-- Vitamina B12 (500 µg → 50000 µg/100g)
(999004, 'Vitamin B-12', 'UG', 50000.0),
-- Ioduro di potassio (225 µg → 22500 µg/100g)
(999005, 'Iodine', 'MCG', 22500.0);
