# ORACLE APEX APLIKACIJOS STRUKTŪRA
## Ligoninės Valdymo Sistema

**Platform:** Oracle APEX 22.1.0
**Database Schema:** 15 esybių
**Versija:** 1.0

---

## NAVIGACIJOS STRUKTŪRA

### Pagrindinis Menu

```
🏠 HOME (Page 1)
│
├── 👥 PACIENTAI (Page 100-199)
│   ├── 101 - Pacientų Registras
│   ├── 102 - Naujo Paciento Registracija
│   ├── 103 - Paciento Profilis (Master-Detail)
│   ├── 104 - Hospitalizuoti Pacientai
│   └── 105 - Vizitų Kalendorius
│
├── 👨‍⚕️ PERSONALAS (Page 200-299)
│   ├── 201 - Gydytojų Katalogas
│   ├── 202 - Gydytojo Profilis
│   ├── 203 - Medicinos Seserų Sąrašas
│   ├── 204 - Darbuotojų Grafikas
│   └── 205 - Darbuotojų Valdymas (HR)
│
├── 🏥 SKYRIAI (Page 300-399)
│   ├── 301 - Skyrių Valdymas
│   ├── 302 - Palatų Valdymas
│   ├── 303 - Lovų Užimtumo Dashboard
│   └── 304 - Skyriaus Statistika
│
├── 💊 MEDICININĖ INFORMACIJA (Page 400-499)
│   ├── 401 - Diagnozių Katalogas
│   ├── 402 - Paciento Diagnozės
│   ├── 403 - Laboratoriniai Tyrimai
│   ├── 404 - Tyrimo Rezultatai
│   ├── 405 - Receptų Valdymas
│   └── 406 - Vaistų Katalogas
│
├── 💰 FINANSAI (Page 500-599)
│   ├── 501 - Sąskaitų Registras
│   ├── 502 - Mokėjimų Priėmimas
│   ├── 503 - Nepamokėtos Sąskaitos
│   ├── 504 - Pajamų Ataskaitos
│   └── 505 - Finansinė Statistika
│
└── ⚙️ ADMINISTRAVIMAS (Page 900-999)
    ├── 901 - Sistemos Nustatymai
    ├── 902 - Vartotojų Valdymas
    ├── 903 - Audit Log
    └── 904 - Stock Alerts
```

---

## DETALI PUSLAPIŲ SPECIFIKACIJA

### 🏠 HOME - Dashboard (Page 1)

**Puslapio Tipas:** Dashboard
**Duomenų Šaltiniai:** v_dashboard_stats

**Regions:**

1. **KPI Cards (4 korteles eilutėje)**
   ```sql
   - Aktyvių Pacientų: SELECT total_active_patients FROM v_dashboard_stats
   - Užimtų Lovų: SELECT occupied_beds FROM v_dashboard_stats
   - Šiandien Vizitų: SELECT today_appointments FROM v_dashboard_stats
   - Nepamokėtos Sąskaitos: SELECT total_outstanding FROM v_dashboard_stats
   ```

2. **Charts Region**
   - **Priėmimų Tendencijos (Line Chart)**
     ```sql
     SELECT admission_date, COUNT(*) as admissions
     FROM admissions
     WHERE admission_date >= ADD_MONTHS(SYSDATE, -6)
     GROUP BY admission_date
     ORDER BY admission_date
     ```

   - **Pajamos pagal Skyrių (Bar Chart)**
     ```sql
     SELECT d.department_name, SUM(b.paid_amount) as revenue
     FROM bills b
     JOIN admissions a ON b.admission_id = a.admission_id
     JOIN beds bd ON a.bed_id = bd.bed_id
     JOIN rooms r ON bd.room_id = r.room_id
     JOIN departments d ON r.department_id = d.department_id
     WHERE TRUNC(b.payment_date) >= TRUNC(ADD_MONTHS(SYSDATE, -1))
     GROUP BY d.department_name
     ORDER BY revenue DESC
     ```

3. **Lists Region**
   - **Artėjantys Vizitai**
     ```sql
     SELECT * FROM v_appointments_calendar
     WHERE appointment_date = TRUNC(SYSDATE)
     AND status IN ('SCHEDULED', 'CONFIRMED')
     ORDER BY appointment_time
     ```

---

### 👥 PACIENTAI

#### Page 101 - Pacientų Registras

