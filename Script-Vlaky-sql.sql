CREATE TABLE data_vlaky (
    id SERIAL PRIMARY KEY,
    nazov_spolocnosti VARCHAR(255),
    rok INT NOT NULL,
    pocet_cestujucich_mil NUMERIC(14,3),
    vlakokilometre_mil NUMERIC(14,3),
    osobokilometre_mil NUMERIC(14,3),
    trzby_mil_eur NUMERIC(14,3),
    pocet_zamestnancov INT,
    meskanie_pct NUMERIC(5,2),
    predaj_online_pct NUMERIC(5,2),
    emisie_co2_kg NUMERIC(18,3),
    nehody INT,
    mzdy_zamestnancov INT,
    obnova_vozoveho_parku INT,
    ostatne_platby_mil_eur NUMERIC(14,3),
    zdroj TEXT,
    UNIQUE (nazov_spolocnosti, rok)
);

 
 
 INSERT INTO data_vlaky (
  nazov_spolocnosti,
  rok,
  pocet_cestujucich_mil,
  vlakokilometre_mil,
  osobokilometre_mil,
  trzby_mil_eur,
  pocet_zamestnancov,
  meskanie_pct,
  predaj_online_pct,
  emisie_co2_kg,
  nehody,
  mzdy_zamestnancov,
  obnova_vozoveho_parku,
  ostatne_platby_mil_eur,
  zdroj
) VALUES
('ZSSK', 2020, 46.660, 32.450, 2117.960,  61.080, 5910, 92.80, 36.00, NULL, 15, 1341, 25,   231.000, 'VS ZSSK 2020'),
('ZSSK', 2021, 45.670, 34.070, 1966.150,  65.360, 5811, 91.50, 39.00, NULL, 18, 1420, NULL, 280.000, 'VS ZSSK 2021'),
('ZSSK', 2022, 67.120, 36.680, 3226.970, 100.620, 5610, 89.20, 43.00, NULL, 22, 1560, NULL, 315.000, 'VS ZSSK 2022'),
('ZSSK', 2023, 71.730, 38.830, 3560.400,  94.000, 5680, 88.50, 47.00, NULL, 19, 1720, 13,   360.000, 'VS ZSSK 2023'),
('ZSSK', 2024, 73.500, 39.200, 3650.000,  98.000, 5600, 88.50, 50.00, NULL, 21, 1850, NULL, 385.000, 'Odhad / Predbežné správy'),
('ZSSK', 2025, 74.200, 39.500, 3680.000,  99.500, 5580, 88.80, 52.00, NULL, 16, 2100, NULL, 395.000, 'VS ZSSK / CRZ 2025');


SELECT * FROM data_vlaky;


BEGIN;

-- 1) Pridať nový stĺpec, ak neexistuje
ALTER TABLE "data_vlaky"
  ADD COLUMN IF NOT EXISTS emisie_g_co2_per_osobokm NUMERIC(6,2);

-- 2) Nastaviť ~30 g CO2/osobokm pre roky 2020-2025
UPDATE "data_vlaky"
SET emisie_g_co2_per_osobokm = 30.00
WHERE rok BETWEEN 2020 AND 2025;

-- 3) (Voliteľné) odstrániť starý stĺpec s kilogramami
ALTER TABLE "data_vlaky"
  DROP COLUMN IF EXISTS emisie_co2_kg;

COMMIT;


SELECT * FROM data_vlaky;



CREATE TABLE zssk_kraje_pdo (
id serial  PRIMARY KEY,
nazov_spolocnosti varchar(255) DEFAULT 'ZSSK',
rok int NOT NULL,
kraj varchar(100) NOT NULL,
objednane_vlkm_tis NUMERIC(10,2),
    priemerny_pocet_vlakov_denne INT,
    odhad_dennych_cestujucich INT,
    dlzka_trati_km NUMERIC(6,2),
    podiel_elektrifikacie_pct NUMERIC(5,2),
    zdroj TEXT DEFAULT 'PDO MD SR',
    FOREIGN KEY (nazov_spolocnosti, rok) REFERENCES data_vlaky(nazov_spolocnosti, rok) ON DELETE CASCADE,
    UNIQUE (nazov_spolocnosti, rok, kraj)
);


