WITH nutrient_report AS (
    SELECT
        nutrient,
        unit,
        SUM(total_daily) AS total_daily
    FROM (
        -- Parte DB (senza energia!)
        SELECT
            n.name AS nutrient,
            n.unit_name AS unit,
            fn.amount * md.grams_per_day / 100.0 AS total_daily
        FROM my_diet md
        JOIN food f ON md.fdc_id = f.fdc_id
        JOIN food_nutrient fn ON f.fdc_id = fn.fdc_id
        JOIN nutrient n ON fn.nutrient_id = n.id
        WHERE n.name IN (
            'Protein','Total lipid (fat)','Carbohydrate, by difference',
            'Calcium, Ca','Sodium, Na','Niacin','Biotin','Choline, total',
            'Vitamin D (D2 + D3)','Vitamin B-12','Iodine','Tryptophan'
            -- NOTA: 'Energy' RIMOSSO da qui!
        )
        
        UNION ALL
        
        -- Parte manuale (inclusa energia)
        SELECT
            mn.nutrient_name AS nutrient,
            mn.unit_name AS unit,
            mn.amount_per_100g * md.grams_per_day / 100.0 AS total_daily
        FROM my_diet md
        JOIN my_diet_nutrients mn ON md.fdc_id = mn.fdc_id
        WHERE mn.nutrient_name IN (
            'Protein','Total lipid (fat)','Carbohydrate, by difference','Energy', -- ✅ ENERGY QUI
            'Calcium, Ca','Sodium, Na','Niacin','Biotin','Choline, total',
            'Vitamin D (D2 + D3)','Vitamin B-12','Iodine','Tryptophan'
        )
    )
    GROUP BY nutrient, unit
),
-- ... resto della query (DRI) identico
dri_comparison AS (
    SELECT 
        nr.nutrient,
        nr.unit,
        nr.total_daily,
        dv.rda,
        dv.ai,
        dv.ul,
        dv.optimal_target,
        CASE
            WHEN dv.rda IS NOT NULL THEN ROUND(nr.total_daily / dv.rda * 100, 1)
            WHEN dv.ai IS NOT NULL THEN ROUND(nr.total_daily / dv.ai * 100, 1)
            ELSE NULL
        END AS percent_dri,
        CASE
            WHEN dv.optimal_target IS NOT NULL THEN ROUND(nr.total_daily / dv.optimal_target * 100, 1)
            ELSE NULL
        END AS percent_optimal
    FROM nutrient_report nr
    LEFT JOIN dri_values dv ON nr.nutrient = dv.nutrient_name
    WHERE nr.nutrient != 'Energy'  -- Escludi energia dai DRI (non ha RDA)
    
    UNION ALL   
    -- Aggiungi energia come riga separata SENZA DRI
    SELECT 
        nutrient,
        unit,
        total_daily,
        NULL, NULL, NULL, NULL,
        NULL,
        NULL
    FROM nutrient_report
    WHERE nutrient = 'Energy'
)
SELECT * FROM dri_comparison ORDER BY nutrient