**Puslapio Tipas:** Interactive Report
**Duomenų Šaltinis:** v_patients_full

**Features:**
- Search Bar (last_name, first_name, insurance_number)
- Filtrai: is_active, city, blood_type
- Column Headers: ID, Vardas, Pavardė, Amžius, Tel., Email, Registracijos Data
- Link to Details: patient_id → Page 103
- Actions: Edit (Page 102), Delete (with confirmation)

**SQL Query:**
```sql
SELECT
    patient_id,
    full_name,
    age,
    gender_display,
    blood_type,
    phone_number,
    email,
    insurance_number,
    registration_date,
    currently_admitted,
    total_appointments,
    outstanding_balance
FROM v_patients_full
WHERE is_active = 'Y'
ORDER BY last_name, first_name
```

**Column Formatting:**
- `currently_admitted = 'Y'` → 🔴 Red badge "Hospitalizuotas"
- `outstanding_balance > 0` → ⚠️ Warning icon
- `age` → Color coding (< 18: blue, 18-65: green, > 65: orange)

---

#### Page 102 - Naujo Paciento Registracija

**Puslapio Tipas:** Form
**Table:** patients
**Mode:** Create / Edit

**Form Items:**

**Asmens Informacija:**
- P102_FIRST_NAME (Text, Required)
- P102_LAST_NAME (Text, Required)
- P102_DATE_OF_BIRTH (Date Picker, Required)
- P102_GENDER (Radio Group: M/F/O, Required)
- P102_BLOOD_TYPE (Select List: A+, A-, B+, B-, AB+, AB-, O+, O-)

**Kontaktinė Informacija:**
- P102_EMAIL (Email)
- P102_PHONE_NUMBER (Text, Required, Format: +370 XXX XXXXX)
- P102_ADDRESS (Textarea)
- P102_CITY (Text)
- P102_POSTAL_CODE (Text)

**Draudimo Informacija:**
- P102_INSURANCE_NUMBER (Text)

**Avariniai Kontaktai:**
- P102_EMERGENCY_CONTACT_NAME (Text)
- P102_EMERGENCY_CONTACT_PHONE (Text)

**Validations:**
- Email format validation
- Phone number format validation (Lithuanian)
- Date of birth < SYSDATE
- Age >= 0

**Process:**
```sql
INSERT INTO patients (
    first_name, last_name, date_of_birth, gender, blood_type,
    email, phone_number, address, city, postal_code,
    insurance_number, emergency_contact_name, emergency_contact_phone
) VALUES (
    :P102_FIRST_NAME, :P102_LAST_NAME, :P102_DATE_OF_BIRTH,
    :P102_GENDER, :P102_BLOOD_TYPE, :P102_EMAIL, :P102_PHONE_NUMBER,
    :P102_ADDRESS, :P102_CITY, :P102_POSTAL_CODE,
    :P102_INSURANCE_NUMBER, :P102_EMERGENCY_CONTACT_NAME,
    :P102_EMERGENCY_CONTACT_PHONE
);
```

**Success Message:** "Pacientas sėkmingai užregistruotas!"
**Branch:** Redirect to Page 103 (Patient Profile) passing patient_id

---

#### Page 103 - Paciento Profilis

**Puslapio Tipas:** Master-Detail (Tabs)
**Master Table:** patients
**Detail Tables:** appointments, admissions, patient_diagnoses, prescriptions, lab_tests, bills

**Tab Structure:**

**Tab 1: Pagrindinė Informacija**
- Display Only forma su paciento info
- Edit button → Page 102

**Tab 2: Vizitai (Appointments)**
- Interactive Report
  ```sql
  SELECT * FROM v_appointments_calendar
  WHERE patient_id = :P103_PATIENT_ID
  ORDER BY appointment_date DESC, appointment_time DESC
  ```
- Button "Naujas Vizitas" → Modal dialog

**Tab 3: Hospitalizacijos (Admissions)**
- Interactive Report
  ```sql
  SELECT * FROM v_admissions_current
  WHERE patient_id = :P103_PATIENT_ID
  ORDER BY admission_date DESC
  ```
- Highlight current admission (status = 'ADMITTED')

**Tab 4: Diagnozės (Diagnoses)**
- Interactive Report
  ```sql
  SELECT * FROM v_patient_diagnoses_full
  WHERE patient_id = :P103_PATIENT_ID
  ORDER BY diagnosis_date DESC
  ```
