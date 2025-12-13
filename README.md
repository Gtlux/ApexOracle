# 🏥 Ligoninės Valdymo Sistema
## Hospital Management System - Oracle APEX

[![Oracle APEX](https://img.shields.io/badge/Oracle%20APEX-22.1.0-red)](https://apex.oracle.com/)
[![Database](https://img.shields.io/badge/Oracle-12c%2B-blue)](https://www.oracle.com/database/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Išsami ligoninės valdymo sistema sukurta naudojant Oracle APEX 22.1.0 platformą. Sistema apima 15 esybių su pilnai implementuotais ryšiais, verslo logika, triggeriais ir views.

---

## 📋 Turinys

- [Apžvalga](#apžvalga)
- [Funkcionalumas](#funkcionalumas)
- [Duomenų Bazės Schema](#duomenų-bazės-schema)
- [Diegimo Instrukcijos](#diegimo-instrukcijos)
- [Projekto Struktūra](#projekto-struktūra)
- [Dokumentacija](#dokumentacija)
- [Technologijos](#technologijos)

---

## 🎯 Apžvalga

Ligoninės valdymo sistema yra kompleksinis sprendimas, skirtas ligoninių operacijų valdymui. Sistema palaiko:

- **Pacientų valdymą** - registracija, medicininė istorija, hospitalizacijos
- **Personalo valdymą** - gydytojai, seserys, darbuotojų grafikai
- **Skyrių valdymą** - skyriai, palatai, lovų užimtumas
- **Medicininę informaciją** - diagnozės, receptai, laboratoriniai tyrimai
- **Finansų valdymą** - sąskaitos, mokėjimai, ataskaitos

---

## ✨ Funkcionalumas

### 👥 Pacientų Modulis
- ✅ Pacientų registracija ir profilių valdymas
- ✅ Vizitų planavimas pas gydytojus
- ✅ Hospitalizacijos valdymas
- ✅ Medicininė istorija ir diagnozės
- ✅ Receptų valdymas
- ✅ Laboratorinių tyrimų sekimas

### 👨‍⚕️ Personalo Modulis
- ✅ Gydytojų ir seserų registras
- ✅ Specializacijų ir licencijų valdymas
- ✅ Darbuotojų grafikų planavimas
- ✅ Gydytojų konsultacijų mokesčiai

### 🏥 Skyrių Modulis
- ✅ Skyrių hierarchija ir valdymas
- ✅ Palatų ir lovų valdymas
- ✅ Real-time lovų užimtumo sekimas
- ✅ Skyriaus budžeto kontrolė

### 💊 Medicinos Modulis
- ✅ Standartizuotas diagnozių katalogas (ICD-10 tipo)
- ✅ Vaistų katalogas ir atsargų valdymas
- ✅ Receptų išrašymas ir sekimas
- ✅ Laboratorinių tyrimų užsakymas ir rezultatai
- ✅ Automatinis atsargų mažinimas

### 💰 Finansų Modulis
- ✅ Automatinis sąskaitų generavimas
- ✅ Mokėjimų priėmimas (grynieji, kortelė, draudimas)
- ✅ Nepamokėtų sąskaitų sekimas
- ✅ Pajamų ataskaitos ir statistika
- ✅ Nuolaidų ir mokesčių valdymas

### ⚙️ Administravimo Modulis
- ✅ Vartotojų vaidmenų valdymas
- ✅ Audit trail visoms pakeitimams
- ✅ Stock alerts žemoms atsargoms
- ✅ Sistemos nustatymai

---

## 🗄️ Duomenų Bazės Schema

### Esybių Sąrašas (15 lentelių)

#### Organizacinės Esybės
1. **DEPARTMENTS** - Ligoninės skyriai (Kardiologija, Chirurgija, etc.)
2. **ROOMS** - Palatai kiekviename skyriuje
3. **BEDS** - Lovos kiekvienoje palatoje

#### Personalo Esybės
4. **EMPLOYEES** - Visi darbuotojai (bazinė lentelė)
5. **DOCTORS** - Gydytojai (paveldi iš EMPLOYEES)
6. **NURSES** - Medicinos seserys (paveldi iš EMPLOYEES)

#### Pacientų Esybės
7. **PATIENTS** - Pacientų registras
8. **APPOINTMENTS** - Vizitai pas gydytojus
9. **ADMISSIONS** - Hospitalizacijos

#### Medicininės Esybės
10. **DIAGNOSES** - Diagnozių katalogas
11. **PATIENT_DIAGNOSES** - Pacientų diagnozės
12. **MEDICATIONS** - Vaistų katalogas
13. **PRESCRIPTIONS** - Receptai
14. **LAB_TESTS** - Laboratoriniai tyrimai

#### Finansinės Esybės
15. **BILLS** - Sąskaitos

### Ryšių Statistika
- **1:N ryšiai:** 21
- **Paveldėjimo ryšiai:** 2
- **Foreign Keys:** 23
- **Check Constraints:** 45+
- **Unique Constraints:** 12
- **Indexes:** 50+

---

## 🚀 Diegimo Instrukcijos

### Sisteminiai Reikalavimai
- Oracle Database 12c ar naujesnė
- Oracle APEX 22.1.0 ar naujesnė
- SQL*Plus arba SQL Developer
- Workspace su Developer privilegijomis

### Žingsnis po Žingsnio

#### 1. Duomenų Bazės Schema

Vykdykite SQL scriptus **būtina tvarka**:

```bash
# 1. Sukurti lenteles
sqlplus username/password@database @database/schema/01_create_tables.sql

# 2. Sukurti triggerius
sqlplus username/password@database @database/schema/02_create_triggers.sql

# 3. Sukurti views
sqlplus username/password@database @database/schema/03_create_views.sql

# 4. (Opcionalu) Įterpti pavyzdinius duomenis
sqlplus username/password@database @database/sample_data/04_insert_sample_data.sql
```

#### 2. Patikrinkite Diegimą

```sql
-- Patikrinkite ar visos lentelės sukurtos
SELECT 'Lentelės: ' || COUNT(*) FROM user_tables
WHERE table_name IN (
    'DEPARTMENTS', 'ROOMS', 'BEDS', 'EMPLOYEES', 'DOCTORS', 'NURSES',
    'PATIENTS', 'APPOINTMENTS', 'ADMISSIONS', 'DIAGNOSES',
    'PATIENT_DIAGNOSES', 'MEDICATIONS', 'PRESCRIPTIONS',
    'LAB_TESTS', 'BILLS'
);
-- Rezultatas: Lentelės: 15

-- Patikrinkite triggerius
SELECT 'Triggeriai: ' || COUNT(*) FROM user_triggers
WHERE table_name IN (SELECT table_name FROM user_tables);
-- Rezultatas: ~20 triggerių

-- Patikrinkite views
SELECT 'Views: ' || COUNT(*) FROM user_views
WHERE view_name LIKE 'V_%';
-- Rezultatas: ~15 views
```

#### 3. APEX Aplikacijos Kūrimas

Galite:

**Variantas A:** Importuoti paruoštą aplikaciją (jei turite export failą)
```
1. APEX Workspace → App Builder → Import
2. Pasirinkite .sql failą
3. Install Application
```

**Variantas B:** Sukurti rankiniu būdu
1. Naudokite dokumentaciją: `database/documentation/APEX_PAGES_MAPPING.md`
2. Sekite puslapių specifikacijas ir SQL queries
3. Konfigūruokite Authorization Schemes
4. Sukurkite LOV (List of Values)

#### 4. Vartotojų Konfigūracija

```sql
-- Sukurti vartotojų grupes (APEX Admin)
BEGIN
    apex_util.create_user_group(
        p_group_name => 'ADMIN',
        p_group_desc => 'Administratoriai'
    );
    apex_util.create_user_group(
        p_group_name => 'DOCTOR',
        p_group_desc => 'Gydytojai'
    );
    apex_util.create_user_group(
        p_group_name => 'NURSE',
        p_group_desc => 'Medicinos seserys'
    );
    apex_util.create_user_group(
        p_group_name => 'BILLING',
        p_group_desc => 'Buhalterija'
    );
END;
/
```

---

## 📁 Projekto Struktūra

```
ApexOracle/
├── README.md                           # Šis failas
├── database/
│   ├── schema/                         # DDL Scripts
│   │   ├── 01_create_tables.sql       # Lentelės, FK, Constraints
│   │   ├── 02_create_triggers.sql     # Triggeriai ir verslo logika
│   │   └── 03_create_views.sql        # Views APEX reports
│   │
│   ├── sample_data/                    # Testiniai duomenys
│   │   └── 04_insert_sample_data.sql  # 10 pacientų, 6 gydytojai, etc.
│   │
│   ├── documentation/                  # Dokumentacija
│   │   ├── KONCEPTUALUS_MODELIS.md    # Esybės, ryšiai, logika
│   │   └── APEX_PAGES_MAPPING.md      # APEX puslapių specifikacijos
│   │
│   └── diagrams/                       # ERD diagramos
│       └── ERD_DIAGRAM_GUIDE.md       # PowerDesigner instrukcijos
│
└── .git/                               # Git repository
```

---

## 📚 Dokumentacija

### Pagrindiniai Dokumentai

1. **[Konceptualus Modelis](database/documentation/KONCEPTUALUS_MODELIS.md)**
   - Visos 15 esybių su detaliais aprašymais
   - Ryšių diagrama ir kardinalumai
   - Verslo taisyklės ir validacijos
   - APEX aplikacijos struktūra
   - Duomenų srautai ir scenarijai

2. **[ERD Diagrama](database/diagrams/ERD_DIAGRAM_GUIDE.md)**
   - PowerDesigner importavimo instrukcijos
   - Detali ERD schema su ryšiais
   - Spalvinis kodavimas
   - Entity attributes summary
   - Normalizacijos lygis (3NF)

3. **[APEX Puslapių Mapping](database/documentation/APEX_PAGES_MAPPING.md)**
   - Visų 50+ puslapių specifikacijos
   - SQL queries kiekvienam puslapiui
   - Form validacijos ir procesai
   - Authorization schemes
   - Dynamic actions ir LOVs

### SQL Failai

| Failas | Aprašymas | Elementai |
|--------|-----------|-----------|
| `01_create_tables.sql` | DDL lentelių kūrimui | 15 lentelių, 23 FK, 45+ constraints |
| `02_create_triggers.sql` | Verslo logikos triggeriai | 20+ triggerių, audit trail |
| `03_create_views.sql` | Views APEX reports | 15 views su statistika |
| `04_insert_sample_data.sql` | Testiniai duomenys | 10 pacientų, 6 gydytojai, 14 palatų |

---

## 🛠️ Technologijos

- **Database:** Oracle 12c+
- **Platform:** Oracle APEX 22.1.0
- **Language:** PL/SQL, SQL
- **Design Tool:** PowerDesigner (optional)
- **Version Control:** Git

### Naudojamos Oracle Features
- ✅ Identity Columns (auto-increment)
- ✅ Virtual Columns (computed)
- ✅ Check Constraints
- ✅ Foreign Key Cascades
- ✅ Triggers (BEFORE/AFTER)
- ✅ Views su JOINs
- ✅ CLOB duomenų tipas
- ✅ Date funkcijos

---

## 🔒 Saugumo Ypatybės

### Duomenų Lygmenyje
- Foreign Key Constraints
- Check Constraints
- Unique Constraints
- NOT NULL validacijos

### Verslo Logikos Lygmenyje (Triggers)
- Vienas pacientas = vienas aktyvus priėmimas
- Viena lova = vienas pacientas vienu metu
- Gydytojas negali turėti sutampančių vizitų
- Automatinis stock valdymas

### Aplikacijos Lygmenyje (APEX)
- Role-based authorization
- Row level security (VPD)
- Session management
- Audit logging

---

## 📊 Statistika

### Duomenų Bazė
- **Lentelės:** 15
- **Stulpeliai:** ~180
- **Foreign Keys:** 23
- **Indexes:** 50+
- **Triggers:** 20+
- **Views:** 15
- **LOV:** 10+

### APEX Aplikacija (Planuojama)
- **Puslapiai:** 50+
- **Forms:** 20+
- **Reports:** 25+
- **Charts:** 10+
- **Dashboards:** 5+

### Pavyzdiniai Duomenys
- Skyriai: 6
- Darbuotojai: 10
- Gydytojai: 6
- Seserys: 4
- Palatai: 14
- Lovos: 25
- Pacientai: 10
- Vizitai: 7
- Priėmimai: 5
- Diagnozės: 10
- Vaistai: 10
- Receptai: 6
- Lab testai: 9
- Sąskaitos: 8

---

## 🎨 PowerDesigner Integracija

Sistema pilnai suderinama su PowerDesigner:

1. **Reverse Engineering:**
   ```
   File → Reverse Engineer → Database
   → Select Oracle 12c
   → Connect to database
   → Generate Physical Data Model
   ```

2. **Spalvinis Kodavimas:**
   - 🟦 Mėlyna - Organizacinės esybės
   - 🟩 Žalia - Personalo esybės
   - 🟨 Geltona - Pacientų esybės
   - 🟧 Oranžinė - Medicininės esybės
   - 🟥 Raudona - Finansinės esybės

3. **Export:**
   - PNG/JPG diagramoms
   - PDF dokumentacijai
   - HTML web dokumentacijai
   - Excel duomenų žodynui

---

## 🧪 Testavimas

### Duomenų Validacija

```sql
-- Test 1: Visos lentelės egzistuoja
SELECT COUNT(*) FROM user_tables
WHERE table_name IN ('DEPARTMENTS', 'PATIENTS', 'BILLS', ...);
-- Tikimasi: 15

-- Test 2: Foreign keys veikia
SELECT COUNT(*) FROM user_constraints
WHERE constraint_type = 'R';
-- Tikimasi: 23

-- Test 3: Triggeriai valid
SELECT COUNT(*) FROM user_triggers WHERE status = 'ENABLED';

-- Test 4: Views valid
SELECT COUNT(*) FROM user_views WHERE view_name LIKE 'V_%';
```

### Verslo Logikos Testai

```sql
-- Test 1: Pacientas negali turėti 2 aktyvių priėmimų
-- Bandymas įterpti antrą priėmimą tam pačiam pacientui
-- Tikimasi: ORA-20001 error

-- Test 2: Lova negali būti priskirta 2 pacientams
-- Bandymas įterpti 2 priėmimus su ta pačia lova
-- Tikimasi: ORA-20002 error

-- Test 3: Automatinis bed status atnaujinimas
INSERT INTO admissions (...) VALUES (...);
SELECT bed_status FROM beds WHERE bed_id = X;
-- Tikimasi: 'OCCUPIED'
```

---

## 📞 Palaikymas

Klausimai ar problemos? Sukurkite issue GitHub repository.

---

## 📄 Licencija

MIT License - laisvai naudokite, modifikuokite ir platinkite.

---

## 🙏 Padėkos

- Oracle APEX Team už puikią low-code platformą
- Oracle dokumentacijai už detalius pavyzdžius
- PowerDesigner už ERD modeliavimo įrankius

---

## 🔄 Versijos Istorija

### v1.0 (2025-12-13)
- ✅ Pradinė schema su 15 esybių
- ✅ Visi triggeriai ir verslo logika
- ✅ Views APEX integracijai
- ✅ Pavyzdiniai duomenys
- ✅ Pilna dokumentacija
- ✅ PowerDesigner suderinamumas

---

**Sukurta su ❤️ Oracle APEX ir PL/SQL**
