-- ============================================================================
-- ORACLE APEX - LIST OF VALUES (LOV)
-- Ligoninės Valdymo Sistema
-- Oracle APEX 22.1.0
-- ============================================================================
-- Šis scriptas aprašo visus LOV, kurie bus naudojami aplikacijoje
-- LOV sukuriami per APEX Builder: Shared Components > List of Values
-- ============================================================================

-- ============================================================================
-- STATIC LOV (7 LOVs)
-- ============================================================================

-- LOV 1: GENDER (Lytis)
-- Type: Static
-- Used in: Patient Form, Employee Form
/*
Display Value          Return Value
-----------------      -------------
Vyras                  M
Moteris                F
Kita                   O
*/

-- LOV 2: BLOOD_TYPE (Kraujo grupė)
-- Type: Static
-- Used in: Patient Form
/*
Display Value          Return Value
-----------------      -------------
A+                     A+
A-                     A-
B+                     B+
B-                     B-
AB+                    AB+
AB-                    AB-
O+                     O+
O-                     O-
*/

-- LOV 3: ROOM_TYPE (Palatos tipas)
-- Type: Static
-- Used in: Room Form, Filters
/*
Display Value              Return Value
-----------------------    --------------
Vienvietė                  PRIVATE
Dvivietė                   SEMI_PRIVATE
Intensyvi terapija         ICU
Skubios pagalbos           EMERGENCY
Operacinė                  OPERATING
*/

-- LOV 4: BED_STATUS (Lovos statusas)
-- Type: Static
-- Used in: Bed Management, Filters
/*
Display Value          Return Value
-----------------      -------------
Laisva                 AVAILABLE
Užimta                 OCCUPIED
Remontuojama           MAINTENANCE
Rezervuota             RESERVED
*/

-- LOV 5: APPOINTMENT_TYPE (Vizito tipas)
-- Type: Static
-- Used in: Appointment Form
/*
Display Value              Return Value
-----------------------    --------------
Profilaktinis              CHECKUP
Konsultacija               CONSULTATION
Pakartotinis               FOLLOWUP
Skubus                     EMERGENCY
*/

-- LOV 6: APPOINTMENT_STATUS (Vizito statusas)
-- Type: Static
-- Used in: Appointment Form, Filters
/*
Display Value          Return Value
-----------------      -------------
Suplanuotas            SCHEDULED
Patvirtintas           CONFIRMED
Įvykęs                 COMPLETED
Atšauktas              CANCELLED
Neatvyko               NO_SHOW
*/

-- LOV 7: PAYMENT_STATUS (Mokėjimo statusas)
-- Type: Static
-- Used in: Bills Report, Filters
/*
Display Value          Return Value
-----------------      -------------
Neapmokėta             UNPAID
Dalinai apmokėta       PARTIAL
Apmokėta               PAID
Vėluojama              OVERDUE
*/

-- LOV 8: PAYMENT_METHOD (Mokėjimo būdas)
-- Type: Static
-- Used in: Payment Form
/*
Display Value              Return Value
-----------------------    --------------
Grynais                    CASH
Kortele                    CARD
Draudimas                  INSURANCE
Banko pavedimas            BANK_TRANSFER
*/

-- LOV 9: EMPLOYMENT_STATUS (Darbo statusas)
-- Type: Static
-- Used in: Employee Form, Filters
/*
Display Value          Return Value
-----------------      -------------
Dirba                  ACTIVE
Atostogose             ON_LEAVE
Nebedirba              TERMINATED
*/

-- LOV 10: SHIFT_PREFERENCE (Pamaina)
-- Type: Static
-- Used in: Nurse Form
/*
Display Value          Return Value
-----------------      -------------
Dieninė                DAY
Naktinė                NIGHT
Kintama                ROTATING
*/

-- LOV 11: DOSAGE_FORM (Vaisto forma)
-- Type: Static
-- Used in: Medication Form
/*
Display Value          Return Value
-----------------      -------------
Tabletė                TABLET
Kapsulė                CAPSULE
Injekcija              INJECTION
Sirupas                SYRUP
Kremas                 CREAM
Lašai                  DROPS
Inhaliatorius          INHALER
*/

