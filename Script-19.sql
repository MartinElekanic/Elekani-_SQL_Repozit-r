




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


INSERT INTO t_mato_elekanic_project_sql_primary_final 
  (industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach,
   priemerna_mzda, cena_chleba, cena_mlieka, kg_chleba_za_mzdu, litrov_mlieka_za_mzdu,
   food_name, avg_yoy_growth, pct_change_yoy, trend_pct,
   rast_hdp_pct, rast_miezd_pct, rast_cien_potravin,
   source_view, year, rn)
SELECT
  industry_name,
  CAST(priemerná_mzda_odvetví AS DECIMAL(18,3)),
  CASE WHEN payroll_year = 2000 THEN NULL ELSE CAST(mzda_minuly_rok AS DECIMAL(18,3)) END,
  CASE WHEN payroll_year = 2000 THEN NULL ELSE CAST(trend_v_percentach AS DECIMAL(6,2)) END,
  NULL, NULL, NULL, NULL, NULL,
  NULL, NULL, NULL, NULL,
  NULL, NULL, NULL,
  'vyvoj_miezd',
  payroll_year::INTEGER,
  NULL
FROM Vyvoj_miezd
WHERE payroll_year BETWEEN 2000 AND 2021
  AND industry_name IN (
    'Administratíva',
    'činnosti v oblasti nemovitostí',
    'Doprava a skladování',
    'Informační a komunikační činnosti',
    'Kultúrni,zábavní a rekreační činnosti',
    'Ostatní činnosti',
    'Penežnictví a pojišťovníctvi',
    'Profesní,vedecké a technické činnosti',
    'Stavebníctví',
    'Težba a dobývání',
    'Ubytování,stravování a pohostinství',
    'Velkoobchod a maloobchod',
    'Verejná správa a obrana',
    'Výroba a rozvod elektriny,plynu',
    'Vzdelávání',
    'Zásobování vodou, činnosti s odpady a sanacemi',
    'Zdravotní a sociální péče',
    'Zemedelství,lesníctvi,rybárství',
    'Zpracovatelský prumysl'
  );

INSERT INTO t_mato_elekanic_project_SQL_primary_final
  (industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach,
   priemerna_mzda, cena_chleba, cena_mlieka, kg_chleba_za_mzdu, litrov_mlieka_za_mzdu,
   food_name, avg_yoy_growth, pct_change_yoy, trend_pct,
   rast_hdp_pct, rast_miezd_pct, rast_cien_potravin,
   source_view, year, rn)
SELECT
  industry_name,
  NULL, NULL, NULL,
  CAST(priemerna_mzda AS DECIMAL(18,3)),
  CAST(cena_chleba AS DECIMAL(12,2)),
  CAST(cena_mlieka AS DECIMAL(12,2)),
  CAST(kg_chleba_za_mzdu AS DECIMAL(12,5)),
  CAST(litrov_mlieka_za_mzdu AS DECIMAL(6,2)),
  NULL, NULL, NULL, NULL,
  NULL, NULL, NULL,
  'konečný_prehlad_množstva',
  rok::INTEGER,
  NULL
FROM konečný_prehľad_množstva
WHERE rok BETWEEN 2006 AND 2018;
INSERT INTO t_mato_elekanic_project_SQL_primary_final
  (industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach,
   priemerna_mzda, cena_chleba, cena_mlieka, kg_chleba_za_mzdu, litrov_mlieka_za_mzdu,
   food_name, avg_yoy_growth, pct_change_yoy, trend_pct,
   rast_hdp_pct, rast_miezd_pct, rast_cien_potravin,
   source_view, rn)
SELECT
  NULL, NULL, NULL, NULL,
  NULL, NULL, NULL, NULL, NULL,
  food_name,
  CAST(avg_yoy_growth AS DECIMAL(10,4)),
  NULL, NULL,
  NULL, NULL, NULL,
  'yoy_avg_food',
  NULL
FROM yoy_avg_food;
INSERT INTO t_mato_elekanic_project_SQL_primary_final
  (industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach,
   priemerna_mzda, cena_chleba, cena_mlieka, kg_chleba_za_mzdu, litrov_mlieka_za_mzdu,
   food_name, avg_yoy_growth, pct_change_yoy, trend_pct,
   rast_hdp_pct, rast_miezd_pct, rast_cien_potravin,
   source_view,rn)
SELECT
  NULL, NULL, NULL, NULL,
  NULL, NULL, NULL, NULL, NULL,
  NULL, NULL,
  CAST(pct_change_yoy AS DECIMAL(6,2)),
  CAST(trend_v_percentach AS DECIMAL(6,2)),
  NULL, NULL, NULL,
  'ceny_mzdy_rok',
  NULL
FROM ceny_mzdy_rok
WHERE pct_change_yoy BETWEEN 2007 AND 2018;
INSERT INTO t_mato_elekanic_project_SQL_primary_final
  (industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach,
   priemerna_mzda, cena_chleba, cena_mlieka, kg_chleba_za_mzdu, litrov_mlieka_za_mzdu,
   food_name, avg_yoy_growth, pct_change_yoy, trend_pct,
   rast_hdp_pct, rast_miezd_pct, rast_cien_potravin,
   source_view, year, rn)
SELECT
  NULL, NULL, NULL, NULL,
  NULL, NULL, NULL, NULL, NULL,
  NULL, NULL, NULL, NULL,
  CAST(rast_hdp_pct AS DECIMAL(14,10)),
  CAST(rast_miezd_pct AS DECIMAL(14,10)),
  CASE WHEN rok = 2006 THEN NULL ELSE CAST(rast_cien_potravin_pct AS DECIMAL(14,10)) END,
  'analyza_hdp',
  rok::INTEGER,
  NULL
FROM analyza_hdp
WHERE rok BETWEEN 2006 AND 2018;

---Kontrola primárnej finálnej tabuľky pred jej zobrazením
SELECT source_view, COUNT(*) FROM t_mato_elekanic_project_SQL_primary_final GROUP BY source_view;


SELECT * FROM t_mato_elekanic_project_sql_primary_final AS tmepspf;

SELECT * FROM t_mato_elekanic_project_sql_primary_final AS tmepspf 
WHERE source_view='konečný_stav_množstva';

--- Kontrola stavu chýbajúcich riadkov pre view Vyvoj_miezd

--počet unikátnych kľúčov v zdroji (industry_name + payroll_year)
SELECT COUNT(*) AS src_total,
       COUNT(DISTINCT industry_name || '|' || COALESCE(CAST(payroll_year AS text),'')) AS src_distinct_keys
