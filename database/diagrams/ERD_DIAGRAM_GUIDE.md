## LIGONINĖS VALDYMO SISTEMOS ERD DIAGRAMA
# PowerDesigner Schema Importavimo Instrukcijos

## 1. Kaip importuoti į PowerDesigner

### Metodas 1: Reverse Engineering iš Oracle DB
1. Paleiskite visus SQL scriptus tvarka:
   - `01_create_tables.sql`
   - `02_create_triggers.sql`
   - `03_create_views.sql`
   - (Opcionalu) `04_insert_sample_data.sql`

2. PowerDesigner:
   - File → Reverse Engineer → Database
   - Pasirinkite "Oracle 12c" arba "Oracle 19c"
   - Connect to database ir pasirinkite savo schema
   - Select tables: Pažymėkite visas 15 lentelių
   - Options: ✓ Import Foreign Keys, ✓ Import Indexes
   - Generate

### Metodas 2: Importavimas iš SQL failo
1. PowerDesigner:
   - File → Reverse Engineer → Database
   - Pasirinkite "Using script files"
   - Pasirinkite `01_create_tables.sql` failą
   - DBMS: Oracle 12c
   - Generate

## 2. ESYBIŲ-RYŠIŲ DIAGRAMA (ERD)

### Esybių Grupavimas

```
┌─────────────────────────────────────────────────────────────────┐
│                     ORGANIZACINĖS ESYBĖS                         │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐  │
│  │ DEPARTMENTS  │──1:N─│    ROOMS     │──1:N─│     BEDS     │  │
│  │              │      │              │      │              │  │
│  └──────────────┘      └──────────────┘      └──────────────┘  │
│         │                                                        │
│         │ 1:N                                                    │
│         ▼                                                        │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     PERSONALO ESYBĖS                             │
├─────────────────────────────────────────────────────────────────┤
│                    ┌──────────────┐                              │
│                    │  EMPLOYEES   │ (Supertype)                  │
│                    └──────────────┘                              │
│                          △  △                                    │
│                    ┌─────┘  └─────┐                             │
│                    │               │                             │
│              ┌──────────┐    ┌──────────┐                        │
│              │ DOCTORS  │    │  NURSES  │ (Subtypes)             │
│              └──────────┘    └──────────┘                        │
│                    │               │                             │
│                    └───────┬───────┘                             │
│                            │ N:1                                 │
│                            ▼                                     │
│                    ┌──────────────┐                              │
│                    │ DEPARTMENTS  │                              │
│                    └──────────────┘                              │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     PACIENTŲ ESYBĖS                              │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐                                                │
│  │   PATIENTS   │ (Centrinis entitas)                            │
│  └──────────────┘                                                │
│         │                                                        │
│    ┌────┼────┬────┬────┬────┬────┐                             │
│    │    │    │    │    │    │    │                             │
│    │1:N │1:N │1:N │1:N │1:N │1:N │1:N                          │
│    ▼    ▼    ▼    ▼    ▼    ▼    ▼                             │
│  ┌───┐┌───┐┌───┐┌───┐┌───┐┌───┐┌───┐                          │
│  │APT││ADM││DIA││PRE││LAB││BIL││...│                           │
│  └───┘└───┘└───┘└───┘└───┘└───┘└───┘                          │
│                                                                  │
│  APT = APPOINTMENTS                                              │
│  ADM = ADMISSIONS                                                │
│  DIA = PATIENT_DIAGNOSES                                         │
│  PRE = PRESCRIPTIONS                                             │
│  LAB = LAB_TESTS                                                 │
│  BIL = BILLS                                                     │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                  MEDICININĖS KATALOGO ESYBĖS                     │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐           ┌──────────────┐                    │
│  │  DIAGNOSES   │           │ MEDICATIONS  │                    │
│  │  (Katalogas) │           │  (Katalogas) │                    │
│  └──────────────┘           └──────────────┘                    │
│         │ 1:N                      │ 1:N                        │
│         ▼                          ▼                            │
│  ┌──────────────┐           ┌──────────────┐                    │
│  │PATIENT_DIAG  │           │PRESCRIPTIONS │                    │
│  └──────────────┘           └──────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
```