- Button "Nauja Diagnozė" → Modal (only for doctors)

**Tab 5: Receptai (Prescriptions)**
- Interactive Report
  ```sql
  SELECT * FROM v_prescriptions_full
  WHERE patient_id = :P103_PATIENT_ID
  ORDER BY prescription_date DESC
  ```
- Filter: Active / All
- Button "Naujas Receptas" → Modal

**Tab 6: Laboratoriniai Tyrimai (Lab Tests)**
- Interactive Report
  ```sql
  SELECT * FROM v_lab_tests_full
  WHERE patient_id = :P103_PATIENT_ID
  ORDER BY test_date DESC
  ```
- Status badges (colored)
- View Results link

**Tab 7: Sąskaitos (Bills)**
- Interactive Grid (editable paid_amount)
  ```sql
  SELECT * FROM v_bills_detailed
  WHERE patient_id = :P103_PATIENT_ID
  ORDER BY bill_date DESC
  ```
- Sum footer: Total Outstanding Balance
- Button "Priimti Mokėjimą" → Page 502

---

### 👨‍⚕️ PERSONALAS

#### Page 201 - Gydytojų Katalogas

**Puslapio Tipas:** Cards / Interactive Report
**Duomenų Šaltinis:** v_doctors_full

**Card View:**
- Photo placeholder
- Doctor Name (large)
- Specialization
- Department
- Consultation Fee
- Available for Emergency badge
- "View Profile" button → Page 202
- "Book Appointment" button → Page 105

**SQL Query:**
```sql
SELECT
    doctor_id,
    full_name,
    specialization,
    department_name,
    consultation_fee,
    years_of_experience,
    available_for_emergency,
    email,
    phone_number,
    today_appointments
FROM v_doctors_full
WHERE employment_status = 'ACTIVE'
ORDER BY department_name, last_name
```

**Filters:**
- Department (Select List)
- Specialization (Select List)
- Available for Emergency (Checkbox)

---

#### Page 202 - Gydytojo Profilis

**Puslapio Tipas:** Master-Detail
**Master:** doctors (join employees)

**Sections:**

1. **Doctor Information (Display Only)**
   - Name, Specialization, License Number
   - Department, Years of Experience
   - Education, Contact Info

2. **Today's Schedule (Interactive Report)**
   ```sql
   SELECT * FROM v_appointments_calendar
   WHERE doctor_id = :P202_DOCTOR_ID
   AND appointment_date = TRUNC(SYSDATE)
   ORDER BY appointment_time
   ```

3. **Statistics (Cards)**
   - Total Patients Treated
   - Total Revenue (This Month)
   - Average Rating (if implemented)
   - Completed Appointments

4. **Calendar Region**
   - Monthly view of all appointments
   - Color-coded by status

---

### 🏥 SKYRIAI

#### Page 303 - Lovų Užimtumo Dashboard

**Puslapio Tipas:** Interactive Grid / Visual Board
**Duomenų Šaltinis:** v_beds_occupancy

**Layout:** Grid view su spalvomis

**SQL Query:**
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
ORDER BY department_name, room_number, bed_number
```

**Visual Representation:**
```
┌─────────────────────────────────────┐
│ KARDIOLOGIJA (A korpusas, 3 aukštas)│
├─────────────────────────────────────┤
│ A301 (Private)                      │
│  └─ [🟢 Laisva] Lova 1              │
│                                     │
│ A302 (Semi-Private)                 │
│  ├─ [🔴 Užimta] Lova 1              │
│  │   Petras Sabonis (3 dienos)     │
│  └─ [🟢 Laisva] Lova 2              │
│                                     │
│ A303 (ICU)                          │
│  ├─ [🔴 Užimta] Lova 1              │
│  ├─ [🟢 Laisva] Lova 2              │
│  ├─ [🟠 Remontuojama] Lova 3        │
│  └─ [🔵 Rezervuota] Lova 4          │
└─────────────────────────────────────┘
```

**Features:**
- Click on bed → Quick Admission Form (modal)
- Filter by Department
- Filter by Status
- Show only available beds checkbox

**Summary Cards:**
- Total Beds: COUNT(*)
- Available: COUNT(WHERE status = 'AVAILABLE')
- Occupied: COUNT(WHERE status = 'OCCUPIED')
- Occupancy Rate: (Occupied / Total) * 100%

---

### 💊 MEDICININĖ INFORMACIJA

#### Page 405 - Receptų Valdymas

**Puslapio Tipas:** Interactive Report + Form
**Duomenų Šaltinis:** v_prescriptions_full

**Interactive Report:**
```sql
SELECT * FROM v_prescriptions_full
WHERE (:P405_PATIENT_ID IS NULL OR patient_id = :P405_PATIENT_ID)
  AND (:P405_DOCTOR_ID IS NULL OR doctor_id = :P405_DOCTOR_ID)
  AND (:P405_STATUS IS NULL OR status = :P405_STATUS)
  AND (:P405_IS_EXPIRED IS NULL OR is_expired = :P405_IS_EXPIRED)