FROM vyvoj_miezd;

--  počet unikátnych kľúčov v cieli (industry_name + year) pre tento source_view
SELECT COUNT(*) AS tgt_total,
       COUNT(DISTINCT industry_name || '|' || COALESCE(CAST(year AS text),'')) AS tgt_distinct_keys
FROM t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';

---Hľadanie presných chýbajúcich riadkov
-- riadky v zdroji, ktoré nemajú zodpovedajúci riadok v cieli
SELECT v.*
FROM vyvoj_miezd v
LEFT JOIN t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
     AND t.industry_name = v.industry_name
     AND t.year = v.payroll_year
WHERE t.industry_name IS NULL
ORDER BY v.industry_name, v.payroll_year
LIMIT 200;

---Kontroly pre príčiny chýbajúcich riadkov
-- A: riadky v zdroji s NULL industry_name alebo NULL payroll_year
SELECT COUNT(*) AS null_keys FROM vyvoj_miezd
WHERE industry_name IS NULL OR payroll_year IS NULL;

-- B: duplicitné kľúče v zdroji (môžu spôsobiť, že pri INSERT s unikátnym indexom sa niečo stratí)
SELECT industry_name, payroll_year, COUNT(*) AS cnt
FROM vyvoj_miezd
GROUP BY industry_name, payroll_year
HAVING COUNT(*) > 1
ORDER BY cnt DESC
LIMIT 200;










SELECT source_view 
FROM t_mato_elekanic_project_sql_primary_final AS tmepspf 
WHERE source_view='analyza_hdp';

--- Post analýza
--- Koľko null je v každom stlpci
SELECT
  SUM(CASE WHEN industry_name IS NULL THEN 1 ELSE 0 END) AS null_industry,
  SUM(CASE WHEN priemer_mzda_odvetvi IS NULL THEN 1 ELSE 0 END) AS null_priemer_mzda,
  SUM(CASE WHEN priemerna_mzda IS NULL THEN 1 ELSE 0 END) AS null_priemerna_mzda,
  SUM(CASE WHEN food_name IS NULL THEN 1 ELSE 0 END) AS null_food_name,
  SUM(CASE WHEN avg_yoy_growth IS NULL THEN 1 ELSE 0 END) AS null_avg_yoy_growth,
  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year
FROM t_mato_elekanic_project_SQL_primary_final;

--- null podľa source view
SELECT source_view,
  SUM(CASE WHEN industry_name IS NULL THEN 1 ELSE 0 END) AS null_industry,
  SUM(CASE WHEN priemerna_mzda IS NULL THEN 1 ELSE 0 END) AS null_priemerna_mzda,
  SUM(CASE WHEN avg_yoy_growth IS NULL THEN 1 ELSE 0 END) AS null_avg_yoy_growth,
  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
  COUNT(*) AS total_rows
FROM t_mato_elekanic_project_SQL_primary_final
GROUP BY source_view
ORDER BY source_view;

---Ukážkové riadky pre každý zdroj
SELECT * FROM t_mato_elekanic_project_SQL_primary_final
WHERE source_view = 'analyza_hdp'
LIMIT 10;


--- Záloha pre riadky, ktoré sa budú meniť (podľa source_view)
CREATE TABLE backup_t_mato_yoy_avg_food AS
SELECT * FROM t_mato_elekanic_project_SQL_primary_final
WHERE source_view = 'yoy_avg_food';

CREATE TABLE backup_t_mato_ceny_mzdy_rok AS
SELECT * FROM t_mato_elekanic_project_SQL_primary_final
WHERE source_view = 'ceny_mzdy_rok';

CREATE TABLE backup_t_mato_vyvoj_miezd AS
SELECT * FROM t_mato_elekanic_project_SQL_primary_final
WHERE source_view = 'vyvoj_miezd';


--- Overenie a identifikácia chýb pred opravou
-- koľko chýb podľa source_view a stĺpca
SELECT source_view,
  COUNT(*) AS total,
  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
  SUM(CASE WHEN avg_yoy_growth IS NULL THEN 1 ELSE 0 END) AS null_avg_yoy_growth
FROM t_mato_elekanic_project_SQL_primary_final
GROUP BY source_view;

-- ukážkové chybné riadky
SELECT * FROM t_mato_elekanic_project_SQL_primary_final
WHERE source_view = 'yoy_avg_food'
LIMIT 20;


--- Kontrola pred opravou
-- 1) Preview chybnych riadkov + navrhovany rok z food_yoy_prices
SELECT t.*,
       p.max_year
FROM t_mato_elekanic_project_SQL_primary_final t
LEFT JOIN (
  SELECT food_name, MAX(year) AS max_year
  FROM food_yoy_prices
  GROUP BY food_name
) p ON t.food_name = p.food_name
WHERE t.source_view = 'yoy_avg_food'
ORDER BY t.food_name
LIMIT 200;

-- 2) Počty a NULLy pre yoy_avg_food
SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
  SUM(CASE WHEN avg_yoy_growth IS NULL THEN 1 ELSE 0 END) AS null_avg_yoy_growth
FROM t_mato_elekanic_project_SQL_primary_final
WHERE source_view = 'yoy_avg_food';


---Ukážka pred opravou
-- 1a) chybné riadky v cieľovej tabuľke
SELECT t.food_name, t.avg_yoy_growth, t.year
FROM t_mato_elekanic_project_SQL_primary_final t
WHERE t.source_view = 'yoy_avg_food'
ORDER BY t.food_name;

-- 1b) navrhovaný rok pre každé food_name (najnovší)
SELECT p.food_name, MAX(p.year) AS max_year
FROM food_yoy_prices p
GROUP BY p.food_name
ORDER BY p.food_name;

-- 1c) spojenie preview: ktoré food_name nemajú rok v source table a aký rok by sme doplnili
SELECT t.food_name, t.avg_yoy_growth, t.year AS current_year, p.max_year
FROM t_mato_elekanic_project_SQL_primary_final t
LEFT JOIN (
  SELECT food_name, MAX(year) AS max_year
  FROM food_yoy_prices
  GROUP BY food_name
) p ON t.food_name = p.food_name
WHERE t.source_view = 'yoy_avg_food'
ORDER BY t.food_name;


