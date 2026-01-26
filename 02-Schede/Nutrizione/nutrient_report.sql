SELECT
    COALESCE(t.nutrient_id, intake.nutrient_name) AS nutrient_id,
    intake.nutrient_name,
    intake.total_amount,
    intake.unit_name,
    t.dri_value,
    t.optimal_value,
    t.category,
    t.display_order
FROM (
    SELECT 
        mnt.nutrient_name,
        mnt.unit_name,
        SUM(mnt.amount_per_100g * md.grams_per_day / 100.0) AS total_amount
    FROM my_diet md
    JOIN my_diet_nutrients mnt ON md.my_fdc_id = mnt.my_fdc_id
    GROUP BY mnt.nutrient_name, mnt.unit_name
) AS intake
LEFT JOIN my_nutrient_targets t 
    ON intake.nutrient_name = t.nutrient_name 
    AND intake.unit_name = t.unit_name
ORDER BY t.display_order NULLS LAST, intake.nutrient_name;