ORDER BY prescription_date DESC
```

**Filters:**
- P405_PATIENT_ID (Autocomplete)
- P405_DOCTOR_ID (Autocomplete)
- P405_STATUS (Select List)
- P405_IS_EXPIRED (Checkbox)

**Form (Modal Dialog) - Naujas Receptas:**

**Items:**
- P405_PATIENT_ID (Popup LOV from patients)
- P405_MEDICATION_ID (Popup LOV from medications - show name, strength, stock)
- P405_DOSAGE (Text, e.g., "500mg")
- P405_FREQUENCY (Text, e.g., "2 kartus per dieną")
- P405_DURATION_DAYS (Number, 1-365)
- P405_QUANTITY (Number, calculated from duration * frequency)
- P405_REFILLS_ALLOWED (Number, 0-12)
- P405_INSTRUCTIONS (Textarea)

**Validation:**
- Check medication availability (stock_quantity >= quantity)
- Check if medication requires_prescription = 'Y'

**Process:**
```sql
INSERT INTO prescriptions (
    patient_id, doctor_id, medication_id,
    prescription_date, dosage, frequency, duration_days,
    quantity, refills_allowed, instructions, status
) VALUES (
    :P405_PATIENT_ID,
    :APP_USER_DOCTOR_ID, -- from session
    :P405_MEDICATION_ID,
    SYSDATE,
    :P405_DOSAGE,
    :P405_FREQUENCY,
    :P405_DURATION_DAYS,
    :P405_QUANTITY,
    :P405_REFILLS_ALLOWED,
    :P405_INSTRUCTIONS,
    'ACTIVE'
);
```

**Success:** Trigger will automatically reduce medication stock

---

#### Page 406 - Vaistų Katalogas

**Puslapio Tipas:** Interactive Grid (editable)
**Table:** medications

**Columns:**
- medication_name (editable)
- generic_name (editable)
- manufacturer (editable)
- category (select list, editable)
- unit_price (number, editable)
- **stock_quantity** (number, editable, highlighted if <= minimum_stock_level)
- minimum_stock_level (number, editable)
- dosage_form (select list, editable)
- strength (text, editable)
- requires_prescription (checkbox, editable)
- is_available (checkbox, editable)

**Conditional Formatting:**
- stock_quantity <= minimum_stock_level → 🔴 Red background
- stock_quantity > minimum_stock_level AND < (minimum_stock_level * 2) → 🟡 Yellow
- is_available = 'N' → Gray out entire row

**Actions:**
- Bulk Update Stock
- Generate Reorder Report (PDF)

**Summary:**
- Low Stock Items: COUNT(WHERE stock_quantity <= minimum_stock_level)
- Out of Stock: COUNT(WHERE stock_quantity = 0)
- Total Medications: COUNT(*)

---

### 💰 FINANSAI

#### Page 501 - Sąskaitų Registras

**Puslapio Tipas:** Interactive Report
**Duomenų Šaltinis:** v_bills_detailed

**SQL Query:**
```sql
SELECT
    bill_id,
    bill_date,
    due_date,
    patient_name,
    bill_source,
    total_amount,
    paid_amount,
    balance,
    payment_status_lt,
    is_overdue,
    days_overdue
FROM v_bills_detailed
WHERE (:P501_PAYMENT_STATUS IS NULL OR payment_status = :P501_PAYMENT_STATUS)
  AND (:P501_PATIENT_ID IS NULL OR patient_id = :P501_PATIENT_ID)
  AND (:P501_DATE_FROM IS NULL OR bill_date >= :P501_DATE_FROM)
  AND (:P501_DATE_TO IS NULL OR bill_date <= :P501_DATE_TO)
