# LIGONINĖS VALDYMO SISTEMOS KONCEPTUALUS MODELIS

## Projekto Apžvalga

**Sistema:** Ligoninės valdymo sistema (Hospital Management System)
**Platforma:** Oracle APEX 22.1.0
**Dizaino įrankis:** PowerDesigner
**Esybių skaičius:** 15

## 1. ESYBĖS IR JŲ PASKIRTIS

### 1.1 Organizacinės Esybės

#### **DEPARTMENTS** (Skyriai)
- **Paskirtis:** Ligoninės organizacinių skyrių valdymas (Kardiologija, Chirurgija, Pediatrija, Onkologija, etc.)
- **Atributai:**
  - department_id (PK)
  - department_name
  - description
  - head_doctor_id (FK -> DOCTORS)
  - phone_number
  - building
  - floor_number
  - budget
  - created_date
  - is_active
- **APEX puslapiai:**
  - Interactive Report su visais skyriais
  - Form naujo skyriaus kūrimui/redagavimui
  - Dashboard su skyriaus statistika (pacientų skaičius, pajamos)

#### **ROOMS** (Palatai)
- **Paskirtis:** Ligoninės palatų valdymas
- **Atributai:**
  - room_id (PK)
  - department_id (FK -> DEPARTMENTS)
  - room_number
  - room_type (PRIVATE, SEMI_PRIVATE, ICU, EMERGENCY, OPERATING)
  - floor_number
  - is_available
  - daily_rate
- **APEX puslapiai:**
  - Interactive Grid su filtravimo galimybėmis pagal skyrių/tipą
  - Master-Detail puslapis (Palata -> Lovos)
  - Availability calendar

#### **BEDS** (Lovos)
- **Paskirtis:** Individualių lovų palatose valdymas
- **Atributai:**
  - bed_id (PK)
  - room_id (FK -> ROOMS)
  - bed_number
  - bed_status (AVAILABLE, OCCUPIED, MAINTENANCE, RESERVED)
  - last_maintenance_date
- **APEX puslapiai:**
  - Real-time status board (spalvinė koduotė pagal statusą)
  - Quick allocation form

### 1.2 Personalo Esybės

#### **EMPLOYEES** (Darbuotojai - bazinė lentelė)
- **Paskirtis:** Visi ligoninės darbuotojai (bazinė lentelė gydytojams, seserims)
- **Atributai:**
  - employee_id (PK)
  - first_name
  - last_name
  - date_of_birth
  - gender
  - email
  - phone_number
  - address
  - city
  - postal_code
  - hire_date
  - employment_status (ACTIVE, ON_LEAVE, TERMINATED)
  - salary
- **Ryšiai:** Supertype lentelė DOCTORS ir NURSES subtype'ams
- **APEX puslapiai:**
  - HR Interactive Report
  - Employee profile page

#### **DOCTORS** (Gydytojai)
- **Paskirtis:** Gydytojų specifinė informacija
- **Atributai:**
  - doctor_id (PK, FK -> EMPLOYEES)
  - department_id (FK -> DEPARTMENTS)
  - specialization
  - license_number
  - consultation_fee
  - years_of_experience
  - education
  - available_for_emergency
- **APEX puslapiai:**
  - Doctor directory su paieška pagal specializaciją
  - Doctor schedule calendar
  - Performance dashboard (pacientų skaičius, pajamos)

#### **NURSES** (Medicinos seserys)
- **Paskirtis:** Medicinos seserų specifinė informacija
- **Atributai:**
  - nurse_id (PK, FK -> EMPLOYEES)
  - department_id (FK -> DEPARTMENTS)
  - certification_level
  - shift_preference (DAY, NIGHT, ROTATING)
  - license_number
- **APEX puslapiai:**
  - Nurse roster management
  - Shift assignment grid
  - Patient assignment board

### 1.3 Pacientų Esybės

#### **PATIENTS** (Pacientai)
- **Paskirtis:** Pacientų registras ir pagrindinė informacija
- **Atributai:**
  - patient_id (PK)
  - first_name
  - last_name
  - date_of_birth
  - gender
  - blood_type
  - email
  - phone_number
  - emergency_contact_name
  - emergency_contact_phone
  - address
  - city
  - postal_code
  - insurance_number
  - registration_date
  - is_active
- **APEX puslapiai:**
  - Patient registration form
  - Patient search (Interactive Report)
  - Patient profile (Master page su tabs)
  - Patient medical history dashboard

