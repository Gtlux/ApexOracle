# APEX AUTOMATINIS APLIKACIJOS GENERAVIMAS IŠ ESAMŲ LENTELIŲ
## Oracle APEX 22.1.0

---

## METODAS 1: CREATE APPLICATION WIZARD (Rekomenduojamas)

### Žingsnis 1: App Builder → Create → From a File

1. **Prisijunkite į APEX Builder**
   ```
   URL: https://your-server:port/apex
   Workspace: HOSPITAL_WORKSPACE
   Username: ADMIN
   ```

2. **App Builder → Create**

3. **Pasirinkite: "New Application"**

### Žingsnis 2: Konfigūruokite Aplikaciją

**Application Definition:**
```
Name: Ligoninės Valdymo Sistema
Appearance: Universal Theme - 42
```

### Žingsnis 3: Pridėti Puslapius Automatiškai

**Click "Add Page" keletą kartų:**

#### Page 1: Dashboard
- Type: **Blank**
- Page Name: "Pagrindinis"

#### Page 2: Pacientų Interactive Report
- Click **Add Page**
- Type: **Interactive Report**
- Page Name: "Pacientai"
- Table/View: **PATIENTS**
- Include Form: ✅ **Yes**
- Form Page: 3
- Navigation: ✅ Create

APEX automatiškai sukurs:
- Page 2: Interactive Report (su visais stulpeliais)
- Page 3: Form (Create/Edit)
- Navigation menu item

#### Page 4: Gydytojų Interactive Report
- Type: **Interactive Report**
- Page Name: "Gydytojai"
- Table/View: **V_DOCTORS_FULL** (naudokite VIEW!)
- Include Form: ✅ Yes
- Form Page: 5

#### Page 6: Vizitų Interactive Report
- Type: **Interactive Report**
- Page Name: "Vizitai"
- Table/View: **APPOINTMENTS**
- Include Form: ✅ Yes
- Form Page: 7

#### Page 8: Kalendorius
- Type: **Calendar**
- Page Name: "Vizitų Kalendorius"
- Table/View: **APPOINTMENTS**
- Display Column: "Pacientas (select iš patients)"
- Start Date: **APPOINTMENT_DATE**
- End Date: **APPOINTMENT_DATE**

**Tęskite su visomis lentelėmis:**
- DEPARTMENTS → Interactive Report + Form
- ROOMS → Interactive Report + Form
- BEDS → Interactive Report + Form
- MEDICATIONS → Interactive Report + Form
- PRESCRIPTIONS → Interactive Report + Form
- LAB_TESTS → Interactive Report + Form
- BILLS → Interactive Report + Form
- ADMISSIONS → Interactive Report + Form

### Žingsnis 4: Features

**Settings:**
- ✅ Navigation
- ✅ About Page
- ❌ Feedback (optional)

### Žingsnis 5: Create Application

Click **Create Application**

APEX **AUTOMATIŠKAI** sukurs:
- ✅ Visus puslapius
- ✅ Forms su visais laukais
- ✅ Interactive Reports
- ✅ Navigation Menu
- ✅ Breadcrumbs

---

## METODAS 2: BLUEPRINT (Quick Start)

### Option A: Using Blueprint

1. **App Builder → Create**
2. **Select: "From a Spreadsheet or Blueprint"**
3. **Click: "Create Application from Blueprint"**
4. **Select: Custom**

Bet šis metodas mažiau tinka esamoms lentelėms.

---

## METODAS 3: PO VIENĄ PUSLAPĮ (Manual)

Jei jau turite aplikaciją ir norite pridėti puslapius:

### Pridėti Interactive Report

1. **Edit Application**
2. **Create Page → Interactive Report**

**Page Attributes:**
```
Page Number: 101
Name: Pacientų Registras
Table/View Name: PATIENTS
Include Form Page: Yes
Primary Key Column: PATIENT_ID
```

**APEX automatiškai:**
- Sukurs visus stulpelius
- Pridės Search Bar
- Pridės Actions Menu
- Sukurs Edit link
- Generate automatinę SQL query

### Pridėti Form

1. **Create Page → Form**

**Page Attributes:**
```
Page Number: 102
Name: Paciento Forma
Table Name: PATIENTS
Primary Key Column: PATIENT_ID
Primary Key Type: Select from existing
```

**APEX automatiškai:**
- Sukurs visus form items
- Nustatys data types
- Pridės validacijas (NOT NULL)
- Sukurs Save/Cancel mygtukus
- Generate INSERT/UPDATE procesus

---

## METODAS 4: DATABASE OBJECT BROWSER

### Generuoti iš Object Browser

1. **SQL Workshop → Object Browser**
2. **Pasirinkite lentelę: PATIENTS**
3. **Click "Create App" (viršuje)**

**APEX sukurs:**
- Report page
- Form page
- Navigation

**Arba:**

4. **Click "Create" → "Form"**
5. Pasirinkite options:
   - Form on Table
   - Form on Table with Report
   - Master-Detail

---

## METODAS 5: AUTOMATIC MASTER-DETAIL

