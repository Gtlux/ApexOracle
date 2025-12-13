# 🏥 Ligoninės Valdymo Sistema - APEX Aplikacijos Pilnas Setup Vadovas

**Application ID:** 10100
**APEX Version:** 22.1.0
**Database Schema:** STUD_581

---

## 📋 BŪTINOS SĄLYGOS

Prieš pradedant, įsitikinkite, kad atlikti visi šie žingsniai:

- [x] ✅ Lentelės sukurtos (`01_create_tables.sql`)
- [x] ✅ Triggers sukurti (`02_create_triggers.sql`)
- [x] ✅ Views sukurti (`03_create_views.sql`)
- [x] ✅ Sample data įkelti (`04_insert_sample_data.sql`)
- [x] ✅ Bazinė APEX aplikacija importuota (`f10100.sql`)

---

## 🚀 GREITAS STARTAS: 3 ŽINGSNIAI

### **ŽINGSNIS 1: APEX AUTO-GENERATION (45 min)**

APEX gali **AUTOMATIŠKAI** sukurti visą aplikaciją iš esamų lentelių!

1. **App Builder** → **Create** → **New Application**
2. **Name:** Ligoninės valdymo sistema
3. **Create App From:** Tables and Views
4. **Add Page:**
   - Select **ALL 15 tables** (APEX automatiškai aptiks)
   - APEX sukurs Interactive Reports + Forms AUTOMATIŠKAI
   - APEX aptiks **23 Foreign Keys** ir sukurs Master-Detail

**APEX auto-generated puslapiai:**
- Home Page
- DEPARTMENTS (Interactive Report + Form)
- EMPLOYEES (Interactive Report + Form)
- DOCTORS (Interactive Report + Form)
- NURSES (Interactive Report + Form)
- ROOMS (Interactive Report + Form)
- BEDS (Interactive Report + Form)
- PATIENTS (Interactive Report + Form) ← **REQ 3 ✅**
- APPOINTMENTS (Interactive Report + Form + Calendar) ← **REQ 6 ✅**
- ADMISSIONS (Interactive Report + Form)
- DIAGNOSES (Interactive Report + Form)
- PATIENT_DIAGNOSES (Interactive Report + Form)
- MEDICATIONS (Interactive Report + Form)
- PRESCRIPTIONS (Interactive Report + Form)
- LAB_TESTS (Interactive Report + Form)
- BILLS (Interactive Report + Form)

**Auto-generated Features:**
- ✅ Interactive Reports su Search ir Filters
- ✅ CRUD Forms (Create, Read, Update, Delete)
- ✅ Foreign Key aptikimas → automatiškai LOVs
- ✅ Navigation Menu su visais puslapiais
- ✅ Calendar (jei aptinka DATE stulpelį)

---

### **ŽINGSNIS 2: PRIDĖTI VIEWS IR LOVS (30 min)**

#### **A) Pridėti VIEW-based Reports** (REQ 4)

1. **Create Page** → **Report** → **Interactive Report**
2. **Page Name:** Sąskaitos
3. **Source Type:** SQL Query
4. **SQL:**
```sql
SELECT * FROM v_bills_detailed
```
5. **Save** ← **REQ 4 ✅ ATLIKTA!**

Pakartok šiems views:
- `v_patients_full` - Pacientų statistika
- `v_doctors_full` - Gydytojų sąrašas
- `v_admissions_current` - Dabartiniai priėmimai
- `v_dashboard_stats` - Dashboard KPI

#### **B) Pridėti LOVs (Shared Components)**

1. **Shared Components** → **List of Values** → **Create**

**STATIC LOVs (5 min kiekvienam):**

