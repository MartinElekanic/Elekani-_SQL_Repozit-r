CREATE TABLE t_mato_elekanic_project_SQL_primary_final (
  industry_name TEXT,
  priemer_mzda_odvetvi DECIMAL(18,3),
  mzda_minuly_rok DECIMAL(18,3),
  trend_v_percentach DECIMAL(6,2),
  priemerna_mzda DECIMAL(18,3),
  cena_chleba DECIMAL(12,2),
  cena_mlieka DECIMAL(12,2),
  kg_chleba_za_mzdu DECIMAL(12,5),
  litrov_mlieka_za_mzdu DECIMAL(6,2),
  food_name TEXT,
  avg_yoy_growth DECIMAL(10,4),
  pct_change_yoy DECIMAL(6,2),
  trend_pct DECIMAL(6,2),
  rast_hdp_pct DECIMAL(14,10),
  rast_miezd_pct DECIMAL(14,10),
  rast_cien_potravin DECIMAL(14,10),
  source_view TEXT,
  year INTEGER,
  rn INTEGER
);





--- Otázka 1
WITH vyvoj_miezd AS (
    SELECT 
        industry_name,
        payroll_year,
        avg_wage AS priemerná_mzda_odvetví,
        LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY payroll_year) AS mzda_minuly_rok,
        ROUND(
            (avg_wage - LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY payroll_year)) 
            / NULLIF(LAG(avg_wage) OVER (PARTITION BY industry_name ORDER BY payroll_year), 0) * 100, 
            2
        ) AS trend_v_percentach
    FROM avg_industry_salary
)
SELECT 
    a.payroll_year,
    a.industry_name,
    a.industry_branch_code,
    vm.priemerná_mzda_odvetví,
    vm.mzda_minuly_rok,
    vm.trend_v_percentach
FROM avg_industry_salary a
JOIN vyvoj_miezd vm
  ON a.industry_name = vm.industry_name
 AND a.payroll_year  = vm.payroll_year;


---Otázka 2
WITH konečný_prehľad_množstva AS (
    SELECT 
        f.rok,
        AVG(i.avg_wage) AS priemerna_mzda,
        f.average_bread_price AS cena_chleba,
        f.average_milk_price AS cena_mlieka
    FROM avg_food_prices f
    JOIN industry_pay i
      ON f.rok = i.payroll_year
    GROUP BY f.rok, f.average_bread_price, f.average_milk_price
),
ročné_hodnoty AS (
    SELECT
        rok,
        priemerna_mzda * 1.0 / NULLIF(cena_chleba, 0) AS kg_chleba,
        priemerna_mzda * 1.0 / NULLIF(cena_mlieka, 0) AS litre_mlieka
    FROM konečný_prehľad_množstva
),
výsledok AS (
    SELECT
        1 AS poradie,
        'Prvé obdobie (2006–2012)' AS obdobie,
        ROUND(AVG(kg_chleba), 1) AS priemer_kg_chleba,
        ROUND(AVG(litre_mlieka), 1) AS priemer_l_mlieka
    FROM ročné_hodnoty
    WHERE rok BETWEEN 2006 AND 2012

    UNION ALL

    SELECT
        2 AS poradie,
        'Posledné obdobie (2012–2018)' AS obdobie,
        ROUND(AVG(kg_chleba), 1) AS priemer_kg_chleba,
        ROUND(AVG(litre_mlieka), 1) AS priemer_l_mlieka
    FROM ročné_hodnoty
    WHERE rok BETWEEN 2012 AND 2018
)
SELECT 
    obdobie,
    priemer_kg_chleba,
    priemer_l_mlieka
FROM výsledok
ORDER BY poradie ASC;


--- Otázka 3