WITH koeficienty AS (
    SELECT 2020 AS rok, 0.90 AS koef_vykony, 0.70 AS koef_cestujuci UNION ALL
    SELECT 2021,        0.93,               0.65 UNION ALL
    SELECT 2022,        0.97,               0.90 UNION ALL
    SELECT 2023,        1.00,               1.00 UNION ALL  -- Bazický rok z PDO
    SELECT 2024,        1.03,               1.03 UNION ALL
    SELECT 2025,        1.05,               1.02
),
zaklad_2023 AS (
    -- Tu sú vložené vaše reálne bazické dáta z PDO za rok 2023
    SELECT * FROM (VALUES
        ('Bratislavský',     9362.00, 95, 41000, 270.00, 80.00),
        ('Trnavský',        5019.00, 55, 13900, 250.00, 58.00),
        ('Nitriansky',      6899.00, 45, 19200, 420.00, 30.00),
        ('Trenčiansky',     4380.00, 40, 11500, 300.00, 42.00),
        ('Žilinský',       12337.00, 65, 30600, 520.00, 58.00),
        ('Banskobystrický', 7920.00, 35, 11900, 620.00, 15.00),
        ('Prešovský',       7848.00, 50, 16100, 430.00, 19.00),
        ('Košický',         7829.00, 55, 25000, 390.00, 53.00)
    ) AS t(kraj, vlkm, vlaky, cestujuci, dlzka, elek)
)
INSERT INTO zssk_kraje_pdo (
    nazov_spolocnosti,
    rok,
    kraj,
    objednane_vlkm_tis,
    priemerny_pocet_vlakov_denne,
    odhad_dennych_cestujucich,
    dlzka_trati_km,
    podiel_elektrifikacie_pct,
    zdroj
)
SELECT 
    'ZSSK' AS nazov_spolocnosti,
    k.rok,
    z.kraj,
    ROUND(z.vlkm * k.koef_vykony, 2) AS objednane_vlkm_tis,
    ROUND(z.vlaky * k.koef_vykony) AS priemerny_pocet_vlakov_denne,
    ROUND(z.cestujuci * k.koef_cestujuci) AS odhad_dennych_cestujucich,
    z.dlzka AS dlzka_trati_km,                          -- Necháva sa bez zmeny
    z.elek AS podiel_elektrifikacie_pct,                 -- Necháva sa bez zmeny
    CASE 
        WHEN k.rok = 2023 THEN 'PDO MD SR (Oficiálny zdroj)'
        ELSE 'PDO MD SR (Modelovaný odhad)'
    END AS zdroj
FROM zaklad_2023 z
CROSS JOIN koeficienty k;


SELECT * FROM zssk_kraje_pdo;


---1.Pomer prepravených ľudí voči dopravnému výkonu(obe jednotky sú v miliónoch )
WITH preprava_agregacia AS (
    SELECT 
        SUM(pocet_cestujucich_mil) AS celkovy_pocet_cestujucich_mil,
        SUM(vlakokilometre_mil) AS celkovy_pocet_prejdenych_vlkm
    FROM data_vlaky
    WHERE rok BETWEEN 2020 AND 2025
)
SELECT 
    celkovy_pocet_cestujucich_mil,
    celkovy_pocet_prejdenych_vlkm,
    
    -- Výpočet pomeru
    ROUND(
        celkovy_pocet_cestujucich_mil * 1.0 / NULLIF(celkovy_pocet_prejdenych_vlkm, 0), 2
    ) AS pomer,

    -- Hodnotenie prepravného pohľadu
    CASE 
        WHEN celkovy_pocet_cestujucich_mil > celkovy_pocet_prejdenych_vlkm THEN 'pozitívny pomer'
        WHEN celkovy_pocet_cestujucich_mil < celkovy_pocet_prejdenych_vlkm THEN 'negatívny pomer'
        ELSE 'vyrovnaný pomer'
    END AS prepravny_pohlad
FROM preprava_agregacia;

--- Priemerná obsadenosť na kilometer vychádza v prospech cestujúcich


ALTER TABLE data_vlaky 
ADD COLUMN Cas_IC_BA_KE_Min INT,
ADD COLUMN CAS_EX_BA_KE_Min INT;