-- preview: ktoré riadky budú aktualizované a aký rok by sa doplnil
SELECT t.food_name, t.year AS current_year, p.max_year
FROM t_mato_elekanic_project_SQL_primary_final t
LEFT JOIN (
  SELECT food_name, MAX(year) AS max_year
  FROM food_yoy_prices
  GROUP BY food_name
) p ON t.food_name = p.food_name
WHERE t.source_view = 'yoy_avg_food'
ORDER BY t.food_name;



--- Bezpečný update v transakcii pre yoy_avg_food
BEGIN;

-- aktualizujeme len riadky z yoy_avg_food, kde year IS NULL a pre ktoré existuje max_year
UPDATE t_mato_elekanic_project_SQL_primary_final t
SET year = p.max_year
FROM (
  SELECT food_name, MAX(year) AS max_year
  FROM food_yoy_prices
  GROUP BY food_name
) p
WHERE t.source_view = 'yoy_avg_food'
  AND t.year IS NULL
  AND t.food_name = p.food_name
  AND p.max_year IS NOT NULL;

-- overenie počtu aktualizovaných riadkov (výstup pred COMMIT)
SELECT COUNT(*) AS updated_count
FROM t_mato_elekanic_project_SQL_primary_final t
JOIN (
  SELECT food_name, MAX(year) AS max_year
  FROM food_yoy_prices
  GROUP BY food_name
) p ON t.food_name = p.food_name
WHERE t.source_view = 'yoy_avg_food'
  AND t.year = p.max_year;

-- ak je výsledok v poriadku, COMMIT; inak ROLLBACK
COMMIT;


--- Pohľad po commit
-- 1. súhrn pre source_view yoy_avg_food
SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year,
  SUM(CASE WHEN avg_yoy_growth IS NULL THEN 1 ELSE 0 END) AS null_avg_yoy_growth
FROM t_mato_elekanic_project_SQL_primary_final
WHERE source_view = 'yoy_avg_food';

-- 2. overenie, že rok 2018 je doplnený pre všetky riadky
SELECT food_name, year, avg_yoy_growth
FROM t_mato_elekanic_project_SQL_primary_final
WHERE source_view = 'yoy_avg_food'
ORDER BY food_name;


--- Kontrola pri iných views
-- počet riadkov podľa source_view
SELECT source_view, COUNT(*) AS cnt
FROM t_mato_elekanic_project_SQL_primary_final
GROUP BY source_view
ORDER BY source_view;

-- kontrola NULLov v kľúčových stĺpcoch pre všetky zdroje
SELECT
  source_view,
  SUM(CASE WHEN industry_name IS NULL THEN 1 ELSE 0 END) AS null_industry,
  SUM(CASE WHEN priemerna_mzda IS NULL THEN 1 ELSE 0 END) AS null_priemerna_mzda,
  SUM(CASE WHEN avg_yoy_growth IS NULL THEN 1 ELSE 0 END) AS null_avg_yoy_growth,
  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_year
FROM t_mato_elekanic_project_SQL_primary_final
GROUP BY source_view
ORDER BY source_view;




--- Najprv zistím vhodný kľúč k tabuľke
-- stĺpce v zdrojovom view/tabuľke
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'ceny_mzdy_rok'
ORDER BY ordinal_position;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'vyvoj_miezd'
ORDER BY ordinal_position;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'analyza_hdp'
ORDER BY ordinal_position;

-- stĺpce v cieľovej tabuľke
SELECT column_name
FROM information_schema.columns
WHERE table_name = 't_mato_elekanic_project_sql_primary_final'
ORDER BY ordinal_position;


--Pre dalšiu diagnostiku
SELECT COUNT(*) AS cnt FROM data_academy_content.vyvoj_miezd;
SELECT COUNT(*) AS cnt FROM tmp_combined WHERE source_view = 'vyvoj_miezd';

SELECT COUNT(*) FILTER (WHERE priemerná_mzda_odvetví IS NULL) AS lag_nulls,
       COUNT(*) AS total
FROM data_academy_content.<view_where_lag_is_computed>;


-- počet riadkov v medzivýsledku kde počítaš LAG 
WITH src AS (
  SELECT * 
  FROM data_academy_content.vyvoj_miezd
)
SELECT 'src' AS stage, COUNT(*) AS cnt
FROM src;

WITH joined AS (
  SELECT
    cp.payroll_year,
    cpib.name AS industry_name,
    cp.industry_branch_code,
    AVG(cp.value) AS priemerna_mzda_odvetvi
  FROM data_academy_content.czechia_payroll AS cp
  LEFT JOIN data_academy_content.czechia_payroll_industry_branch AS cpib
    ON cp.industry_branch_code = cpib.code
  GROUP BY cp.payroll_year, cpib.name, cp.industry_branch_code
)
SELECT 'joined' AS stage, COUNT(*) AS cnt
FROM joined;


WITH src AS (
  SELECT * 
  FROM data_academy_content.vyvoj_miezd 
),
joined AS (
  SELECT
    cp.payroll_year,
    cpib.name AS industry_name,
    cp.industry_branch_code,
    AVG(cp.value) AS priemerna_mzda_odvetvi
  FROM data_academy_content.czechia_payroll AS cp
  LEFT JOIN data_academy_content.czechia_payroll_industry_branch AS cpib
    ON cp.industry_branch_code = cpib.code
  GROUP BY cp.payroll_year, cpib.name, cp.industry_branch_code
)
SELECT
  (SELECT COUNT(*) FROM src)   AS src_cnt,
  (SELECT COUNT(*) FROM joined) AS joined_cnt;



-- 1.1 min/max rok v czechia_payroll
SELECT MIN(payroll_year) AS min_year, MAX(payroll_year) AS max_year, COUNT(DISTINCT payroll_year) AS distinct_years
FROM data_academy_content.czechia_payroll;

-- 1.2 počet rokov pre každé industry_branch_code
SELECT industry_branch_code, COUNT(DISTINCT payroll_year) AS years_count,
       MIN(payroll_year) AS min_year, MAX(payroll_year) AS max_year
FROM data_academy_content.czechia_payroll
GROUP BY industry_branch_code
ORDER BY years_count ASC
LIMIT 200;

-- 1.3 koľko unikátnych (code, year) párov
SELECT COUNT(DISTINCT industry_branch_code || '|' || payroll_year) AS code_year_pairs
FROM data_academy_content.czechia_payroll;



-- 0. nastavenie schémy
SET search_path = data_academy_content;

-- 1. deduplikovaná mapa code -> name (dočasne, nemeníme zdroj)

