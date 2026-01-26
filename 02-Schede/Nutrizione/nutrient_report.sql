-- Query universale per tutti i formati
SELECT
    mnt.nutrient_name,
    mnt.unit_name,
    COALESCE(ti.total_amount, 0) AS total_amount,
    mnt.dri_value,
    mnt.optimal_value,
    mnt.category,
    mnt.display_order
FROM my_nutrient_targets mnt
LEFT JOIN (
    SELECT nutrient_name, unit_name, SUM(amount) AS total_amount
    FROM (
        -- Dati da USDA
        SELECT n.name AS nutrient_name, n.unit_name, SUM(CAST(fn.amount AS REAL) * md.grams_per_day / 100.0) AS amount
        FROM my_diet md
        JOIN food f ON md.fdc_id = f.fdc_id
        JOIN food_nutrient fn ON f.fdc_id = fn.fdc_id
        JOIN nutrient n ON CAST(fn.nutrient_id AS TEXT) = CAST(n.id AS TEXT)
        GROUP BY n.name, n.unit_name
        
        UNION ALL
        
        -- Dati manuali
        SELECT mdn.nutrient_name, mdn.unit_name, SUM(mdn.amount_per_100g * md.grams_per_day / 100.0) AS amount
        FROM my_diet md
        JOIN my_diet_nutrients mdn ON md.fdc_id = mdn.fdc_id
        GROUP BY mdn.nutrient_name, mdn.unit_name
    )
    GROUP BY nutrient_name, unit_name
) ti ON mnt.nutrient_name = ti.nutrient_name AND mnt.unit_name = ti.unit_name
ORDER BY 
    CASE WHEN mnt.category = 'energy' THEN 0 ELSE 1 END,
    mnt.category,
    mnt.display_order,
    mnt.nutrient_name;
