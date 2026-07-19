# Elekani-_SQL_Repozit-r
Repozitár s projektom pre Engeto
**Autor**
Martin Elekanič
**Zameranie** na zistenie vývoja miezd a cien potravín v Českej Republike počas spoločných rokov 2006 až 2018, vrátane dodatočného materiálu v podobe ďalšej tabuľky o vplyve HDP a iných makroekonomických ukazovateľoch voči populácií ČR a ostatných európskych štátov.                                                            **Prostredie** : Projekt prebiehal v programe Dbeaver Community na výukovej databáze a platforme PostgreSQL. 

**Analýza miezd a cien potravín + Makroekonomické trendy a populácia európskych štátov**
Štruktúra projektu
t_Martin_Elekanič_sql_projekt_primary_final     *Pre vývoj pohybu miezd a cien potravín
t_Martin_Elekanič_sql_projekt_secondary_final   * Pre dodatočný materiál o HDP a iných ukazovateľoch voči populácií štátov Európy

**Výskumné otázky**
1.Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? 
2.Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd? 
3.Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
4.Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5.Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?      

**Odpovede**
**1**.--- Prezrel som výstup tabuľky porovnania miezd odvetví a zistenia píšem nižšie podľa sledovania čísel vývoja mzdy

---Administratíva - nárast
---činnosti v oblasti nemovitostí - nárast
---Doprava a skladování - nárast
---Informační a komunikační činnosti - nárast
--- Kultúrni,zábavní a rekreační činnosti - nárast
--- Ostatní činnosti - nárast
---Penežnictví a pojišťovníctvi - nárast
--- Profesní,vedecké a technické činnosti - nárast
--- Stavebníctví - nárast
--- Težba a dobývání - nárast
--- Ubytování,stravování a pohostinství - nárast
--- Velkoobchod a maloobchod - nárast
---Verejná správa a obrana - nárast
--- Výroba a rozvod elektriny,plynu - nárast
--- Vzdelávání -nárast
--- Zásobování vodou, činnosti s odpady a sanacemi - nárast
--- Zdravotní a sociální péče - nárast
--- Zemedelství,lesníctvi,rybárství - nárast
--- Zpracovatelský prumysl - nárast

--- Takže všetky odvetvia vykazujú nárast miezd

**2.** ---Za celé spoločné merané obdobie rozdelené na dvakrát (6 rokov), bolo možné za priemernú mzdu kúpiť v prvých 6 rokoch(7,59) kilogramov chleba a 9,13 litrov mlieka
--- Počas ďalších 6 rokov (2012 až 2018) sa dalo kúpiť 8,15 kg chleba a 9,74 litrov mlieka, čo predstavuje rozdiel 0,56 kg chleba a 0,61 litra mlieka.

**3.** 
---Najnižší % nárast a teda aj najpomalší nárast z kategórie potravín majú papriky - najbližšia kladná hodnota k 0

**4.** áno, existuje rok - 2008, kedy ceny potravín výrazne medziročne narástli oproti mzdám, konkrétne o 13,87 %. Treba povedať, že väčším či menším nárastom cez 10% sa vyznačujú aj roky 2017 a 2018 (12,28 a 10,6%)

**5.** 
Nepotvrdilo sa jednoznačne, že by malo HDP vplyv na zmenu ceny potraviny či výšky mzdy. Pri väčšine rokov vidno síce väčší či menší pohyb, ale nedá sa to generalizovať. Otázku potvrdzuje medziročne rok 2017, kedy mzdy dosiahli až 6,8% a a ceny stúpli výraznejšie až na 7,3%. Samotné HDP zostáva na stabilnej hodnote a nepreukazuje markantný pohyb.




**Primárne tabuľky,z ktorých sa vychádzalo**
czechia_price, czechia_price_category
czechia_payroll, czechia_payroll_unit, czechia_payroll_value_type, czechia_payroll_calculation, czechia_payroll_industry_branch
countries
economies

**Informácia o chýbajúcich hodnotách**
Pri zisťovaní údajov o ekonomikách štátov som si všimol, že Viacerým štátom chýbajú dáta pri koeficiente gini
 Faerské ostrovy nemajú dáta pre hdp medzi rokmi 2011 až 2018
 A Gibraltár dokonca vôbec, Lichtenštajnsko trochu postráda gdp dáta

**Informácia o hodnotách null**
Prítomnosť NULL hodnôt v mojich Views nie je chybou dopytu, ale korektným zobrazením reality zdrojových dát. Dáta pochádzajú z rôznych zdrojov s rôznym časovým pokrytím (mzdy 2000–2021 vs. ceny 2006–2018). Použitie NULL hodnôt namiesto ich umelého vymazania (cez INNER JOIN)  umožnilo zachovať kompletný prehľad o vývoji miezd aj v rokoch, kedy sa ceny potravín ešte nesledovali. Pri interpretácii konkrétnych otázok tieto NULL hodnoty  filtrujem priamo v dopytoch. Dáta náražajú na špcifickú granularitu priemyselných odvetví, čo znamená, že ceny potravín sú naviazané na Spracovateľský priemysel. Keďže ostatných 18 odvetví (napr. Informační technologie, Penežníctvo stavebnictví) tieto potraviny nevyrába, stĺpce s cenami potravín a prepočtom kúpnej sily pre ne zostávajú NULL, čo je metodicky správne. Čo sa týka použitia joinov, použitie LEFT JOIN  bolo zámerné, aby sa nestratili informácie o mzdách v iných odvetviach a rokoch, aj keď pre ne nie sú údaje o cenách potravín. Ak by sa použil INNER JOIN, databáza by odfiltrovala všetky roky mimo 2006–2018 a všetky odvetvia okrem spracovateľského priemyslu, čím by sa prišlo o dôležitý kontext vývoja miezd




**Zodpovedajúce výsledné tabuľky****Views**
1. Vývoj_Miezd
2. konečný_prehľad_množstva
3. yoy_avg_food
4. ceny_mzdy_rok
5. rast_miezd_rok,  analyza_hdp
6. europe_data (pre doplňujúci materiál o ekonomike ostatných štátov Európy)


**Technológie**
Dbeaver Community, PostgreSQL