WITH ceny_po_rokoch AS (
    SELECT
        food_name,
        EXTRACT(YEAR FROM month_start)::int AS year,
        AVG(total_price) AS priemerna_cena_v_roku
    FROM cena_na_mesiac
    GROUP BY
        food_name,
        EXTRACT(YEAR FROM month_start)::int
),
ceny_s_predchadzajucim_rokom AS (
    SELECT
        food_name,
        year,
        priemerna_cena_v_roku,
        LAG(year) OVER (
            PARTITION BY food_name
            ORDER BY year
        ) AS predchadzajuci_rok,
        LAG(priemerna_cena_v_roku) OVER (
            PARTITION BY food_name
            ORDER BY year
        ) AS cena_minuly_rok
    FROM ceny_po_rokoch
),
potravina_medzirocne AS (
    SELECT
        food_name,
        year,
        CASE
            WHEN predchadzajuci_rok = year - 1 THEN
                100.0 * (
                    priemerna_cena_v_roku
                    / NULLIF(cena_minuly_rok, 0) - 1
                )
        END AS pct_change_yoy
    FROM ceny_s_predchadzajucim_rokom
)
SELECT
    food_name,
    ROUND(AVG(pct_change_yoy)::numeric, 2) AS avg_yoy_growth
FROM potravina_medzirocne
WHERE pct_change_yoy IS NOT NULL
GROUP BY food_name
ORDER BY avg_yoy_growth ASC 
LIMIT 1;


--- Otázka 4
WITH wage_year AS (
    SELECT 
        payroll_year, 
        AVG(trend_v_percentach) AS trend_miezd_pct
    FROM medziročný_rast_miezd
    GROUP BY payroll_year
),
food_year AS (
    SELECT 
        year, 
        AVG(pct_change_yoy) AS trend_potravin_pct
    FROM food_yoy_prices
    GROUP BY year
)
SELECT 
    w.payroll_year, 
    ROUND(w.trend_miezd_pct, 2) AS trend_miezd_pct, 
    ROUND(f.trend_potravin_pct, 2) AS trend_potravin_pct,
    ROUND(f.trend_potravin_pct - w.trend_miezd_pct, 2) AS rozdiel_pct,
    CASE 
        WHEN (f.trend_potravin_pct - w.trend_miezd_pct) > 10 THEN 'Áno (>10 %)'
        ELSE 'Nie'
    END AS vyssi_rast_potravin_o_10_pct
FROM wage_year w
JOIN food_year f ON w.payroll_year = f.year
ORDER BY w.payroll_year ASC;


---Otázka 5
WITH prehlad_rastu AS (
    SELECT 
        rhc.year, 
        rhc.medzirocne_hdp AS rast_hdp_pct,
        rmr.rast_miezd_pct,
        iy.avg_yoy_growth AS rast_cien_potravin_pct
    FROM rast_hdp_cz rhc
    JOIN rast_miezd_rok rmr  ON rhc.year = rmr.payroll_year
    JOIN inflation_yearly iy ON rhc.year = iy.year
)
SELECT 
    year,
    ROUND(rast_hdp_pct, 2) AS rast_hdp_pct,
    ROUND(rast_miezd_pct, 2) AS rast_miezd_pct,
    ROUND(rast_cien_potravin_pct, 2) AS rast_cien_potravin_pct
FROM prehlad_rastu
ORDER BY year ASC;




CREATE TABLE t_mato_elekanic_project_SQL_secondary_final (
country text NOT NULL,
continent text,
year integer NOT NULL,
gdp decimal(15,2),
gini decimal(4,1),
population bigint,
rn integer NOT NULL, 
PRIMARY KEY (country, year)
);


---Doplňujúci materiál makroekonomických ukazovateľov k ostatným štátom Európy
WITH europe_data AS (
    SELECT
        c.country,
        c.continent,
        e.year,
        e.gdp,
        e.gini,
        e.population
    FROM economies e
    LEFT JOIN countries c
        ON e.country = c.country
    WHERE c.continent = 'Europe'
      AND e.year BETWEEN 2006 AND 2018
)
-- Finálny SELECT, ktorý z CTE vytiahne dáta
SELECT *
FROM europe_data
ORDER BY country, year;


