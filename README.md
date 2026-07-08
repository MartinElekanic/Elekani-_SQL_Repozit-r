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

**Primárne tabuľky,z ktorých sa vychádzalo**
czechia_price, czechia_price_category
czechia_payroll, czechia_payroll_unit, czechia_payroll_value_type, czechia_payroll_calculation, czechia_payroll_industry_branch
countries
economies

**Informácia o chýbajúcich hodnotách**
Pri zisťovaní údajov o ekonomikách štátov som si všimol, že Viacerým štátom chýbajú dáta pri koeficiente gini
 Faerské ostrovy nemajú dáta pre hdp medzi rokmi 2011 až 2018
 A Gibraltár dokonca vôbec, Lichtenštajnsko trochu postráda gdp dáta



**Zodpovedajúce výsledné tabuľky**
1. Cte_Vývoj_Miezd
2. konečný_prehľad_množstva
3. yoy_avg_food
4. ceny_mzdy_rok
5. rast_miezd_rok,  analyza_hdp
6. europe_data


**Technológie**
Dbeaver Community, PostgreSQL
