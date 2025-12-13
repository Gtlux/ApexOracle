# 🏥 APEX PUSLAPIŲ KŪRIMO VADOVAS - Step by Step

**Application ID:** 10100
**APEX Version:** 22.1.0
**Database Schema:** STUD_581

---

## 📋 TURINYS

1. [LOVs Kūrimas](#1-lovs-kūrimas-30-vnt)
2. [Home Page (REQ 1)](#2-home-page-req-1)
3. [Patients Report + Form (REQ 3)](#3-patients-interactive-report--form-req-3)
4. [Patient Master-Detail (REQ 5)](#4-patient-master-detail-req-5)
5. [Appointments Calendar (REQ 6)](#5-appointments-calendar-req-6)
6. [Bills Report su VIEW (REQ 4)](#6-bills-report-su-view-req-4)
7. [Doctors Report + Form](#7-doctors-report--form)
8. [Likusieji Puslapiai](#8-likusieji-puslapiai)
9. [Navigation Menu](#9-navigation-menu)
10. [Validacijos](#10-validacijos)

---

## 1. LOVs KŪRIMAS (30 VNT)

### Kaip patekti:
```
App Builder → Application 10100 → Shared Components → List of Values → Create
```

### 1.1 STATIC LOVs (14 vnt)

#### **LOV_GENDER**
```
Name: LOV_GENDER
Type: Static
Values:
  Display Value    | Return Value
  ─────────────────┼─────────────
  Vyras           | M
  Moteris         | F
  Kita            | O
```

**Kaip sukurti:**
1. **Create** → **From Scratch** → **Static**
2. **Name:** LOV_GENDER
3. **Static Values:**
   - Click **Add Entry**
   - Display Value: `Vyras`, Return Value: `M`
   - Click **Add Entry**
   - Display Value: `Moteris`, Return Value: `F`
   - Click **Add Entry**
   - Display Value: `Kita`, Return Value: `O`
4. **Create**

---

#### **LOV_BLOOD_TYPE**
```
Name: LOV_BLOOD_TYPE
Type: Static
Values:
  A+ | A+
  A- | A-
  B+ | B+
  B- | B-
  AB+ | AB+
  AB- | AB-
  O+ | O+
  O- | O-
```

---

#### **LOV_ROOM_TYPE**
```
Name: LOV_ROOM_TYPE
Type: Static
Values:
  Vienvietė           | PRIVATE
  Dvivietė            | SEMI_PRIVATE
  Intensyvi priežiūra | ICU
  Skubi pagalba       | EMERGENCY
  Operacinė           | OPERATING
```

---

#### **LOV_APPOINTMENT_TYPE**
```
Name: LOV_APPOINTMENT_TYPE
Type: Static
Values:
  Patikrinimas  | CHECKUP
  Konsultacija  | CONSULTATION
  Pakartotinis  | FOLLOWUP
  Skubūs        | EMERGENCY
```

---

#### **LOV_APPOINTMENT_STATUS**
```
Name: LOV_APPOINTMENT_STATUS
Type: Static
Values:
  Suplanuotas | SCHEDULED
  Patvirtintas | CONFIRMED
  Įvykęs | COMPLETED
  Atšauktas | CANCELLED
  Neatvyko | NO_SHOW
```

---

#### **LOV_BED_STATUS**
```
Name: LOV_BED_STATUS
Type: Static
Values:
  Laisva | AVAILABLE
  Užimta | OCCUPIED
  Remontas | MAINTENANCE
  Rezervuota | RESERVED
```

---

#### **LOV_EMPLOYMENT_STATUS**
```
Name: LOV_EMPLOYMENT_STATUS
Type: Static
Values:
  Dirba | ACTIVE
  Atostogose | ON_LEAVE
  Atleistas | TERMINATED
```

---

#### **LOV_PAYMENT_STATUS**
```
Name: LOV_PAYMENT_STATUS
Type: Static
Values:
  Neapmokėta | UNPAID
  Dalinai | PARTIAL
  Apmokėta | PAID
  Vėluoja | OVERDUE
```

---

#### **LOV_PAYMENT_METHOD**
```
Name: LOV_PAYMENT_METHOD
Type: Static
Values:
  Grynais | CASH
  Kortele | CARD
  Draudimas | INSURANCE
  Pervedimu | BANK_TRANSFER
```

---

#### **LOV_LAB_TEST_TYPE**
```
Name: LOV_LAB_TEST_TYPE
Type: Static
Values:
  Kraujo tyrimas | BLOOD
  Šlapimo tyrimas | URINE
  Rentgenas | XRAY
  MRI | MRI
  CT | CT_SCAN
  Echoskopija | ULTRASOUND
  Elektrokardiograma | ECG
  EEG | EEG
  Biopsija | BIOPSY
```

---

#### **LOV_ADMISSION_TYPE**
```
Name: LOV_ADMISSION_TYPE
Type: Static
Values:
  Skubaus | EMERGENCY
  Planuotas | PLANNED
  Perkėlimas | TRANSFER
```

---

#### **LOV_ADMISSION_STATUS**
```
Name: LOV_ADMISSION_STATUS
Type: Static
Values:
  Priimtas | ADMITTED
  Išrašytas | DISCHARGED
  Perkeltas | TRANSFERRED
```

---

#### **LOV_PRESCRIPTION_STATUS**
```
Name: LOV_PRESCRIPTION_STATUS
Type: Static
Values:
  Aktyvus | ACTIVE
  Užbaigtas | COMPLETED
  Atšauktas | CANCELLED
```

---

#### **LOV_LAB_TEST_STATUS**
```
Name: LOV_LAB_TEST_STATUS
Type: Static
Values:
  Užsakytas | ORDERED
  Vykdomas | IN_PROGRESS
  Baigtas | COMPLETED
  Atšauktas | CANCELLED
```

---

### 1.2 DYNAMIC LOVs (16 vnt)

#### **LOV_DEPARTMENTS**
```
Name: LOV_DEPARTMENTS
Type: Dynamic (SQL Query)
SQL Query:
```
```sql
SELECT department_name AS d,
       department_id AS r
  FROM departments
 WHERE is_active = 'Y'
 ORDER BY department_name
```

**Kaip sukurti:**
1. **Create** → **From Scratch** → **Dynamic**
2. **Name:** LOV_DEPARTMENTS
3. **Query:**
```sql
SELECT department_name AS d,
       department_id AS r
  FROM departments
 WHERE is_active = 'Y'
 ORDER BY department_name
```
4. **Create**

---

#### **LOV_DOCTORS**
```
Name: LOV_DOCTORS
Type: Dynamic
SQL Query:
```
```sql
SELECT e.first_name || ' ' || e.last_name || ' (' || d.specialization || ')' AS d,
       d.doctor_id AS r
  FROM doctors d
  JOIN employees e ON d.doctor_id = e.employee_id
 WHERE e.employment_status = 'ACTIVE'
 ORDER BY e.last_name, e.first_name
```

---

#### **LOV_PATIENTS**
```
Name: LOV_PATIENTS
Type: Dynamic
SQL Query:
```
```sql
SELECT first_name || ' ' || last_name || ' (' || TO_CHAR(date_of_birth, 'YYYY-MM-DD') || ')' AS d,
       patient_id AS r
  FROM patients
 WHERE is_active = 'Y'
 ORDER BY last_name, first_name
```

---

#### **LOV_PATIENTS_AUTOCOMPLETE** (su search)
```
Name: LOV_PATIENTS_AUTOCOMPLETE
Type: Dynamic
SQL Query:
```
```sql
SELECT first_name || ' ' || last_name AS d,
       patient_id AS r
  FROM patients
 WHERE is_active = 'Y'
   AND (UPPER(first_name) LIKE '%' || UPPER(:SEARCH_STRING) || '%'
        OR UPPER(last_name) LIKE '%' || UPPER(:SEARCH_STRING) || '%'
        OR insurance_number LIKE '%' || :SEARCH_STRING || '%')
 ORDER BY last_name, first_name
```
**Display Extra Values:** Yes
**Display Null Value:** Yes

---

#### **LOV_MEDICATIONS**
```
Name: LOV_MEDICATIONS
Type: Dynamic
SQL Query:
```
```sql
SELECT medication_name || ' ' || strength || ' (' || dosage_form || ')' AS d,
       medication_id AS r
  FROM medications
 WHERE is_available = 'Y'
 ORDER BY medication_name
```

---

#### **LOV_DIAGNOSES**
```
Name: LOV_DIAGNOSES
Type: Dynamic
SQL Query:
```
```sql
SELECT diagnosis_code || ' - ' || diagnosis_name AS d,
       diagnosis_id AS r
  FROM diagnoses
 WHERE is_active = 'Y'
 ORDER BY diagnosis_code
```

---

#### **LOV_ROOMS**
```
Name: LOV_ROOMS
Type: Dynamic
SQL Query:
```
```sql
SELECT r.room_number || ' (' || r.room_type || ', ' || d.department_name || ')' AS d,
       r.room_id AS r
  FROM rooms r
  JOIN departments d ON r.department_id = d.department_id
 WHERE r.is_available = 'Y'
 ORDER BY r.room_number
```

---

#### **LOV_BEDS**
```
Name: LOV_BEDS
Type: Dynamic
SQL Query:
```
```sql
SELECT r.room_number || '-' || b.bed_number || ' (' || b.bed_status || ')' AS d,
       b.bed_id AS r
  FROM beds b
  JOIN rooms r ON b.room_id = r.room_id
 WHERE b.bed_status IN ('AVAILABLE', 'RESERVED')
 ORDER BY r.room_number, b.bed_number
```

---

#### **LOV_NURSES**
```
Name: LOV_NURSES
Type: Dynamic
SQL Query:
```
```sql
SELECT e.first_name || ' ' || e.last_name AS d,
       n.nurse_id AS r
  FROM nurses n
  JOIN employees e ON n.nurse_id = e.employee_id
 WHERE e.employment_status = 'ACTIVE'
 ORDER BY e.last_name, e.first_name
```

---

### 1.3 CASCADE LOVs (3 vnt - priklauso nuo parent item)

#### **LOV_ROOMS_BY_DEPT**
```
Name: LOV_ROOMS_BY_DEPT
Type: Dynamic
SQL Query:
```
```sql
SELECT room_number || ' (' || room_type || ')' AS d,
       room_id AS r
  FROM rooms
 WHERE department_id = :P103_DEPARTMENT_ID
   AND is_available = 'Y'
 ORDER BY room_number
```
**Pastaba:** `:P103_DEPARTMENT_ID` - parent item (Department dropdown)

**Kaip naudoti formoje:**
1. Sukurti Select List su LOV_DEPARTMENTS (parent)
2. Sukurti Select List su LOV_ROOMS_BY_DEPT (child)
3. Child item **Cascading LOV Parent Item(s):** P103_DEPARTMENT_ID

---

#### **LOV_BEDS_BY_ROOM**
```
Name: LOV_BEDS_BY_ROOM
Type: Dynamic
SQL Query:
```
```sql
SELECT bed_number || ' (' || bed_status || ')' AS d,
       bed_id AS r
  FROM beds
 WHERE room_id = :P103_ROOM_ID
 ORDER BY bed_number
```

---

#### **LOV_DOCTORS_BY_DEPT**
```
Name: LOV_DOCTORS_BY_DEPT
Type: Dynamic
SQL Query:
```
```sql
SELECT e.first_name || ' ' || e.last_name || ' (' || d.specialization || ')' AS d,
       d.doctor_id AS r
  FROM doctors d
  JOIN employees e ON d.doctor_id = e.employee_id
 WHERE d.department_id = :P105_DEPARTMENT_ID
   AND e.employment_status = 'ACTIVE'
 ORDER BY e.last_name, e.first_name
```

---

**✅ SUKURTA: 30 LOVs (14 Static + 16 Dynamic + 3 CASCADE)**

---

## 2. HOME PAGE (REQ 1)

### Page 1: Dashboard

**Kaip sukurti:**
1. **Edit Page 1** (jau egzistuoja po f10100.sql import)
2. **Page Designer** → Dešinėje pusėje matai tuščią page
3. Pridėsime: Dashboard Cards + KPI Statistics

### 2.1 Pridėti Dashboard Cards Region

**Žingsniai:**
1. **Right-click** ant **Body** → **Create Region**
2. **Title:** Sistemos Meniu
3. **Type:** Cards
4. **Source:**
   - **Type:** SQL Query
   - **SQL Query:**
```sql
SELECT 'Pacientai' AS title,
       'Pacientų registras ir istorijos' AS description,
       'fa-users' AS icon_css_class,
       apex_page.get_url(p_page => 101) AS card_link
  FROM dual
UNION ALL
SELECT 'Vizitų Kalendorius' AS title,
       'Gydytojų vizitai ir tvarkaraščiai' AS description,
       'fa-calendar' AS icon_css_class,
       apex_page.get_url(p_page => 105) AS card_link
  FROM dual
UNION ALL
SELECT 'Gydytojai' AS title,
       'Gydytojų duomenys ir specializacijos' AS description,
       'fa-user-md' AS icon_css_class,
       apex_page.get_url(p_page => 301) AS card_link
  FROM dual
UNION ALL
SELECT 'Sąskaitos' AS title,
       'Apskaita ir mokėjimai' AS description,
       'fa-money' AS icon_css_class,
       apex_page.get_url(p_page => 501) AS card_link
  FROM dual
UNION ALL
SELECT 'Priėmimai' AS title,
       'Hospitalizuoti pacientai' AS description,
       'fa-bed' AS icon_css_class,
       apex_page.get_url(p_page => 401) AS card_link
  FROM dual
UNION ALL
SELECT 'Vaistai' AS title,
       'Vaistų katalogas ir atsargos' AS description,
       'fa-pills' AS icon_css_class,
       apex_page.get_url(p_page => 701) AS card_link
  FROM dual
```

4. **Attributes:**
   - **Title Column:** TITLE
   - **Body Column:** DESCRIPTION
   - **Icon CSS Classes Column:** ICON_CSS_CLASS
   - **Card Link Column:** CARD_LINK
5. **Save**

---

### 2.2 Pridėti KPI Statistics Region

**Žingsniai:**
1. **Right-click** ant **Body** → **Create Region**
2. **Title:** Statistika
3. **Type:** Static Content
4. **Source:**
```html
<div class="apex-stats">
    <div class="stat-box">
        <h3>&PATIENT_COUNT.</h3>
        <p>Pacientų</p>
    </div>
    <div class="stat-box">
        <h3>&APPOINTMENT_COUNT.</h3>
        <p>Vizitų šiandien</p>
    </div>
    <div class="stat-box">
        <h3>&ADMISSION_COUNT.</h3>
        <p>Hospitalizuotų</p>
    </div>
    <div class="stat-box">
        <h3>&UNPAID_BILLS.</h3>
        <p>Neapmokėtų sąskaitų</p>
    </div>
</div>
```

5. **Processing** → **Before Header** → **Create Process**
6. **Name:** Load Statistics
7. **Type:** Execute Code
8. **PL/SQL Code:**
```sql
DECLARE
    v_patient_count NUMBER;
    v_appointment_count NUMBER;
    v_admission_count NUMBER;
    v_unpaid_bills NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_patient_count
      FROM patients WHERE is_active = 'Y';

    SELECT COUNT(*) INTO v_appointment_count
      FROM appointments
     WHERE TRUNC(appointment_date) = TRUNC(SYSDATE)
       AND status IN ('SCHEDULED', 'CONFIRMED');

    SELECT COUNT(*) INTO v_admission_count
      FROM admissions WHERE status = 'ADMITTED';

    SELECT COUNT(*) INTO v_unpaid_bills
      FROM bills WHERE payment_status IN ('UNPAID', 'PARTIAL');

    apex_util.set_session_state('PATIENT_COUNT', v_patient_count);
    apex_util.set_session_state('APPOINTMENT_COUNT', v_appointment_count);
    apex_util.set_session_state('ADMISSION_COUNT', v_admission_count);
    apex_util.set_session_state('UNPAID_BILLS', v_unpaid_bills);
END;
```

9. **Shared Components** → **Application Items** → **Create:**
   - PATIENT_COUNT
   - APPOINTMENT_COUNT
   - ADMISSION_COUNT
   - UNPAID_BILLS

**✅ REQ 1: Home page su navigacija SUKURTAS**

---

## 3. PATIENTS INTERACTIVE REPORT + FORM (REQ 3)

### Page 101: Patients Interactive Report

**Kaip sukurti:**
1. **Create Page** → **Report** → **Interactive Report**
2. **Page Name:** Pacientai
3. **Page Number:** 101
4. **Navigation:** Breadcrumb
5. **Source:**
   - **Table/View Name:** V_PATIENTS_FULL (VIEW su statistika)
   - **arba SQL Query:**
```sql
SELECT patient_id,
       full_name AS "Vardas Pavardė",
       age AS "Amžius",
       gender_display AS "Lytis",
       blood_type AS "Kraujo grupė",
       phone_number AS "Telefonas",
       email AS "El. paštas",
       insurance_number AS "Draudimo Nr.",
       registration_date AS "Registracijos data",
       total_appointments AS "Vizitų skaičius",
       unpaid_bills_count AS "Neapmokėtų sąskaitų",
       is_active AS "Aktyvus"
  FROM v_patients_full
 ORDER BY last_name, first_name
```

6. **Include Form Page:** Yes (sukurs Page 102 automatiškai)
7. **Primary Key:** PATIENT_ID
8. **Create**

**Interactive Report Filters:**

Po sukūrimo, **Edit Page 101**:
1. **Edit Region "Pacientai"**
2. **Search Bar:** Yes
3. **Toolbar:**
   - **Actions:** Yes
   - **Download:** Yes (CSV, PDF)
   - **Save Report:** Yes

**Pridėti Filtrus:**
1. **Right-click** ant region → **Create Page Item**
2. **Name:** P101_SEARCH_NAME
3. **Type:** Text Field
4. **Label:** Paieška pagal vardą
5. **Placement:** Region → Before Rows

6. **Create Page Item**
7. **Name:** P101_FILTER_GENDER
8. **Type:** Select List
9. **Label:** Lytis
10. **List of Values:** LOV_GENDER
11. **Display Null Value:** Yes
12. **Null Display Value:** Visi

13. **Edit Region "Pacientai"** → **Source** → **SQL Query:**
```sql
SELECT patient_id,
       full_name AS "Vardas Pavardė",
       age AS "Amžius",
       gender_display AS "Lytis",
       blood_type AS "Kraujo grupė",
       phone_number AS "Telefonas",
       email AS "El. paštas",
       insurance_number AS "Draudimo Nr.",
       registration_date AS "Registracijos data",
       total_appointments AS "Vizitų skaičius",
       unpaid_bills_count AS "Neapmokėtų sąskaitų",
       is_active AS "Aktyvus"
  FROM v_patients_full
 WHERE (:P101_SEARCH_NAME IS NULL OR
        UPPER(full_name) LIKE '%' || UPPER(:P101_SEARCH_NAME) || '%')
   AND (:P101_FILTER_GENDER IS NULL OR gender = :P101_FILTER_GENDER)
 ORDER BY last_name, first_name
```

14. **Page Items to Submit:** P101_SEARCH_NAME,P101_FILTER_GENDER

**✅ Interactive Report su 2+ filters SUKURTAS**

---

### Page 102: Patient Form (CRUD)

**Automatiškai sukurta su Page 101, bet reikia customize:**

1. **Edit Page 102**
2. **Pakeisti Items į LOVs:**

**P102_GENDER:**
- **Type:** Radio Group
- **List of Values:** LOV_GENDER
- **Display Null Value:** No

**P102_BLOOD_TYPE:**
- **Type:** Select List
- **List of Values:** LOV_BLOOD_TYPE
- **Display Null Value:** Yes

**P102_IS_ACTIVE:**
- **Type:** Radio Group
- **List of Values:** Static (Y=Aktyvus, N=Neaktyvus)

3. **Pakeisti Labels į lietuvių kalbą:**
   - P102_FIRST_NAME → Vardas
   - P102_LAST_NAME → Pavardė
   - P102_DATE_OF_BIRTH → Gimimo data
   - P102_GENDER → Lytis
   - P102_BLOOD_TYPE → Kraujo grupė
   - P102_EMAIL → El. paštas
   - P102_PHONE_NUMBER → Telefonas
   - P102_EMERGENCY_CONTACT_NAME → Artimojo vardas
   - P102_EMERGENCY_CONTACT_PHONE → Artimojo telefonas
   - P102_ADDRESS → Adresas
   - P102_CITY → Miestas
   - P102_POSTAL_CODE → Pašto kodas
   - P102_INSURANCE_NUMBER → Draudimo numeris

4. **Save**

**✅ REQ 3: Interactive Report + CRUD Form SUKURTAS**

---

## 4. PATIENT MASTER-DETAIL (REQ 5)

### Page 103: Patient Profile (Master-Detail Side by Side)

**Kaip sukurti:**
1. **Create Page** → **Form**
2. **Page Mode:** Modal Dialog
3. **Data Source:** Table PATIENTS
4. **Page Number:** 103
5. **Page Name:** Paciento Profilis
6. **Create**

**Po sukūrimo, pridėti Detail region:**

7. **Right-click** ant region "Paciento Profilis" → **Create Sub Region**
8. **Title:** Vizitai
9. **Type:** Interactive Grid
10. **Source:**
    - **Type:** SQL Query
    - **SQL Query:**
```sql
SELECT a.appointment_id,
       a.appointment_date AS "Data",
       a.appointment_time AS "Laikas",
       e.first_name || ' ' || e.last_name AS "Gydytojas",
       a.appointment_type AS "Tipas",
       a.status AS "Statusas",
       a.notes AS "Pastabos"
  FROM appointments a
  JOIN doctors d ON a.doctor_id = d.doctor_id
  JOIN employees e ON d.doctor_id = e.employee_id
 WHERE a.patient_id = :P103_PATIENT_ID
 ORDER BY a.appointment_date DESC
```

11. **Attributes:**
    - **Edit Enabled:** Yes
    - **Add Row:** Yes
    - **Delete Row:** Yes

12. **Pakeisti Layout į Side by Side:**
    - **Edit Page 103**
    - **Page Designer** → **Layout** tab
    - **Master Region:** Left Column
    - **Detail Region:** Right Column

13. **Page Template:** Standard
14. **Form Template:** Labels Left

**✅ REQ 5: Master-Detail Side by Side SUKURTAS**

---

## 5. APPOINTMENTS CALENDAR (REQ 6)

### Page 105: Appointments Calendar su Drag & Drop

**Kaip sukurti:**
1. **Create Page** → **Calendar**
2. **Page Number:** 105
3. **Page Name:** Vizitų Kalendorius
4. **Table/View:** V_APPOINTMENTS_CALENDAR (arba APPOINTMENTS)
5. **Display Column:** Pasirink SQL Query vietoj Table

**SQL Query:**
```sql
SELECT appointment_id,
       patient_id || ': ' ||
       (SELECT first_name || ' ' || last_name FROM patients WHERE patient_id = a.patient_id) ||
       ' → ' ||
       (SELECT first_name || ' ' || last_name FROM employees WHERE employee_id = a.doctor_id) AS title,
       appointment_date AS start_date,
       appointment_date AS end_date,
       CASE status
           WHEN 'SCHEDULED' THEN 'blue'
           WHEN 'CONFIRMED' THEN 'green'
           WHEN 'COMPLETED' THEN 'gray'
           WHEN 'CANCELLED' THEN 'red'
       END AS css_class
  FROM appointments a
```

6. **Primary Key:** APPOINTMENT_ID
7. **Display Column:** TITLE
8. **Start Date:** START_DATE
9. **End Date:** END_DATE
10. **Create**

**Pridėti Drag & Drop:**

11. **Edit Calendar Region** → **Attributes**
12. **Drag and Drop:** Yes
13. **Create Link:** Target → Page 102 (Appointment Form)
14. **View / Edit Link:** Target → Page 102

15. **Processing** → **Create Process** (AFTER Calendar region)
16. **Name:** Update Appointment Date
17. **Type:** Execute Code
18. **PL/SQL Code:**
```sql
BEGIN
    UPDATE appointments
       SET appointment_date = TO_DATE(:APEX$NEW_START_DATE, 'YYYYMMDD'),
           appointment_time = TO_CHAR(TO_DATE(:APEX$NEW_START_DATE, 'YYYYMMDD'), 'HH24:MI')
     WHERE appointment_id = :APEX$PK_VALUE;
END;
```
19. **When:** After Submit
20. **Condition:** Request = CHANGE_DATE

**✅ REQ 6: Calendar su drag & drop SUKURTAS**

---

## 6. BILLS REPORT SU VIEW (REQ 4)

### Page 501: Bills Report (VIEW-based)

**Kaip sukurti:**
1. **Create Page** → **Report** → **Interactive Report**
2. **Page Number:** 501
3. **Page Name:** Sąskaitos
4. **Source:** SQL Query

**SQL Query (naudojant VIEW):**
```sql
SELECT bill_id,
       patient_name AS "Pacientas",
       bill_date AS "Sąskaitos data",
       due_date AS "Mokėjimo terminas",
       total_amount AS "Suma",
       paid_amount AS "Sumokėta",
       balance AS "Likutis",
       payment_status_display AS "Statusas",
       payment_method_display AS "Mokėjimo būdas",
       source_type AS "Tipas"
  FROM v_bills_detailed
 WHERE payment_status IN ('UNPAID', 'PARTIAL', 'PAID', 'OVERDUE')
 ORDER BY bill_date DESC
```

5. **Include Form Page:** Yes (sukurs Page 502)
6. **Primary Key:** BILL_ID
7. **Create**

**Format stulpelius:**

8. **Edit Columns:**
   - **Suma, Sumokėta, Likutis:**
     - **Type:** Number Field
     - **Format Mask:** 999G999G999G999G990D00
     - **Alignment:** Right

   - **Statusas:**
     - **Highlight:**
       - UNPAID → Red
       - PARTIAL → Orange
       - PAID → Green
       - OVERDUE → Dark Red

**Pridėti agregacijas:**

9. **Aggregate:**
   - **Suma:** Sum
   - **Sumokėta:** Sum
   - **Likutis:** Sum

**✅ REQ 4: Report su VIEW (multi-table JOIN) SUKURTAS**

---

## 7. DOCTORS REPORT + FORM

### Page 301: Doctors Report

**Kaip sukurti:**
1. **Create Page** → **Report** → **Interactive Report**
2. **Page Number:** 301
3. **Page Name:** Gydytojai
4. **Source:** SQL Query

**SQL Query:**
```sql
SELECT d.doctor_id,
       e.first_name || ' ' || e.last_name AS "Vardas Pavardė",
       d.specialization AS "Specializacija",
       dept.department_name AS "Skyrius",
       d.license_number AS "Licencijos Nr.",
       d.consultation_fee AS "Konsultacijos kaina",
       d.years_of_experience AS "Darbo patirtis",
       e.email AS "El. paštas",
       e.phone_number AS "Telefonas",
       e.employment_status AS "Statusas"
  FROM doctors d
  JOIN employees e ON d.doctor_id = e.employee_id
  JOIN departments dept ON d.department_id = dept.department_id
 ORDER BY e.last_name, e.first_name
```

5. **Include Form Page:** Yes
6. **Primary Key:** DOCTOR_ID
7. **Create**

---

### Page 302: Doctor Form

**Customize po sukūrimo:**

1. **P302_DEPARTMENT_ID:**
   - **Type:** Select List
   - **List of Values:** LOV_DEPARTMENTS

2. **P302_SPECIALIZATION:**
   - **Type:** Text Field (arba sukurti LOV_SPECIALIZATIONS)

3. **Labels į lietuvių kalbą**

---

## 8. LIKUSIEJI PUSLAPIAI

### Naudojant tą patį pattern'ą sukurti:

**Page 201-202: Appointments**
- Interactive Report + Form
- LOVs: LOV_PATIENTS, LOV_DOCTORS, LOV_APPOINTMENT_TYPE, LOV_APPOINTMENT_STATUS

**Page 401-402: Admissions**
- Interactive Report + Form
- LOVs: LOV_PATIENTS, LOV_DOCTORS, LOV_BEDS, LOV_ADMISSION_TYPE, LOV_ADMISSION_STATUS

**Page 601-602: Diagnoses**
- Interactive Report + Form
- LOV: LOV_DIAGNOSES (autocomplete)

**Page 701-702: Medications**
- Interactive Report + Form
- LOV: LOV_MEDICATIONS

**Page 801-802: Prescriptions**
- Interactive Report + Form
- LOVs: LOV_PATIENTS, LOV_DOCTORS, LOV_MEDICATIONS, LOV_PRESCRIPTION_STATUS

**Page 901-902: Lab Tests**
- Interactive Report + Form
- LOVs: LOV_PATIENTS, LOV_DOCTORS, LOV_LAB_TEST_TYPE, LOV_LAB_TEST_STATUS

---

## 9. NAVIGATION MENU

### Kaip atnaujinti:

1. **Shared Components** → **Navigation** → **Lists** → **Navigation Menu**
2. **Create Entry:**

```
Entry Name: Pradžia
Target Page: 1
Icon: fa-home

Entry Name: Pacientai
Target Page: 101
Icon: fa-users
  Sub Entry: Pacientų sąrašas → 101
  Sub Entry: Paciento profilis → 103

Entry Name: Vizitai
Target Page: 105
Icon: fa-calendar
  Sub Entry: Kalendorius → 105
  Sub Entry: Vizitų sąrašas → 201

Entry Name: Gydytojai
Target Page: 301
Icon: fa-user-md

Entry Name: Priėmimai
Target Page: 401
Icon: fa-bed

Entry Name: Ataskaitos
Icon: fa-file-text
  Sub Entry: Sąskaitos → 501
  Sub Entry: Statistika → 601

Entry Name: Katalogas
Icon: fa-book
  Sub Entry: Vaistai → 701
  Sub Entry: Diagnozės → 601
  Sub Entry: Lab Testai → 901
```

---

## 10. VALIDACIJOS

### Pavyzdžiai su lietuviškomis klaidomis:

#### Email Validation (Page 102 - Patient Form)

1. **Edit Page 102**
2. **Validations** → **Create**
3. **Name:** Validate Email Format
4. **Type:** Item is valid email address
5. **Item:** P102_EMAIL
6. **Error Message:** Neteisingas el. pašto formatas
7. **Error Display Location:** Inline with Field

---

#### Date of Birth Validation

1. **Create Validation**
2. **Name:** DOB Cannot Be Future
3. **Type:** Function Body (returning Boolean)
4. **PL/SQL Function Body:**
```sql
RETURN :P102_DATE_OF_BIRTH < SYSDATE;
```
5. **Error Message:** Gimimo data negali būti ateityje
6. **Error Display Location:** Inline with Field

---

#### Phone Number Validation

1. **Create Validation**
2. **Name:** Valid Phone Format
3. **Type:** Function Body (returning Boolean)
4. **PL/SQL Function Body:**
```sql
RETURN REGEXP_LIKE(:P102_PHONE_NUMBER, '^\+?[0-9 \-\(\)]+$');
```
5. **Error Message:** Neteisingas telefono numerio formatas. Naudokite tik skaičius, +, -, (, )
6. **Error Display Location:** Inline with Field

---

#### Appointment Duration

1. **Create Validation (Page 202)**
2. **Name:** Valid Duration
3. **Type:** Item matches Regular Expression
4. **Item:** P202_DURATION_MINUTES
5. **Regular Expression:** ^([1-9][0-9]|1[0-9]{2}|2[0-3][0-9]|240)$
6. **Error Message:** Trukmė turi būti tarp 15 ir 240 minučių
7. **Error Display Location:** Inline with Field

---

#### Stock Quantity Check (Medications)

1. **Create Validation (Page 702)**
2. **Name:** Sufficient Stock
3. **Type:** Function Body (returning Boolean)
4. **PL/SQL Function Body:**
```sql
DECLARE
    v_stock NUMBER;
BEGIN
    SELECT stock_quantity INTO v_stock
      FROM medications
     WHERE medication_id = :P702_MEDICATION_ID;

    RETURN v_stock >= :P702_MINIMUM_STOCK_LEVEL;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN TRUE;
END;
```
5. **Error Message:** Atsargos nepakankamos. Reikia papildyti.
6. **Error Display Location:** Inline with Field

---

## ✅ REIKALAVIMŲ CHECKLIST

Po visų žingsnių patikrink:

- [x] **REQ 1:** Home page su navigacija kortelėmis (Page 1)
- [x] **REQ 2:** Patogus Navigation Menu su mygtukais
- [x] **REQ 3:** Interactive Report su filters + CRUD (Page 101-102)
- [x] **REQ 4:** Report naudojant VIEW v_bills_detailed (Page 501)
- [x] **REQ 5:** Master-Detail Side by Side (Page 103)
- [x] **REQ 6:** Calendar su drag & drop (Page 105)
- [x] **REQ 7:** 30 LOVs, tarp jų 16 dynamic ✅

---

## 📊 LAIKO ĮVERTINIMAS

| Etapas | Laikas |
|--------|--------|
| 30 LOVs sukūrimas | 2 val |
| Home Page (Page 1) | 30 min |
| Patients Report + Form (101-102) | 45 min |
| Patient Master-Detail (103) | 1 val |
| Calendar (105) | 1 val |
| Bills Report (501) | 30 min |
| Doctors Report + Form (301-302) | 45 min |
| Likusieji 10 puslapių | 3 val |
| Navigation Menu | 30 min |
| Validacijos (10 vnt) | 1 val |
| Labels lietuvių kalba | 1 val |
| Testing | 1 val |
| **VISO** | **~12-13 val** |

---

**Autorius:** APEX Hospital Management System
**Data:** 2025-12-13
**APEX:** 22.1.0