ORDER BY bill_date DESC
```

**Filters:**
- P501_PAYMENT_STATUS (Select List)
- P501_PATIENT_ID (Autocomplete)
- P501_DATE_FROM, P501_DATE_TO (Date Range)

**Conditional Formatting:**
- payment_status = 'PAID' → 🟢 Green row
- payment_status = 'OVERDUE' → 🔴 Red row, bold
- payment_status = 'PARTIAL' → 🟡 Yellow row

**Aggregates:**
- SUM(total_amount)
- SUM(paid_amount)
- SUM(balance)

**Actions:**
- View Bill Details
- Print Invoice (PDF)
- Record Payment → Page 502
- Send Reminder (Email) - for overdue bills

---

#### Page 502 - Mokėjimų Priėmimas

**Puslapio Tipas:** Form
**Table:** bills (UPDATE)

**Form Items:**

**Display Only:**
- P502_BILL_ID
- P502_PATIENT_NAME
- P502_BILL_DATE
- P502_TOTAL_AMOUNT
- P502_PAID_AMOUNT (current)
- P502_BALANCE (current)

**Editable:**
- P502_PAYMENT_AMOUNT (Number, Required, <= :P502_BALANCE)
- P502_PAYMENT_METHOD (Select List: CASH, CARD, INSURANCE, BANK_TRANSFER)
- P502_PAYMENT_NOTES (Textarea)

**Calculation (Dynamic):**
- New Paid Amount = :P502_PAID_AMOUNT + :P502_PAYMENT_AMOUNT
- New Balance = :P502_TOTAL_AMOUNT - New Paid Amount

**Process:**
```sql
UPDATE bills
SET paid_amount = paid_amount + :P502_PAYMENT_AMOUNT,
    payment_method = :P502_PAYMENT_METHOD,
    notes = notes || CHR(10) || 'Mokėjimas: ' || :P502_PAYMENT_AMOUNT ||
            ' (' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') || '). ' ||
            :P502_PAYMENT_NOTES
WHERE bill_id = :P502_BILL_ID;
```

**Trigger:** trg_bill_payment_status automatiškai atnaujins payment_status

**Success Message:** "Mokėjimas sėkmingai priimtas!"
**Print Receipt:** Button to generate PDF receipt

---

#### Page 504 - Pajamų Ataskaitos

**Puslapio Tipas:** Dashboard / Reports

**Regions:**

1. **Pajamų Suvestinė (Cards)**
   ```sql
   SELECT
       SUM(CASE WHEN TRUNC(payment_date) = TRUNC(SYSDATE)
           THEN paid_amount ELSE 0 END) as today_revenue,
       SUM(CASE WHEN TRUNC(payment_date) >= TRUNC(SYSDATE, 'MM')
           THEN paid_amount ELSE 0 END) as month_revenue,
       SUM(CASE WHEN TRUNC(payment_date) >= TRUNC(SYSDATE, 'YYYY')
           THEN paid_amount ELSE 0 END) as year_revenue
   FROM bills
   WHERE payment_status IN ('PAID', 'PARTIAL')
   ```

2. **Pajamos per Laiką (Line Chart)**
   ```sql
   SELECT
       TRUNC(payment_date) as payment_day,
       SUM(paid_amount) as daily_revenue
   FROM bills
   WHERE payment_date >= ADD_MONTHS(SYSDATE, -3)
   GROUP BY TRUNC(payment_date)
   ORDER BY payment_day
   ```

3. **Pajamos pagal Šaltinį (Pie Chart)**
   ```sql
   SELECT
       CASE
           WHEN admission_id IS NOT NULL THEN 'Hospitalizacija'
           WHEN appointment_id IS NOT NULL THEN 'Vizitas'
           ELSE 'Kita'
       END as revenue_source,
       SUM(paid_amount) as amount
   FROM bills
   WHERE payment_status IN ('PAID', 'PARTIAL')
     AND TRUNC(payment_date) >= TRUNC(SYSDATE, 'MM')
   GROUP BY CASE
           WHEN admission_id IS NOT NULL THEN 'Hospitalizacija'
           WHEN appointment_id IS NOT NULL THEN 'Vizitas'
           ELSE 'Kita'
       END
   ```

4. **Top 10 Pacientų pagal Išlaidas (Bar Chart)**
   ```sql
   SELECT
       p.first_name || ' ' || p.last_name as patient_name,
       SUM(b.total_amount) as total_spent
   FROM bills b
   JOIN patients p ON b.patient_id = p.patient_id
   GROUP BY p.patient_id, p.first_name, p.last_name
   ORDER BY total_spent DESC
   FETCH FIRST 10 ROWS ONLY
   ```

**Export Options:**
- PDF Report (APEX Office Print)
- Excel Export
- CSV Download

---

### ⚙️ ADMINISTRAVIMAS

#### Page 903 - Audit Log

**Puslapio Tipas:** Interactive Report (Read-Only)
**Table:** audit_log

**SQL Query:**
```sql
SELECT
    audit_id,
    table_name,
    operation,
    record_id,
    changed_by,
    changed_date,
    old_values,
    new_values