CREATE TEMP TABLE tmp_cpib_most_freq AS
SELECT code, name
FROM (
  SELECT code, name,
         ROW_NUMBER() OVER (PARTITION BY code ORDER BY cnt DESC, name) AS rn
  FROM (
    SELECT code, name, COUNT(*) AS cnt
    FROM data_academy_content.czechia_payroll_industry_branch
    GROUP BY code, name
  ) t
) u
WHERE rn = 1;

-- 2. agreguj payroll na úroveň code + year (dočasne)

CREATE TEMP TABLE tmp_payroll_agg AS
SELECT
  payroll_year,
  industry_branch_code,
  AVG(value) AS priemerna_mzda_odvetvi
FROM data_academy_content.czechia_payroll
GROUP BY payroll_year, industry_branch_code;

-- 3.1 vytvor TEMP tabuľku rokov (years)
CREATE TEMP TABLE tmp_years AS
SELECT generate_series(
  (SELECT MIN(payroll_year) FROM data_academy_content.czechia_payroll),
  (SELECT MAX(payroll_year) FROM data_academy_content.czechia_payroll)
)::int AS year;

-- 3.2 vytvor TEMP tabuľku unikátnych kódov (codes)
CREATE TEMP TABLE tmp_codes AS
SELECT DISTINCT industry_branch_code
FROM data_academy_content.czechia_payroll;

-- 4. vytvorenie gridu a naplnenie agregovanými hodnotami

CREATE TEMP TABLE tmp_filled AS
SELECT
  c.industry_branch_code,
  y.year AS payroll_year,
  a.priemerna_mzda_odvetvi
FROM tmp_codes c
CROSS JOIN tmp_years y
LEFT JOIN tmp_payroll_agg a
  ON a.industry_branch_code = c.industry_branch_code
 AND a.payroll_year = y.year;

-- 5. pripojenie deduplikovanej mapy code->name a výpočet LAG

CREATE TEMP TABLE tmp_with_lag AS
SELECT
  j.industry_name,
  j.industry_branch_code,
  j.payroll_year,
  j.priemerna_mzda_odvetvi,
  LAG(j.priemerna_mzda_odvetvi) OVER (PARTITION BY j.industry_name ORDER BY j.payroll_year) AS prev_priemerna_mzda_odvetvi
FROM (
  SELECT
    f.payroll_year,
    tmp.name AS industry_name,
    f.industry_branch_code,
    f.priemerna_mzda_odvetvi
  FROM tmp_filled f
  LEFT JOIN tmp_cpib_most_freq tmp
    ON f.industry_branch_code = tmp.code
) j;


-- 6.1 očakávané počty
SELECT
  (SELECT COUNT(*) FROM tmp_codes) AS codes_count,
  (SELECT COUNT(*) FROM tmp_years) AS years_count,
  (SELECT COUNT(*) FROM tmp_with_lag) AS filled_rows;

-- 6.2 koľko riadkov nemá priradené industry_name
SELECT COUNT(*) AS no_name_count FROM tmp_with_lag WHERE industry_name IS NULL;

-- 6.3 náhodná vzorka pre kontrolu
SELECT * FROM tmp_with_lag
ORDER BY industry_name NULLS LAST, payroll_year
LIMIT 200;


---Overovacie dopyty
-- A: potvrdiť počty (spusti ak ešte nemáš filled_rows)
SELECT
  (SELECT COUNT(*) FROM tmp_codes) AS codes_count,
  (SELECT COUNT(*) FROM tmp_years) AS years_count,
  (SELECT COUNT(*) FROM tmp_with_lag) AS filled_rows;

-- B: koľko riadkov nemá priradené industry_name
SELECT COUNT(*) AS no_name_count FROM tmp_with_lag WHERE industry_name IS NULL;

-- C: koľko unikátnych párov industry_name + payroll_year v tmp_with_lag
SELECT COUNT(DISTINCT COALESCE(industry_name,'__NULL__') || '|' || payroll_year) AS unique_name_year_pairs
FROM tmp_with_lag;


--- Ktoré riadky chýbajú
SELECT w.industry_name, w.payroll_year AS year, w.priemerna_mzda_odvetvi
FROM tmp_with_lag w
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = w.industry_name
 AND t.year = w.payroll_year
WHERE t.industry_name IS NULL
ORDER BY w.industry_name NULLS LAST, w.payroll_year
LIMIT 500;


SELECT DISTINCT f.industry_branch_code
FROM tmp_filled f
LEFT JOIN tmp_cpib_most_freq m ON f.industry_branch_code = m.code
WHERE m.code IS NULL
ORDER BY f.industry_branch_code;

SELECT * FROM t_mato_elekanic_project_sql_primary_final AS tmepspf; 

---Manuálna mapa kódov industry_name
-- vytvor dočasnú manuálnu mapu pre chýbajúce kódy

CREATE TEMP TABLE tmp_cpib_manual (code text PRIMARY KEY, industry_name text);

INSERT INTO tmp_cpib_manual (code, industry_name) VALUES
  ('N', 'Administrativní a podpůrné činnosti'),
  ('L', 'Činnosti v oblasti nemovitostí'),
  ('R', 'Kulturní, zábavní a rekreační činnosti'),
  ('K', 'Peněžnictví a pojišťovnictví'),
  ('M', 'Profesní, vědecké a technické činnosti'),
  ('F', 'Stavebnictví'),
  ('B', 'Těžba a dobývání'),
  ('I', 'Ubytování, stravování a pohostinství'),
  ('G', 'Velkoobchod a maloobchod; opravy a údržba motorových vozidel'),
  ('O', 'Veřejná správa a obrana; povinné sociální zabezpečení'),
  ('D', 'Výroba a rozvod elektřiny, plynu, tepla a klimatiz. vzduchu'),
  ('P', 'Vzdělávání'),
  ('E', 'Zásobování vodou; činnosti související s odpady a sanacemi'),
  ('A', 'Zemědělství, lesnictví, rybářství'),
  ('C', 'Zpracovatelský průmysl');

SELECT * FROM tmp_cpib_manual;

-- rozšírime existujúcu deduplikovanú mapu o manuálne priradenia (tmp_cpib_most_freq musí existovať)

CREATE TEMP TABLE tmp_cpib_combined AS
SELECT code, name AS industry_name FROM tmp_cpib_most_freq
UNION
SELECT code, industry_name FROM tmp_cpib_manual;

SELECT * FROM tmp_cpib_combined;
-- vytvoríme novú verziu tmp_with_lag, kde chýbajúce industry_name doplníme z tmp_cpib_combined

