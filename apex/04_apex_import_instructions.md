# ORACLE APEX APLIKACIJOS IMPORT INSTRUKCIJOS
## Ligoninės Valdymo Sistema

**Versija:** 1.0
**APEX Version:** 22.1.0
**Aplikacijos ID:** 100

---

## TURINYS

1. [Prieš Pradedant](#prieš-pradedant)
2. [Duomenų Bazės Paruošimas](#duomenų-bazės-paruošimas)
3. [Workspace Sukūrimas](#workspace-sukūrimas)
4. [Aplikacijos Kūrimo Metodai](#aplikacijos-kūrimo-metodai)
5. [Žingsnis po Žingsnio Instrukcijos](#žingsnis-po-žingsnio-instrukcijos)
6. [Post-Import Konfigūracija](#post-import-konfigūracija)
7. [Testavimas](#testavimas)
8. [Troubleshooting](#troubleshooting)

---

## PRIEŠ PRADEDANT

### Sisteminiai Reikalavimai

- ✅ Oracle Database 12c ar naujesnė
- ✅ Oracle APEX 22.1.0 ar naujesnė
- ✅ SQL*Plus arba SQL Developer
- ✅ Web naršyklė (Chrome, Firefox, Edge)
- ✅ Prieiga prie Oracle APEX workspace
- ✅ Schema su Developer privilegijomis

### Reikalingi Failai

```
ApexOracle/
├── database/
│   ├── schema/
│   │   ├── 01_create_tables.sql        ✅ Lentelės
│   │   ├── 02_create_triggers.sql      ✅ Triggeriai
│   │   └── 03_create_views.sql         ✅ Views
│   └── sample_data/
│       └── 04_insert_sample_data.sql   ✅ Testiniai duomenys
├── apex/
│   ├── 01_create_apex_application.sql  ✅ Helper funkcijos
│   ├── 02_create_lovs.sql              ✅ LOV aprašymai
│   ├── 03_apex_pages_complete_guide.md ✅ Puslapių specifikacijos
│   └── 04_apex_import_instructions.md  ✅ Šis failas
```

---

## DUOMENŲ BAZĖS PARUOŠIMAS

### 1. Sukurti Schema (jei dar nėra)

```sql
-- Prisijunkite kaip SYSTEM arba DBA
sqlplus system/password@database

-- Sukurkite naują schemą (arba naudokite esamą)
CREATE USER hospital_db IDENTIFIED BY "StrongPassword123!";

-- Suteikite privilegijas
GRANT CONNECT, RESOURCE TO hospital_db;
GRANT CREATE VIEW TO hospital_db;
GRANT CREATE TRIGGER TO hospital_db;
GRANT CREATE SEQUENCE TO hospital_db;
GRANT UNLIMITED TABLESPACE TO hospital_db;

-- APEX workspace privilegijos
GRANT APEX_ADMINISTRATOR_ROLE TO hospital_db;
```

### 2. Paleisti DDL Scriptus

**Tvarka yra labai svarbi!**

```bash
# Prisijunkite kaip hospital_db
sqlplus hospital_db/StrongPassword123!@database

# 1. Sukurti lenteles
@/path/to/ApexOracle/database/schema/01_create_tables.sql

# 2. Sukurti triggerius
@/path/to/ApexOracle/database/schema/02_create_triggers.sql

# 3. Sukurti views
@/path/to/ApexOracle/database/schema/03_create_views.sql

# 4. (Optional) Įterpti testus duomenis
@/path/to/ApexOracle/database/sample_data/04_insert_sample_data.sql

# 5. Helper funkcijos APEX
@/path/to/ApexOracle/apex/01_create_apex_application.sql
```

### 3. Patikrinti Diegimą

```sql
-- Patikrinkite lenteles (turi būti 15)
SELECT COUNT(*) FROM user_tables
WHERE table_name IN (
    'DEPARTMENTS', 'ROOMS', 'BEDS', 'EMPLOYEES', 'DOCTORS', 'NURSES',
    'PATIENTS', 'APPOINTMENTS', 'ADMISSIONS', 'DIAGNOSES',
    'PATIENT_DIAGNOSES', 'MEDICATIONS', 'PRESCRIPTIONS',
    'LAB_TESTS', 'BILLS'
);
-- Expected: 15

-- Patikrinkite triggerius (turėtų būti ~20)
SELECT COUNT(*) FROM user_triggers WHERE status = 'ENABLED';

-- Patikrinkite views (turėtų būti ~15)
SELECT COUNT(*) FROM user_views WHERE view_name LIKE 'V_%';

-- Patikrinkite duomenis (jei paleido sample_data)
SELECT 'Patients: ' || COUNT(*) FROM patients
UNION ALL SELECT 'Doctors: ' || COUNT(*) FROM doctors
UNION ALL SELECT 'Departments: ' || COUNT(*) FROM departments;
```

---

## WORKSPACE SUKŪRIMAS

### Variantas A: Naudoti Esamą Workspace

Jei jau turite APEX workspace:
1. Prisijunkite į workspace
2. Užtikrinkite, kad workspace naudoja `hospital_db` schemą
3. Pereikite prie [Aplikacijos Kūrimo](#aplikacijos-kūrimo-metodai)

### Variantas B: Sukurti Naują Workspace

#### Per APEX Administration

1. Prisijunkite į **APEX Administration**
   ```
   URL: https://your-server:port/apex/apex_admin
   ```

2. **Create Workspace**
   - Workspace Name: `HOSPITAL_WORKSPACE`
   - Workspace ID: (auto-generated)

3. **Identify Schema**
   - Schema Name: `HOSPITAL_DB`
   - Password: (your schema password)

4. **Identify Administrator**
   - Username: `ADMIN`
   - Email: `admin@hospital.lt`
   - Password: (choose strong password)

5. Click **Create Workspace**

#### Per SQL*Plus

```sql
BEGIN
    APEX_INSTANCE_ADMIN.ADD_WORKSPACE(
        p_workspace_id   => NULL,
        p_workspace      => 'HOSPITAL_WORKSPACE',
        p_primary_schema => 'HOSPITAL_DB'
    );

    APEX_UTIL.SET_WORKSPACE(
        p_workspace => 'HOSPITAL_WORKSPACE'
    );

    APEX_UTIL.CREATE_USER(
        p_user_name                    => 'ADMIN',
        p_email_address                => 'admin@hospital.lt',
        p_web_password                 => 'AdminPassword123!',
        p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
        p_change_password_on_first_use => 'N'
    );

    COMMIT;
END;
/
```

---

## APLIKACIJOS KŪRIMO METODAI

### METODAS 1: Rankinė Kūrimas (Rekomenduojama Mokymui)

**Pranašumai:**
- Pilnas kontrolė
- Geriau suprasite struktūrą
- Galite pritaikyti pagal poreikius

**Laikas:** ~4-6 valandos

**Instrukcijos:** Sekite [Žingsnis po Žingsnio](#žingsnis-po-žingsnio-instrukcijos)

---

### METODAS 2: SQL Workshop Script (Greitesnis)

**Pranašumai:**
- Greitesnis nei rankinė kūrimas
- Automatizuoja LOV kūrimą
- Galima modifikuoti prieš paleidimą

**Laikas:** ~1-2 valandos

#### Žingsniai:

1. **Prisijunkite į APEX Builder**
   ```
   URL: https://your-server:port/apex
   Workspace: HOSPITAL_WORKSPACE
   Username: ADMIN
   Password: (your password)
   ```

2. **SQL Workshop → SQL Scripts**

3. **Upload arba Create New Script**
   - Name: `create_apex_app`
   - Paste contents from `apex/01_create_apex_application.sql`
   - Run Script

4. **Sukurti Aplikaciją per Create Application Wizard**
   - Go to: **App Builder → Create**
   - Name: `Ligoninės Valdymo Sistema`
   - ID: 100
   - Appearance: Universal Theme (42)
   - Features: Select None (sukursime rankiniu būdu)

5. **Shared Components → List of Values**
   - Follow `apex/02_create_lovs.sql` instructions
   - Create all 30 LOVs

6. **Create Pages**
   - Follow `apex/03_apex_pages_complete_guide.md`
   - Start with critical pages: 1, 101, 102, 103, 105, 501

---

## ŽINGSNIS PO ŽINGSNIO INSTRUKCIJOS

### 1. SUKURTI APLIKACIJĄ

**App Builder → Create → New Application**

**Application Settings:**
```
Name: Ligoninės Valdymo Sistema
ID: 100
Alias: HOSPITAL_MGMT
Schema: HOSPITAL_DB
Theme: Universal Theme (42)
```

**Features to Include (First Time):**
- ✅ Home Page
- ❌ Do NOT use wizards (sukursime rankiniu būdu)

Click **Create Application**

---

### 2. KONFIGŪRUOTI SHARED COMPONENTS

#### 2.1 Application Items

**Shared Components → Application Items → Create**

Sukurti šiuos items:
- `APP_USER_ID` (NUMBER)
- `APP_USER_ROLE` (VARCHAR2)
- `APP_USER_DOCTOR_ID` (NUMBER)
- `APP_USER_DEPARTMENT_ID` (NUMBER)
- `APP_CURRENT_DATE` (VARCHAR2)

#### 2.2 Application Process (Initialization)

**Shared Components → Application Processes → Create**

```
Name: SET_USER_INFO
Point: On New Instance (new session)
Type: PL/SQL Code
```

```sql
BEGIN
    -- Set user info based on APEX username
    :APP_USER_ID := get_employee_id_by_username(:APP_USER);

    IF :APP_USER_ID IS NOT NULL THEN
        :APP_USER_ROLE := get_user_role(:APP_USER_ID);

        -- If doctor, set doctor_id
        IF :APP_USER_ROLE = 'DOCTOR' THEN
            :APP_USER_DOCTOR_ID := :APP_USER_ID;

            -- Get department
            BEGIN
                SELECT department_id INTO :APP_USER_DEPARTMENT_ID
                FROM doctors
                WHERE doctor_id = :APP_USER_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
        END IF;
    ELSE
        -- Default values for testing
        :APP_USER_ROLE := 'ADMIN';
    END IF;

    :APP_CURRENT_DATE := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
EXCEPTION
    WHEN OTHERS THEN
        :APP_USER_ROLE := 'ADMIN';
END;
```

#### 2.3 Authorization Schemes

**Shared Components → Authorization Schemes → Create**

**1. IS_AUTHENTICATED**
```
Name: IS_AUTHENTICATED
Type: Exists SQL Query
SQL: SELECT 1 FROM dual WHERE :APP_USER IS NOT NULL
```

**2. IS_ADMIN**
```
Name: IS_ADMIN
Type: PL/SQL Function Body
PL/SQL: RETURN :APP_USER_ROLE = 'ADMIN';
```

**3. IS_DOCTOR**
```
Name: IS_DOCTOR
Type: PL/SQL Function Body
PL/SQL: RETURN :APP_USER_ROLE IN ('DOCTOR', 'ADMIN');
```

**4. IS_MEDICAL_STAFF**
```
Name: IS_MEDICAL_STAFF
Type: PL/SQL Function Body
PL/SQL: RETURN :APP_USER_ROLE IN ('DOCTOR', 'NURSE', 'ADMIN');
```

**5. IS_BILLING**
```
Name: IS_BILLING
Type: PL/SQL Function Body
PL/SQL: RETURN :APP_USER_ROLE IN ('BILLING', 'ADMIN');
```

---

### 3. SUKURTI LIST OF VALUES (LOV)

**Shared Components → List of Values → Create**

Sukurkite visus LOV pagal `apex/02_create_lovs.sql`.

**Prioritetiniai LOV (privalomi):**

1. **LOV_GENDER** (Static)
   ```
   STATIC2:Vyras;M,Moteris;F,Kita;O
   ```

2. **LOV_BLOOD_TYPE** (Static)
   ```
   STATIC2:A+;A+,A-;A-,B+;B+,B-;B-,AB+;AB+,AB-;AB-,O+;O+,O-;O-
   ```

3. **LOV_DEPARTMENTS** (Dynamic)
   ```sql
   SELECT department_name AS d, department_id AS r
   FROM departments
   WHERE is_active = 'Y'
   ORDER BY department_name
   ```

4. **LOV_DOCTORS** (Dynamic)
   ```sql
   SELECT e.first_name || ' ' || e.last_name || ' (' || d.specialization || ')' AS d,
          d.doctor_id AS r
   FROM doctors d
   JOIN employees e ON d.doctor_id = e.employee_id
   WHERE e.employment_status = 'ACTIVE'
   ORDER BY e.last_name, e.first_name
   ```

5. **LOV_PATIENTS** (Dynamic - Popup)
   ```sql
   SELECT p.patient_id AS r,
          p.first_name || ' ' || p.last_name || ' (' ||
          TO_CHAR(p.date_of_birth, 'YYYY-MM-DD') || ')' AS d,
          p.insurance_number AS desc
   FROM patients p
   WHERE p.is_active = 'Y'
     AND (UPPER(p.first_name || ' ' || p.last_name) LIKE '%' || UPPER(:APEX$SEARCH_TERM) || '%'
          OR p.insurance_number LIKE '%' || :APEX$SEARCH_TERM || '%')
   ORDER BY p.last_name, p.first_name
   FETCH FIRST 50 ROWS ONLY
   ```

**Sukurkite visus 30 LOV iš `02_create_lovs.sql`!**

---

### 4. SUKURTI NAVIGATION MENU

**Shared Components → Navigation Menu → Desktop Navigation Menu**

**Edit Menu Structure:**

```
Home (Page 1)

Pacientai (List Entry - no page)
├─ Pacientų Registras (Page 101)
├─ Naujas Pacientas (Page 102)
├─ Vizitų Kalendorius (Page 105)

Personalas (List Entry - no page)
├─ Gydytojai (Page 201)
├─ Darbuotojai (Page 205)

Skyriai (List Entry - no page)
├─ Skyrių Valdymas (Page 301)
├─ Palatų Valdymas (Page 302)
├─ Lovų Užimtumas (Page 303)

Medicina (List Entry - no page)
├─ Diagnozės (Page 401)
├─ Receptai (Page 405)
├─ Vaistai (Page 406)
├─ Lab Tyrimai (Page 408)

Finansai (List Entry - no page)
├─ Sąskaitos (Page 501)
├─ Mokėjimai (Page 502)
```

---

### 5. SUKURTI PUSLAPIUS

#### 5.1 Page 1 - Dashboard

**Create → Page → Blank Page**

```
Page Number: 1
Name: Pagrindinis
Page Mode: Normal
Breadcrumb: Do not use breadcrumbs
Navigation: Use Standard Navigation
```

**Add Regions:**

**Region 1: KPI Cards**
- Type: Cards
- Source: SQL Query (from guide)
- Template: Standard

**Region 2: Šiandien Vizitai**
- Type: Interactive Report
- Source: `v_appointments_calendar`
- WHERE clause: `appointment_date = TRUNC(SYSDATE)`

#### 5.2 Page 101 - Pacientų Registras ✅ REQ 3

**Create → Page → Interactive Report**

```
Page Number: 101
Name: Pacientų Registras
Table/View: V_PATIENTS_FULL
Include Form: No (sukursime atskirai)
```

**Page Items (Filters):**
- P101_CITY (Select List - Dynamic LOV)
- P101_GENDER (Select List - LOV_GENDER)
- P101_BLOOD_TYPE (Select List - LOV_BLOOD_TYPE)
- P101_ADMITTED_ONLY (Checkbox)

**Interactive Report WHERE Clause:**
```sql
(:P101_CITY IS NULL OR city = :P101_CITY)
AND (:P101_GENDER IS NULL OR gender = :P101_GENDER)
AND (:P101_BLOOD_TYPE IS NULL OR blood_type = :P101_BLOOD_TYPE)
AND (:P101_ADMITTED_ONLY IS NULL OR
     (currently_admitted = 'Y' AND :P101_ADMITTED_ONLY = 'Y'))
```

**Button: Naujas Pacientas**
- Position: Next
- Target: Page 102
- Behavior: Redirect to Page
- Clear Cache: 102

**Link Column: Profilis**
- Type: Link
- Target: Page 103
- Set Items: P103_PATIENT_ID = #PATIENT_ID#

#### 5.3 Page 102 - Paciento Forma ✅ REQ 3 (CRUD)

**Create → Page → Form**

```
Page Number: 102
Name: Paciento Forma
Table: PATIENTS
Primary Key: PATIENT_ID
Mode: Modal Dialog
```

**Form Items:**

Sukurkite visus items iš `03_apex_pages_complete_guide.md` Page 102 section.

**Key Items:**
- P102_FIRST_NAME (Required)
- P102_LAST_NAME (Required)
- P102_DATE_OF_BIRTH (Date Picker, Required)
- P102_GENDER (Radio Group - LOV_GENDER, Required)
- P102_BLOOD_TYPE (Select List - LOV_BLOOD_TYPE)
- P102_PHONE_NUMBER (Required, Format Mask)
- P102_EMAIL (Email validation)

**Validations:**
- Email format
- Date not in future
- Phone format

#### 5.4 Page 103 - Paciento Profilis ✅ REQ 5 (Master-Detail)

**Create → Page → Blank Page**

```
Page Number: 103
Name: Paciento Profilis
Page Mode: Normal
```

**Layout:** Two Column (Master on Left, Details on Right)

**Master Region:**
- Type: Display Only (from v_patients_full)
- WHERE: patient_id = :P103_PATIENT_ID

**Detail Regions (Tabs):**
1. Vizitai (Interactive Report from v_appointments_calendar)
2. Hospitalizacijos (IR from v_admissions_current)
3. Diagnozės (Interactive Grid from patient_diagnoses)
4. Receptai (IR from v_prescriptions_full)
5. Lab Tyrimai (IR from v_lab_tests_full)
6. Sąskaitos (IR from v_bills_detailed)

**Master-Detail Mode: Side by Side** (NOT Stacked - pagal reikalavimą!)

#### 5.5 Page 105 - Vizitų Kalendorius ✅ REQ 6

**Create → Page → Calendar**

```
Page Number: 105
Name: Vizitų Kalendorius
Table/View: V_APPOINTMENTS_CALENDAR
Display Column: DISPLAY_TEXT
Start Date: APPOINTMENT_DATETIME
End Date: APPOINTMENT_DATETIME + (DURATION_MINUTES/1440)
Primary Key: APPOINTMENT_ID
```

**Calendar Settings:**
- View: Month
- Drag and Drop: Enabled
- Create/Edit Link: Page 106 (Modal Dialog)

**Drag & Drop Process:**
```sql
UPDATE appointments
SET appointment_date = TRUNC(:APEX$NEW_START_DATE),
    appointment_time = TO_CHAR(:APEX$NEW_START_DATE, 'HH24:MI')
WHERE appointment_id = :APEX$PK_VALUE;
```

#### 5.6 Page 501 - Sąskaitų Registras ✅ REQ 4 (VIEW)

**Create → Page → Interactive Report**

```
Page Number: 501
Name: Sąskaitų Registras
Table/View: V_BILLS_DETAILED (VIEW su JOIN!)
```

**Filters:**
- P501_PAYMENT_STATUS (Select List - LOV_PAYMENT_STATUS)
- P501_PATIENT_ID (Popup LOV - LOV_PATIENTS)
- P501_DATE_FROM, P501_DATE_TO (Date Range)
- P501_OVERDUE_ONLY (Checkbox)

**Aggregates:**
- SUM(total_amount)
- SUM(paid_amount)
- SUM(balance)

**Conditional Formatting:**
- payment_status = 'OVERDUE' → Red row

---

### 6. PRIDĖTI KITUS PUSLAPIUS

Sekite `03_apex_pages_complete_guide.md` instrukcijas ir sukurkite:

**Priority Pages:**
- Page 201 - Gydytojų Katalogas (Cards)
- Page 301 - Skyrių Valdymas (IR)
- Page 302 - Palatų Valdymas (Interactive Grid)
- Page 303 - Lovų Užimtumas (Classic Report)
- Page 405 - Receptų Valdymas (IR su daugybe LOV)
- Page 406 - Vaistų Katalogas (Interactive Grid)
- Page 408 - Lab Tyrimai (IR)

**Modal Dialogs:**
- Page 106 - Naujo Vizito Forma
- Page 407 - Naujo Recepto Forma
- Page 502 - Mokėjimo Priėmimas

---

## POST-IMPORT KONFIGŪRACIJA

### 1. Vartotojų Kūrimas

**Workspace Administration → Manage Users and Groups**

**Create Test Users:**

1. **admin** - Administrator
   - Username: admin
   - Email: admin@hospital.lt
   - Password: (strong password)
   - Developer: Yes
   - User Groups: ADMIN

2. **doctor1** - Dr. Jonas Petraitis
   - Username: jonas.petraitis
   - Email: jonas.petraitis@hospital.lt
   - User Groups: DOCTOR

3. **nurse1** - Vida Paulauskienė
   - Username: vida.paulauskiene
   - Email: vida.paulauskiene@hospital.lt
   - User Groups: NURSE

4. **billing1** - Billing User
   - Username: billing
   - Email: billing@hospital.lt
   - User Groups: BILLING

### 2. User Groups

**Create User Groups:**
- ADMIN
- DOCTOR
- NURSE
- BILLING

### 3. Authentication Scheme

**Shared Components → Authentication Schemes**

Naudokite **Application Express Accounts** (default)

### 4. Globalization

**Edit Application Definition → Globalization**

```
Primary Language: Lithuanian (lt)
Date Format: YYYY-MM-DD
Number Format: 999G999G999G990D00
Automatic Time Zone: No
```

---

## TESTAVIMAS

### Test Checklist

#### ✅ Funkciniai Testai

**1. Pacientų modulis:**
- [ ] Sukurti naują pacientą (Page 102)
- [ ] Redaguoti pacientą
- [ ] Filtruoti pacientus pagal miestą, lytį, kraujo grupę (Page 101)
- [ ] Ištrinti pacientą
- [ ] Atidaryti paciento profilį (Page 103)
- [ ] Peržiūrėti visus 6 tabs profiliui

**2. Vizitų kalendorius:**
- [ ] Sukurti naują vizitą (Page 106)
- [ ] Perkelti vizitą drag & drop (Page 105)
- [ ] Redaguoti vizitą
- [ ] Validacija: overlapping appointments

**3. Master-Detail:**
- [ ] Paciento profilis veikia Side by Side
- [ ] Visi 6 tabs rodo duomenis
- [ ] Interactive Grid (Diagnozės) leidžia add/edit/delete

**4. Sąskaitos:**
- [ ] Report rodo duomenis iš VIEW (Page 501)
- [ ] Filtrai veikia (5 filtrai)
- [ ] Priimti mokėjimą (Page 502)
- [ ] Sukurti naują sąskaitą

**5. LOV:**
- [ ] Visi 30 LOV sukurti
- [ ] Static LOV veikia
- [ ] Dynamic LOV veikia
- [ ] CASCADE LOV veikia (priklauso nuo parent)
- [ ] Popup/Autocomplete LOV veikia

#### ✅ Reikalavimų Atitikimas

- [x] **REQ 3:** Interactive Report su filtrais ir CRUD (Page 101, 102)
- [x] **REQ 4:** Report su VIEW (Page 501)
- [x] **REQ 5:** Master-Detail Side by Side (Page 103)
- [x] **REQ 6:** Kalendorius su drag & drop (Page 105)
- [x] **LOV:** 30 LOV (14 static + 16 dynamic)
- [x] **Visos lentelės:** 15/15 panaudotos

#### ✅ Saugumo Testai

- [ ] Authorization schemes veikia
- [ ] Vartotojai mato tik leidžiamus puslapius
- [ ] Validacijos veikia
- [ ] Error messages aiškūs

---

## TROUBLESHOOTING

### Problemos ir Sprendimai

#### 1. "Table or view does not exist"

**Priežastis:** Views nebuvo sukurti arba schema neteisinga

**Sprendimas:**
```sql
-- Patikrinkite ar views egzistuoja
SELECT view_name FROM user_views WHERE view_name LIKE 'V_%';

-- Jei nėra, paleiskite
@database/schema/03_create_views.sql
```

#### 2. LOV negrąžina duomenų

**Priežastis:** SQL Query klaida arba nėra duomenų

**Sprendimas:**
```sql
-- Testuokite SQL Query per SQL Workshop
SELECT * FROM departments WHERE is_active = 'Y';

-- Jei tuščia, įterpkite duomenis
@database/sample_data/04_insert_sample_data.sql
```

#### 3. Trigger klaidos

**Priežastis:** Trigger nevalid arba logika klaida

**Sprendimas:**
```sql
-- Patikrinkite trigger status
SELECT trigger_name, status FROM user_triggers WHERE status = 'INVALID';

-- Recompile
ALTER TRIGGER trigger_name COMPILE;

-- Jei nepavyksta, žiūrėkite errors
SHOW ERRORS TRIGGER trigger_name;
```

#### 4. "ORA-20001: Pacientas jau turi aktyvų priėmimą"

**Priežastis:** Verslo logikos trigger veikia teisingai!

**Sprendimas:** Tai yra EXPECTED behavior. Pacientas negali turėti >1 aktyvaus priėmimo.

#### 5. Calendar drag & drop neveikia

**Priežastis:** Process klaida arba column names neteisingi

**Sprendimas:**
1. Edit Calendar Region
2. Settings → Drag and Drop → Enable
3. Verify Process SQL naudoja :APEX$PK_VALUE ir :APEX$NEW_START_DATE

#### 6. Master-Detail nerodo duomenų

**Priežastis:** P103_PATIENT_ID nenustatytas

**Sprendimas:**
1. Verify link from Page 101 passes patient_id
2. Check Set Items: P103_PATIENT_ID = #PATIENT_ID#

---

## PAPILDOMI RESURSAI

### Dokumentacija
- [Oracle APEX Documentation](https://docs.oracle.com/en/database/oracle/apex/)
- [APEX Community](https://community.oracle.com/apex)
- [SQL Reference](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/)

### Video Tutorial (Recommended)
1. YouTube: "Oracle APEX 22 Tutorial"
2. Oracle Learning Library: APEX Tutorials

### Support
- Issues: GitHub repository
- Email: support@hospital.lt (jūsų)

---

## SUKURTOS APLIKACIJOS EXPORT

### Kaip Export'inti Aplikaciją

**Po sukūrimo galite export'inti:**

1. **App Builder → Export/Import → Export**
2. Select Application: 100
3. File Format: SQL
4. Export Supporting Objects:
   - ✅ Supporting Objects
   - ✅ Install Checks
   - ✅ Build Options
5. Click **Export**
6. Save file: `f100.sql`

**Šį failą galite dalinti su kolegomis!**

### Kaip Import'uoti

1. **App Builder → Import**
2. Select `f100.sql`
3. Import As: Application
4. File Character Set: UTF-8
5. Click **Next** → **Install Application**

---

## TIMELINE

### Greitas Estimate

| Užduotis | Laikas |
|----------|--------|
| DB Schema Setup | 30 min |
| Workspace Setup | 15 min |
| Shared Components (LOV, Auth) | 1 hour |
| Page 1 (Dashboard) | 30 min |
| Page 101, 102 (Patients) | 1 hour |
| Page 103 (Master-Detail) | 1.5 hours |
| Page 105 (Calendar) | 1 hour |
| Page 501, 502 (Bills) | 1 hour |
| Other Pages (201, 301, 405, 406) | 2 hours |
| Testing & Refinement | 1 hour |
| **TOTAL** | **~10 hours** |

**Jei turite export failą:** ~1 hour (just import + test)

---

## CONCLUSION

Sekdami šias instrukcijas, sukursite pilnai funkcionuojančią ligoninės valdymo sistemą su:

✅ 20+ puslapių
✅ 30 LOV
✅ Visos 15 esybės panaudotos
✅ Master-Detail forma
✅ Kalendorius su drag & drop
✅ Maksimali duomenų kontrolė
✅ Atitinka visus reikalavimus

**Sėkmės kuriant aplikaciją!** 🚀
