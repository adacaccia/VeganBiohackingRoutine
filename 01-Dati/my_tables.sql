/* WARNING: Script requires that SQLITE_DBCONFIG_DEFENSIVE be disabled */
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE my_nutrient_targets (
    nutrient_id TEXT PRIMARY KEY,          -- Tuo ID logico (es. 'calcium')
    usda_nutrient_id INTEGER,              -- Corrisponde a nutrient.id in USDA; NULL se non esiste
    nutrient_name TEXT NOT NULL,           -- Identico a nutrient.name in USDA
    unit_name TEXT NOT NULL,               -- Identico a nutrient.unit_name in USDA ('mg', 'µg', ecc.)
    dri_value REAL,                        -- RDA/EAR ufficiale (adulto 51+ anni, NIH/EFSA)
    optimal_value REAL,                    -- Obiettivo ottimale (Greger/prevenzione)
    optimal_source TEXT,                   -- Fonte dell'obiettivo ottimale
    vegan_reliability TEXT CHECK(vegan_reliability IN ('high', 'medium', 'low', 'supplement_required')),
    notes TEXT
);
INSERT INTO my_nutrient_targets VALUES('vitamin_a',1104,'Vitamin A, RAE','UG',900.0,900.0,'MG','medium','Carotenoids from sweet potatoes, spinach');
INSERT INTO my_nutrient_targets VALUES('vitamin_b1',1165,'Thiamin','MG',1.199999999999999956,1.199999999999999956,'NIH RDA','high','Legumes, whole grains');
INSERT INTO my_nutrient_targets VALUES('vitamin_b2',1166,'Riboflavin','MG',1.300000000000000044,1.300000000000000044,'NIH RDA','high','Mushrooms, almonds, fortified foods');
INSERT INTO my_nutrient_targets VALUES('vitamin_b3',1167,'Niacin','MG',16.0,16.0,'NIH RDA','high','Peanuts, whole grains');
INSERT INTO my_nutrient_targets VALUES('vitamin_b5',1168,'Pantothenic acid','MG',5.0,5.0,'NIH AI','high','Ubiquitous in plant foods');
INSERT INTO my_nutrient_targets VALUES('vitamin_b6',1169,'Vitamin B-6','MG',1.699999999999999956,1.699999999999999956,'NIH RDA','high','Chickpeas, bananas, potatoes');
INSERT INTO my_nutrient_targets VALUES('biotin',1106,'Biotin','UG',30.0,30.0,'NIH AI','medium','Nuts, seeds, legumes; your intake: 53.6 µg');
INSERT INTO my_nutrient_targets VALUES('folate',1170,'Folate, DFE','UG',400.0,400.0,'NIH RDA','high','Leafy greens, lentils, asparagus');
INSERT INTO my_nutrient_targets VALUES('vitamin_b12',1162,'Vitamin B-12','UG',2.399999999999999912,250.0,'Greger: 250 µg cyanocobalamin daily','supplement_required','No reliable whole-food vegan sources; you use 500 µg');
INSERT INTO my_nutrient_targets VALUES('vitamin_c',1163,'Vitamin C, total ascorbic acid','MG',90.0,200.0,'Greger: ~200 mg for optimal antioxidant support','high','Bell peppers, broccoli, citrus');
INSERT INTO my_nutrient_targets VALUES('vitamin_d',1175,'Vitamin D (D2 + D3)','UG',15.0,50.0,'Greger: 2000 IU (50 µg) daily for most adults','supplement_required','You use 50 µg; minimal sun exposure assumed');
INSERT INTO my_nutrient_targets VALUES('vitamin_e',1109,'Vitamin E (alpha-tocopherol)','MG',15.0,15.0,'NIH RDA; no strong evidence for higher doses','high','Sunflower seeds, almonds, spinach');
INSERT INTO my_nutrient_targets VALUES('vitamin_k1',1177,'Vitamin K (phylloquinone)','UG',120.0,120.0,'NIH AI','high','Kale, spinach, broccoli (you eat 500g spinach)');
INSERT INTO my_nutrient_targets VALUES('vitamin_k2_mk7',NULL,'Vitamin K2 (Menaquinone-7)','UG',NULL,45.0,'Schurgers et al. 2007; supports arterial health','low','Only natto is rich source; consider supplement if not eaten');
INSERT INTO my_nutrient_targets VALUES('calcium',1087,'Calcium, Ca','MG',1000.0,1200.0,'Greger: 600–1200 mg from food + supplement if needed','medium','You get 123.6%; sources: fortified plant milk, kale, tahini');
INSERT INTO my_nutrient_targets VALUES('chromium',1090,'Chromium, Cr','UG',30.0,35.0,'NIH AI','high','Broccoli, whole grains, nuts');
INSERT INTO my_nutrient_targets VALUES('copper',1091,'Copper, Cu','MG',0.9000000000000000222,0.9000000000000000222,'NIH RDA','high','Cashews, sesame seeds, lentils');
INSERT INTO my_nutrient_targets VALUES('iodine',1107,'Iodine','UG',150.0,150.0,'NIH RDA; use iodized salt or supplement','medium','Assume iodized salt; seaweed variable/risky');
INSERT INTO my_nutrient_targets VALUES('iron',1089,'Iron, Fe','MG',8.0,14.0,'Greger: higher intake advised for vegans due to non-heme absorption','medium','Lentils, tofu, spinach; pair with vitamin C');
INSERT INTO my_nutrient_targets VALUES('magnesium',1092,'Magnesium, Mg','MG',420.0,420.0,'NIH RDA','high','Almonds, black beans, oats');
INSERT INTO my_nutrient_targets VALUES('manganese',1093,'Manganese, Mn','MG',2.299999999999999822,2.299999999999999822,'NIH AI','high','Whole grains, nuts, leafy greens');
INSERT INTO my_nutrient_targets VALUES('molybdenum',1094,'Molybdenum, Mo','UG',45.0,45.0,'NIH RDA','high','Legumes, grains');
INSERT INTO my_nutrient_targets VALUES('phosphorus',1095,'Phosphorus, P','MG',700.0,700.0,'NIH RDA','high','Ubiquitous in plant proteins');
INSERT INTO my_nutrient_targets VALUES('potassium',1096,'Potassium, K','MG',2600.0,4700.0,'NIH AI; Greger emphasizes high-potassium diets','high','Bananas, potatoes, spinach, beans');
INSERT INTO my_nutrient_targets VALUES('selenium',1097,'Selenium, Se','UG',55.0,55.0,'NIH RDA','medium','Brazil nuts (1–2/day); soil-dependent');
INSERT INTO my_nutrient_targets VALUES('sodium',1098,'Sodium, Na','MG',1500.0,1500.0,'NIH Chronic Disease Risk Reduction Intake','low','You report 1069.7 mg; well below limit');
INSERT INTO my_nutrient_targets VALUES('zinc',1100,'Zinc, Zn','MG',11.0,15.0,'Greger: higher intake for vegans due to phytates','medium','Pumpkin seeds, lentils, tofu');
INSERT INTO my_nutrient_targets VALUES('choline',1179,'Choline, total','MG',550.0,700.0,'Greger aligns with EFSA Adequate Intake; supports liver/brain','medium','You get 687.6 mg; sources: soy, chickpeas, broccoli');
INSERT INTO my_nutrient_targets VALUES('energy',1008,'Energy','KCAL',NULL,2000.0,'Cronometer Gold average','high','Target based on consistent daily intake');
INSERT INTO my_nutrient_targets VALUES('ala',NULL,'ALA','G',1.600000000000000088,2.0,NULL,'medium',NULL);
INSERT INTO my_nutrient_targets VALUES('la',NULL,'LA','G',17.0,17.0,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('lycopene',NULL,'Lycopene','UG',NULL,10000.0,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('lutein_zeaxanthin',NULL,'Lutein + zeaxanthin','UG',NULL,10000.0,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('tryptophan',NULL,'Tryptophan','G',0.4799999999999999823,0.4799999999999999823,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('threonine',NULL,'Threonine','G',2.399999999999999912,2.399999999999999912,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('isoleucine',NULL,'Isoleucine','G',3.120000000000000106,3.120000000000000106,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('leucine',NULL,'Leucine','G',4.679999999999999716,4.679999999999999716,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('lysine',NULL,'Lysine','G',3.600000000000000088,3.600000000000000088,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('met_cys',NULL,'Cysteine and methionine(sulfer containig AA)','G',1.800000000000000044,1.800000000000000044,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('phe_tyr',NULL,'Phenylalanine and tyrosine (aromatic  AA)','G',3.0,3.0,NULL,'high',NULL);
INSERT INTO my_nutrient_targets VALUES('valine',NULL,'Valine','G',3.120000000000000106,3.120000000000000106,NULL,'high',NULL);
CREATE TABLE my_diet_nutrients (
    fdc_id INTEGER NOT NULL,          -- riferimento a my_diet.fdc_id
    nutrient_name TEXT NOT NULL,      -- es. 'Choline, total'
    unit_name TEXT NOT NULL,          -- es. 'mg'
    amount_per_100g REAL NOT NULL     -- valore per 100g dell'alimento
);
INSERT INTO my_diet_nutrients VALUES(173757,'Choline, total','MG',49.0);
INSERT INTO my_diet_nutrients VALUES(173757,'Biotin','UG',3.0);
INSERT INTO my_diet_nutrients VALUES(174276,'Choline, total','MG',250.0);
INSERT INTO my_diet_nutrients VALUES(174276,'Biotin','UG',10.0);
INSERT INTO my_diet_nutrients VALUES(1750353,'Choline, total','MG',10.0);
INSERT INTO my_diet_nutrients VALUES(1750353,'Biotin','UG',0.5);
INSERT INTO my_diet_nutrients VALUES(2346394,'Choline, total','MG',38.0);
INSERT INTO my_diet_nutrients VALUES(2346394,'Biotin','UG',1.5);
INSERT INTO my_diet_nutrients VALUES(2346396,'Choline, total','MG',40.0);
INSERT INTO my_diet_nutrients VALUES(2346396,'Biotin','UG',2.5);
INSERT INTO my_diet_nutrients VALUES(10000001,'Calcium, Ca','MG',30000.0);
INSERT INTO my_diet_nutrients VALUES(10000001,'Energy','KCAL',0.0);
INSERT INTO my_diet_nutrients VALUES(10000002,'Choline, total','MG',14600.0);
INSERT INTO my_diet_nutrients VALUES(10000002,'Energy','KCAL',0.0);
INSERT INTO my_diet_nutrients VALUES(10000003,'Vitamin B-12','UG',100000.0);
INSERT INTO my_diet_nutrients VALUES(10000003,'Energy','KCAL',0.0);
INSERT INTO my_diet_nutrients VALUES(10000004,'Vitamin D (D2 + D3)','UG',10000.0);
INSERT INTO my_diet_nutrients VALUES(10000004,'Energy','KCAL',0.0);
INSERT INTO my_diet_nutrients VALUES(10000005,'Iodine','UG',45000.0);
INSERT INTO my_diet_nutrients VALUES(10000005,'Energy','KCAL',0.0);
INSERT INTO my_diet_nutrients VALUES(10000006,'Calcium, Ca','MG',3.0);
INSERT INTO my_diet_nutrients VALUES(10000006,'Magnesium, Mg','MG',1.0);
INSERT INTO my_diet_nutrients VALUES(10000006,'Sodium, Na','MG',2.0);
INSERT INTO my_diet_nutrients VALUES(10000006,'Iodine','UG',0.0);
INSERT INTO my_diet_nutrients VALUES(2346396,'Energy','KCAL',367.0);
INSERT INTO my_diet_nutrients VALUES(2346394,'Energy','KCAL',654.0);
INSERT INTO my_diet_nutrients VALUES(1109430,'ALA','G',9.080000000000000071);
INSERT INTO my_diet_nutrients VALUES(1109430,'LA','G',38.09000000000000342);
INSERT INTO my_diet_nutrients VALUES(2346396,'Chromium, Cr','UG',13.5);
INSERT INTO my_diet_nutrients VALUES(2346394,'Chromium, Cr','UG',10.0);
INSERT INTO my_diet_nutrients VALUES(169074,'Chromium, Cr','UG',0.5);
INSERT INTO my_diet_nutrients VALUES(168462,'Chromium, Cr','UG',0.4000000000000000222);
INSERT INTO my_diet_nutrients VALUES(173757,'Chromium, Cr','UG',1.800000000000000044);
INSERT INTO my_diet_nutrients VALUES(168462,'Cysteine and methionine(sulfer containig AA)','G',0.0879999999999999949);
INSERT INTO my_diet_nutrients VALUES(169074,'Cysteine and methionine(sulfer containig AA)','G',0.02099999999999999783);
INSERT INTO my_diet_nutrients VALUES(173757,'Cysteine and methionine(sulfer containig AA)','G',0.2349999999999999867);
INSERT INTO my_diet_nutrients VALUES(174276,'Cysteine and methionine(sulfer containig AA)','G',2.176000000000000157);
INSERT INTO my_diet_nutrients VALUES(2346394,'Cysteine and methionine(sulfer containig AA)','G',0.1900000000000000022);
INSERT INTO my_diet_nutrients VALUES(168462,'Phenylalanine and tyrosine (aromatic  AA)','G',0.2369999999999999885);
INSERT INTO my_diet_nutrients VALUES(169074,'Phenylalanine and tyrosine (aromatic  AA)','G',0.05399999999999999245);
INSERT INTO my_diet_nutrients VALUES(173757,'Phenylalanine and tyrosine (aromatic  AA)','G',0.6949999999999999512);
INSERT INTO my_diet_nutrients VALUES(174276,'Phenylalanine and tyrosine (aromatic  AA)','G',7.814999999999999503);
INSERT INTO my_diet_nutrients VALUES(2346394,'Phenylalanine and tyrosine (aromatic  AA)','G',1.036699999999999955);
CREATE TABLE IF NOT EXISTS "my_diet" (
    fdc_id TEXT NOT NULL,
    grams_per_day REAL NOT NULL
);
INSERT INTO my_diet VALUES('168462',500.0);
INSERT INTO my_diet VALUES('169074',500.0);
INSERT INTO my_diet VALUES('173757',400.0);
INSERT INTO my_diet VALUES('174276',32.0);
INSERT INTO my_diet VALUES('1109430',50.0);
INSERT INTO my_diet VALUES('2346394',18.0);
INSERT INTO my_diet VALUES('2346396',180.0);
INSERT INTO my_diet VALUES('2543409',240.0);
INSERT INTO my_diet VALUES('10000001',2.0);
INSERT INTO my_diet VALUES('10000002',2.0);
INSERT INTO my_diet VALUES('10000003',1.0);
INSERT INTO my_diet VALUES('10000004',1.0);
INSERT INTO my_diet VALUES('10000005',1.0);
INSERT INTO my_diet VALUES('10000006',2300.0);
COMMIT;