CREATE TEMP TABLE tmp_with_lag_filled AS
SELECT
  COALESCE(w.industry_name, c.industry_name) AS industry_name,
  w.industry_branch_code,
  w.payroll_year,
  w.priemerna_mzda_odvetvi,
  w.prev_priemerna_mzda_odvetvi
FROM tmp_with_lag w
LEFT JOIN tmp_cpib_combined c
  ON w.industry_branch_code = c.code;

SELECT * FROM tmp_with_lag_filled;


-- pridáme stĺpce pre mzda_minuly_rok a trend_v_percentach (percentuálna zmena)

CREATE TEMP TABLE tmp_with_lag_final AS
SELECT
  industry_name,
  payroll_year,
  priemerna_mzda_odvetvi,
  prev_priemerna_mzda_odvetvi AS mzda_minuly_rok,
  CASE
    WHEN prev_priemerna_mzda_odvetvi IS NULL THEN NULL
    WHEN prev_priemerna_mzda_odvetvi = 0 THEN NULL
    ELSE ROUND( (priemerna_mzda_odvetvi - prev_priemerna_mzda_odvetvi) / prev_priemerna_mzda_odvetvi * 100.0, 4 )
  END AS trend_v_percentach
FROM tmp_with_lag_filled;

SELECT * FROM tmp_with_lag_final;

-- Preview: ktoré riadky z tmp_with_lag_final ešte nie sú v cieľovej tabuľke
SELECT w.industry_name, w.payroll_year AS year, w.priemerna_mzda_odvetvi, w.mzda_minuly_rok, w.trend_v_percentach
FROM tmp_with_lag_final w
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = w.industry_name
 AND t.year = w.payroll_year
WHERE t.industry_name IS NULL
ORDER BY w.industry_name NULLS LAST, w.payroll_year;

---Bezpečný insert - backup + transakcia
BEGIN;

-- 1) záloha existujúcich riadkov pre tento source_view
CREATE TEMP TABLE tmp_backup_vyvoj AS
SELECT * FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';

ROLLBACK;

-- overenie, že tmp_with_lag_final existuje a obsahuje 440 riadkov
SELECT COUNT(*) AS cnt FROM tmp_with_lag_final;

-- vypíše riadky, ktoré ešte nie sú v cieľovej tabuľke pre source_view = 'vyvoj_miezd'
SELECT w.industry_name, w.payroll_year AS year, w.priemerna_mzda_odvetvi, w.mzda_minuly_rok, w.trend_v_percentach
FROM tmp_with_lag_final w
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = w.industry_name
 AND t.year = w.payroll_year
WHERE t.industry_name IS NULL
ORDER BY w.industry_name NULLS LAST, w.payroll_year;

BEGIN;

-- záloha existujúcich riadkov pre tento source_view
CREATE TEMP TABLE tmp_backup_vyvoj AS
SELECT * FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';


ROLLBACK;


SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'data_academy_content'
  AND table_name = 't_mato_elekanic_project_sql_primary_final'
ORDER BY ordinal_position;


ROLLBACK;

CREATE VIEW data_academy_content.v_lag_final AS
WITH
  yrs AS (
    SELECT generate_series(
      (SELECT MIN(payroll_year) FROM data_academy_content.czechia_payroll),
      (SELECT MAX(payroll_year) FROM data_academy_content.czechia_payroll)
    )::int AS year
  ),
  codes AS (
    SELECT DISTINCT industry_branch_code FROM data_academy_content.czechia_payroll
  ),
  payroll_agg AS (
    SELECT payroll_year, industry_branch_code, AVG(value) AS priemer_mzda_odvetvi
    FROM data_academy_content.czechia_payroll
    GROUP BY payroll_year, industry_branch_code
  ),
  grid AS (
    SELECT c.industry_branch_code, y.year AS payroll_year
    FROM codes c CROSS JOIN yrs y
  ),
  filled AS (
    SELECT g.industry_branch_code, g.payroll_year, a.priemer_mzda_odvetvi
    FROM grid g
    LEFT JOIN payroll_agg a
      ON a.industry_branch_code = g.industry_branch_code
     AND a.payroll_year = g.payroll_year
  ),
  cpib_map AS (
    SELECT code, MIN(name) AS industry_name
    FROM data_academy_content.czechia_payroll_industry_branch
    GROUP BY code
  ),
  joined AS (
    SELECT
      COALESCE(m.industry_name, f.industry_branch_code) AS industry_name,
      f.payroll_year,
      f.priemer_mzda_odvetvi
    FROM filled f
    LEFT JOIN cpib_map m ON f.industry_branch_code = m.code
  )
SELECT
  industry_name,
  payroll_year AS year,
  priemer_mzda_odvetvi,
  LAG(priemer_mzda_odvetvi) OVER (PARTITION BY industry_name ORDER BY payroll_year) AS mzda_minuly_rok,
  CASE
    WHEN LAG(priemer_mzda_odvetvi) OVER (PARTITION BY industry_name ORDER BY payroll_year) IS NULL THEN NULL
    WHEN LAG(priemer_mzda_odvetvi) OVER (PARTITION BY industry_name ORDER BY payroll_year) = 0 THEN NULL
    ELSE ROUND(
      (priemer_mzda_odvetvi - LAG(priemer_mzda_odvetvi) OVER (PARTITION BY industry_name ORDER BY payroll_year))
      / LAG(priemer_mzda_odvetvi) OVER (PARTITION BY industry_name ORDER BY payroll_year) * 100.0, 4)
  END AS trend_v_percentach
FROM joined;

---Rýchla kontrola po spustení
-- očakávane 440
SELECT COUNT(*) AS cnt FROM data_academy_content.v_lag_final;

-- náhľad zoradený abecedne
SELECT * FROM data_academy_content.v_lag_final
ORDER BY industry_name NULLS LAST, year
LIMIT 200;




-- 1. preview: koľko riadkov by sa vložilo
SELECT COUNT(*) AS to_insert_count
FROM data_academy_content.v_lag_final v
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = v.industry_name
 AND t.year = v.year
WHERE t.industry_name IS NULL;

-- 2. bezpečný INSERT (backup + vloženie len chýbajúcich riadkov)
BEGIN;

CREATE TEMP TABLE tmp_backup_vyvoj AS
SELECT * FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';

INSERT INTO data_academy_content.t_mato_elekanic_project_sql_primary_final
  (industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach, source_view, year)
SELECT
  v.industry_name,
  v.priemer_mzda_odvetvi,
  v.mzda_minuly_rok,
  v.trend_v_percentach,
  'vyvoj_miezd',
  v.year