```sql
-- LOV_GENDER
Vyras = M
Moteris = F
Kita = O

-- LOV_BLOOD_TYPE
A+ = A+
A- = A-
B+ = B+
B- = B-
AB+ = AB+
AB- = AB-
O+ = O+
O- = O-

-- LOV_ROOM_TYPE
Vienvietė = PRIVATE
Dvivietė = SEMI_PRIVATE
Intensyvi priežiūra = ICU
Skubi pagalba = EMERGENCY
Operacinė = OPERATING

-- LOV_APPOINTMENT_TYPE
Patikrinimas = CHECKUP
Konsultacija = CONSULTATION
Pakartotinis = FOLLOWUP
Skubūs = EMERGENCY

-- LOV_APPOINTMENT_STATUS
Suplanuotas = SCHEDULED
Patvirtintas = CONFIRMED
Įvykęs = COMPLETED
Atšauktas = CANCELLED
Neatvyko = NO_SHOW

-- LOV_BED_STATUS
Laisva = AVAILABLE
Užimta = OCCUPIED
Remontas = MAINTENANCE
Rezervuota = RESERVED

-- LOV_EMPLOYMENT_STATUS
Dirba = ACTIVE
Atostogose = ON_LEAVE
Atleistas = TERMINATED

-- LOV_PAYMENT_STATUS
Neapmokėta = UNPAID
Dalinai = PARTIAL
Apmokėta = PAID
Vėluoja = OVERDUE

-- LOV_PAYMENT_METHOD
Grynais = CASH
Kortele = CARD
Draudimas = INSURANCE
Pervedimu = BANK_TRANSFER

-- LOV_LAB_TEST_TYPE
Kraujo tyrimas = BLOOD
Šlapimo tyrimas = URINE
Rentgenas = XRAY
MRI = MRI
CT = CT_SCAN
Echoskopija = ULTRASOUND
Elektrokardiograma = ECG
```

**DYNAMIC LOVs (SQL-based):**

```sql
-- LOV_DEPARTMENTS
SELECT department_id AS d, department_name AS r
  FROM departments
 WHERE is_active = 'Y'
 ORDER BY department_name

-- LOV_DOCTORS
SELECT doctor_id AS d,
       e.first_name || ' ' || e.last_name || ' (' || d.specialization || ')' AS r
  FROM doctors d
  JOIN employees e ON d.doctor_id = e.employee_id
 WHERE e.employment_status = 'ACTIVE'
 ORDER BY e.last_name, e.first_name

-- LOV_PATIENTS
SELECT patient_id AS d,
       first_name || ' ' || last_name || ' (' || TO_CHAR(date_of_birth, 'YYYY-MM-DD') || ')' AS r
  FROM patients
 WHERE is_active = 'Y'
 ORDER BY last_name, first_name

-- LOV_MEDICATIONS
SELECT medication_id AS d,
       medication_name || ' ' || strength || ' (' || dosage_form || ')' AS r
  FROM medications
 WHERE is_available = 'Y'
 ORDER BY medication_name

-- LOV_DIAGNOSES
SELECT diagnosis_id AS d,
       diagnosis_code || ' - ' || diagnosis_name AS r
  FROM diagnoses
 WHERE is_active = 'Y'
 ORDER BY diagnosis_code

-- LOV_ROOMS_BY_DEPT (CASCADE - priklauso nuo department)
SELECT room_id AS d,
       room_number || ' (' || room_type || ')' AS r
  FROM rooms
 WHERE department_id = :P103_DEPARTMENT_ID  -- parent item
   AND is_available = 'Y'
 ORDER BY room_number

-- LOV_BEDS_BY_ROOM (CASCADE - priklauso nuo room)
SELECT bed_id AS d,
       bed_number || ' (' || bed_status || ')' AS r
  FROM beds
 WHERE room_id = :P103_ROOM_ID
 ORDER BY bed_number
```

#### **C) Atnaujinti Forms su LOVs (10 min per formą)**

Kiekvienoje formoje pakeisti text laukus į Select List:

1. **Edit Form Page** → **Select Item** (pvz., P102_GENDER)
2. **Type:** Select List
3. **List of Values:** LOV_GENDER
4. **Display Extra Values:** No
5. **Display Null Value:** No
6. **Save**

Pakartok visiems FK laukams ir enum laukams!

---

### **ŽINGSNIS 3: CUSTOMIZATION (3-4 val)**

#### **A) Pakeisti Labels į Lietuvių Kalbą**