UPDATE data_vlaky SET Cas_IC_BA_KE_Min = 276, CAS_EX_BA_KE_Min = 345 WHERE rok = 2020;
UPDATE data_vlaky SET Cas_IC_BA_KE_Min = 276, CAS_EX_BA_KE_Min = 340 WHERE rok = 2021;
UPDATE data_vlaky SET Cas_IC_BA_KE_Min = 276, CAS_EX_BA_KE_Min = 338 WHERE rok = 2022;
UPDATE data_vlaky SET Cas_IC_BA_KE_Min = 271, CAS_EX_BA_KE_Min = 316 WHERE rok = 2023;
UPDATE data_vlaky SET Cas_IC_BA_KE_Min = 271, CAS_EX_BA_KE_Min = 316 WHERE rok = 2024;
UPDATE data_vlaky SET Cas_IC_BA_KE_Min = 271, CAS_EX_BA_KE_Min = 315 WHERE rok = 2025;

--- 2. Pohľad na cestovný čas a priemerné meškanie vlakov
WITH casovy_pohlad AS (
    SELECT 
        rok,
        cas_ic_ba_ke_min,
        cas_ex_ba_ke_min,
        meskanie_pct
    FROM data_vlaky
    WHERE rok BETWEEN 2020 AND 2025
)
SELECT 
    rok,
    cas_ic_ba_ke_min AS cas_ic_min,
    cas_ex_ba_ke_min AS cas_ex_min,
    
    -- Výpočet pomeru častejších cestovných časov (IC vs. Express)
    ROUND(
        cas_ic_ba_ke_min::numeric / NULLIF(cas_ex_ba_ke_min, 0), 2
    ) AS pomer_ic_vs_ex,
    
    meskanie_pct AS presnost_gvd_pct,
    
    -- Vyhodnotenie presnosti GVD
    CASE 
        WHEN meskanie_pct >= 90.0 THEN 'Vysoká presnosť (>=90%)'
        WHEN meskanie_pct BETWEEN 88.5 AND 89.9 THEN 'Priemerná presnosť'
        ELSE 'Znížená presnosť (<88.5%)'
    END AS vyhodnotenie_presnosti
FROM casovy_pohlad
ORDER BY rok ASC;

--- Za 6 rokov sa cestovný čas InterCity mierne zlepšil, kým Expresy a Rýchliky výraznejšie zrýchlili svoje jazdy.
--- Spočiatku vysoká presnosť, z prvých dvoch rokov, sa zhoršila na priemer v tomto porovnaní


---3. Porovnanie pomeru tržieb a dopravného výkonu
---Tržba v EUR na vlakokilometer
WITH euro_vlkm AS (
    SELECT
        rok,
        trzby_mil_eur,
        vlakokilometre_mil,
        ROUND(
            (trzby_mil_eur / NULLIF(vlakokilometre_mil, 0))::numeric,
            2
        ) AS trzba_na_1_vlkm_eur
    FROM data_vlaky
    WHERE rok BETWEEN 2020 AND 2025
)

SELECT
    rok,
    trzby_mil_eur,
    vlakokilometre_mil,
    trzba_na_1_vlkm_eur,
    CASE
        WHEN trzba_na_1_vlkm_eur >= 2.50 THEN 'Vysoká jednotková výnosnosť'
        WHEN trzba_na_1_vlkm_eur >= 2.00 THEN 'Priemerná jednotková výnosnosť'
        ELSE 'Znížená jednotková výnosnosť (napr. COVID obdobie)'
    END AS hodnotenie_efektivity
FROM euro_vlkm
ORDER BY rok;
--- Výrazný nárast tržieb, mierny prejdených vlkm, a sínusoidová efektivita jendotkovej výnosnosti v eurách na vlkm 

--- 6 ročný pohľad na tržby vs vlkm
WITH rast_spolocnosti AS (
    SELECT
        nazov_spolocnosti,

        MAX(CASE WHEN rok = 2020 THEN trzby_mil_eur END) AS trzby_2020_mil_eur,
        MAX(CASE WHEN rok = 2025 THEN trzby_mil_eur END) AS trzby_2025_mil_eur,

        MAX(CASE WHEN rok = 2020 THEN vlakokilometre_mil END) AS vlkm_2020_mil,
        MAX(CASE WHEN rok = 2025 THEN vlakokilometre_mil END) AS vlkm_2025_mil

    FROM data_vlaky
    WHERE rok IN (2020, 2025)
    GROUP BY nazov_spolocnosti
)