## 3. DETALUS RYŠIŲ SĄRAŠAS SU KARDINALUMU

### Vienas-su-Daug (1:N) Ryšiai

| Parent Entity | Child Entity | Relationship | FK Column | Constraint |
|--------------|--------------|--------------|-----------|------------|
| DEPARTMENTS | ROOMS | 1:N | department_id | fk_room_department |
| DEPARTMENTS | DOCTORS | 1:N | department_id | fk_doc_department |
| DEPARTMENTS | NURSES | 1:N | department_id | fk_nurse_department |
| DOCTORS | DEPARTMENTS | 1:N (head) | head_doctor_id | fk_dept_head_doctor |
| ROOMS | BEDS | 1:N | room_id | fk_bed_room |
| BEDS | ADMISSIONS | 1:N | bed_id | fk_adm_bed |
| PATIENTS | APPOINTMENTS | 1:N | patient_id | fk_appt_patient |
| PATIENTS | ADMISSIONS | 1:N | patient_id | fk_adm_patient |
| PATIENTS | PATIENT_DIAGNOSES | 1:N | patient_id | fk_patdiag_patient |
| PATIENTS | PRESCRIPTIONS | 1:N | patient_id | fk_presc_patient |
| PATIENTS | LAB_TESTS | 1:N | patient_id | fk_lab_patient |
| PATIENTS | BILLS | 1:N | patient_id | fk_bill_patient |
| DOCTORS | APPOINTMENTS | 1:N | doctor_id | fk_appt_doctor |
| DOCTORS | ADMISSIONS | 1:N | admitting_doctor_id | fk_adm_doctor |
| DOCTORS | PATIENT_DIAGNOSES | 1:N | doctor_id | fk_patdiag_doctor |
| DOCTORS | PRESCRIPTIONS | 1:N | doctor_id | fk_presc_doctor |
| DOCTORS | LAB_TESTS | 1:N | doctor_id | fk_lab_doctor |
| DIAGNOSES | PATIENT_DIAGNOSES | 1:N | diagnosis_id | fk_patdiag_diagnosis |
| MEDICATIONS | PRESCRIPTIONS | 1:N | medication_id | fk_presc_medication |
| ADMISSIONS | BILLS | 1:N | admission_id | fk_bill_admission |
| APPOINTMENTS | BILLS | 1:N | appointment_id | fk_bill_appointment |

### Paveldėjimo Ryšiai (Supertype-Subtype)

| Supertype | Subtype | Type | FK Column | Constraint |
|-----------|---------|------|-----------|------------|
| EMPLOYEES | DOCTORS | IS-A | doctor_id | fk_doc_employee |
| EMPLOYEES | NURSES | IS-A | nurse_id | fk_nurse_employee |

**Pastaba:** Paveldėjimas implementuotas per "Shared Primary Key" strategiją:
- `DOCTORS.doctor_id` yra ir PK ir FK į `EMPLOYEES.employee_id`
- `NURSES.nurse_id` yra ir PK ir FK į `EMPLOYEES.employee_id`

## 4. SPALVINIS KODAVIMAS PowerDesigner'yje

Rekomenduojamas spalvinis kodavimas esybėms:

```
🟦 Mėlyna (Blue) - Organizacinės esybės
   - DEPARTMENTS
   - ROOMS
   - BEDS

🟩 Žalia (Green) - Personalo esybės
   - EMPLOYEES
   - DOCTORS
   - NURSES

🟨 Geltona (Yellow) - Pacientų esybės
   - PATIENTS
   - APPOINTMENTS
   - ADMISSIONS

🟧 Oranžinė (Orange) - Medicininės esybės
   - DIAGNOSES
   - PATIENT_DIAGNOSES
   - MEDICATIONS
   - PRESCRIPTIONS
   - LAB_TESTS

🟥 Raudona (Red) - Finansinės esybės
   - BILLS
```

## 5. ENTITY ATTRIBUTES SUMMARY

### DEPARTMENTS (15 atributų)
- **PK:** department_id
- **FK:** head_doctor_id → DOCTORS
- **Unique:** department_name
- **Check:** is_active ('Y'/'N'), floor_number (-2 to 20)