-- LOV 12: TEST_TYPE (Tyrimo tipas)
-- Type: Static
-- Used in: Lab Test Form
/*
Display Value              Return Value
-----------------------    --------------
Kraujo tyrimas             BLOOD
Šlapimo tyrimas            URINE
Rentgenas                  XRAY
MRI                        MRI
Kompiuterinė tomografija   CT_SCAN
Echoskopija                ULTRASOUND
Elektrokardiograma         ECG
Elektroencefalograma       EEG
Biopsija                   BIOPSY
*/

-- LOV 13: ADMISSION_TYPE (Priėmimo tipas)
-- Type: Static
-- Used in: Admission Form
/*
Display Value          Return Value
-----------------      -------------
Skubus                 EMERGENCY
Planuotas              PLANNED
Perkėlimas             TRANSFER
*/

-- LOV 14: YES_NO (Taip/Ne)
-- Type: Static
-- Used in: Various forms
/*
Display Value          Return Value
-----------------      -------------
Taip                   Y
Ne                     N
*/

-- ============================================================================
-- DYNAMIC LOV (10+ LOVs)
-- ============================================================================

-- LOV 15: DEPARTMENTS (Skyriai)
-- Type: Dynamic
-- Used in: Forms, Filters
-- SQL Query:
SELECT
    department_name AS display_value,
    department_id AS return_value
FROM departments
WHERE is_active = 'Y'
ORDER BY department_name;

-- LOV 16: DOCTORS (Gydytojai)
-- Type: Dynamic
-- Used in: Appointment Form, Admission Form, etc.
-- SQL Query:
SELECT
    e.first_name || ' ' || e.last_name || ' (' || d.specialization || ')' AS display_value,
    d.doctor_id AS return_value
FROM doctors d
JOIN employees e ON d.doctor_id = e.employee_id
WHERE e.employment_status = 'ACTIVE'
ORDER BY e.last_name, e.first_name;

-- LOV 17: DOCTORS_BY_DEPARTMENT (Gydytojai pagal skyrių) - CASCADE LOV
-- Type: Dynamic (Cascade from Department)
-- Parent: P_DEPARTMENT_ID
-- SQL Query:
SELECT
    e.first_name || ' ' || e.last_name || ' - ' || d.specialization AS display_value,
    d.doctor_id AS return_value
FROM doctors d
JOIN employees e ON d.doctor_id = e.employee_id
WHERE e.employment_status = 'ACTIVE'
  AND d.department_id = :P_DEPARTMENT_ID
ORDER BY e.last_name, e.first_name;

-- LOV 18: NURSES (Medicinos seserys)
-- Type: Dynamic
-- SQL Query:
SELECT
    e.first_name || ' ' || e.last_name || ' (' || n.certification_level || ')' AS display_value,
    n.nurse_id AS return_value
FROM nurses n
JOIN employees e ON n.nurse_id = e.employee_id
WHERE e.employment_status = 'ACTIVE'
ORDER BY e.last_name, e.first_name;

-- LOV 19: PATIENTS (Pacientai) - AUTOCOMPLETE
-- Type: Dynamic (Popup LOV with Search)
-- Used in: Appointment Form, Admission Form, Prescription Form
-- SQL Query:
SELECT
    p.patient_id AS value,
    p.first_name || ' ' || p.last_name || ' (' ||
    TO_CHAR(p.date_of_birth, 'YYYY-MM-DD') || ')' AS label,
    p.insurance_number AS description
FROM patients p
WHERE p.is_active = 'Y'
  AND (   UPPER(p.first_name) LIKE '%' || UPPER(:SEARCH_STRING) || '%'
       OR UPPER(p.last_name) LIKE '%' || UPPER(:SEARCH_STRING) || '%'
       OR p.insurance_number LIKE '%' || :SEARCH_STRING || '%'
      )
ORDER BY p.last_name, p.first_name
FETCH FIRST 50 ROWS ONLY;

-- LOV 20: MEDICATIONS (Vaistai) - WITH STOCK INFO
-- Type: Dynamic (Popup LOV)
-- Used in: Prescription Form
-- SQL Query:
SELECT
    medication_id AS value,
    medication_name || ' (' || strength || ')' AS label,
    'Atsargos: ' || stock_quantity || ' | Kaina: €' ||
    TO_CHAR(unit_price, 'FM999990.00') AS description
