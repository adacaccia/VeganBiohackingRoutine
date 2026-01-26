WITH usda_contrib AS (
    SELECT n.name AS nutrient_name,
           n.unit_name,
           SUM(fn.amount * md.grams_per_day / 100.0) AS amount
      FROM my_diet md
           JOIN
           food f ON CAST (md.fdc_id AS TEXT) = f.fdc_id
           JOIN
           food_nutrient fn ON f.fdc_id = fn.fdc_id
           JOIN
           nutrient n ON fn.nutrient_id = n.id
     WHERE n.name = 'Energy' AND
           n.unit_name = 'KCAL' OR
           n.name != 'Energy'
     GROUP BY n.name,
              n.unit_name
),-- 2. Contributi manuali
manual_contrib AS (
    SELECT mdn.nutrient_name,
           mdn.unit_name,
           SUM(mdn.amount_per_100g * md.grams_per_day / 100.0) AS amount
      FROM my_diet md
           JOIN
           my_diet_nutrients mdn ON md.fdc_id = mdn.fdc_id
     GROUP BY mdn.nutrient_name,
              mdn.unit_name
),-- 3. Totale per nutriente
total_intake AS (
    SELECT nutrient_name,
           unit_name,
           SUM(amount) AS total_amount
      FROM (
               SELECT *
                 FROM usda_contrib
               UNION ALL
               SELECT *
                 FROM manual_contrib
           )
     GROUP BY nutrient_name,
              unit_name
),-- 4. Report finale
final_report AS (
    SELECT mnt.nutrient_name,
           mnt.unit_name,
           COALESCE(ti.total_amount, 0) AS intake_amount,
           mnt.dri_value,
           mnt.optimal_value
      FROM my_nutrient_targets mnt
           LEFT JOIN
           total_intake ti ON mnt.nutrient_name = ti.nutrient_name AND
                              mnt.unit_name = ti.unit_name
)
SELECT
    nutrient_name AS Nutriente,
    unit_name AS Unità,
    ROUND(intake_amount, 1) AS Totale,
    dri_value AS DRI,                     -- nuova colonna 3
    CASE WHEN dri_value > 0 THEN 100 * intake_amount / dri_value END AS pct_dri,
    optimal_value AS Opt,                 -- nuova colonna 5
    CASE WHEN optimal_value > 0 THEN 100 * intake_amount / optimal_value END AS pct_opt
FROM final_report
ORDER BY nutrient_name;