#### **ADMISSIONS** (Priėmimai/Hospitalizacija)
- **Paskirtis:** Pacientų priėmimo į ligoninę ir išrašymo valdymas
- **Atributai:**
  - admission_id (PK)
  - patient_id (FK -> PATIENTS)
  - bed_id (FK -> BEDS)
  - admitting_doctor_id (FK -> DOCTORS)
  - admission_date
  - discharge_date
  - admission_type (EMERGENCY, PLANNED, TRANSFER)
  - admission_reason
  - discharge_notes
  - status (ADMITTED, DISCHARGED, TRANSFERRED)
- **APEX puslapiai:**
  - Admission form su bed allocation
  - Current admissions dashboard
  - Discharge management page
  - Length of stay reports

#### **APPOINTMENTS** (Vizitai/Konsultacijos)
- **Paskirtis:** Pacientų vizitų pas gydytojus planavimas ir valdymas
- **Atributai:**
  - appointment_id (PK)
  - patient_id (FK -> PATIENTS)
  - doctor_id (FK -> DOCTORS)
  - appointment_date
  - appointment_time
  - duration_minutes
  - appointment_type (CHECKUP, CONSULTATION, FOLLOWUP, EMERGENCY)
  - status (SCHEDULED, CONFIRMED, COMPLETED, CANCELLED, NO_SHOW)
  - notes
  - cancellation_reason
- **APEX puslapiai:**
  - Appointment booking calendar
  - Doctor's daily schedule
  - Patient appointment history
  - Automated reminder system integration page

### 1.4 Medicininės Esybės

#### **DIAGNOSES** (Diagnozių katalogas)
- **Paskirtis:** Standartizuotas diagnozių sąrašas (ICD-10 tipo)
- **Atributai:**
  - diagnosis_id (PK)
  - diagnosis_code (unique)
  - diagnosis_name
  - category
  - severity_level
  - description
  - is_active
- **APEX puslapiai:**
  - Diagnosis lookup (LOV - List of Values)
  - Diagnosis management (admin)
  - Diagnosis statistics/reports

#### **PATIENT_DIAGNOSES** (Pacientų diagnozės)
- **Paskirtis:** Siejimas tarp pacientų ir jų diagnozių
- **Atributai:**
  - patient_diagnosis_id (PK)
  - patient_id (FK -> PATIENTS)
  - diagnosis_id (FK -> DIAGNOSES)
  - doctor_id (FK -> DOCTORS)
  - diagnosis_date
  - notes
  - is_primary (ar pagrindinė diagnozė)
  - status (ACTIVE, RESOLVED, CHRONIC)
- **APEX puslapiai:**
  - Medical history view (Detail region paciento profilyje)
  - Diagnosis entry form
  - Chronic condition monitoring dashboard

#### **MEDICATIONS** (Vaistų katalogas)
- **Paskirtis:** Ligoninėje naudojamų vaistų katalogas
- **Atributai:**
  - medication_id (PK)
  - medication_name
  - generic_name
  - manufacturer
  - category
  - unit_price
  - stock_quantity
  - minimum_stock_level
  - dosage_form (TABLET, CAPSULE, INJECTION, SYRUP)
  - strength
  - requires_prescription
  - is_available
- **APEX puslapiai:**
  - Medication inventory grid
  - Low stock alerts
  - Medication search (LOV)
  - Price management

#### **PRESCRIPTIONS** (Receptai)
- **Paskirtis:** Gydytojų išrašyti receptai pacientams
- **Atributai:**
  - prescription_id (PK)
  - patient_id (FK -> PATIENTS)
  - doctor_id (FK -> DOCTORS)
  - medication_id (FK -> MEDICATIONS)
  - prescription_date
  - dosage
  - frequency
  - duration_days
  - quantity
  - refills_allowed
  - instructions
  - status (ACTIVE, COMPLETED, CANCELLED)
- **APEX puslapiai:**
  - Prescription entry form
  - Active prescriptions list (paciento profilyje)
  - Pharmacy dispensing interface
  - Prescription history reports

#### **LAB_TESTS** (Laboratoriniai tyrimai)
- **Paskirtis:** Pacientams atliktų laboratorinių tyrimų valdymas
- **Atributai:**
  - lab_test_id (PK)
  - patient_id (FK -> PATIENTS)
  - doctor_id (FK -> DOCTORS)
  - test_type (BLOOD, URINE, XRAY, MRI, CT_SCAN, ULTRASOUND, ECG)
  - test_date
  - test_time
  - status (ORDERED, IN_PROGRESS, COMPLETED, CANCELLED)
  - results
  - normal_range
  - lab_technician_name
  - cost
  - notes