FROM data_academy_content.v_lag_final v
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = v.industry_name
 AND t.year = v.year
WHERE t.industry_name IS NULL
ORDER BY v.industry_name NULLS LAST, v.year;  -- insert in alphabetical order as selected

-- 3. kontrola po vložení
SELECT
  (SELECT COUNT(*) FROM data_academy_content.t_mato_elekanic_project_sql_primary_final WHERE source_view = 'vyvoj_miezd') AS after_cnt,
  (SELECT COUNT(*) FROM tmp_backup_vyvoj) AS before_cnt,
  (SELECT COUNT(*) FROM data_academy_content.v_lag_final) AS source_cnt;

COMMIT;


SELECT industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach, year
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd'
ORDER BY industry_name NULLS LAST, year;

SELECT * FROM t_mato_elekanic_project_sql_primary_final AS tmepspf; 


SELECT COUNT(*) AS to_insert_count
FROM data_academy_content.v_lag_final v
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = v.industry_name
 AND t.year = v.year
WHERE t.industry_name IS NULL;

SELECT v.industry_name, v.year, v.priemer_mzda_odvetvi, v.mzda_minuly_rok, v.trend_v_percentach
FROM data_academy_content.v_lag_final v
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = v.industry_name
 AND t.year = v.year
WHERE t.industry_name IS NULL
ORDER BY v.industry_name NULLS LAST, v.year;


-- preview: riadky v cieľovej tabuľke, ktoré majú NULL v aspoň jednom z troch stĺpcov
SELECT t.industry_name, t.year,
       t.priemer_mzda_odvetvi, t.mzda_minuly_rok, t.trend_v_percentach,
       v.priemer_mzda_odvetvi AS src_priemer, v.mzda_minuly_rok AS src_prev, v.trend_v_percentach AS src_trend
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final t
JOIN data_academy_content.v_lag_final v
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = v.industry_name
 AND t.year = v.year
WHERE (t.priemer_mzda_odvetvi IS NULL OR t.mzda_minuly_rok IS NULL OR t.trend_v_percentach IS NULL)
ORDER BY t.industry_name NULLS LAST, t.year;







-- vloženie len chýbajúcich riadkov (nezapisujeme industry_branch_code)
INSERT INTO data_academy_content.t_mato_elekanic_project_sql_primary_final
  (industry_name, priemerná_mzda_odvetví, mzda_minuly_rok, trend_v_percentach, source_view, year)
SELECT
  w.industry_name,
  w.priemerná_mzda_odvetví,
  w.mzda_minuly_rok,
  w.trend_v_percentach,
  'vyvoj_miezd',
  w.payroll_year
FROM tmp_with_lag_final w
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = w.industry_name
 AND t.year = w.payroll_year
WHERE t.industry_name IS NULL;

-- kontrola po vložení
SELECT
  (SELECT COUNT(*) FROM data_academy_content.t_mato_elekanic_project_sql_primary_final WHERE source_view = 'vyvoj_miezd') AS after_cnt,
  (SELECT COUNT(*) FROM tmp_backup_vyvoj) AS before_cnt,
  (SELECT COUNT(*) FROM tmp_with_lag_final) AS source_cnt;

COMMIT;




-- 2) vloženie len chýbajúcich riadkov z tmp_with_lag_final
INSERT INTO data_academy_content.t_mato_elekanic_project_sql_primary_final
  (industry_name, priemerná_mzda_odvetví, mzda_minuly_rok, trend_v_percentach, source_view, year)
SELECT
  w.industry_name,
  w.priemerná_mzda_odvetví,
  w.mzda_minuly_rok,
  w.trend_v_percentach,
  'vyvoj_miezd',
  w.payroll_year
FROM tmp_with_lag_final w
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd'
 AND t.industry_name = w.industry_name
 AND t.year = w.payroll_year
WHERE t.industry_name IS NULL;


-- 3) kontrola počtov po vložení
SELECT
  (SELECT COUNT(*) FROM data_academy_content.t_mato_elekanic_project_sql_primary_final WHERE source_view = 'vyvoj_miezd') AS after_cnt,
  (SELECT COUNT(*) FROM tmp_backup_vyvoj) AS before_cnt,
  (SELECT COUNT(*) FROM tmp_with_lag_final) AS source_cnt;

COMMIT;





-- 7. Ak sú výsledky OK, bezpečné vloženie do primárnej tabuľky (spusti len ak overené)
-- Poznámka: tento blok je voliteľný, spusti ho až po kontrole výstupov
BEGIN;

CREATE TEMP TABLE tmp_backup_vyvoj AS
SELECT * FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';

INSERT INTO data_academy_content.t_mato_elekanic_project_sql_primary_final
  (industry_name, priemerna_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach, source_view, year)
SELECT
  industry_name,
  priemerna_mzda_odvetvi,
  NULL::numeric,
  NULL::numeric,
  'vyvoj_miezd',
  payroll_year
FROM tmp_with_lag
ON CONFLICT (industry_name, year) DO UPDATE
  SET priemerna_mzda_odvetvi = EXCLUDED.priemerna_mzda_odvetvi;

-- kontrola počtov po vložení
SELECT
  (SELECT COUNT(*) FROM data_academy_content.vyvoj_miezd) AS src_cnt,
  (SELECT COUNT(*) FROM data_academy_content.t_mato_elekanic_project_sql_primary_final WHERE source_view = 'vyvoj_miezd') AS after_cnt;

COMMIT;



SELECT * FROM t_mato_elekanic_project_sql_primary_final AS tmepspf; 

-- 1.1 ktoré riadky majú NULL v aspoň jednom z hlavných stĺpcov
SELECT industry_name, year, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd'
  AND (priemer_mzda_odvetvi IS NULL OR mzda_minuly_rok IS NULL OR trend_v_percentach IS NULL)
ORDER BY industry_name NULLS LAST, year;

-- 1.2 unikátne industry_name, ktoré sú postihnuté
SELECT DISTINCT industry_name
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd'
  AND (priemer_mzda_odvetvi IS NULL OR mzda_minuly_rok IS NULL OR trend_v_percentach IS NULL)
ORDER BY industry_name;



-- nahradíš poddotazom z kroku 1.2 ak chceš, tu je všeobecný dotaz
WITH affected AS (
  SELECT DISTINCT industry_name
  FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
  WHERE source_view = 'vyvoj_miezd'
    AND (priemer_mzda_odvetvi IS NULL OR mzda_minuly_rok IS NULL OR trend_v_percentach IS NULL)
)
SELECT a.industry_name,
       (SELECT COUNT(*) FROM data_academy_content.v_lag_final v WHERE v.industry_name = a.industry_name) AS view_years,
       (SELECT COUNT(*) FROM data_academy_content.t_mato_elekanic_project_sql_primary_final t
         WHERE t.source_view = 'vyvoj_miezd' AND t.industry_name = a.industry_name) AS target_years