FROM audit_log
WHERE (:P903_TABLE_NAME IS NULL OR table_name = :P903_TABLE_NAME)
  AND (:P903_OPERATION IS NULL OR operation = :P903_OPERATION)
  AND (:P903_DATE_FROM IS NULL OR changed_date >= :P903_DATE_FROM)
  AND (:P903_DATE_TO IS NULL OR changed_date <= :P903_DATE_TO)
ORDER BY changed_date DESC
```

**Features:**
- Filter by Table Name
- Filter by Operation (INSERT/UPDATE/DELETE)
- Date Range Filter
- View JSON diff (modal dialog)

---

#### Page 904 - Stock Alerts

**Puslapio Tipas:** Interactive Report
**Table:** medication_stock_alerts

**SQL Query:**
```sql
SELECT
    alert_id,
    medication_name,
    current_stock,
    minimum_level,
    alert_date,
    CASE
        WHEN current_stock = 0 THEN 'Išsekęs'
        WHEN current_stock < minimum_level THEN 'Kritinis'
        ELSE 'Žemas'
    END as alert_level
FROM medication_stock_alerts
ORDER BY alert_date DESC
```

**Actions:**
- Mark as Resolved
- Reorder (link to supplier system)
- Update Stock → Page 406

---

## APEX KOMPONENAI IR FEATURES

### Authorization Schemes

```sql
-- ADMIN
BEGIN
    RETURN apex_util.current_user_in_group('ADMIN');
END;

-- DOCTOR
BEGIN
    RETURN apex_util.current_user_in_group('DOCTOR') OR
           apex_util.current_user_in_group('ADMIN');
END;

-- NURSE
BEGIN
    RETURN apex_util.current_user_in_group('NURSE') OR
           apex_util.current_user_in_group('ADMIN');
END;

-- BILLING
BEGIN
    RETURN apex_util.current_user_in_group('BILLING') OR
           apex_util.current_user_in_group('ADMIN');
END;
```

### Application Items

- **APP_USER_ID** - Current user employee_id
- **APP_USER_ROLE** - User role (ADMIN/DOCTOR/NURSE/BILLING)
- **APP_USER_DOCTOR_ID** - Doctor ID (if user is doctor)
- **APP_USER_DEPARTMENT_ID** - User's department
- **APP_CURRENT_DATE** - System date

### Application Processes

**On New Instance:**
```sql
BEGIN
    -- Set user info
    :APP_USER_ID := get_employee_id(:APP_USER);
    :APP_USER_ROLE := get_user_role(:APP_USER);

    -- If doctor, set doctor_id
    IF :APP_USER_ROLE = 'DOCTOR' THEN
        SELECT doctor_id INTO :APP_USER_DOCTOR_ID
        FROM doctors
        WHERE doctor_id = :APP_USER_ID;
    END IF;
END;
```

### LOV (List of Values)

**Patients LOV:**
```sql
SELECT patient_id as d,
       first_name || ' ' || last_name ||
       ' (' || insurance_number || ')' as r
FROM patients
WHERE is_active = 'Y'
ORDER BY last_name, first_name
```

**Doctors LOV:**
```sql
SELECT doctor_id as d,
       e.first_name || ' ' || e.last_name ||
       ' - ' || d.specialization as r
FROM doctors d
JOIN employees e ON d.doctor_id = e.employee_id
WHERE e.employment_status = 'ACTIVE'
ORDER BY e.last_name
```

**Medications LOV:**
```sql
SELECT medication_id as d,
       medication_name || ' (' || strength || ') - ' ||
       'Stock: ' || stock_quantity as r