SELECT
    nazov_spolocnosti,

    trzby_2020_mil_eur,
    trzby_2025_mil_eur,

    ROUND(
        (
            (trzby_2025_mil_eur - trzby_2020_mil_eur)
            / NULLIF(trzby_2020_mil_eur, 0)
        ) * 100,
        2
    ) AS rast_trzieb_pct,

    vlkm_2020_mil,
    vlkm_2025_mil,

    ROUND(
        (
            (vlkm_2025_mil - vlkm_2020_mil)
            / NULLIF(vlkm_2020_mil, 0)
        ) * 100,
        2
    ) AS rast_vlkm_pct,

    CASE
        WHEN
            (
                (trzby_2025_mil_eur - trzby_2020_mil_eur)
                / NULLIF(trzby_2020_mil_eur, 0)
            )
            >
            (
                (vlkm_2025_mil - vlkm_2020_mil)
                / NULLIF(vlkm_2020_mil, 0)
            )
        THEN 'Tržby rástli rýchlejšie ako odjazdené km (rast jednotkovej výnosnosti)'

        ELSE 'Dopravný výkon rástol rýchlejšie ako tržby'
    END AS interpretacia_pomeru

FROM rast_spolocnosti
ORDER BY nazov_spolocnosti;
--- % tržieb je oveľa vyššie ako % odjazdených vlkm


--- 4. Prepravení cestujúci vs počet zamestnancov 
WITH cestujuci_vs_zamestnanci AS (
    SELECT
        nazov_spolocnosti,

        MAX(CASE WHEN rok = 2020 THEN pocet_cestujucich_mil END) AS cestujuci_2020_mil,
        MAX(CASE WHEN rok = 2025 THEN pocet_cestujucich_mil END) AS cestujuci_2025_mil,

        MAX(CASE WHEN rok = 2020 THEN pocet_zamestnancov END) AS zamestnanci_2020,
        MAX(CASE WHEN rok = 2025 THEN pocet_zamestnancov END) AS zamestnanci_2025

    FROM data_vlaky
    WHERE rok IN (2020, 2025)
    GROUP BY nazov_spolocnosti
)

SELECT
    nazov_spolocnosti,

    cestujuci_2020_mil,
    cestujuci_2025_mil,

    ROUND(
        (
            (cestujuci_2025_mil - cestujuci_2020_mil)
            / NULLIF(cestujuci_2020_mil, 0)
        ) * 100,
        2
    ) AS rast_cestujuci_pct,

    zamestnanci_2020,
    zamestnanci_2025,

    ROUND(
        (
            (zamestnanci_2025 - zamestnanci_2020)::numeric
            / NULLIF(zamestnanci_2020, 0)
        ) * 100,
        2
    ) AS rast_zamestnanci_pct,

    ROUND(
        (cestujuci_2020_mil * 1000000.0)
        / NULLIF(zamestnanci_2020, 0),
        0
    ) AS cestujuci_na_zamestnanca_2020,

    ROUND(
        (cestujuci_2025_mil * 1000000.0)
        / NULLIF(zamestnanci_2025, 0),
        0
    ) AS cestujuci_na_zamestnanca_2025,

    ROUND(
        (
            (
                (cestujuci_2025_mil * 1000000.0)
                / NULLIF(zamestnanci_2025, 0)
            )
            -
            (
                (cestujuci_2020_mil * 1000000.0)
                / NULLIF(zamestnanci_2020, 0)
            )
        )
        /
        NULLIF(
            (
                (cestujuci_2020_mil * 1000000.0)
                / NULLIF(zamestnanci_2020, 0)
            ),
            0
        ) * 100,
        2
    ) AS zmena_produktivity_pct,

    CASE
        WHEN
            (
                (cestujuci_2025_mil - cestujuci_2020_mil)
                / NULLIF(cestujuci_2020_mil, 0)
            )
            >
            (
                (zamestnanci_2025 - zamestnanci_2020)::numeric
                / NULLIF(zamestnanci_2020, 0)
            )
        THEN 'Rast cestujúcich predbehol rast zamestnancov (nárast produktivity práce)'

        WHEN
            (
                (cestujuci_2025_mil - cestujuci_2020_mil)
                / NULLIF(cestujuci_2020_mil, 0)
            )
            =
            (
                (zamestnanci_2025 - zamestnanci_2020)::numeric
                / NULLIF(zamestnanci_2020, 0)
            )
        THEN 'Produktivita zostala približne nezmenená'

        ELSE 'Počet zamestnancov rástol rýchlejšie ako počet cestujúcich'
    END AS interpretacia_produktivity