### Sukurti Master-Detail automatiškai

1. **Create Page → Master Detail**

**Master:**
```
Master Table: PATIENTS
Master Primary Key: PATIENT_ID
```

**Detail:**
```
Detail Table: APPOINTMENTS
Foreign Key: PATIENT_ID
```

**Layout:**
- ✅ **Two Step** (Side by Side layout)
- Display Type: Report

APEX automatiškai:
- Sukurs Master formą
- Sukurs Detail Interactive Report
- Sujungs per Foreign Key
- Pridės navigaciją

---

## PRAKTINIS PAVYZDYS: VISA LIGONINĖS SISTEMA

### Quick Application Generation

```sql
-- Paleiskite APEX Builder UI:

1. CREATE APPLICATION
   Name: Ligoninės Valdymo Sistema

2. ADD PAGES (automatiškai):

   Page 2-3:   PATIENTS (Report + Form)
   Page 4-5:   DOCTORS (Report + Form)  -- naudokite v_doctors_full VIEW
   Page 6-7:   APPOINTMENTS (Report + Form)
   Page 8:     APPOINTMENTS (Calendar)
   Page 10-11: ADMISSIONS (Report + Form)
   Page 12-13: DEPARTMENTS (Report + Form)
   Page 14-15: ROOMS (Report + Form)
   Page 16-17: BEDS (Report + Form)
   Page 18-19: MEDICATIONS (Report + Form)
   Page 20-21: PRESCRIPTIONS (Report + Form)
   Page 22-23: LAB_TESTS (Report + Form)
   Page 24-25: BILLS (Report + Form)
   Page 26-27: DIAGNOSES (Report + Form)
   Page 28-29: PATIENT_DIAGNOSES (Report + Form)
   Page 30-31: NURSES (Report + Form) -- naudokite v_nurses VIEW

3. CREATE APPLICATION

   Užtruks: ~2 minutės
   Rezultatas: 30+ puslapių aplikacija!
```

---

## POST-GENERATION CUSTOMIZATION

### Ką pakeisti po automatinio generavimo:

#### 1. Foreign Keys → LOV

**Edit Form Page:**
```
Item: P3_DEPARTMENT_ID
Type: Select List
LOV Type: SQL Query
SQL Query:
  SELECT department_name AS d, department_id AS r
  FROM departments
  WHERE is_active = 'Y'
  ORDER BY department_name
Display Extra Values: No
Null Display Value: - Pasirinkite skyrių -
```

#### 2. Date Fields → Date Picker

```
Item: P3_DATE_OF_BIRTH
Type: Date Picker
Format Mask: YYYY-MM-DD
Maximum Value: SYSDATE
```

#### 3. Pridėti Validacijas

```
Validation Name: Email Format
Type: Item is a valid email address
Item: P3_EMAIL
Error Message: Neteisingas el. pašto formatas
```

#### 4. Conditional Display

```
Item: P3_GENDER
Type: Radio Group
LOV Type: Static
Static Values:
  STATIC2:Vyras;M,Moteris;F,Kita;O
Display As: Horizontal
```

#### 5. Filters į Interactive Report

**Edit Interactive Report:**
```
Add Page Item:
  P2_CITY (Select List - Dynamic)

SQL Query (Report):
  WHERE (:P2_CITY IS NULL OR city = :P2_CITY)
```

---

## AUTOMATIC RELATIONSHIP DETECTION

APEX **automatiškai** atpažįsta Foreign Keys!

### Kaip veikia:

1. **Jūsų DB Foreign Keys:**
   ```sql
   ALTER TABLE appointments
   ADD CONSTRAINT fk_appt_patient
   FOREIGN KEY (patient_id) REFERENCES patients(patient_id);
   ```

2. **APEX automatiškai:**
   - Form item `P_PATIENT_ID` taps **Select List**
   - LOV automatiškai sugeneruotas:
     ```sql
     SELECT patient_id AS d, patient_id AS r
     FROM patients
     ```

3. **Jūs galite pakeisti:**
   - Edit LOV Display Expression:
     ```sql
     SELECT first_name || ' ' || last_name AS d,
            patient_id AS r
     FROM patients
     WHERE is_active = 'Y'
     ```

---

## NAUDOTI VIEWS VIETOJ TABLES

**Rekomenduojama!**

### Kodėl Views geriau:

```sql
-- Vietoj DOCTORS lentelės:
CREATE OR REPLACE VIEW v_doctors_display AS
SELECT
    d.doctor_id,
    e.first_name || ' ' || e.last_name AS full_name,
    d.specialization,
    dept.department_name,
    d.license_number,
    e.phone_number,
    e.email,
    d.consultation_fee
FROM doctors d
JOIN employees e ON d.doctor_id = e.employee_id
JOIN departments dept ON d.department_id = dept.department_id
WHERE e.employment_status = 'ACTIVE';
```

**APEX'e naudokite:**
```
Table/View: V_DOCTORS_DISPLAY (vietoj DOCTORS)
```