FROM medications
WHERE is_available = 'Y'
ORDER BY medication_name
```

### Dynamic Actions

**Example: Calculate Total Cost on Prescription Form**
```javascript
// When P405_QUANTITY or P405_MEDICATION_ID changes
// Get unit_price from medications
// Calculate: P405_TOTAL_COST = unit_price * quantity

var medicationId = $v('P405_MEDICATION_ID');
var quantity = $v('P405_QUANTITY');

if (medicationId && quantity) {
    apex.server.process('GET_MEDICATION_PRICE', {
        x01: medicationId
    }, {
        success: function(data) {
            var unitPrice = data.unit_price;
            var totalCost = unitPrice * quantity;
            $s('P405_TOTAL_COST', totalCost.toFixed(2));
        }
    });
}
```

### Plugins (Recommended)

1. **APEX Office Print** - PDF/Excel generation
2. **APEX Calendar** - Enhanced calendar views
3. **Chart Plugins** - Advanced visualizations
4. **QR Code Generator** - For patient/prescription IDs
5. **Barcode Scanner** - For medication tracking

---

## SAUGUMO NUSTATYMAI

### Page Level Authorization

| Page Range | Authorization | Description |
|------------|--------------|-------------|
| 100-199 | IS_AUTHENTICATED | Visi autentifikuoti vartotojai |
| 200-299 | IS_HR_OR_ADMIN | Tik HR ar Admin |
| 300-399 | IS_ADMIN | Tik Administratoriai |
| 400-499 | IS_MEDICAL_STAFF | Gydytojai ir Seserys |
| 500-599 | IS_BILLING_OR_ADMIN | Buhalterija ar Admin |
| 900-999 | IS_ADMIN | Tik Administratoriai |

### Row Level Security

**Example:** Gydytojai mato tik savo skyriaus pacientus
```sql
-- VPD Policy
CREATE OR REPLACE FUNCTION patient_security_policy(
    schema_var IN VARCHAR2,
    table_var IN VARCHAR2
) RETURN VARCHAR2 IS
    v_user_role VARCHAR2(50);
    v_dept_id NUMBER;
BEGIN
    v_user_role := V('APP_USER_ROLE');

    IF v_user_role = 'ADMIN' THEN
        RETURN NULL; -- No restriction
    ELSIF v_user_role = 'DOCTOR' THEN
        v_dept_id := V('APP_USER_DEPARTMENT_ID');
        RETURN 'patient_id IN (
            SELECT DISTINCT patient_id
            FROM admissions a
            JOIN beds b ON a.bed_id = b.bed_id
            JOIN rooms r ON b.room_id = r.room_id
            WHERE r.department_id = ' || v_dept_id || '
        )';
    END IF;

    RETURN '1=0'; -- Deny by default
END;
```

---

## PERFORMANCE OPTIMIZATION

### Computed Columns
- Use VIRTUAL columns for calculations (e.g., bills.balance)
- Materialize complex views for reports

### Caching
- Enable APEX caching for static LOVs
- Cache dashboard queries (5 min refresh)

### Pagination
- Use row limiting (FETCH FIRST N ROWS)
- Enable lazy loading for large reports

### Indexes
- All foreign keys indexed ✓
- Composite indexes for common queries ✓
- Function-based indexes for computed fields

---

## DEPLOYMENT CHECKLIST

### Pre-deployment
- [ ] Run all DDL scripts in order
- [ ] Verify all triggers are valid
- [ ] Verify all views are valid
- [ ] Insert sample data (optional)
- [ ] Create users and assign roles
- [ ] Configure email settings (APEX_MAIL)

### APEX Application Import
- [ ] Import application export file
- [ ] Configure workspace
- [ ] Set up authentication scheme
- [ ] Configure authorization schemes
- [ ] Test all pages
- [ ] Verify LOVs are working
- [ ] Test PDF generation
- [ ] Verify email notifications

### Post-deployment
- [ ] User acceptance testing
- [ ] Performance testing
- [ ] Security audit
- [ ] Backup strategy
- [ ] Monitoring setup

---

**Pastaba:** Ši dokumentacija aprašo visų puslapių logiką ir struktūrą. Faktinė APEX aplikacija turės būti sukurta rankiniu būdu arba importuota iš export failo, naudojant šią dokumentaciją kaip specifikaciją.