FROM cestujuci_vs_zamestnanci
ORDER BY nazov_spolocnosti;

--- 5. Počet online kúpených lístkov vs počet denne vypravených vlakov
WITH kraje_vlaky_spolu AS (
    -- Agregácia denného počtu vlakov zo všetkých 8 krajov za každý rok
    SELECT 
        rok,
        SUM(priemerny_pocet_vlakov_denne) AS celkovo_vlakov_denne_SR
    FROM zssk_kraje_pdo
    GROUP BY rok
)
SELECT 
    dv.rok,
    dv.predaj_online_pct,
    kp.celkovo_vlakov_denne_SR,

    -- 1. Medziročný posun v podiele online predaja (v percentuálnych bodoch - p.b.)
    ROUND(
        (dv.predaj_online_pct - LAG(dv.predaj_online_pct) OVER (ORDER BY dv.rok))::numeric, 2
    ) AS zmena_online_pct_p_b,

    -- 2. Medziročný percentuálny rast online predaja (%)
    ROUND(
        ((dv.predaj_online_pct - LAG(dv.predaj_online_pct) OVER (ORDER BY dv.rok))::numeric 
        / NULLIF(LAG(dv.predaj_online_pct) OVER (ORDER BY dv.rok), 0)) * 100.0, 2
    ) AS rast_online_predaja_medzirocne_pct,

    -- 3. Hodnotenie úrovne digitalizácie predaja (vyhodnocuje sa priamo stĺpec predaj_online_pct)
    CASE 
        WHEN dv.predaj_online_pct >= 40.0 
            THEN 'Vysoká digitalizácia (Dominancia aplikácie/webu)'
        WHEN dv.predaj_online_pct BETWEEN 25.0 AND 39.99 
            THEN 'Rastúci podiel online predaja'
        ELSE 'Nízky podiel digitalizácie (Prevažne pokladnice/COVID utlmenie)'
    END AS hodnotenie_digitalizacie

FROM data_vlaky dv
JOIN kraje_vlaky_spolu kp ON dv.rok = kp.rok
WHERE dv.rok BETWEEN 2020 AND 2025
ORDER BY dv.rok ASC;

--- Vidieť pramu úmeru medzi rastom predaja online lístkov a rastom vypravených vlakov

---6.Pomer dĺžky tratí a vypustených emisií CO2 g/osobakm
WITH kraje_trate_spolu AS (
    -- Agregácia celkovej dĺžky tratí v km zo všetkých 8 krajov za každý rok
    SELECT 
        rok,
        SUM(dlzka_trati_km) AS celkova_dlzka_trati_km
    FROM zssk_kraje_pdo
    GROUP BY rok
)
SELECT 
    dv.rok,
    kp.celkova_dlzka_trati_km,
    dv.emisie_g_co2_per_osobokm,

    -- 1. Medziročná zmena emisií v gramoch CO2 / osobokm (v absolútnych hodnotách)
    ROUND(
        (dv.emisie_g_co2_per_osobokm - LAG(dv.emisie_g_co2_per_osobokm) OVER (ORDER BY dv.rok))::numeric, 2
    ) AS zmena_emisii_medzirocne_g,

    -- 2. Medziročný percentuálny pokles / nárast emisií (%)
    ROUND(
        ((dv.emisie_g_co2_per_osobokm - LAG(dv.emisie_g_co2_per_osobokm) OVER (ORDER BY dv.rok))::numeric 
        / NULLIF(LAG(dv.emisie_g_co2_per_osobokm) OVER (ORDER BY dv.rok), 0)) * 100.0, 2
    ) AS zmena_emisii_medzirocne_pct,

    -- 3. Relatívny index: Emisie prepočítané na 100 km siete
    ROUND(
        (dv.emisie_g_co2_per_osobokm::numeric / NULLIF(kp.celkova_dlzka_trati_km, 0)) * 100.0, 4
    ) AS emisie_na_100km_siete,

    -- 4. Hodnotenie ekologickej efektivity a dekarbonizácie
    CASE 
        WHEN dv.emisie_g_co2_per_osobokm <= 30 
            THEN 'Vysoká ekologická efektivita (Nízke emisie / Postupujúca elektrifikácia)'
        WHEN dv.emisie_g_co2_per_osobokm BETWEEN 31 AND 40 
            THEN 'Priemerná ekologická efektivita'
        ELSE 'Znížená ekologická efektivita (Prevažne dieselová trakcia / Nižšia obsadenosť)'
    END AS hodnotenie_ekologie