Edit kiekvieną puslapį:
- **Page Name:** Angliškas → Lietuviškas
  - Patients → Pacientai
  - Doctors → Gydytojai
  - Appointments → Vizitai

- **Column Headings:**
  - First Name → Vardas
  - Last Name → Pavardė
  - Date of Birth → Gimimo data
  - Gender → Lytis
  - Blood Type → Kraujo grupė

#### **B) Pridėti Master-Detail (REQ 5)**

**Pavyzdys: Patient Profile (Master-Detail Side by Side)**

1. **Create Page** → **Form** → **Master Detail**
2. **Layout:** Side by Side ← **SVARBU!**
3. **Master Table:** PATIENTS
4. **Detail Table:** APPOINTMENTS
5. **Foreign Key:** PATIENT_ID

**Rezultatas:** Page 103 - Master-Detail ← **REQ 5 ✅**

Pakartok:
- Patient → Diagnoses
- Patient → Prescriptions
- Doctor → Appointments

#### **C) Pridėti Calendar (REQ 6 su drag & drop)**

1. **Create Page** → **Calendar**
2. **Table/View:** APPOINTMENTS arba V_APPOINTMENTS_CALENDAR
3. **Display Column:** PATIENT_NAME (iš VIEW)
4. **Start Date:** APPOINTMENT_DATE
5. **End Date:** APPOINTMENT_DATE
6. **Create/Edit Link:** Page 102 (Appointment Form)

**Drag & Drop:**
7. **Edit Calendar Region** → **Attributes**
8. **Drag and Drop:** Yes
9. **Update Process:**
```sql
UPDATE appointments
   SET appointment_date = :NEW_START_DATE,
       appointment_time = TO_CHAR(:NEW_START_DATE, 'HH24:MI')
 WHERE appointment_id = :APPOINTMENT_ID
```

**Rezultatas:** Page 105 - Calendar ← **REQ 6 ✅**

#### **D) Pridėti Validacijas**

**Pavyzdys: Email Validation**

1. **Edit Page 102 (Patient Form)**
2. **Validations** → **Create**
3. **Type:** Item is valid email address
4. **Item:** P102_EMAIL
5. **Error Message:** Neteisingas el. pašto formatas
6. **Error Display Location:** Inline with Field

**Daugiau validacijų:**

```sql
-- Date of Birth negali būti ateityje
:P102_DATE_OF_BIRTH < SYSDATE
Klaida: "Gimimo data negali būti ateityje"

-- Phone number validation
REGEXP_LIKE(:P102_PHONE_NUMBER, '^\+?[0-9 \-\(\)]+$')
Klaida: "Neteisingas telefono numerio formatas"

-- Insurance number validation
:P102_INSURANCE_NUMBER IS NOT NULL
Klaida: "Draudimo numeris privalomas"

-- Appointment duration
:P105_DURATION_MINUTES BETWEEN 15 AND 240
Klaida: "Trukmė turi būti tarp 15 ir 240 minučių"
```

#### **E) Home Page (REQ 1) su Dashboard**

1. **Edit Page 1 (Home)**
2. **Add Region** → **Chart** → **Pie Chart**
3. **Title:** Pacientų pasiskirstymas pagal lytį
4. **SQL:**
```sql
SELECT gender_display AS label, COUNT(*) AS value
  FROM v_patients_full
 GROUP BY gender_display
```

5. **Add Region** → **Static Content** → **Cards**
6. **SQL:**
```sql
SELECT department_name AS title,
       total_doctors || ' gydytojai' AS description,
       '/apex/f?p=10100:301' AS link
  FROM v_department_stats
```

7. **Add Navigation Cards:**
```html
<div class="apex-cards">
    <div class="apex-card">
        <a href="f?p=10100:101">
            <span class="icon">👥</span>
            <h3>Pacientai</h3>
        </a>
    </div>
    <div class="apex-card">
        <a href="f?p=10100:105">
            <span class="icon">📅</span>
            <h3>Vizitų Kalendorius</h3>
        </a>
    </div>
    <div class="apex-card">
        <a href="f?p=10100:301">
            <span class="icon">⚕️</span>
            <h3>Gydytojai</h3>
        </a>
    </div>
    <div class="apex-card">
        <a href="f?p=10100:501">
            <span class="icon">💰</span>
            <h3>Sąskaitos</h3>
        </a>
    </div>
</div>
```