- **APEX puslapiai:**
  - Lab test order form
  - Lab results entry/viewer
  - Pending tests dashboard
  - Patient test history
  - Lab report generator (PDF)

### 1.5 Finansinės Esybės

#### **BILLS** (Sąskaitos)
- **Paskirtis:** Pacientų sąskaitų už paslaugas generavimas ir valdymas
- **Atributai:**
  - bill_id (PK)
  - patient_id (FK -> PATIENTS)
  - admission_id (FK -> ADMISSIONS, nullable)
  - appointment_id (FK -> APPOINTMENTS, nullable)
  - bill_date
  - due_date
  - total_amount
  - paid_amount
  - balance
  - payment_status (UNPAID, PARTIAL, PAID, OVERDUE)
  - payment_method (CASH, CARD, INSURANCE, BANK_TRANSFER)
  - payment_date
  - discount_percent
  - tax_amount
  - notes
- **APEX puslapiai:**
  - Billing dashboard
  - Invoice generation
  - Payment processing form
  - Outstanding bills report
  - Revenue analytics charts
  - Payment history

## 2. RYŠIAI (RELATIONSHIPS)

### 2.1 Vienas-su-Daug (1:N) Ryšiai

1. **DEPARTMENTS → ROOMS** (1:N)
   - Vienas skyrius turi daug palatų
   - Kiekviena palata priklauso vienam skyriui

2. **DEPARTMENTS → DOCTORS** (1:N)
   - Vienas skyrius turi daug gydytojų
   - Kiekvienas gydytojas dirba viename skyriuje

3. **DEPARTMENTS → NURSES** (1:N)
   - Vienas skyrius turi daug seserų
   - Kiekviena sesuo dirba viename skyriuje

4. **ROOMS → BEDS** (1:N)
   - Viena palata turi daug lovų
   - Kiekviena lova priklauso vienai palatai

5. **PATIENTS → ADMISSIONS** (1:N)
   - Vienas pacientas gali turėti daug priėmimų (skirtingu laiku)
   - Kiekvienas priėmimas priklauso vienam pacientui

6. **PATIENTS → APPOINTMENTS** (1:N)
   - Vienas pacientas gali turėti daug vizitų
   - Kiekvienas vizitas priklauso vienam pacientui

7. **PATIENTS → PATIENT_DIAGNOSES** (1:N)
   - Vienas pacientas gali turėti daug diagnozių
   - Kiekviena diagnozė priklauso vienam pacientui

8. **PATIENTS → PRESCRIPTIONS** (1:N)
   - Vienas pacientas gali turėti daug receptų
   - Kiekvienas receptas priklauso vienam pacientui

9. **PATIENTS → LAB_TESTS** (1:N)
   - Vienas pacientas gali turėti daug laboratorinių tyrimų
   - Kiekvienas tyrimas priklauso vienam pacientui

10. **PATIENTS → BILLS** (1:N)
    - Vienas pacientas gali turėti daug sąskaitų
    - Kiekviena sąskaita priklauso vienam pacientui

11. **DOCTORS → ADMISSIONS** (1:N)
    - Vienas gydytojas gali priimti daug pacientų
    - Kiekvienas priėmimas turi vieną priimantį gydytoją

12. **DOCTORS → APPOINTMENTS** (1:N)
    - Vienas gydytojas gali turėti daug vizitų
    - Kiekvienas vizitas yra su vienu gydytoju

13. **DOCTORS → PATIENT_DIAGNOSES** (1:N)
    - Vienas gydytojas gali diagnozuoti daug pacientų
    - Kiekviena diagnozė išrašyta vieno gydytojo

14. **DOCTORS → PRESCRIPTIONS** (1:N)
    - Vienas gydytojas gali išrašyti daug receptų
    - Kiekvienas receptas išrašytas vieno gydytojo

15. **DOCTORS → LAB_TESTS** (1:N)
    - Vienas gydytojas gali užsakyti daug tyrimų
    - Kiekvienas tyrimas užsakytas vieno gydytojo

16. **DOCTORS → DEPARTMENTS** (1:N) - kaip vadovas
    - Vienas gydytojas gali vadovauti vienam skyriui
    - Skyrius turi vieną vadovą (head_doctor)

17. **BEDS → ADMISSIONS** (1:N)
    - Viena lova gali turėti daug priėmimų (skirtingu laiku)
    - Kiekvienas priėmimas naudoja vieną lovą

18. **DIAGNOSES → PATIENT_DIAGNOSES** (1:N)
    - Viena diagnozė iš katalogo gali būti priskirta daugeliui pacientų
    - Kiekviena paciento diagnozė nurodo vieną diagnozę iš katalogo