FROM medications
WHERE is_available = 'Y'
  AND (   UPPER(medication_name) LIKE '%' || UPPER(:SEARCH_STRING) || '%'
       OR UPPER(generic_name) LIKE '%' || UPPER(:SEARCH_STRING) || '%'
      )
ORDER BY medication_name
FETCH FIRST 50 ROWS ONLY;

-- LOV 21: MEDICATIONS_IN_STOCK (Vaistai tik su atsargomis)
-- Type: Dynamic
-- Used in: Prescription Form (validation)
-- SQL Query:
SELECT
    medication_name || ' (' || strength || ') - Likutis: ' || stock_quantity AS display_value,
    medication_id AS return_value
FROM medications
WHERE is_available = 'Y'
  AND stock_quantity > 0
ORDER BY medication_name;

-- LOV 22: DIAGNOSES (Diagnozės)
-- Type: Dynamic (Popup LOV)
-- Used in: Patient Diagnosis Form
-- SQL Query:
SELECT
    diagnosis_id AS value,
    diagnosis_code || ' - ' || diagnosis_name AS label,
    category || ' | ' || NVL(severity_level, 'N/A') AS description
FROM diagnoses
WHERE is_active = 'Y'
  AND (   UPPER(diagnosis_code) LIKE '%' || UPPER(:SEARCH_STRING) || '%'
       OR UPPER(diagnosis_name) LIKE '%' || UPPER(:SEARCH_STRING) || '%'
      )
ORDER BY diagnosis_code
FETCH FIRST 50 ROWS ONLY;

-- LOV 23: ROOMS (Palatai)
-- Type: Dynamic
-- Used in: Bed Form
-- SQL Query:
SELECT
    r.room_number || ' (' ||
    CASE r.room_type
        WHEN 'PRIVATE' THEN 'Vienvietė'
        WHEN 'SEMI_PRIVATE' THEN 'Dvivietė'
        WHEN 'ICU' THEN 'ICU'
        WHEN 'EMERGENCY' THEN 'Skubi pagalba'
        WHEN 'OPERATING' THEN 'Operacinė'
    END || ')' AS display_value,
    r.room_id AS return_value
FROM rooms r
JOIN departments d ON r.department_id = d.department_id
WHERE d.is_active = 'Y'
ORDER BY r.room_number;

-- LOV 24: AVAILABLE_BEDS (Laisvos lovos)
-- Type: Dynamic
-- Used in: Admission Form
-- SQL Query:
SELECT
    r.room_number || ' - Lova ' || b.bed_number ||
    ' (' || d.department_name || ')' AS display_value,
    b.bed_id AS return_value
FROM beds b
JOIN rooms r ON b.room_id = r.room_id
JOIN departments d ON r.department_id = d.department_id
WHERE b.bed_status IN ('AVAILABLE', 'RESERVED')
  AND d.is_active = 'Y'
ORDER BY d.department_name, r.room_number, b.bed_number;

-- LOV 25: AVAILABLE_BEDS_BY_DEPARTMENT (Laisvos lovos pagal skyrių) - CASCADE
-- Type: Dynamic (Cascade from Department)
-- Parent: P_DEPARTMENT_ID
-- SQL Query:
SELECT
    r.room_number || ' - Lova ' || b.bed_number ||
    ' (€' || r.daily_rate || '/dieną)' AS display_value,
    b.bed_id AS return_value
FROM beds b
JOIN rooms r ON b.room_id = r.room_id
WHERE b.bed_status IN ('AVAILABLE', 'RESERVED')
  AND r.department_id = :P_DEPARTMENT_ID
ORDER BY r.room_number, b.bed_number;

-- LOV 26: ACTIVE_ADMISSIONS (Aktyvūs priėmimai)
-- Type: Dynamic
-- Used in: Bill Form
-- SQL Query:
SELECT
    p.first_name || ' ' || p.last_name || ' (' ||
    TO_CHAR(a.admission_date, 'YYYY-MM-DD') || ')' AS display_value,
    a.admission_id AS return_value
FROM admissions a
JOIN patients p ON a.patient_id = p.patient_id
WHERE a.status = 'ADMITTED'
ORDER BY a.admission_date DESC;

