WITH nutrient_report AS (
    SELECT
        nutrient,
        unit_name AS unit,
        SUM(total_daily) AS total_daily
    FROM (
        -- PARTE DB USDA: ESCLUDI COMPLETAMENTE L'ENERGIA
        SELECT
            n.name AS nutrient,
            n.unit_name,
            fn.amount * md.grams_per_day / 100.0 AS total_daily
        FROM my_diet md
        JOIN food f ON md.fdc_id = f.fdc_id
        JOIN food_nutrient fn ON f.fdc_id = fn.fdc_id
        JOIN nutrient n ON fn.nutrient_id = n.id
        WHERE n.name IN (
            'Protein','Total lipid (fat)','Carbohydrate, by difference',
            'Calcium, Ca','Sodium, Na','Niacin','Biotin','Choline, total',
            'Vitamin D (D2 + D3)','Vitamin B-12','Iodine','Tryptophan'
            -- NOTA: 'Energy' RIMOSSO DA QUI!
        )
        
        UNION ALL
        
        -- PARTE MANUALE: INCLUDI L'ENERGIA
        SELECT
            mn.nutrient_name AS nutrient,
            mn.unit_name,
            mn.amount_per_100g * md.grams_per_day / 100.0 AS total_daily
        FROM my_diet md
        JOIN my_diet_nutrients mn ON md.fdc_id = mn.fdc_id
        WHERE mn.nutrient_name IN (
            'Protein','Total lipid (fat)','Carbohydrate, by difference','Energy', -- ✅ ENERGY QUI
            'Calcium, Ca','Sodium, Na','Niacin','Biotin','Choline, total',
            'Vitamin D (D2 + D3)','Vitamin B-12','Iodine','Tryptophan'
        )
    )
    GROUP BY nutrient, unit_name
),

dri_comparison AS (
    SELECT 
        nr.nutrient,
        nr.unit,
        nr.total_daily,
        -- CORRETTO: percentuale vs RDA/AI
        CASE
            WHEN dv.rda IS NOT NULL THEN ROUND(nr.total_daily / NULLIF(dv.rda, 0) * 100, 1)
            WHEN dv.ai IS NOT NULL THEN ROUND(nr.total_daily / NULLIF(dv.ai, 0) * 100, 1)
            ELSE NULL
        END AS percent_dri,
        -- CORRETTO: percentuale vs Obiettivo Ottimale
        CASE
            WHEN dv.optimal_target IS NOT NULL THEN ROUND(nr.total_daily / NULLIF(dv.optimal_target, 0) * 100, 1)
            ELSE NULL
        END AS percent_optimal,
        -- CORRETTO: mostra SOLO l'obiettivo ottimale (non l'UL!)
        dv.optimal_target
    FROM nutrient_report nr
    LEFT JOIN dri_values dv ON nr.nutrient = dv.nutrient_name
    WHERE nr.nutrient != 'Energy'  -- Escludi energia dai DRI
    
    UNION ALL
    
    -- Energia: nessun DRI
    SELECT 
        nutrient,
        unit,
        total_daily,
        NULL, NULL, NULL
    FROM nutrient_report
    WHERE nutrient = 'Energy'
)
SELECT * FROM dri_comparison ORDER BY nutrient;