FROM affected a
ORDER BY a.industry_name;

SELECT *
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd'
  AND industry_name IS NULL
ORDER BY year;

BEGIN;
CREATE TEMP TABLE tmp_backup_null_names AS
SELECT *
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd'
  AND industry_name IS NULL;
COMMIT;


-- dočasná tabuľka s rokovými hodnotami z backupu
CREATE TEMP TABLE tmp_null_years AS
SELECT DISTINCT year FROM tmp_backup_null_names;

-- zoznam správnych industry_name|year z view pre tieto roky
CREATE TEMP TABLE tmp_replacement_pairs AS
SELECT v.industry_name, v.year, v.priemer_mzda_odvetvi, v.mzda_minuly_rok, v.trend_v_percentach
FROM data_academy_content.v_lag_final v
JOIN tmp_null_years y ON v.year = y.year
ORDER BY v.industry_name NULLS LAST, v.year;

SELECT * FROM tmp_replacement_pairs;

BEGIN;

-- odstránenie všetkých riadkov s NULL industry_name pre tento source_view
DELETE FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd'
  AND industry_name IS NULL;

COMMIT;


BEGIN;

INSERT INTO data_academy_content.t_mato_elekanic_project_sql_primary_final
  (industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach, source_view, year)
SELECT
  r.industry_name,
  r.priemer_mzda_odvetvi,
  r.mzda_minuly_rok,
  r.trend_v_percentach,
  'vyvoj_miezd',
  r.year
FROM tmp_replacement_pairs r
ORDER BY r.industry_name NULLS LAST, r.year;

COMMIT;

-- koľko NULL riadkov zostalo
SELECT COUNT(*) AS null_remaining
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd' AND industry_name IS NULL;

-- očakávaný celkový počet (po vložení)
SELECT COUNT(*) AS total_after
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';

-- zobrazenie vložených riadkov pre kontrolu
SELECT t.industry_name, t.year, t.priemer_mzda_odvetvi, t.mzda_minuly_rok, t.trend_v_percentach
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final t
JOIN tmp_replacement_pairs r
  ON t.industry_name = r.industry_name AND t.year = r.year
WHERE t.source_view = 'vyvoj_miezd'
ORDER BY t.industry_name NULLS LAST, t.year;


--- riadky v tabuľke
-- A: koľko riadkov celkovo pre tento source_view
SELECT COUNT(*) AS total_for_view
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';

-- B: koľko unikátnych párov industry_name|year (bez NULL industry_name)

SELECT COUNT(*) AS distinct_pairs
FROM (
  SELECT DISTINCT industry_name, year
  FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
  WHERE source_view = 'vyvoj_miezd' AND industry_name IS NOT NULL
) sub;

-- C: koľko riadkov s NULL industry_name
SELECT COUNT(*) AS null_name_rows
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd' AND industry_name IS NULL;

-- D: či sú duplicitné páry industry_name|year (viac než 1)
SELECT industry_name, year, COUNT(*) AS cnt
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd' AND industry_name IS NOT NULL
GROUP BY industry_name, year
HAVING COUNT(*) > 1
ORDER BY cnt DESC
LIMIT 50;

-- E: či sú v tabuľke riadky z iných source_view, ktoré by mohli prispieť k počtu
SELECT source_view, COUNT(*) FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
GROUP BY source_view ORDER BY COUNT(*) DESC;


ROLLBACK;

-- celková záloha pre bezpečný rollback
BEGIN;
CREATE TEMP TABLE tmp_backup_vyvoj_all AS
SELECT * FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';
COMMIT;

SELECT industry_name, year, COUNT(*) AS cnt
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd' AND industry_name IS NOT NULL
GROUP BY industry_name, year
HAVING COUNT(*) > 1
ORDER BY cnt DESC
LIMIT 100;


BEGIN;

WITH to_keep AS (
  SELECT ctid
  FROM (
    SELECT ctid,
           ROW_NUMBER() OVER (PARTITION BY industry_name, year ORDER BY ctid) AS rn
    FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
    WHERE source_view = 'vyvoj_miezd' AND industry_name IS NOT NULL
  ) s
  WHERE s.rn = 1
),
to_delete AS (
  SELECT t.ctid
  FROM data_academy_content.t_mato_elekanic_project_sql_primary_final t
  LEFT JOIN to_keep k ON t.ctid = k.ctid
  WHERE t.source_view = 'vyvoj_miezd' AND t.industry_name IS NOT NULL AND k.ctid IS NULL
)
DELETE FROM data_academy_content.t_mato_elekanic_project_sql_primary_final t
USING to_delete d
WHERE t.ctid = d.ctid;

COMMIT;


BEGIN;
DELETE FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd' AND industry_name IS NULL;
COMMIT;

SELECT * FROM t_mato_elekanic_project_sql_primary_final AS tmepspf;

SELECT * FROM vyvoj_miezd AS vm; 

SELECT COUNT(*) AS total_for_view
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';

SELECT source_view, COUNT(*) AS cnt
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
GROUP BY source_view
ORDER BY cnt DESC;

SELECT
  (SELECT COUNT(*) FROM (SELECT DISTINCT industry_name, year FROM data_academy_content.t_mato_elekanic_project_sql_primary_final WHERE source_view = 'vyvoj_miezd' AND industry_name IS NOT NULL) s) AS distinct_pairs,
  (SELECT COUNT(*) FROM data_academy_content.t_mato_elekanic_project_sql_primary_final WHERE source_view = 'vyvoj_miezd' AND industry_name IS NULL) AS null_name_rows;

SELECT DISTINCT industry_name
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd'
ORDER BY industry_name NULLS LAST
LIMIT 200;


SELECT v.industry_name, v.year
FROM data_academy_content.v_lag_final v
LEFT JOIN data_academy_content.t_mato_elekanic_project_sql_primary_final t
  ON t.source_view = 'vyvoj_miezd' AND t.industry_name = v.industry_name AND t.year = v.year
WHERE t.industry_name IS NULL
ORDER BY v.industry_name NULLS LAST, v.year;