### EMPLOYEES (14 atributų)
- **PK:** employee_id
- **Unique:** email
- **Check:** gender ('M'/'F'/'O'), employment_status, date validations

### DOCTORS (8 atributų)
- **PK:** doctor_id
- **FK:** doctor_id → EMPLOYEES, department_id → DEPARTMENTS
- **Unique:** license_number
- **Check:** years_of_experience (0-60)

### NURSES (5 atributų)
- **PK:** nurse_id
- **FK:** nurse_id → EMPLOYEES, department_id → DEPARTMENTS
- **Unique:** license_number
- **Check:** shift_preference ('DAY'/'NIGHT'/'ROTATING')

### ROOMS (7 atributų)
- **PK:** room_id
- **FK:** department_id → DEPARTMENTS
- **Unique:** room_number
- **Check:** room_type (5 variantai)

### BEDS (6 atributų)
- **PK:** bed_id
- **FK:** room_id → ROOMS
- **Unique:** (room_id, bed_number)
- **Check:** bed_status (4 variantai)

### PATIENTS (17 atributų)
- **PK:** patient_id
- **Check:** gender, blood_type (8 variantai), is_active

### APPOINTMENTS (12 atributų)
- **PK:** appointment_id
- **FK:** patient_id → PATIENTS, doctor_id → DOCTORS
- **Check:** appointment_type (4), status (5), duration (15-240 min)

### ADMISSIONS (11 atributų)
- **PK:** admission_id
- **FK:** patient_id → PATIENTS, bed_id → BEDS, admitting_doctor_id → DOCTORS
- **Check:** admission_type (3), status (3), discharge_date >= admission_date

### DIAGNOSES (7 atributų)
- **PK:** diagnosis_id
- **Unique:** diagnosis_code
- **Check:** severity_level (4 variantai), is_active

### PATIENT_DIAGNOSES (8 atributų)
- **PK:** patient_diagnosis_id
- **FK:** patient_id, diagnosis_id, doctor_id
- **Check:** is_primary ('Y'/'N'), status (3 variantai)

### MEDICATIONS (13 atributų)
- **PK:** medication_id
- **Unique:** (medication_name, strength)
- **Check:** dosage_form (7), requires_prescription, stock validations

### PRESCRIPTIONS (13 atributų)
- **PK:** prescription_id
- **FK:** patient_id, doctor_id, medication_id
- **Check:** status (3), duration (1-365 days), refills (0-12)

### LAB_TESTS (13 atributų)
- **PK:** lab_test_id
- **FK:** patient_id, doctor_id
- **Check:** test_type (9 variantai), status (4)
- **CLOB:** results (dideliem duomenims)

### BILLS (16 atributų)
- **PK:** bill_id
- **FK:** patient_id, admission_id (nullable), appointment_id (nullable)
- **Virtual:** balance (total_amount - paid_amount)
- **Check:** payment_status (4), payment_method (4), validations

## 6. INDEXES SUMMARY

### Performance Indexes (50+ indexes)

**Pacientų paieška:**
- idx_pat_name (last_name, first_name)
- idx_pat_insurance (insurance_number)
- idx_pat_regdate (registration_date)

**Vizitų kalendorius:**
- idx_appt_doc_date (doctor_id, appointment_date) - COMPOSITE
- idx_appt_date (appointment_date)
- idx_appt_status (status)

**Lovų valdymas:**
- idx_bed_status (bed_status)
- idx_bed_room (room_id)

**Finansų ataskaitos:**
- idx_bill_status (payment_status)
- idx_bill_due (due_date)
- idx_bill_patient (patient_id)

## 7. BUSINESS RULES IMPLEMENTED

### Duomenų Vientisumas (Data Integrity)
1. ✓ Pacientas negali turėti >1 aktyvaus priėmimo
2. ✓ Lova negali būti priskirta >1 pacientui vienu metu
3. ✓ Gydytojas negali turėti sutampančių vizitų
4. ✓ Negalima išrašyti recepto neaktyviam vaistui
5. ✓ Sąskaitos paid_amount <= total_amount
6. ✓ Discharge_date >= admission_date