-- LOV 27: PATIENT_APPOINTMENTS (Paciento vizitai) - CASCADE
-- Type: Dynamic (Cascade from Patient)
-- Parent: P_PATIENT_ID
-- SQL Query:
SELECT
    TO_CHAR(appointment_date, 'YYYY-MM-DD') || ' ' || appointment_time ||
    ' (' || appointment_type || ')' AS display_value,
    appointment_id AS return_value
FROM appointments
WHERE patient_id = :P_PATIENT_ID
  AND status IN ('SCHEDULED', 'CONFIRMED', 'COMPLETED')
ORDER BY appointment_date DESC, appointment_time DESC;

-- LOV 28: SPECIALIZATIONS (Specializacijos)
-- Type: Dynamic
-- Used in: Doctor Search Filter
-- SQL Query:
SELECT DISTINCT
    specialization AS display_value,
    specialization AS return_value
FROM doctors
ORDER BY specialization;

-- LOV 29: MEDICATION_CATEGORIES (Vaistų kategorijos)
-- Type: Dynamic
-- Used in: Medication Filter
-- SQL Query:
SELECT DISTINCT
    category AS display_value,
    category AS return_value
FROM medications
WHERE category IS NOT NULL
ORDER BY category;

-- LOV 30: DIAGNOSIS_CATEGORIES (Diagnozių kategorijos)
-- Type: Dynamic
-- Used in: Diagnosis Filter
-- SQL Query:
SELECT DISTINCT
    category AS display_value,
    category AS return_value
FROM diagnoses
WHERE category IS NOT NULL
ORDER BY category;

-- ============================================================================
-- LOV SUMMARY
-- ============================================================================
/*
TOTAL LOVs: 30

STATIC LOVs: 14
1. Gender
2. Blood Type
3. Room Type
4. Bed Status
5. Appointment Type
6. Appointment Status
7. Payment Status
8. Payment Method
9. Employment Status
10. Shift Preference
11. Dosage Form
12. Test Type
13. Admission Type
14. Yes/No

DYNAMIC LOVs: 16
15. Departments
16. Doctors
17. Doctors by Department (CASCADE)
18. Nurses
19. Patients (AUTOCOMPLETE)
20. Medications (POPUP with search)
21. Medications in Stock
22. Diagnoses (POPUP with search)
23. Rooms
24. Available Beds
25. Available Beds by Department (CASCADE)
26. Active Admissions
27. Patient Appointments (CASCADE)
28. Specializations
29. Medication Categories
30. Diagnosis Categories

CASCADE LOVs: 3 (dependent on parent item value)
POPUP/AUTOCOMPLETE LOVs: 3 (with search functionality)
*/

-- ============================================================================
-- APEX BUILDER INSTRUKCIJOS
-- ============================================================================

/*
KAIP SUKURTI LOV PER APEX BUILDER:

1. Prisijunkite į APEX Builder
2. Shared Components > List of Values
3. Click "Create"

STATIC LOV KŪRIMAS:
- Name: LOV_GENDER
- Type: Static
- Click "Next"
- Add entries:
  Display: Vyras, Return: M
  Display: Moteris, Return: F
  Display: Kita, Return: O

DYNAMIC LOV KŪRIMAS:
- Name: LOV_DEPARTMENTS
- Type: Dynamic
- SQL Query: (nukopijuokite iš viršaus)
- Display Column: display_value
- Return Column: return_value

CASCADE LOV KŪRIMAS:
- Name: LOV_DOCTORS_BY_DEPARTMENT
- Type: Dynamic
- SQL Query: (nukopijuokite iš viršaus)
- Cascade LOV Parent Item(s): P101_DEPARTMENT_ID
- Optimized for: Page Item
- Display Null: Yes
- Null Display Value: - Pasirinkite skyrių -

POPUP LOV KŪRIMAS:
- Name: LOV_PATIENTS
- Type: Dynamic
- SQL Query: (naudokite su :SEARCH_STRING)
- Display Columns: label, description
- Search Column: label
- Return Column: value
- Template: Optional Badge

NAUDOJIMAS FORMOSE:
1. Sukurkite Page Item (pvz., P102_GENDER)
2. Type: Select List / Popup LOV / Autocomplete
3. List of Values: LOV_GENDER (shared component)
4. Display Extra Values: No
5. Display Null Value: Yes (jei optional)
*/

-- ============================================================================
-- PABAIGA
-- ============================================================================

COMMIT;