SELECT industry_name, year, COUNT(*) AS cnt
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd' AND industry_name IS NOT NULL
GROUP BY industry_name, year
HAVING COUNT(*) > 1
ORDER BY cnt DESC
LIMIT 50;

















-- preview: koľko riadkov v cieľovej tabuľke sa zhoduje s dátami zo zdroja podľa year
SELECT
  COUNT(*) AS target_rows,
  COUNT(s.pct_change_yoy) AS matched_rows
FROM t_mato_elekanic_project_sql_primary_final t
LEFT JOIN ceny_mzdy_rok s
  ON t.year = s.pct_change_yoy 
WHERE t.source_view = 'ceny_mzdy_rok';


-- koľko riadkov v zdroji a v cieli
SELECT 'source_count' AS what, COUNT(*) AS cnt FROM ceny_mzdy_rok;
SELECT 'target_count' AS what, COUNT(*) AS cnt
FROM t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'ceny_mzdy_rok';

-- ukážka zdroja
SELECT * FROM ceny_mzdy_rok ORDER BY 1 LIMIT 50;

-- ukážka cieľa (len pre kontrolu)
SELECT food_name, year, pct_change_yoy, trend_pct
FROM t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'ceny_mzdy_rok'
ORDER BY food_name LIMIT 200;



-- A: koľko riadkov v cieli pre tento source_view
SELECT COUNT(*) AS tgt_cnt
FROM t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'ceny_mzdy_rok';

-- B: koľko riadkov v konečnom prehľade
SELECT COUNT(*) AS src_cnt
FROM konečný_prehľad_množstva;


-- koľko riadkov cieľ vs koľko sa dá spojiť podľa industry_name
SELECT
  COUNT(*) AS target_rows,
  COUNT(k.industry_name) AS matched_rows
FROM t_mato_elekanic_project_sql_primary_final t
LEFT JOIN konečný_prehľad_množstva as k
  ON t.industry_name = k.industry_name
WHERE t.source_view = 'ceny_mzdy_rok';




-- 1. záloha existujúcich riadkov pre vyvoj_miezd
BEGIN;
CREATE TEMP TABLE tmp_backup_vyvoj_all AS
SELECT * FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';
COMMIT;

-- 2. vymaž všetky riadky pre vyvoj_miezd
BEGIN;
DELETE FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd';
COMMIT;


--- Vloženie podľa view Vyvoj_miezd
BEGIN;
INSERT INTO data_academy_content.t_mato_elekanic_project_sql_primary_final
  (industry_name, priemerná_mzda_odvetví, mzda_minuly_rok, trend_v_percentach, source_view, payroll_year)
SELECT
  industry_name,
  priemerná_mzda_odvetví,
  mzda_minuly_rok,
  trend_v_percentach,
  'vyvoj_miezd',
  payroll_year
FROM vyvoj_miezd AS vm 
ORDER BY industry_name NULLS LAST, payroll_year;
COMMIT;


ROLLBACK;

-- zisti presné názvy stĺpcov vo view vyvoj_miezd
SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'data_academy_content'   
  AND table_name = 'vyvoj_miezd'
ORDER BY ordinal_position;

BEGIN;
INSERT INTO data_academy_content.t_mato_elekanic_project_sql_primary_final
  (industry_name, priemer_mzda_odvetvi, mzda_minuly_rok, trend_v_percentach, source_view, year)
SELECT
  "industry_name",                                 
  "priemerná_mzda_odvetví",                       
  "mzda_minuly_rok",                               
  "trend_v_percentach",                            
  'vyvoj_miezd',                                   
  "payroll_year"                                   
FROM data_academy_content.vyvoj_miezd vm
ORDER BY "industry_name" NULLS LAST, "payroll_year";
COMMIT;

-- Overenie
SELECT (SELECT COUNT(*) FROM data_academy_content.vyvoj_miezd) AS view_count,
       (SELECT COUNT(*) FROM data_academy_content.t_mato_elekanic_project_sql_primary_final WHERE source_view = 'vyvoj_miezd') AS table_count;

SELECT COUNT(*) AS null_names
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd' AND industry_name IS NULL;

SELECT COUNT(*) AS distinct_pairs_after
FROM (
  SELECT DISTINCT industry_name, year
  FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
  WHERE source_view = 'vyvoj_miezd' AND industry_name IS NOT NULL
) sub;


-- celkový počet riadkov v tabuľke (všetky source_view)
SELECT COUNT(*) AS total_rows
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final;

-- počet riadkov pre konkrétny source_view
SELECT source_view, COUNT(*) AS cnt
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
GROUP BY source_view
ORDER BY cnt DESC;

-- zoznam stĺpcov a ich poradie (schema)
SELECT column_name, ordinal_position, data_type
FROM information_schema.columns
WHERE table_schema = 'data_academy_content'
  AND table_name = 't_mato_elekanic_project_sql_primary_final'
ORDER BY ordinal_position;

-- prvých 200 riadkov pre rýchly náhľad
SELECT *
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
ORDER BY source_view NULLS LAST, industry_name NULLS LAST, year
LIMIT 300;

SELECT *
FROM data_academy_content.t_mato_elekanic_project_sql_primary_final
WHERE source_view = 'vyvoj_miezd'
ORDER BY industry_name NULLS LAST, year;

SELECT * FROM t_mato_elekanic_project_sql_primary_final AS tmepspf; 













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

--- rn znamená row number - poradie riadkov
--- Vkladám údaje do novej tabuľky presne podľa view europe_data
INSERT INTO t_mato_elekanic_project_sql_secondary_final
  (country, continent, year, gdp, gini, population, rn)
SELECT
  country,
  continent,
  year,
  gdp,
  gini,
  population,
  ROW_NUMBER() OVER (ORDER BY country, year) AS rn
FROM europe_data
WHERE country IN (
  'Albania','Andorra','Austria','Belarus','Belgium','Bosnia and Herzegovina',
  'Bulgaria','Croatia','Czech Republic','Denmark','Estonia','Faroe Islands',
  'Finland','France','Germany','Gibraltar','Greece','Hungary','Iceland',
  'Ireland','Italy','Latvia','Liechtenstein','Lithuania','Luxembourg','Malta',
  'Moldova','Monaco','Montenegro','Netherlands','North Macedonia','Norway',
  'Poland','Portugal','Romania','Russian Federation','San Marino','Serbia',
  'Slovakia','Slovenia','Spain','Sweden','Switzerland','Ukraine','United Kingdom'
)
  AND year BETWEEN 2006 AND 2018;

SELECT * FROM t_mato_elekanic_project_sql_secondary_final AS tmepssf; 