FROM data_vlaky dv
JOIN kraje_trate_spolu kp ON dv.rok = kp.rok
WHERE dv.rok BETWEEN 2020 AND 2025
ORDER BY dv.rok ASC;

--- 7. Pomer nehôd vs počet denne vypravených vlakov voči dlžke tratí
WITH kraje_agregacia AS (
    -- Agregácia krajských dát na celonárodnú úroveň pre každý rok
    SELECT 
        rok,
        SUM(dlzka_trati_km) AS celkova_dlzka_trati_km,
        SUM(priemerny_pocet_vlakov_denne) AS celkovo_vlakov_denne_sr
    FROM zssk_kraje_pdo
    GROUP BY rok
)
SELECT 
    dv.rok,
    dv.nehody AS pocet_nehod,
    ka.celkova_dlzka_trati_km,
    ka.celkovo_vlakov_denne_sr,

    -- 1. Počet nehôd prepočítaný na 1 000 km tratí
    ROUND(
        (dv.nehody::numeric / NULLIF(ka.celkova_dlzka_trati_km, 0)) * 1000.0, 2
    ) AS nehody_na_1000km_trati,

    -- 2. Počet nehôd prepočítaný na 100 denne vypravených vlakov
    ROUND(
        (dv.nehody::numeric / NULLIF(ka.celkovo_vlakov_denne_sr, 0)) * 100.0, 2
    ) AS nehody_na_100_vlakov_denne,

    -- 3. Medziročná zmena počtu nehôd (%)
    ROUND(
        ((dv.nehody - LAG(dv.nehody) OVER (ORDER BY dv.rok))::numeric 
        / NULLIF(LAG(dv.nehody) OVER (ORDER BY dv.rok), 0)) * 100.0, 2
    ) AS zmena_nehod_medzirocne_pct,

    -- 4. Hodnotenie bezpečnosti železničnej prevádzky
    CASE 
        WHEN (dv.nehody::numeric / NULLIF(ka.celkovo_vlakov_denne_sr, 0)) * 100.0 <= 15.0 
            THEN 'Vysoká úroveň bezpečnosti'
        WHEN (dv.nehody::numeric / NULLIF(ka.celkovo_vlakov_denne_sr, 0)) * 100.0 BETWEEN 15.01 AND 25.0 
            THEN 'Priemerná úroveň bezpečnosti'
        ELSE 'Zvýšená nehodovosť (Vyžaduje bezpečnostný audit / Modernizáciu ZZ)'
    END AS hodnotenie_bezpecnosti

FROM data_vlaky dv
JOIN kraje_agregacia ka ON dv.rok = ka.rok
WHERE dv.rok BETWEEN 2020 AND 2025
ORDER BY dv.rok ASC; 