### Automatizacija (Triggers)
1. ✓ Automatinis bed_status atnaujinimas (OCCUPIED/AVAILABLE)
2. ✓ Automatinis room_availability atnaujinimas
3. ✓ Automatinis medication stock_quantity mažinimas
4. ✓ Automatinis bill payment_status nustatymas
5. ✓ Automatinis discharge_date nustatymas
6. ✓ Automatinis modified_date atnaujinimas (8 lentelės)
7. ✓ Low stock alerts logging
8. ✓ Audit trail BILLS lentelei

## 8. NORMALIZACIJA

### Normalizacijos Lygis: 3NF (Third Normal Form)

**1NF (First Normal Form):**
- ✓ Visi atributai yra atomic (nedalomi)
- ✓ Nėra repeating groups
- ✓ Yra primary keys

**2NF (Second Normal Form):**
- ✓ 1NF + visi non-key atributai priklauso nuo viso primary key
- ✓ Nėra partial dependencies

**3NF (Third Normal Form):**
- ✓ 2NF + nėra transitive dependencies
- ✓ Non-key atributai nepriklauso nuo kitų non-key atributų

**Pavyzdžiai:**
- MEDICATIONS katalogas atskirtas nuo PRESCRIPTIONS
- DIAGNOSES katalogas atskirtas nuo PATIENT_DIAGNOSES
- EMPLOYEES bazinė lentelė su DOCTORS ir NURSES subtypes

## 9. PowerDesigner GENERATION OPTIONS

### Rekomenduojami Nustatymai

**Physical Diagram:**
- ✓ Show Foreign Keys
- ✓ Show Indexes
- ✓ Show Triggers
- ✓ Show Check Constraints
- ✓ Column Data Types

**Display Preferences:**
- Format: List (vertikal)
- Show: Name + Code
- Show Nullability: ✓
- Show Data Type: ✓

**Diagram Layout:**
- Auto Layout: Hierarchical (Top to Bottom)
- Group by: Subject Area
  - Organization (DEPARTMENTS, ROOMS, BEDS)
  - Staff (EMPLOYEES, DOCTORS, NURSES)
  - Patients (PATIENTS, APPOINTMENTS, ADMISSIONS)
  - Medical (DIAGNOSES, MEDICATIONS, PRESCRIPTIONS, LAB_TESTS)
  - Finance (BILLS)

**Relationship Lines:**
- Style: Crow's Foot
- Show Cardinality: Both Ends
- Show Role Names: ✓

## 10. EXPORT OPTIONS

### Exportavimas į kitus formatus:

1. **PNG/JPG (diagrama):**
   - File → Export → Export Image
   - Resolution: 300 DPI (spausdinimui)

2. **PDF (dokumentacija):**
   - File → Print → PDF Printer
   - Include: Diagram + Report

3. **HTML (web dokumentacija):**
   - Tools → Generate Report → HTML Format
   - Include: All objects + relationships

4. **Excel (duomenų dictionary):**
   - Tools → Generate Report → Excel Format
   - Tables + Columns + Relationships

## 11. VALIDACIJA

### Pre-generation Checklist:

- [ ] Visi Foreign Keys turi Indexes
- [ ] Visi CHECK constraints apibrėžti
- [ ] Visi UNIQUE constraints nustatyti
- [ ] Visos lentelės turi Primary Keys
- [ ] Circular references išspręsti (DEPARTMENTS ↔ DOCTORS)
- [ ] ON DELETE CASCADE/SET NULL teisingai nustatyti
- [ ] Sequences sukurti (IDENTITY columns)
- [ ] Comments pridėti lentelėms ir svarbiems stulpeliams

### SQL Script Generation:

PowerDesigner → Database → Generate Database:
- Target DBMS: Oracle 12c / 19c
- Options:
  - ✓ Check Model
  - ✓ Create Tables
  - ✓ Create Indexes
  - ✓ Create Triggers
  - ✓ Create Comments
  - ✓ Create Foreign Keys

---

**Pastaba:** Šis dokumentas sukurtas kartu su SQL DDL scriptais. Visi ryšiai ir constraintai jau implementuoti SQL failuose ir gali būti importuoti į PowerDesigner naudojant reverse engineering funkciją.