**Privalumai:**
- ✅ Jau sujungti duomenys
- ✅ Gražus display
- ✅ Automatic JOIN
- ✅ Greičiau už manual SQL

---

## INTERACTIVE GRID VS INTERACTIVE REPORT

### Kada naudoti Interactive Grid:

**Editable Data:**
```
Page Type: Interactive Grid
Table: MEDICATIONS
Features:
  ✅ Add Row
  ✅ Edit
  ✅ Delete
  ✅ Save Button
```

APEX automatiškai:
- Leidžia inline editing
- Automatic DML
- Row validation
- Batch save

### Kada naudoti Interactive Report:

**Read-Only su Edit Form:**
```
Page Type: Interactive Report
Include Form: Yes
```

---

## APEX AUTOMATIC FEATURES

### Kas generuojama automatiškai:

#### 1. CRUD Operations
```sql
-- APEX automatiškai sukurs:
-- INSERT
-- UPDATE
-- DELETE
```

#### 2. Automatic Validations
- NOT NULL fields → Required
- VARCHAR2(50) → Max Length
- DATE → Date Picker
- NUMBER → Number Field

#### 3. Automatic Processes
- Fetch row
- Save changes
- Delete row
- Clear cache

#### 4. Automatic Branches
- After save → return to report
- After delete → return to report
- Cancel → return to report

---

## TROUBLESHOOTING

### Problema: "Table not found"

**Sprendimas:**
```sql
-- Patikrinkite schema:
SELECT table_name FROM user_tables;

-- Workspace schema turi būti HOSPITAL_DB
-- APEX Application → Edit Definition → Schema
```

### Problema: "Foreign Key nerodo display values"

**Sprendimas:**
```
Edit Page Item
Type: Popup LOV
LOV: Create custom LOV
SQL Query:
  SELECT first_name || ' ' || last_name AS d,
         patient_id AS r
  FROM patients
```

### Problema: "Too many columns"

**Sprendimas:**
```
Interactive Report → Actions → Columns
Hide unwanted columns:
  - created_date
  - modified_date
  - system_columns
```

---

## RECOMMENDED WORKFLOW

### Greičiausias būdas sukurti aplikaciją:

**1. Auto-generate bazinę aplikaciją (15 min)**
```
Create Application Wizard
→ Add all 15 tables as Reports + Forms
→ Create
```

**2. Customize (2-3 val)**
```
- Convert FK į LOV
- Pridėti filtrus
- Customize labels (lietuviškai)
- Pridėti validacijas
```

**3. Pridėti advanced features (3-4 val)**
```
- Calendar
- Master-Detail
- Dashboard
- Custom buttons
```

**4. Testing (1 val)**

**TOTAL: 6-8 valandos** (vs 10 val manual)

---

## EXAMPLE: AUTO-GENERATE PATIENT MODULE

### Step-by-Step:

**1. Create Page → Interactive Report**
```
Table: V_PATIENTS_FULL  (naudokite VIEW!)
Include Form: Yes
Form Page: Auto-assign
```

**Result:**
- Page 101: Interactive Report (automatiškai visi stulpeliai)
- Page 102: Form (automatiškai visi laukai)

**2. Customize Report (101):**
```
Edit SQL Query:
  SELECT patient_id,
         full_name,
         age,
         gender_display,
         phone_number,
         email,
         currently_admitted
  FROM v_patients_full
  WHERE is_active = 'Y'
```

**3. Add Filters:**
```
Create Page Items:
  P101_CITY (Select List)
  P101_GENDER (Select List)

Modify SQL:
  WHERE is_active = 'Y'
    AND (:P101_CITY IS NULL OR city = :P101_CITY)
    AND (:P101_GENDER IS NULL OR gender = :P101_GENDER)
```

**4. Customize Form (102):**
```
P102_GENDER → Radio Group
P102_BLOOD_TYPE → Select List
P102_DATE_OF_BIRTH → Date Picker (max: SYSDATE)
P102_PHONE_NUMBER → Format Mask: +370 000 00000

Add Validations:
  - Email format
  - Phone format
  - Date not future
```

**5. Done!**

Laikas: **30 min** vietoj 2 val manual!

---

## SUMMARY

### Greičiausias būdas:

```
1. App Builder → Create → New Application
2. Add Page 15 kartų (viena kiekvienai lentelei)
   - Type: Interactive Report + Form
   - Table: [pasirinkite lentelę]
3. Create Application
4. Customize:
   - FK → LOV (30 min)
   - Labels → Lithuanian (30 min)
   - Validations (1 val)
5. DONE!
```

**Rezultatas:**
- ✅ 30+ puslapių
- ✅ Visi CRUD
- ✅ Navigation
- ✅ Basic validations
- ✅ ~3-4 valandos (vs 10 val manual)

**Tada pridėti advanced:**
- Calendar (Page 105)
- Master-Detail (Page 103)
- Dashboard (Page 1)
- Custom LOV
- Filters

---

Ar norėtum kad parodysiu **screenshot'us** arba video tutorial kaip tai padaryti? Arba gal turite specifinį klausimą apie kurią lentelę?