---8. Vzťah tržieb a priemernej mzdy zamestnancov
WITH financie_mzdy AS (
    SELECT 
        rok,
        trzby_mil_eur,
        mzdy_zamestnancov
    FROM data_vlaky
    WHERE rok BETWEEN 2020 AND 2025
)
SELECT 
    rok,
    trzby_mil_eur,
    mzdy_zamestnancov,

    -- 1. Medziročná zmena tržieb (%)
    ROUND(
        ((trzby_mil_eur - LAG(trzby_mil_eur) OVER (ORDER BY rok))::numeric 
        / NULLIF(LAG(trzby_mil_eur) OVER (ORDER BY rok), 0)) * 100.0, 2
    ) AS zmena_trzieb_medzirocne_pct,

    -- 2. Medziročná zmena miezd (%)
    ROUND(
        ((mzdy_zamestnancov - LAG(mzdy_zamestnancov) OVER (ORDER BY rok))::numeric 
        / NULLIF(LAG(mzdy_zamestnancov) OVER (ORDER BY rok), 0)) * 100.0, 2
    ) AS zmena_mzdy_medzirocne_pct,

    -- 3. Prepočet: Objem tržieb (v €) pripadajúci na 1 € mzdových nákladov
    ROUND(
        (trzby_mil_eur * 1000000.0 / NULLIF(mzdy_zamestnancov, 0))::numeric, 2
    ) AS trzby_na_1eur_mzdy,

    -- 4. Hodnotenie vývoja mzdovej nákladovosti voči tržbám
    CASE 
        WHEN 
            ((trzby_mil_eur - LAG(trzby_mil_eur) OVER (ORDER BY rok)) / NULLIF(LAG(trzby_mil_eur) OVER (ORDER BY rok), 0)) >
            ((mzdy_zamestnancov - LAG(mzdy_zamestnancov) OVER (ORDER BY rok)) / NULLIF(LAG(mzdy_zamestnancov) OVER (ORDER BY rok), 0))
        THEN 'Rast tržieb predbehol rast miezd (Efektívny vývoj nákladov)'
        
        WHEN 
            ((trzby_mil_eur - LAG(trzby_mil_eur) OVER (ORDER BY rok)) / NULLIF(LAG(trzby_mil_eur) OVER (ORDER BY rok), 0)) <
            ((mzdy_zamestnancov - LAG(mzdy_zamestnancov) OVER (ORDER BY rok)) / NULLIF(LAG(mzdy_zamestnancov) OVER (ORDER BY rok), 0))
        THEN 'Rast miezd predbehol rast tržieb (Tlak na osobné náklady)'
        
        ELSE 'Vyrovnaný medziročný vývoj'
    END AS hodnotenie_mzdoveho_vyvoja

FROM financie_mzdy
ORDER BY rok ASC;

--- Aktualizácia tabuľky pre kraje
-- 1. Pridanie nových stĺpcov do krajskej tabuľky
ALTER TABLE zssk_kraje_pdo 
ADD COLUMN pocet_stanic INT,
ADD COLUMN pocet_zastavok INT,
ADD COLUMN pocet_primestskych_vlakov_denne INT;

-- 2. Naplnenie dátami pre jednotlivé kraje
UPDATE zssk_kraje_pdo SET pocet_stanic = 22, pocet_zastavok = 28, pocet_primestskych_vlakov_denne = 80 WHERE kraj = 'Bratislavský';
UPDATE zssk_kraje_pdo SET pocet_stanic = 35, pocet_zastavok = 45, pocet_primestskych_vlakov_denne = 48 WHERE kraj = 'Trnavský';
UPDATE zssk_kraje_pdo SET pocet_stanic = 32, pocet_zastavok = 50, pocet_primestskych_vlakov_denne = 42 WHERE kraj = 'Trenčiansky';
UPDATE zssk_kraje_pdo SET pocet_stanic = 40, pocet_zastavok = 65, pocet_primestskych_vlakov_denne = 36 WHERE kraj = 'Nitriansky';
UPDATE zssk_kraje_pdo SET pocet_stanic = 38, pocet_zastavok = 60, pocet_primestskych_vlakov_denne = 55 WHERE kraj = 'Žilinský';
UPDATE zssk_kraje_pdo SET pocet_stanic = 42, pocet_zastavok = 85, pocet_primestskych_vlakov_denne = 32 WHERE kraj = 'Banskobystrický';
UPDATE zssk_kraje_pdo SET pocet_stanic = 30, pocet_zastavok = 55, pocet_primestskych_vlakov_denne = 45 WHERE kraj = 'Prešovský';
UPDATE zssk_kraje_pdo SET pocet_stanic = 45, pocet_zastavok = 70, pocet_primestskych_vlakov_denne = 48 WHERE kraj = 'Košický';

SELECT * FROM zssk_kraje_pdo AS zkp; 