19. **MEDICATIONS → PRESCRIPTIONS** (1:N)
    - Vienas vaistas gali būti daug receptuose
    - Kiekvienas receptas nurodo vieną vaistą

20. **ADMISSIONS → BILLS** (1:N)
    - Vienas priėmimas gali turėti kelias sąskaitas (skirtingoms paslaugoms)
    - Sąskaita gali būti susijusi su vienu priėmimu (arba vizitu)

21. **APPOINTMENTS → BILLS** (1:N)
    - Vienas vizitas gali turėti kelias sąskaitas
    - Sąskaita gali būti susijusi su vienu vizitu

### 2.2 Paveldėjimo Ryšiai (Supertype-Subtype)

1. **EMPLOYEES → DOCTORS** (Supertype-Subtype)
   - DOCTORS paveldi visus EMPLOYEES atributus
   - Išplečiamas su specialization, license_number, etc.

2. **EMPLOYEES → NURSES** (Supertype-Subtype)
   - NURSES paveldi visus EMPLOYEES atributus
   - Išplečiamas su certification_level, shift_preference, etc.

## 3. APEX APLIKACIJOS STRUKTŪRA

### 3.1 Navigacijos Menu Struktūra

```
HOME (Dashboard)
├── PACIENTAI
│   ├── Pacientų registras
│   ├── Naujo paciento registracija
│   ├── Hospitalizuoti pacientai
│   └── Vizitų kalendorius
├── PERSONALAS
│   ├── Gydytojai
│   ├── Medicinos seserys
│   └── Darbuotojų grafikas
├── SKYRIAI
│   ├── Skyrių valdymas
│   ├── Palatų valdymas
│   └── Lovų užimtumas
├── MEDICININĖ INFORMACIJA
│   ├── Diagnozės
│   ├── Laboratoriniai tyrimai
│   ├── Receptai
│   └── Vaistų katalogas
├── FINANSAI
│   ├── Sąskaitos
│   ├── Mokėjimai
│   └── Pajamų ataskaitos
└── ADMINISTRAVIMAS
    ├── Sistemos nustatymai
    └── Vartotojų valdymas
```

### 3.2 Pagrindiniai Puslapių Tipai

#### Dashboard Pages (Home)
- KPI Cards: Aktyvių pacientų sk., Užimtų lovų sk., Šiandien vizitų sk., Nepamokėtų sąskaitų suma
- Charts: Priėmimų tendencijos, Pajamos pagal skyrių, Populiariausios diagnozės
- Lists: Artėjantys vizitai, Kritiniai pacientai, Low stock vaistai

#### Interactive Reports
- Pacientų sąrašas su paieška ir filtrais
- Gydytojų katalogas
- Hospitalizuotų pacientų sąrašas
- Sąskaitų registras

#### Forms (Create/Edit)
- Paciento registracijos forma
- Vizito užsakymo forma
- Priėmimo forma su lovos pasirinkimu
- Recepto išrašymo forma
- Sąskaitos generavimo forma

#### Master-Detail Pages
- Paciento profilis (Master) → Diagnozės, Receptai, Tyrimai, Sąskaitos (Details)
- Skyrius (Master) → Palatai, Gydytojai, Statistika (Details)
- Palata (Master) → Lovos su status (Details)

#### Calendar Pages
- Gydytojų vizitų kalendorius
- Palatų užimtumo kalendorius
- Operacijų grafikas

#### Reports & Analytics
- Finansinės ataskaitos (PDF)
- Pacientų statistika
- Skyriaus efektyvumo ataskaitos
- Lab test rezultatų ataskaitos

## 4. DUOMENŲ SRAUTAI IR VEIKLOS SCENARIJAI

### Scenarijus 1: Naujo Paciento Priėmimas
1. Pacientas registruojamas sistemoje (PATIENTS)
2. Užsakomas vizitas pas gydytoją (APPOINTMENTS)
3. Gydytojas įveda diagnozę (PATIENT_DIAGNOSES)
4. Gydytojas išrašo receptą (PRESCRIPTIONS)
5. Gydytojas užsako lab testus (LAB_TESTS)
6. Generuojama sąskaita (BILLS)

### Scenarijus 2: Paciento Hospitalizacija
1. Gydytojas nusprendžia hospitalizuoti pacientą
2. Sistema parodo laisvas lovas (BEDS su status AVAILABLE)
3. Sukuriamas priėmimas (ADMISSIONS) ir lova užimama
4. Priskirta sesuo prižiūri pacientą
5. Atliekami tyrimai ir procedūros
6. Pacientas išrašomas, lova atlaisvinama
7. Generuojama galutinė sąskaita