**Rezultatas:** Home Page su navigacija ← **REQ 1 ✅**

---

## ✅ REIKALAVIMŲ CHECKLIST

Po visų žingsnių, patikrink:

- [ ] **REQ 1:** Home page su navigacija į visus puslapius ✅
- [ ] **REQ 2:** Patogūs navigation buttons ✅ (auto-generated menu)
- [ ] **REQ 3:** Interactive Report su filters + CRUD (pvz., Patients) ✅
- [ ] **REQ 4:** Report naudojant VIEW (pvz., Bills from v_bills_detailed) ✅
- [ ] **REQ 5:** Master-Detail Side by Side (pvz., Patient Profile) ✅
- [ ] **REQ 6:** Calendar su drag & drop (Appointments) ✅
- [ ] **REQ 7:** Minimum 3 LOVs, 1 dynamic ✅ (turėsite 20+!)

---

## 📊 GALUTINIS REZULTATAS

**Puslapiai (~20+):**
- Page 1: Home / Dashboard
- Page 101: Patients Report
- Page 102: Patient Form
- Page 103: Patient Profile (Master-Detail)
- Page 105: Appointments Calendar
- Page 201: Appointments Report
- Page 301: Doctors Report
- Page 302: Doctor Form
- Page 401: Admissions Report
- Page 501: Bills Report (VIEW-based)
- ... ir kiti

**LOVs (30+):**
- 14 Static LOVs
- 16 Dynamic LOVs
- 3 CASCADE LOVs
- 3 POPUP/Autocomplete LOVs

**Features:**
- ✅ Pilnas CRUD visoms 15 lentelėms
- ✅ Foreign Key → LOV mapping
- ✅ Calendar su drag & drop
- ✅ Master-Detail forms
- ✅ VIEW-based reports
- ✅ Dashboard su KPI
- ✅ Validation su lietuviškomis klaidomis
- ✅ Navigation menu

---

## ⏱️ LAIKO ĮVERTINIMAS

| Etapas | Laikas |
|--------|--------|
| APEX Auto-Generation | 45 min |
| Views ir LOVs | 30 min |
| Labels į lietuvių kalbą | 1 val |
| Master-Detail setup | 30 min |
| Calendar setup | 30 min |
| Validations | 1 val |
| Home Page customization | 30 min |
| Testing ir polish | 1 val |
| **VISO** | **~5-6 val** |

---

## 🎯 GREITAS TESTAS

Po setup, patikrink:

```sql
-- Pacientų skaičius
SELECT COUNT(*) FROM patients; -- 10

-- Appointments skaičius
SELECT COUNT(*) FROM appointments; -- 15

-- LOVs skaičius
SELECT COUNT(*) FROM apex_application_lovs WHERE application_id = 10100;

-- Puslapių skaičius
SELECT COUNT(*) FROM apex_application_pages WHERE application_id = 10100;
```

---

## 💡 PAPILDOMI PATARIMAI

1. **Automatic Row Fetch:** APEX automatiškai generuoja fetch processes
2. **Automatic DML:** APEX automatiškai generuoja INSERT/UPDATE/DELETE
3. **Session State Protection:** Įjungk visoms sensitive forms
4. **Authorization Schemes:** Pridėk role-based access (pvz., Doctor vs Nurse)
5. **Success Messages:** Pakeisk į lietuviškas:
   - "Row inserted" → "Įrašas sukurtas"
   - "Row updated" → "Įrašas atnaujintas"
   - "Row deleted" → "Įrašas ištrintas"

---

**Autorius:** ApexOracle Hospital Management System
**Versija:** 1.0
**Data:** 2025-12-13
**APEX:** 22.1.0 ✅
