-- nutrient_query.sql
WITH db_nutrients AS (
    SELECT 
        n.name AS nutrient,
        n.unit_name,
        SUM(fn.amount * md.grams_per_day / 100.0) AS amount
    FROM my_diet md
    JOIN food f ON md.fdc_id = f.fdc_id
    JOIN food_nutrient fn ON f.fdc_id = fn.fdc_id
    JOIN nutrient n ON fn.nutrient_id = n.id
    WHERE n.name IN (
        'Protein','Total lipid (fat)','Carbohydrate, by difference','Energy',
        'Calcium, Ca','Sodium, Na','Niacin','Biotin'
    )
    GROUP BY n.name, n.unit_name
),
manual_nutrients AS (
    SELECT 
        mn.nutrient_name AS nutrient,
        mn.unit_name,
        SUM(mn.amount_per_100g * md.grams_per_day / 100.0) AS amount
    FROM my_diet_nutrients mn
    JOIN my_diet md ON mn.fdc_id = md.fdc_id
    GROUP BY mn.nutrient_name, mn.unit_name
)
SELECT 
    nutrient,
    unit_name,
    ROUND(SUM(amount), 1) AS total_daily
FROM (
    SELECT nutrient, unit_name, amount FROM db_nutrients
    UNION ALL
    SELECT nutrient, unit_name, amount FROM manual_nutrients
)
GROUP BY nutrient, unit_name
ORDER BY nutrient;