### Scenarijus 3: Lovų Valdymas
1. Skyrius turi daug palatų (ROOMS)
2. Kiekviena palata turi lovas (BEDS)
3. Real-time status board rodo užimtumą
4. Seserys gali rezervuoti lovas
5. Sistema automatiškai atnaujina status pagal admissions

### Scenarijus 4: Finansų Valdymas
1. Už kiekvieną paslaugą generuojama sąskaita (BILLS)
2. Sąskaitos susietos su pacientu, priėmimu arba vizitu
3. Sistema stebi mokėjimų statusą
4. Automatiniai priminimai vėluojantiems mokėjimams
5. Ataskaitos apie pajamas pagal skyrių, gydytoją, paslaugą

## 5. DUOMENŲ VIENTISUMAS (DATA INTEGRITY)

### Referential Integrity
- Visi Foreign Keys su ON DELETE CASCADE arba ON DELETE SET NULL pagal logiką
- Check constraints statusams ir enum tipo laukams
- Unique constraints licence_number, email, room_number, etc.

### Business Rules
- Pacientas negali turėti daugiau nei vieno aktyvaus priėmimo vienu metu
- Lova negali būti priskirta keliems pacientams tuo pačiu metu
- Sąskaitos paid_amount negali viršyti total_amount
- Appointment negali būti ateityje daugiau nei 6 mėnesius
- Doctor konsultacijos trukmė turi būti 15-120 minučių

### Triggers (bus SQL scripte)
- Automatinis bed status atnaujinimas kai sukuriamas/ištrinamas admission
- Automatinis bill total_amount ir balance skaičiavimas
- Automatinis medication stock_quantity atnaujinimas kai išrašomas receptas
- Audit trail kūrimas svarbių lentelių pakeitimams

## 6. INDEKSAI IR OPTIMIZACIJA

### Dažnai naudojamos paieškos
- PATIENTS: last_name, registration_date, insurance_number
- APPOINTMENTS: appointment_date, patient_id, doctor_id, status
- ADMISSIONS: admission_date, patient_id, status
- BILLS: patient_id, payment_status, bill_date
- PRESCRIPTIONS: patient_id, prescription_date, status
- LAB_TESTS: patient_id, test_date, status

### Composite Indexes
- (patient_id, appointment_date) - paciento vizitų istorija
- (doctor_id, appointment_date) - gydytojo grafikas
- (department_id, admission_date) - skyriaus užimtumas
- (room_id, bed_number) - greita lovos paieška

## 7. SAUGUMO ASPEKTAI

### APEX Authorization Schemes
- **ADMIN** - pilna prieiga prie visų duomenų ir nustatymų
- **DOCTOR** - prieiga prie pacientų, diagnozių, receptų, tyrimų
- **NURSE** - prieiga prie pacientų, lovų, priėmimų
- **RECEPTIONIST** - prieiga prie vizitų, pacientų registracijos
- **BILLING** - prieiga prie sąskaitų, mokėjimų
- **LAB_TECH** - prieiga prie laboratorinių tyrimų

### Row Level Security
- Gydytojai mato tik savo skyriaus pacientus
- Seserys mato tik savo priskirtus pacientus
- Finansų darbuotojai mato visas sąskaitas

## 8. ATEITIES PLĖTROS GALIMYBĖS

### Papildomos Esybės (jei reikės)
- **INSURANCE_COMPANIES** - draudimo kompanijų valdymas
- **SURGERIES** - operacijų planavimas ir įrašai
- **MEDICAL_EQUIPMENT** - medicinos įrangos katalogas
- **STAFF_SCHEDULES** - detalūs darbuotojų grafikai
- **PATIENT_ALLERGIES** - pacientų alergijos
- **VITAL_SIGNS** - pacientų gyvybinių ženklų stebėjimas
- **IMAGING_STUDIES** - radiologinių vaizdų valdymas

### Integracijos
- Email/SMS priminimai apie vizitus
- Payment gateway integracija
- Lab equipment integracija
- Electronic Health Records (EHR) standartas
- Reporting services (APEX Office Print)

---

**Pastaba:** Ši schema sukurta atsižvelgiant į Oracle APEX 22.1.0 galimybes ir PowerDesigner suderinamumą. Visos esybės ir ryšiai atitinka normalizacijos principus (3NF) ir užtikrina duomenų vientisumą.
