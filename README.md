# Elekani-_SQL_Repozit-r
# Projekt: Analýza miezd, cien potravín a HDP v ČR

Tento projekt sa zaoberá databázovou analýzou vývoja priemerných miezd, cien potravín a hrubého domáceho produktu (HDP) v Českej republike. Obsahuje SQL skripty pre tvorbu primárnych a sekundárnych pohľadov (`VIEWS`), spracovanie časových radov a vyhodnotenie výskumných otázok.

---

## Ciele projektu

- **Vytvorenie databázových pohľadov** prepájajúcich údaje o mzdám, cenách potravín a makroekonomike.
- **Výpočet medziročných percentuálnych zmien** pomocou analytických a agregačných funkcií (`JOIN`, `GROUP BY`, `CASE`, `LAG`, `LEAD`).
- **Analýza kúpnej sily** obyvateľstva v rôznych časových obdobiach.
- **Hodnotenie závislostí** medzi rastom HDP, miezd a cien potravín.

---

## Metodika a riešenie výskumných otázok

### Otázka 2: Porovnanie kúpnej sily (Chlieb vs. Mlieko)
Porovnanie množstva chleba (kg) a mlieka (l), ktoré bolo možné kúpiť za priemernú mzdu v prvom (2006–2012) a poslednom (2012–2018) porovnateľnom období.

| Obdobie | Priemerný počet kg chleba | Priemerný počet l mlieka |
| :--- | :---: | :---: |
| **Prvé obdobie (2006–2012)** | 1 084,4 kg | 1 304,6 l |
| **Posledné obdobie (2012–2018)** | 1 165,0 kg | 1 392,0 l |

> **Záver:** Kúpna sila obyvateľstva pri základných potravinách (chlieb a mlieko) medzi prvým a posledným obdobím mierne vzrástla.

---

### Otázka 3: Potravina s najnižším medziročným nárastom
Pri analýze sa hľadalo **matematické minimum** medziročnej percentuálnej zmeny ceny potravín.

- **Správna odpoveď:** **Kryštálový cukor** s priemernou medziročnou zmenou **−11,5 %** (cena v priemere klesala/zlacňovala).
- **Ošetrenie dátových výnimiek:**
  - `Kapr živý`: Podľa metodiky ČSÚ sa sleduje iba v decembri. Pôvodné pouzitie `LAG(..., 12)` porovnávalo 12 decembrových záznamov (t. j. 12 rokov dozadu), čo skresľovalo výsledok (−57 %). Táto výnimka bola z ročného mesačného porovnania odstránená.
  - `Volatilné potraviny`: Zemiaky, rajčiaky, maslo a papriky vykazovali vysokú výkyvovosť (napr. papriky +90,2 %, zemiaky +61 %). Tieto extrémy boli ponechané, nakoľko odzrkadľujú reálne vplyvy počasia, úrody a trhu.

---

### Otázka 4: Medziročný nárast cien potravín vs. mzdy (> 10 %)
Zisťovalo sa, či existuje rok, v ktorom ceny potravín medziročne vzrástli o viac ako 10 % voči rastu miezd.

> [!NOTE]
> **Úprava agregácie:** Použitie ročného priemeru (`AVG`) naprieč všetkými potravinami za obdobie **2006–2018** ukázalo, že ročná medziročná zmena cien potravín **ani v jednom roku neprekročila hranicu 10 %**.

---

### Otázka 5: Vplyv HDP na mzdy a ceny potravín
Analýza porovnávala súbežnú reakciu (rok $t$) a oneskorenú reakciu (rok $t+1$ pomocou funkcie `LEAD()`).

- **Mzdy:** Preukázali **náznak oneskorenej reakcie** (cca 1 rok) — vyšší rast HDP sa obvykle prejavia výraznejším nárastom miezd v nasledujúcom roku.
- **Ceny potravín:** Nepotvrdili pravidelný vzťah k HDP. Ceny potravín podliehajú vysokej volatilite (počasie, dovoz) a vykazujú skôr štatistickú súvislosť než priamu príčinnú závislosť.

---

## Obmedzenia projektu

- **Pandémia COVID-19 (2020–2021):** Spôsobila výkyvy a pokles miezd v odvetviach ako ubytovanie, stravovanie a kultúra.
- **Surovinové šoky (2016–2017):** Nedostatok surovín na výrobu mliečnych výrobkov viedol k dočasnému nárastu cien mlieka a masla.

---

## Zhrnutie

Projekt poskytol praktické skúsenosti s:
1. Navrhovaním a optimalizáciou relational SQL queries (`JOIN`, `GROUP BY`, `CASE`, window functions).
2. Čistením dát a metodickým spracovaním štatistických výkyvov.
3. Spájaním makroekonomických dát a interpretáciou ekonomických súvislostí.