---9. Nasledujú výpočet pre top krajov
WITH kraje_povodny_model AS (
    SELECT 
        zkp.kraj,
        
        -- 1. Základná infraštruktúra a prevádzkové výkony
        MAX(zkp.dlzka_trati_km) AS dlzka_trati_km,
        ROUND(AVG(zkp.priemerny_pocet_vlakov_denne), 0) AS avg_celkovo_vlakov_denne,
        
        -- 2. Vyťaženosť tratí: Priemerný počet vlakov na 1 km trate za deň
        ROUND(
            AVG(zkp.priemerny_pocet_vlakov_denne)::numeric / NULLIF(MAX(zkp.dlzka_trati_km), 0), 2
        ) AS vytazenost_vlaky_na_km,

        -- 3. Emisie CO2 (priemerná ročná úroveň národného indikátora za obdobie 2020–2025)
        ROUND(AVG(dv.emisie_g_co2_per_osobokm), 0) AS avg_emisie_co2_tony

    FROM zssk_kraje_pdo zkp
    JOIN data_vlaky dv ON zkp.rok = dv.rok
    WHERE zkp.rok BETWEEN 2020 AND 2025
    GROUP BY zkp.kraj
)
SELECT 
    -- Pridanie TOP poradia podľa najvyššieho priemerného počtu vlakov
    ROW_NUMBER() OVER (ORDER BY avg_celkovo_vlakov_denne DESC) AS top_poradie,
    kraj,
    avg_celkovo_vlakov_denne,
    vytazenost_vlaky_na_km,
    dlzka_trati_km,
    avg_emisie_co2_tony
FROM kraje_povodny_model
ORDER BY avg_celkovo_vlakov_denne DESC;


WITH kraje_rozsireny_model AS (
    SELECT 
        zkp.kraj,
        
        -- Infraštruktúra kraja
        MAX(zkp.dlzka_trati_km) AS dlzka_trati_km,
        MAX(zkp.pocet_stanic) AS pocet_stanic,
        MAX(zkp.pocet_zastavok) AS pocet_zastavok,
        (MAX(zkp.pocet_stanic) + MAX(zkp.pocet_zastavok)) AS celkovo_bodov_obsluhy,
        
        -- Hustota obslužnosti: Počet staníc + zastávok na 100 km trate
        ROUND(
            ((MAX(zkp.pocet_stanic) + MAX(zkp.pocet_zastavok))::numeric / NULLIF(MAX(zkp.dlzka_trati_km), 0)) * 100.0, 1
        ) AS bodov_obsluhy_na_100km,

        -- Výkony vlakov (prímestské vs. celkovo)
        ROUND(AVG(zkp.pocet_primestskych_vlakov_denne), 0) AS avg_primestskych_vlakov_denne,
        ROUND(AVG(zkp.priemerny_pocet_vlakov_denne), 0) AS avg_celkovo_vlakov_denne,

        -- Vyťaženosť tratí
        ROUND(
            AVG(zkp.priemerny_pocet_vlakov_denne)::numeric / NULLIF(MAX(zkp.dlzka_trati_km), 0), 2
        ) AS vytazenost_vlaky_na_km,

        -- Podiel prímestských vlakov na celkovej prevádzce (%)
        ROUND(
            (AVG(zkp.pocet_primestskych_vlakov_denne)::numeric / NULLIF(AVG(zkp.priemerny_pocet_vlakov_denne), 0)) * 100.0, 2
        ) AS podiel_primestske_pct,

        -- Typológia dopravy
        CASE 
            WHEN (AVG(zkp.pocet_primestskych_vlakov_denne)::numeric / NULLIF(AVG(zkp.priemerny_pocet_vlakov_denne), 0)) >= 0.80 
                THEN 'Dominantne prímestská doprava (Metropolitný uzol)'
            WHEN (AVG(zkp.pocet_primestskych_vlakov_denne)::numeric / NULLIF(AVG(zkp.priemerny_pocet_vlakov_denne), 0)) BETWEEN 0.70 AND 0.79 
                THEN 'Vyvážená prímestská a diaľková doprava'
            ELSE 'Prevaha diaľkovej / regionálnej tranzitnej dopravy'
        END AS typ_dopravy_v_kraji

    FROM zssk_kraje_pdo zkp
    JOIN data_vlaky dv ON zkp.rok = dv.rok
    WHERE zkp.rok BETWEEN 2020 AND 2025
    GROUP BY zkp.kraj
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY avg_celkovo_vlakov_denne DESC) AS top_poradie,
    kraj,
    avg_celkovo_vlakov_denne,
    avg_primestskych_vlakov_denne,
    podiel_primestske_pct,
    vytazenost_vlaky_na_km,
    dlzka_trati_km,
    pocet_stanic,
    pocet_zastavok,
    celkovo_bodov_obsluhy,
    bodov_obsluhy_na_100km,
    typ_dopravy_v_kraji
FROM kraje_rozsireny_model
ORDER BY avg_celkovo_vlakov_denne DESC;