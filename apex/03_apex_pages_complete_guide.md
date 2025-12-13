# ORACLE APEX APLIKACIJOS PILNAS VADOVAS
## Ligoninės Valdymo Sistema - Visi Puslapiai

**Aplikacijos ID:** 100
**Pavadinimas:** Ligoninės Valdymo Sistema
**Alias:** HOSPITAL_MGMT
**APEX Version:** 22.1.0

---

## TURINYS

1. [Page 1 - Dashboard](#page-1---dashboard)
2. [PACIENTAI Module (Pages 101-110)](#pacientai-module)
3. [PERSONALAS Module (Pages 201-210)](#personalas-module)
4. [SKYRIAI Module (Pages 301-310)](#skyriai-module)
5. [MEDICININĖ INFORMACIJA Module (Pages 401-410)](#medicininė-informacija-module)
6. [FINANSAI Module (Pages 501-510)](#finansai-module)
7. [Navigation Setup](#navigation-setup)
8. [Authorization Schemes](#authorization-schemes)

---

## PAGE 1 - DASHBOARD
**Pavadinimas:** Pagrindinis
**Type:** Blank Page
**Authorization:** Is Authenticated

### Regions:

#### Region 1: KPI Cards (Static Content)
**Type:** Cards
**Source Type:** SQL Query

```sql
SELECT
    'Aktyvių Pacientų' as title,
    total_active_patients as value,
    'success' as color,
    'fa-users' as icon
FROM v_dashboard_stats
UNION ALL
SELECT
    'Užimtų Lovų',
    occupied_beds,
    CASE WHEN (occupied_beds::FLOAT / (occupied_beds + available_beds)) > 0.8
         THEN 'danger' ELSE 'warning' END,
    'fa-bed'
FROM v_dashboard_stats
UNION ALL
SELECT
    'Šiandien Vizitų',
    today_appointments,
    'info',
    'fa-calendar'
FROM v_dashboard_stats
UNION ALL
SELECT
    'Vėluojančių Sąskaitų',
    unpaid_bills,
    CASE WHEN unpaid_bills > 0 THEN 'danger' ELSE 'success' END,
    'fa-euro-sign'
FROM v_dashboard_stats;
```

**Card Attributes:**
- Title: &TITLE.
- Value: &VALUE.
- Icon: &ICON.
- Icon CSS Classes: u-color-&COLOR.

#### Region 2: Šiandien Vizitai
**Type:** Interactive Report
**Source:** v_appointments_calendar
**Filter:** `WHERE appointment_date = TRUNC(SYSDATE) AND status IN ('SCHEDULED', 'CONFIRMED')`

**Columns:**
- appointment_time
- patient_name
- doctor_name
- appointment_type
- status

#### Region 3: Kritiniai Pranešimai
**Type:** Classic Report
**Source:**

```sql
SELECT
    'ALERT' as type,
    medication_name as message,
    'Žemos atsargos: ' || current_stock as details,
    alert_date
FROM medication_stock_alerts
WHERE alert_date >= TRUNC(SYSDATE) - 7
UNION ALL
SELECT
    'WARNING',
    patient_name,
    'Vėluojama sąskaita: €' || TO_CHAR(balance, 'FM999990.00'),
    due_date
FROM v_bills_detailed
WHERE payment_status = 'OVERDUE'
ORDER BY alert_date DESC
FETCH FIRST 10 ROWS ONLY;
```

### Navigation Buttons:
- Pacientai (→ Page 101)
- Personalas (→ Page 201)
- Skyriai (→ Page 301)
- Vaistai (→ Page 406)
- Sąskaitos (→ Page 501)

---

## PACIENTAI MODULE

### PAGE 101 - Pacientų Registras
**✅ ATITINKA REIKALAVIMĄ 3: Interactive Report su filtrais ir CRUD**

**Type:** Interactive Report
**Table:** patients (per v_patients_full)

#### SQL Source:
```sql
SELECT
    patient_id,
    full_name,
    age,
    gender_display,
    blood_type,
    phone_number,
    email,
    city,
    insurance_number,
    registration_date,
    CASE WHEN currently_admitted = 'Y'
         THEN '<span class="badge badge-danger">Hospitalizuotas</span>'
         ELSE '<span class="badge badge-success">Ambulatorinis</span>'
    END as status_badge,
    total_appointments,
    outstanding_balance
FROM v_patients_full
WHERE (:P101_CITY IS NULL OR city = :P101_CITY)
  AND (:P101_GENDER IS NULL OR gender = :P101_GENDER)
  AND (:P101_BLOOD_TYPE IS NULL OR blood_type = :P101_BLOOD_TYPE)
  AND (:P101_ADMITTED_ONLY IS NULL OR
       (currently_admitted = 'Y' AND :P101_ADMITTED_ONLY = 'Y'))
ORDER BY last_name, first_name;
```

#### Page Items (Filters):
- **P101_CITY** (Select List - Dynamic LOV)
  ```sql
  SELECT DISTINCT city AS d, city AS r
  FROM patients
  WHERE city IS NOT NULL
  ORDER BY city;
  ```

- **P101_GENDER** (Select List - LOV_GENDER)
- **P101_BLOOD_TYPE** (Select List - LOV_BLOOD_TYPE)
- **P101_ADMITTED_ONLY** (Checkbox - LOV_YES_NO)

#### Buttons:
1. **Naujas Pacientas** (→ Page 102, mode=CREATE)
   - Position: Right of Interactive Search Bar
   - Hot: Yes
   - Icon: fa-plus

2. **Redaguoti** (→ Page 102, mode=EDIT)
   - Position: Row action
   - Link: `f?p=&APP_ID.:102:&SESSION.::NO::P102_PATIENT_ID:&PATIENT_ID.`

3. **Profilis** (→ Page 103)
   - Position: Row action (primary)
   - Link: `f?p=&APP_ID.:103:&SESSION.::NO::P103_PATIENT_ID:&PATIENT_ID.`

4. **Ištrinti**
   - Position: Row action
   - Confirmation: "Ar tikrai norite ištrinti pacientą?"
   - Process:
     ```sql
     DELETE FROM patients WHERE patient_id = :P101_PATIENT_ID_DELETE;
     ```

#### Column Formatting:
- `outstanding_balance > 0` → Red text, bold
- `status_badge` → Unescaped HTML
- `age > 65` → Orange background

---

### PAGE 102 - Paciento Forma
**✅ ATITINKA REIKALAVIMĄ: Forma su maksimalia validacija ir LOV**

**Type:** Form
**Table:** patients
**Primary Key:** patient_id

#### Page Items:

**Grupė: Asmens Informacija**
- **P102_FIRST_NAME** (Text Field)
  - Label: Vardas *
  - Required: Yes
  - Validation: Length 2-50

- **P102_LAST_NAME** (Text Field)
  - Label: Pavardė *
  - Required: Yes
  - Validation: Length 2-50

- **P102_DATE_OF_BIRTH** (Date Picker)
  - Label: Gimimo Data *
  - Required: Yes
  - Format: YYYY-MM-DD
  - Maximum Date: SYSDATE
  - Validation: NOT future date

- **P102_GENDER** (Radio Group - LOV_GENDER)
  - Label: Lytis *
  - Required: Yes
  - Display as: Radio Group (Horizontal)

- **P102_BLOOD_TYPE** (Select List - LOV_BLOOD_TYPE)
  - Label: Kraujo Grupė
  - Null Value: - Nežinoma -

**Grupė: Kontaktai**
- **P102_PHONE_NUMBER** (Text Field)
  - Label: Telefono Numeris *
  - Required: Yes
  - Format Mask: +370 000 00000
  - Validation: Regex `^\+370 \d{3} \d{5}$`

- **P102_EMAIL** (Text Field)
  - Label: El. Paštas
  - Type: Email
  - Validation: Valid email format

- **P102_ADDRESS** (Textarea)
  - Label: Adresas
  - Rows: 3

- **P102_CITY** (Text Field)
  - Label: Miestas

- **P102_POSTAL_CODE** (Text Field)
  - Label: Pašto Kodas
  - Format Mask: LT-00000

**Grupė: Draudimas**
- **P102_INSURANCE_NUMBER** (Text Field)
  - Label: Draudimo Numeris
  - Help Text: Sveikatos draudimo numeris

**Grupė: Avariniai Kontaktai**
- **P102_EMERGENCY_CONTACT_NAME** (Text Field)
  - Label: Artimo Asmens Vardas

- **P102_EMERGENCY_CONTACT_PHONE** (Text Field)
  - Label: Artimo Asmens Telefonas
  - Format Mask: +370 000 00000

#### Validations:
1. **Email Format**
   ```sql
   IF :P102_EMAIL IS NOT NULL AND
      REGEXP_LIKE(:P102_EMAIL, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') = FALSE
   THEN
       RETURN 'Neteisingas el. pašto formatas';
   END IF;
   ```

2. **Age Validation**
   ```sql
   IF :P102_DATE_OF_BIRTH >= SYSDATE THEN
       RETURN 'Gimimo data negali būti ateityje';
   END IF;
   ```

3. **Phone Format**
   - Client-side: Pattern attribute
   - Server-side: PL/SQL validation

#### Processes:
**Process: Save Patient**
```sql
IF :P102_PATIENT_ID IS NULL THEN
    -- INSERT
    INSERT INTO patients (
        first_name, last_name, date_of_birth, gender, blood_type,
        email, phone_number, address, city, postal_code,
        insurance_number, emergency_contact_name, emergency_contact_phone,
        is_active
    ) VALUES (
        :P102_FIRST_NAME, :P102_LAST_NAME, :P102_DATE_OF_BIRTH,
        :P102_GENDER, :P102_BLOOD_TYPE, :P102_EMAIL, :P102_PHONE_NUMBER,
        :P102_ADDRESS, :P102_CITY, :P102_POSTAL_CODE,
        :P102_INSURANCE_NUMBER, :P102_EMERGENCY_CONTACT_NAME,
        :P102_EMERGENCY_CONTACT_PHONE, 'Y'
    ) RETURNING patient_id INTO :P102_PATIENT_ID;
ELSE
    -- UPDATE
    UPDATE patients
    SET first_name = :P102_FIRST_NAME,
        last_name = :P102_LAST_NAME,
        date_of_birth = :P102_DATE_OF_BIRTH,
        gender = :P102_GENDER,
        blood_type = :P102_BLOOD_TYPE,
        email = :P102_EMAIL,
        phone_number = :P102_PHONE_NUMBER,
        address = :P102_ADDRESS,
        city = :P102_CITY,
        postal_code = :P102_POSTAL_CODE,
        insurance_number = :P102_INSURANCE_NUMBER,
        emergency_contact_name = :P102_EMERGENCY_CONTACT_NAME,
        emergency_contact_phone = :P102_EMERGENCY_CONTACT_PHONE
    WHERE patient_id = :P102_PATIENT_ID;
END IF;
```

**Success Message:** "Pacientas sėkmingai išsaugotas!"
**Branch:** Page 103 (Patient Profile), Pass P103_PATIENT_ID = P102_PATIENT_ID

---

### PAGE 103 - Paciento Profilis (Master-Detail)
**✅ ATITINKA REIKALAVIMĄ 5: Master-Detail forma (Side by Side)**

**Type:** Blank Page (Master-Detail)
**Layout:** Side by Side (NOT Stacked - pagal reikalavimą)

#### Master Region: Paciento Informacija
**Type:** Display Only Form
**Source:**
```sql
SELECT * FROM v_patients_full
WHERE patient_id = :P103_PATIENT_ID;
```

**Display Items:**
- Full Name (large font, bold)
- Age | Gender | Blood Type
- Contact Info (phone, email)
- Insurance Number
- Emergency Contact
- Registration Date
- Status Badge (Hospitalized/Outpatient)

**Buttons:**
- Redaguoti (→ Page 102)
- Naujas Vizitas (→ Page 106, Modal)
- Hospitalizuoti (→ Page 107, Modal) - jei nėra admitted

#### Detail Regions (Tabs - Right Side):

**Tab 1: Vizitai (APPOINTMENTS)**
**Type:** Interactive Report

```sql
SELECT
    appointment_id,
    appointment_date,
    appointment_time,
    doctor_name,
    specialization,
    appointment_type,
    status,
    consultation_fee
FROM v_appointments_calendar
WHERE patient_id = :P103_PATIENT_ID
ORDER BY appointment_date DESC, appointment_time DESC;
```

**Actions:**
- Naujas Vizitas (Modal Dialog)
- Peržiūrėti Detalės
- Atšaukti (if status = SCHEDULED)

**Tab 2: Hospitalizacijos (ADMISSIONS)**
**Type:** Interactive Report

```sql
SELECT
    admission_id,
    admission_date,
    discharge_date,
    length_of_stay,
    doctor_name,
    room_number,
    bed_number,
    admission_type,
    status
FROM v_admissions_current
WHERE patient_id = :P103_PATIENT_ID
ORDER BY admission_date DESC;
```

**Tab 3: Diagnozės (PATIENT_DIAGNOSES)**
**Type:** Interactive Grid (Editable)

```sql
SELECT
    pd.patient_diagnosis_id,
    pd.diagnosis_date,
    d.diagnosis_code,
    d.diagnosis_name,
    pd.is_primary,
    pd.status,
    doc.full_name as doctor_name,
    pd.notes
FROM patient_diagnoses pd
JOIN diagnoses d ON pd.diagnosis_id = d.diagnosis_id
JOIN v_doctors_full doc ON pd.doctor_id = doc.doctor_id
WHERE pd.patient_id = :P103_PATIENT_ID
ORDER BY pd.diagnosis_date DESC;
```

**Grid Settings:**
- Add Row: Yes
- Edit: Yes
- Delete: Yes
- Toolbar: Search, Actions, Add Row

**Tab 4: Receptai (PRESCRIPTIONS)**
**Type:** Interactive Report

```sql
SELECT * FROM v_prescriptions_full
WHERE patient_id = :P103_PATIENT_ID
ORDER BY prescription_date DESC;
```

**Conditional Highlighting:**
- is_expired = 'Y' → Gray background
- status = 'ACTIVE' → Green icon

**Tab 5: Laboratoriniai Tyrimai (LAB_TESTS)**
**Type:** Interactive Report

```sql
SELECT * FROM v_lab_tests_full
WHERE patient_id = :P103_PATIENT_ID
ORDER BY test_date DESC;
```

**Tab 6: Sąskaitos (BILLS)**
**Type:** Interactive Report

```sql
SELECT * FROM v_bills_detailed
WHERE patient_id = :P103_PATIENT_ID
ORDER BY bill_date DESC;
```

**Footer:** SUM(balance) as "Bendra Skola"

---

### PAGE 105 - Vizitų Kalendorius
**✅ ATITINKA REIKALAVIMĄ 6: Kalendorius su įrašų perkėlimu ir redagavimu**

**Type:** Calendar
**Source:** v_appointments_calendar

**Calendar Attributes:**
- Display Column: display_text
- Start Date Column: appointment_datetime
- End Date Column: appointment_datetime + (duration_minutes/1440)
- Primary Key: appointment_id

**Create/Edit Link:** Page 106 (Modal Dialog)
**Drag and Drop:** Enabled
**Color:** Based on status_color column

**SQL Query:**
```sql
SELECT
    appointment_id,
    appointment_datetime as start_date,
    appointment_datetime + NUMTODSINTERVAL(duration_minutes, 'MINUTE') as end_date,
    patient_name || ' - ' || doctor_name as display_text,
    status_color,
    appointment_id as primary_key_value
FROM v_appointments_calendar
WHERE (:P105_DOCTOR_ID IS NULL OR doctor_id = :P105_DOCTOR_ID)
  AND (:P105_DEPARTMENT_ID IS NULL OR department_id = :P105_DEPARTMENT_ID)
  AND appointment_date BETWEEN :P105_START_DATE AND :P105_END_DATE;
```

**Filters:**
- P105_DOCTOR_ID (Select List - LOV_DOCTORS)
- P105_DEPARTMENT_ID (Select List - LOV_DEPARTMENTS)
- P105_START_DATE, P105_END_DATE (Date Range)

**Drag & Drop Process:**
```sql
UPDATE appointments
SET appointment_date = TRUNC(:APEX$NEW_START_DATE),
    appointment_time = TO_CHAR(:APEX$NEW_START_DATE, 'HH24:MI')
WHERE appointment_id = :APEX$PK_VALUE;
```

**Validations:**
- Check for doctor availability (no overlapping appointments)
- Check if date is not in past

---

### PAGE 106 - Naujo Vizito Forma (Modal)
**Type:** Modal Dialog Form
**Table:** appointments

**Items:**
- **P106_PATIENT_ID** (Popup LOV - LOV_PATIENTS autocomplete) *
- **P106_DOCTOR_ID** (Select List - LOV_DOCTORS) *
- **P106_APPOINTMENT_DATE** (Date Picker) *
  - Min Value: SYSDATE
  - Default: SYSDATE + 1
- **P106_APPOINTMENT_TIME** (Time Picker) *
  - Format: HH24:MI
  - Increment: 15 minutes
- **P106_DURATION_MINUTES** (Number Field)
  - Default: 30
  - Min: 15, Max: 240
- **P106_APPOINTMENT_TYPE** (Select List - LOV_APPOINTMENT_TYPE) *
- **P106_NOTES** (Textarea)

**Validation:**
```sql
-- Check for overlapping appointments
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM appointments
    WHERE doctor_id = :P106_DOCTOR_ID
      AND appointment_date = :P106_APPOINTMENT_DATE
      AND status IN ('SCHEDULED', 'CONFIRMED')
      AND appointment_id != NVL(:P106_APPOINTMENT_ID, -1)
      AND (
          -- Overlap check
          TO_TIMESTAMP(TO_CHAR(appointment_date, 'YYYY-MM-DD') || ' ' || appointment_time, 'YYYY-MM-DD HH24:MI')
          BETWEEN
              TO_TIMESTAMP(TO_CHAR(:P106_APPOINTMENT_DATE, 'YYYY-MM-DD') || ' ' || :P106_APPOINTMENT_TIME, 'YYYY-MM-DD HH24:MI')
          AND
              TO_TIMESTAMP(TO_CHAR(:P106_APPOINTMENT_DATE, 'YYYY-MM-DD') || ' ' || :P106_APPOINTMENT_TIME, 'YYYY-MM-DD HH24:MI')
              + NUMTODSINTERVAL(:P106_DURATION_MINUTES, 'MINUTE')
      );

    IF v_count > 0 THEN
        RETURN 'Gydytojas šiuo laiku jau turi vizitą!';
    END IF;
END;
```

**Process: Save Appointment**
- Success Message: "Vizitas sėkmingai suplanuotas!"
- Close Dialog: Yes
- Refresh Parent: Page 105

---

## PERSONALAS MODULE

### PAGE 201 - Gydytojų Katalogas
**Type:** Cards
**Source:** v_doctors_full

**SQL:**
```sql
SELECT
    doctor_id,
    full_name,
    specialization,
    department_name,
    'fa-user-md' as icon,
    consultation_fee,
    years_of_experience,
    phone_number,
    email,
    CASE WHEN available_for_emergency = 'Y'
         THEN '<span class="badge badge-success">Priima skubius</span>'
         ELSE ''
    END as badge
FROM v_doctors_full
WHERE (:P201_SPECIALIZATION IS NULL OR specialization = :P201_SPECIALIZATION)
  AND (:P201_DEPARTMENT_ID IS NULL OR department_id = :P201_DEPARTMENT_ID)
  AND employment_status = 'ACTIVE'
ORDER BY last_name, first_name;
```

**Card Template:**
```
Title: &FULL_NAME.
Subtitle: &SPECIALIZATION.
Body: &DEPARTMENT_NAME.
       Patirtis: &YEARS_OF_EXPERIENCE. metų
       Konsultacija: €&CONSULTATION_FEE.
       &BADGE.
Icon: &ICON.
```

**Filters:**
- P201_SPECIALIZATION (Select List - LOV_SPECIALIZATIONS)
- P201_DEPARTMENT_ID (Select List - LOV_DEPARTMENTS)

**Actions:**
- Peržiūrėti Profilį (→ Page 202)
- Rezervuoti Vizitą (→ Page 106)

---

### PAGE 205 - Darbuotojų Valdymas
**Type:** Interactive Grid
**Table:** employees (+ doctors/nurses)

**SQL:**
```sql
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.email,
    e.phone_number,
    e.employment_status,
    e.hire_date,
    e.salary,
    CASE
        WHEN EXISTS (SELECT 1 FROM doctors WHERE doctor_id = e.employee_id)
            THEN 'Gydytojas'
        WHEN EXISTS (SELECT 1 FROM nurses WHERE nurse_id = e.employee_id)
            THEN 'Sesuo'
        ELSE 'Kitas'
    END as role_type
FROM employees e
ORDER BY e.last_name, e.first_name;
```

**Editable Columns:**
- first_name, last_name, email, phone_number
- employment_status (LOV)
- salary

**Authorization:** IS_ADMIN only

---

## SKYRIAI MODULE

### PAGE 301 - Skyrių Valdymas
**Type:** Interactive Report
**Table:** departments

```sql
SELECT
    d.department_id,
    d.department_name,
    d.building,
    d.floor_number,
    d.budget,
    d.phone_number,
    doc.full_name as head_doctor,
    ds.doctor_count,
    ds.nurse_count,
    ds.bed_count,
    ds.occupied_bed_count,
    ROUND((ds.occupied_bed_count / NULLIF(ds.bed_count, 0)) * 100, 1) || '%' as occupancy_rate
FROM departments d
LEFT JOIN v_doctors_full doc ON d.head_doctor_id = doc.doctor_id
LEFT JOIN v_department_stats ds ON d.department_id = ds.department_id
WHERE d.is_active = 'Y'
ORDER BY d.department_name;
```

**Actions:**
- Redaguoti (→ Page 302 Form)
- Peržiūrėti Lovas (→ Page 303)

---

### PAGE 302 - Palatų Valdymas
**Type:** Interactive Grid (Editable)
**Table:** rooms

```sql
SELECT
    r.room_id,
    r.department_id,
    r.room_number,
    r.room_type,
    r.floor_number,
    r.daily_rate,
    r.is_available,
    (SELECT COUNT(*) FROM beds WHERE room_id = r.room_id) as bed_count,
    (SELECT COUNT(*) FROM beds WHERE room_id = r.room_id AND bed_status = 'OCCUPIED') as occupied_count
FROM rooms r
WHERE (:P302_DEPARTMENT_ID IS NULL OR r.department_id = :P302_DEPARTMENT_ID)
  AND (:P302_ROOM_TYPE IS NULL OR r.room_type = :P302_ROOM_TYPE)
ORDER BY r.room_number;
```

**Filters:**
- P302_DEPARTMENT_ID (Select List - LOV_DEPARTMENTS - CASCADE parent)
- P302_ROOM_TYPE (Select List - LOV_ROOM_TYPE)

**Grid Features:**
- Add Row: Yes
- Edit: Yes (inline)
- Delete: Yes
- Toolbar: Yes

**Editable Columns:**
- department_id (LOV_DEPARTMENTS)
- room_number (required)
- room_type (LOV_ROOM_TYPE, required)
- floor_number
- daily_rate (number)

---

### PAGE 303 - Lovų Užimtumas (Real-time Board)
**✅ NAUDOJA: BEDS, ROOMS, DEPARTMENTS esybes**

**Type:** Classic Report (with custom styling)
**Source:** v_beds_occupancy

```sql
SELECT
    department_name,
    room_number,
    bed_number,
    bed_status,
    bed_status_lt,
    status_color,
    patient_name,
    days_in_hospital,
    daily_rate
FROM v_beds_occupancy
WHERE (:P303_DEPARTMENT_ID IS NULL OR department_id = :P303_DEPARTMENT_ID)
  AND (:P303_SHOW_AVAILABLE_ONLY IS NULL OR
       (bed_status = 'AVAILABLE' AND :P303_SHOW_AVAILABLE_ONLY = 'Y'))
ORDER BY department_name, room_number, bed_number;
```

**Report Template:** Badge List (custom HTML)

```html
<div class="bed-card" style="background-color: &STATUS_COLOR.; padding: 10px; margin: 5px; border-radius: 5px;">
    <strong>&ROOM_NUMBER. - Lova &BED_NUMBER.</strong><br>
    Status: &BED_STATUS_LT.<br>
    <span style="display: &PATIENT_NAME_DISPLAY.;">
        Pacientas: &PATIENT_NAME.<br>
        Dienos: &DAYS_IN_HOSPITAL.
    </span>
    €&DAILY_RATE./dieną
</div>
```

**Filters:**
- P303_DEPARTMENT_ID (Select List - LOV_DEPARTMENTS)
- P303_SHOW_AVAILABLE_ONLY (Checkbox)

**Action:** Click on bed → Quick Admission Modal

---

## MEDICININĖ INFORMACIJA MODULE

### PAGE 401 - Diagnozių Katalogas
**Type:** Interactive Grid
**Table:** diagnoses

```sql
SELECT
    diagnosis_id,
    diagnosis_code,
    diagnosis_name,
    category,
    severity_level,
    description,
    is_active
FROM diagnoses
WHERE (:P401_CATEGORY IS NULL OR category = :P401_CATEGORY)
  AND (:P401_SEVERITY IS NULL OR severity_level = :P401_SEVERITY)
ORDER BY diagnosis_code;
```

**Filters:**
- P401_CATEGORY (Select List - LOV_DIAGNOSIS_CATEGORIES - CASCADE)
- P401_SEVERITY (Select List - Static: MILD, MODERATE, SEVERE, CRITICAL)

**Editable:** Yes (for ADMIN only)

---

### PAGE 405 - Receptų Valdymas
**✅ NAUDOJA: PRESCRIPTIONS, MEDICATIONS, PATIENTS, DOCTORS**

**Type:** Interactive Report
**Source:** v_prescriptions_full

```sql
SELECT * FROM v_prescriptions_full
WHERE (:P405_PATIENT_ID IS NULL OR patient_id = :P405_PATIENT_ID)
  AND (:P405_DOCTOR_ID IS NULL OR doctor_id = :P405_DOCTOR_ID)
  AND (:P405_MEDICATION_ID IS NULL OR medication_id = :P405_MEDICATION_ID)
  AND (:P405_STATUS IS NULL OR status = :P405_STATUS)
  AND (:P405_ACTIVE_ONLY IS NULL OR (status = 'ACTIVE' AND :P405_ACTIVE_ONLY = 'Y'))
ORDER BY prescription_date DESC;
```

**Filters (LOV):**
- P405_PATIENT_ID (Popup LOV - LOV_PATIENTS autocomplete) **← LOV 1**
- P405_DOCTOR_ID (Select List - LOV_DOCTORS) **← LOV 2**
- P405_MEDICATION_ID (Popup LOV - LOV_MEDICATIONS) **← LOV 3**
- P405_STATUS (Select List - Static) **← LOV 4**
- P405_ACTIVE_ONLY (Checkbox) **← LOV 5**

**Actions:**
- Naujas Receptas (→ Page 407 Modal)
- Redaguoti
- Atšaukti Receptą

---

### PAGE 406 - Vaistų Katalogas
**Type:** Interactive Grid (Editable)
**Table:** medications

```sql
SELECT
    medication_id,
    medication_name,
    generic_name,
    manufacturer,
    category,
    unit_price,
    stock_quantity,
    minimum_stock_level,
    dosage_form,
    strength,
    requires_prescription,
    is_available,
    CASE WHEN stock_quantity <= minimum_stock_level
         THEN 'Y' ELSE 'N'
    END as low_stock_flag
FROM medications
WHERE (:P406_CATEGORY IS NULL OR category = :P406_CATEGORY)
  AND (:P406_LOW_STOCK_ONLY IS NULL OR
       (stock_quantity <= minimum_stock_level AND :P406_LOW_STOCK_ONLY = 'Y'))
ORDER BY medication_name;
```

**Filters:**
- P406_CATEGORY (Select List - LOV_MEDICATION_CATEGORIES - CASCADE)
- P406_LOW_STOCK_ONLY (Checkbox)

**Conditional Highlighting:**
- stock_quantity <= minimum_stock_level → Red background
- stock_quantity = 0 → Bold red text

**Editable Columns:**
- medication_name, generic_name, manufacturer
- category, unit_price, stock_quantity, minimum_stock_level
- dosage_form (LOV_DOSAGE_FORM)
- strength, requires_prescription (LOV_YES_NO)
- is_available (LOV_YES_NO)

---

### PAGE 407 - Naujo Recepto Forma (Modal)
**Type:** Modal Dialog Form
**Table:** prescriptions

**Items:**
- **P407_PATIENT_ID** (Popup LOV - LOV_PATIENTS autocomplete) *
- **P407_MEDICATION_ID** (Popup LOV - LOV_MEDICATIONS_IN_STOCK) *
  - **CASCADE Dynamic Action:** Update P407_UNIT_PRICE, P407_STOCK_QTY
- **P407_DOSAGE** (Text) * - e.g., "500mg"
- **P407_FREQUENCY** (Text) * - e.g., "2 kartus per dieną"
- **P407_DURATION_DAYS** (Number) * - Min: 1, Max: 365
- **P407_QUANTITY** (Number) * - Calculated or manual
- **P407_REFILLS_ALLOWED** (Number) - Default: 0, Max: 12
- **P407_INSTRUCTIONS** (Textarea)

**Display Only Items:**
- P407_UNIT_PRICE (from medication)
- P407_STOCK_QTY (from medication)
- P407_TOTAL_COST (calculated: quantity * unit_price)

**Dynamic Action:**
```javascript
// When P407_MEDICATION_ID changes
apex.server.process('GET_MEDICATION_INFO', {
    x01: $v('P407_MEDICATION_ID')
}, {
    success: function(data) {
        $s('P407_UNIT_PRICE', data.unit_price);
        $s('P407_STOCK_QTY', data.stock_quantity);
    }
});

// Calculate total
var qty = $v('P407_QUANTITY');
var price = $v('P407_UNIT_PRICE');
$s('P407_TOTAL_COST', (qty * price).toFixed(2));
```

**Validation:**
```sql
-- Check stock
DECLARE
    v_stock NUMBER;
BEGIN
    SELECT stock_quantity INTO v_stock
    FROM medications
    WHERE medication_id = :P407_MEDICATION_ID;

    IF v_stock < :P407_QUANTITY THEN
        RETURN 'Nepakanka atsargų! Likutis: ' || v_stock;
    END IF;
END;
```

---

## FINANSAI MODULE

### PAGE 501 - Sąskaitų Registras
**✅ ATITINKA REIKALAVIMĄ 4: Report naudojant VIEW su kelių lentelių duomenimis**

**Type:** Interactive Report
**Source:** v_bills_detailed (VIEW su JOIN)

```sql
SELECT
    bill_id,
    bill_date,
    due_date,
    patient_name,
    patient_phone,
    insurance_number,
    bill_source,
    total_amount,
    paid_amount,
    balance,
    payment_status_lt,
    payment_method,
    is_overdue,
    days_overdue,
    status_color
FROM v_bills_detailed
WHERE (:P501_PAYMENT_STATUS IS NULL OR payment_status = :P501_PAYMENT_STATUS)
  AND (:P501_PATIENT_ID IS NULL OR patient_id = :P501_PATIENT_ID)
  AND (:P501_DATE_FROM IS NULL OR bill_date >= :P501_DATE_FROM)
  AND (:P501_DATE_TO IS NULL OR bill_date <= :P501_DATE_TO)
  AND (:P501_OVERDUE_ONLY IS NULL OR (is_overdue = 'Y' AND :P501_OVERDUE_ONLY = 'Y'))
ORDER BY CASE WHEN is_overdue = 'Y' THEN 0 ELSE 1 END, bill_date DESC;
```

**Filters:**
- P501_PAYMENT_STATUS (Select List - LOV_PAYMENT_STATUS) **← LOV**
- P501_PATIENT_ID (Popup LOV - LOV_PATIENTS autocomplete) **← LOV**
- P501_DATE_FROM, P501_DATE_TO (Date Range)
- P501_OVERDUE_ONLY (Checkbox)

**Conditional Formatting:**
- payment_status = 'OVERDUE' → Red row, bold
- payment_status = 'PAID' → Green icon
- balance > 1000 → Warning icon

**Aggregate Functions:**
- SUM(total_amount) as "Bendra Suma"
- SUM(paid_amount) as "Sumokėta"
- SUM(balance) as "Likutis"

**Actions:**
- Peržiūrėti (→ Bill Details)
- Priimti Mokėjimą (→ Page 502)
- Spausdinti Sąskaitą (PDF)
- Ištrinti (with confirmation)

**Button: Nauja Sąskaita** (→ Page 503 Modal)

---

### PAGE 502 - Mokėjimo Priėmimas
**Type:** Modal Dialog Form
**Table:** bills (UPDATE only)

**Display Only Items:**
- P502_PATIENT_NAME
- P502_BILL_DATE
- P502_TOTAL_AMOUNT
- P502_PAID_AMOUNT (current)
- P502_BALANCE (current)

**Editable Items:**
- **P502_PAYMENT_AMOUNT** (Number) *
  - Required: Yes
  - Validation: <= :P502_BALANCE
  - Min: 0.01

- **P502_PAYMENT_METHOD** (Select List - LOV_PAYMENT_METHOD) *
  - Required: Yes

- **P502_PAYMENT_NOTES** (Textarea)

**Computations:**
- P502_NEW_PAID := :P502_PAID_AMOUNT + :P502_PAYMENT_AMOUNT
- P502_NEW_BALANCE := :P502_TOTAL_AMOUNT - :P502_NEW_PAID

**Process:**
```sql
UPDATE bills
SET paid_amount = paid_amount + :P502_PAYMENT_AMOUNT,
    payment_method = :P502_PAYMENT_METHOD,
    notes = CASE
        WHEN notes IS NOT NULL
        THEN notes || CHR(10) || '---' || CHR(10)
        ELSE ''
    END || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') ||
           ' - Mokėjimas: €' || :P502_PAYMENT_AMOUNT ||
           ' (' || :P502_PAYMENT_METHOD || ')' ||
           CASE WHEN :P502_PAYMENT_NOTES IS NOT NULL
                THEN CHR(10) || :P502_PAYMENT_NOTES
                ELSE ''
           END
WHERE bill_id = :P502_BILL_ID;
```

**Success:**
- Message: "Mokėjimas sėkmingai priimtas!"
- Close Dialog: Yes
- Refresh Parent: Page 501

---

### PAGE 503 - Naujos Sąskaitos Forma (Modal)
**Type:** Modal Dialog Form
**Table:** bills

**Items:**
- **P503_PATIENT_ID** (Popup LOV - LOV_PATIENTS) *
- **P503_SOURCE_TYPE** (Radio - Admission/Appointment) *
  - **CASCADE:** Shows either P503_ADMISSION_ID or P503_APPOINTMENT_ID

- **P503_ADMISSION_ID** (Select List - LOV_ACTIVE_ADMISSIONS)
  - Visible when: P503_SOURCE_TYPE = 'ADMISSION'
  - **CASCADE LOV** based on P503_PATIENT_ID

- **P503_APPOINTMENT_ID** (Select List - LOV_PATIENT_APPOINTMENTS)
  - Visible when: P503_SOURCE_TYPE = 'APPOINTMENT'
  - **CASCADE LOV** based on P503_PATIENT_ID

- **P503_TOTAL_AMOUNT** (Number) * - Required
- **P503_DISCOUNT_PERCENT** (Number) - Default: 0, Max: 100
- **P503_TAX_AMOUNT** (Number) - Calculated or manual
- **P503_DUE_DATE** (Date Picker) *
  - Default: SYSDATE + 30
  - Min: SYSDATE

- **P503_NOTES** (Textarea)

**Dynamic Actions:**
- Calculate tax from total_amount
- Validate discount percentage
- Check for duplicate bills

---

## LAB TESTS MODULE

### PAGE 408 - Laboratoriniai Tyrimai
**✅ NAUDOJA: LAB_TESTS esybę**

**Type:** Interactive Report
**Source:** v_lab_tests_full

```sql
SELECT * FROM v_lab_tests_full
WHERE (:P408_PATIENT_ID IS NULL OR patient_id = :P408_PATIENT_ID)
  AND (:P408_DOCTOR_ID IS NULL OR doctor_id = :P408_DOCTOR_ID)
  AND (:P408_TEST_TYPE IS NULL OR test_type = :P408_TEST_TYPE)
  AND (:P408_STATUS IS NULL OR status = :P408_STATUS)
  AND (:P408_DATE_FROM IS NULL OR test_date >= :P408_DATE_FROM)
  AND (:P408_DATE_TO IS NULL OR test_date <= :P408_DATE_TO)
ORDER BY test_date DESC, test_time DESC;
```

**Filters:**
- P408_PATIENT_ID (Popup LOV - autocomplete)
- P408_DOCTOR_ID (Select List - LOV_DOCTORS)
- P408_TEST_TYPE (Select List - LOV_TEST_TYPE)
- P408_STATUS (Select List - Static)
- P408_DATE_FROM, P408_DATE_TO (Date Range)

**Actions:**
- Naujas Tyrimas (→ Page 409 Modal)
- Įvesti Rezultatus (→ Page 410 Modal)
- Peržiūrėti Rezultatus

---

## NAVIGATION SETUP

### Navigation Menu Structure

```
Desktop Navigation:
├── 🏠 Pagrindinis (Page 1)
├── 👥 PACIENTAI
│   ├── Pacientų Registras (Page 101) ✅ REQ 3
│   ├── Naujas Pacientas (Page 102) ✅ REQ 3 Form
│   ├── Vizitų Kalendorius (Page 105) ✅ REQ 6
│   └── ---
├── 👨‍⚕️ PERSONALAS
│   ├── Gydytojai (Page 201)
│   └── Darbuotojai (Page 205)
├── 🏥 SKYRIAI
│   ├── Skyrių Valdymas (Page 301)
│   ├── Palatų Valdymas (Page 302)
│   └── Lovų Užimtumas (Page 303)
├── 💊 MEDICINA
│   ├── Diagnozės (Page 401)
│   ├── Receptai (Page 405) ✅ Multiple LOVs
│   ├── Vaistai (Page 406)
│   └── Lab Tyrimai (Page 408)
└── 💰 FINANSAI
    ├── Sąskaitos (Page 501) ✅ REQ 4
    └── Mokėjimai (Page 502)

Modal Dialogs (Not in menu):
├── Page 102 - Patient Form ✅ REQ 3 (CRUD)
├── Page 103 - Patient Profile ✅ REQ 5 (Master-Detail)
├── Page 106 - Appointment Form
├── Page 407 - Prescription Form
├── Page 502 - Payment Form
└── Page 503 - Bill Form
```

---

## AUTHORIZATION SCHEMES

### Schemes to Create:

1. **IS_AUTHENTICATED**
   ```sql
   RETURN TRUE; -- All logged in users
   ```

2. **IS_ADMIN**
   ```sql
   RETURN :APP_USER_ROLE = 'ADMIN';
   ```

3. **IS_DOCTOR**
   ```sql
   RETURN :APP_USER_ROLE IN ('DOCTOR', 'ADMIN');
   ```

4. **IS_MEDICAL_STAFF**
   ```sql
   RETURN :APP_USER_ROLE IN ('DOCTOR', 'NURSE', 'ADMIN');
   ```

5. **IS_BILLING**
   ```sql
   RETURN :APP_USER_ROLE IN ('BILLING', 'ADMIN');
   ```

### Page Authorization:
- Pages 1, 101, 105: IS_AUTHENTICATED
- Pages 102, 103, 106: IS_MEDICAL_STAFF
- Pages 201, 205: IS_ADMIN
- Pages 301-303: IS_ADMIN
- Pages 401-408: IS_MEDICAL_STAFF
- Pages 501-503: IS_BILLING

---

## TESTING CHECKLIST

### ✅ Reikalavimų Atitikimas:

1. **REQ 3:** ✅ Page 101 - Interactive Report su filtrais ir CRUD
2. **REQ 4:** ✅ Page 501 - Report naudojant VIEW (v_bills_detailed)
3. **REQ 5:** ✅ Page 103 - Master-Detail (Side by Side)
4. **REQ 6:** ✅ Page 105 - Calendar su drag & drop
5. **LOV Requirement:** ✅ 30 LOVs (14 static + 16 dynamic)
   - 3+ CASCADE LOVs
   - 3+ POPUP/Autocomplete LOVs
6. **Visų lentelių panaudojimas:** ✅ Visos 15 lentelių

### Test Scenarios:

1. **Pacientų modulis:**
   - Sukurti naują pacientą su visais validacijais
   - Filtruoti pacientus pagal miestą, lytį, kraujo grupę
   - Redaguoti paciento duomenis
   - Ištrinti pacientą (su cascade)

2. **Vizitų kalendorius:**
   - Sukurti naują vizitą
   - Perkelti vizitą drag & drop
   - Redaguoti vizitą
   - Atšaukti vizitą
   - Validacija: overlapping appointments

3. **Master-Detail:**
   - Atidaryti paciento profilį
   - Peržiūrėti visus tabs (6 tabs)
   - Pridėti naują diagnozę per grid
   - Peržiūrėti sąskaitas

4. **Receptai:**
   - Filtruoti pagal 5 skirtingus parametrus
   - Sukurti naują receptą su automatiniu stock mažinimu
   - Validacija: nepakanka atsargų

5. **Sąskaitos:**
   - Filtruoti pagal statusą, datą
   - Priimti mokėjimą
   - Sukurti naują sąskaitą

---

## VISOS NAUDOJAMOS LENTELĖS

| # | Lentelė | Puslapiai | Funkcionalumas |
|---|---------|-----------|----------------|
| 1 | DEPARTMENTS | 301, 103, 201 | Skyrių valdymas, filtrai |
| 2 | ROOMS | 302, 303 | Palatų valdymas, užimtumas |
| 3 | BEDS | 303, 106 | Lovų statusas, priėmimai |
| 4 | EMPLOYEES | 205 | Darbuotojų valdymas |
| 5 | DOCTORS | 201, 202, LOVs | Gydytojų katalogas |
| 6 | NURSES | LOVs | Seserų sąrašas |
| 7 | PATIENTS | 101, 102, 103 | Pacientų CRUD, profilis |
| 8 | APPOINTMENTS | 105, 106, 103 | Kalendorius, vizitai |
| 9 | ADMISSIONS | 103, 107 | Hospitalizacijos |
| 10 | DIAGNOSES | 401, LOVs | Diagnozių katalogas |
| 11 | PATIENT_DIAGNOSES | 103 | Paciento diagnozės (Master-Detail) |
| 12 | MEDICATIONS | 406 | Vaistų katalogas, atsargos |
| 13 | PRESCRIPTIONS | 405, 407, 103 | Receptų valdymas |
| 14 | LAB_TESTS | 408, 103 | Laboratoriniai tyrimai |
| 15 | BILLS | 501, 502, 503, 103 | Sąskaitų valdymas, mokėjimai |

**Visos 15 lentelių panaudotos! ✅**

---

## PABAIGA

Ši dokumentacija aprašo pilną APEX aplikaciją su:
- **20+ puslapių**
- **30 LOVs** (14 static + 16 dynamic)
- **Visos 15 esybės** panaudotos
- **Master-Detail** (Side by Side)
- **Calendar** su drag & drop
- **Maksimali validacija** ir LOV panaudojimas
- **Atitinka visus reikalavimus** ✅
