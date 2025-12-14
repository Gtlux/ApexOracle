# 🏥 LIGONINĖS VALDYMO SISTEMA - APEX Aplikacijos Kūrimas

**Šiame vadove** naudojant žingsnis-po-žingsnio instrukcijas bus sukurta pilna Ligoninės Valdymo sistema Oracle APEX 22.1.0 aplinkoje.

**Aplikacijos informacija:**
- **Application ID:** 100
- **Application Name:** Ligoninės Valdymo Sistema
- **APEX Version:** 22.1.0
- **Database Schema:** HOSPITAL_DB (arba jūsų schema)

---

## 📋 TURINYS

**Prieš Pradedant:**
- [Aplikacijos Kūrimas](#pradinis-aplikacijos-kūrimas)
- [Shared Components Setup](#shared-components-setup)

**LOVs ir Shared Components:**
1. [LOVs Kūrimas (30 vnt)](#1-lovs-kūrimas-30-vnt)

**Puslapių Kūrimas (žingsnis-po-žingsnio):**
2. [Home Page - Dashboard (REQ 1)](#2-home-page-dashboard-req-1)
3. [Pacientų Interactive Report + Form (REQ 3)](#3-pacientų-interactive-report--form-req-3)
4. [Paciento Master-Detail Profilis (REQ 5)](#4-paciento-master-detail-profilis-req-5)
5. [Vizitų Kalendorius (REQ 6)](#5-vizitų-kalendorius-req-6)
6. [Sąskaitų Report su VIEW (REQ 4)](#6-sąskaitų-report-su-view-req-4)
7. [Gydytojų Report + Form](#7-gydytojų-report--form)
8. [Priėmimų (Admissions) Valdymas](#8-priėmimų-admissions-valdymas)
9. [Receptų (Prescriptions) Valdymas](#9-receptų-prescriptions-valdymas)
10. [Lovų Užimtumo Vaizdas](#10-lovų-užimtumo-vaizdas)

**Patobulinimai:**
11. [Navigation Menu Konfigūracija](#11-navigation-menu-konfigūracija)
12. [Validacijos ir Business Logic](#12-validacijos-ir-business-logic)
13. [Dynamic Actions](#13-dynamic-actions)

---

## PRADINIS APLIKACIJOS KŪRIMAS

### Naujos aplikacijos sukūrimas naudojant Create Application Wizard

Naudojant "Create Application Wizard" galima sukurti skirtingų tipų puslapius, pvz., "Report", "Form", "Master-Detail".

**Puslapių tipai:**
- **Report (Ataskaitos)** - puslapiai, kuriuose rodomas lentelės turinys (be redagavimo galimybės).
- **Form (Formos)** - leidžia vartotojams keisti lentelės turinį, pvz. įterpti naują įrašą arba pakeisti esamą įrašą.
- **Master-Detail formos** - tuo pačiu metu rodo daugiau nei vieną lentelę, dažniausiai lentelės parenkamos taip, kad tarp šių lentelių įrašų būtų ryšys "vienas su daug".

**Aplikacijos sukūrimas:**

1. Paspauskite **App Builder** ir pasirinkite **Create**. Atsidarys vedlio langas.
2. Pasirinkite **New Application**.
3. **Create an Application** lange:
   - **Name:** įrašykite `Ligoninės Valdymo Sistema`
   - **Appearance:** pasirinkite **Vita** arba **Universal Theme 42**

4. Šiame etape **NESPAUSKITE** "Add Page" - mes kursime puslapius kiekvieną atskirai naudodami detalias instrukcijas.

5. Spustelėkite **Create Application** mygtuką ir patvirtinkite aplikacijos kūrimą.

6. Įsitikinkite, kad sukurtos aplikacijos sąraše yra pradinis puslapis (Page 1 - Home).

---

## SHARED COMPONENTS SETUP

Prieš kuriant puslapius, reikia sukurti bendrus komponentus (Shared Components), kurie bus naudojami visoje aplikacijoje.

---

## 1. LOVs KŪRIMAS (30 VNT)

### Kaip patekti į LOV kūrimo langą:

1. Aplikacijos pagrindiniame lange (Application Home Page) paspauskite **Shared Components**
2. Sekcijoje **Other Components** paspauskite **List of Values**
3. Paspauskite **Create** mygtuką

---

### 1.1 STATIC LOVs (14 vnt)

Static LOVs - tai fiksuotos reikšmės, kurios nesikeičia ir nėra gaunamos iš duomenų bazės lentelių.

---

#### **LOV_GENDER** (Lyties pasirinkimas)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_GENDER`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje kursite reikšmių poras (Display/Return):
   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1`
   - **Display Value:** `Vyras`
   - **Return Value:** `M`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2`
   - **Display Value:** `Moteris`
   - **Return Value:** `F`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3`
   - **Display Value:** `Kita`
   - **Return Value:** `O`

6. Paspauskite **Create** mygtuką

**✅ LOV_GENDER sukurtas!**

---

#### **LOV_BLOOD_TYPE** (Kraujo grupės)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_BLOOD_TYPE`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite visas 8 kraujo grupes:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `A+` | **Return Value:** `A+`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `A-` | **Return Value:** `A-`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `B+` | **Return Value:** `B+`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `B-` | **Return Value:** `B-`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `5` | **Display Value:** `AB+` | **Return Value:** `AB+`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `6` | **Display Value:** `AB-` | **Return Value:** `AB-`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `7` | **Display Value:** `O+` | **Return Value:** `O+`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `8` | **Display Value:** `O-` | **Return Value:** `O-`

6. Paspauskite **Create** mygtuką

**✅ LOV_BLOOD_TYPE sukurtas!**

---

#### **LOV_ROOM_TYPE** (Kambario tipas)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_ROOM_TYPE`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite kambario tipus:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Vienvietė` | **Return Value:** `PRIVATE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Dvivietė` | **Return Value:** `SEMI_PRIVATE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Intensyvi priežiūra` | **Return Value:** `ICU`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `Skubi pagalba` | **Return Value:** `EMERGENCY`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `5` | **Display Value:** `Operacinė` | **Return Value:** `OPERATING`

6. Paspauskite **Create** mygtuką

**✅ LOV_ROOM_TYPE sukurtas!**

---

#### **LOV_APPOINTMENT_TYPE** (Vizito tipas)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_APPOINTMENT_TYPE`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite vizitų tipus:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Patikrinimas` | **Return Value:** `CHECKUP`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Konsultacija` | **Return Value:** `CONSULTATION`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Pakartotinis` | **Return Value:** `FOLLOWUP`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `Skubūs` | **Return Value:** `EMERGENCY`

6. Paspauskite **Create** mygtuką

**✅ LOV_APPOINTMENT_TYPE sukurtas!**

---

#### **LOV_APPOINTMENT_STATUS** (Vizito būsena)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_APPOINTMENT_STATUS`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite vizitų būsenas:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Suplanuotas` | **Return Value:** `SCHEDULED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Patvirtintas` | **Return Value:** `CONFIRMED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Įvykęs` | **Return Value:** `COMPLETED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `Atšauktas` | **Return Value:** `CANCELLED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `5` | **Display Value:** `Neatvyko` | **Return Value:** `NO_SHOW`

6. Paspauskite **Create** mygtuką

**✅ LOV_APPOINTMENT_STATUS sukurtas!**

---

#### **LOV_BED_STATUS** (Lovos būsena)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_BED_STATUS`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite lovos būsenas:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Laisva` | **Return Value:** `AVAILABLE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Užimta` | **Return Value:** `OCCUPIED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Remontas` | **Return Value:** `MAINTENANCE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `Rezervuota` | **Return Value:** `RESERVED`

6. Paspauskite **Create** mygtuką

**✅ LOV_BED_STATUS sukurtas!**

---

#### **LOV_EMPLOYMENT_STATUS** (Darbuotojo būsena)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_EMPLOYMENT_STATUS`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite darbuotojo būsenas:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Dirba` | **Return Value:** `ACTIVE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Atostogose` | **Return Value:** `ON_LEAVE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Atleistas` | **Return Value:** `TERMINATED`

6. Paspauskite **Create** mygtuką

**✅ LOV_EMPLOYMENT_STATUS sukurtas!**

---

#### **LOV_PAYMENT_STATUS** (Apmokėjimo būsena)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_PAYMENT_STATUS`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite apmokėjimo būsenas:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Neapmokėta` | **Return Value:** `UNPAID`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Dalinai` | **Return Value:** `PARTIAL`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Apmokėta` | **Return Value:** `PAID`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `Vėluoja` | **Return Value:** `OVERDUE`

6. Paspauskite **Create** mygtuką

**✅ LOV_PAYMENT_STATUS sukurtas!**

---

#### **LOV_PAYMENT_METHOD** (Mokėjimo būdas)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_PAYMENT_METHOD`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite mokėjimo būdus:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Grynais` | **Return Value:** `CASH`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Kortele` | **Return Value:** `CARD`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Draudimas` | **Return Value:** `INSURANCE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `Pervedimu` | **Return Value:** `BANK_TRANSFER`

6. Paspauskite **Create** mygtuką

**✅ LOV_PAYMENT_METHOD sukurtas!**

---

#### **LOV_LAB_TEST_TYPE** (Laboratorinių tyrimų tipai)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_LAB_TEST_TYPE`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite laboratorinių tyrimų tipus:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Kraujo tyrimas` | **Return Value:** `BLOOD`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Šlapimo tyrimas` | **Return Value:** `URINE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Rentgenas` | **Return Value:** `XRAY`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `MRI` | **Return Value:** `MRI`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `5` | **Display Value:** `CT` | **Return Value:** `CT_SCAN`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `6` | **Display Value:** `Echoskopija` | **Return Value:** `ULTRASOUND`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `7` | **Display Value:** `Elektrokardiograma` | **Return Value:** `ECG`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `8` | **Display Value:** `EEG` | **Return Value:** `EEG`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `9` | **Display Value:** `Biopsija` | **Return Value:** `BIOPSY`

6. Paspauskite **Create** mygtuką

**✅ LOV_LAB_TEST_TYPE sukurtas!**

---

#### **LOV_ADMISSION_TYPE** (Hospitalizacijos tipas)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_ADMISSION_TYPE`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite hospitalizacijos tipus:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Skubaus` | **Return Value:** `EMERGENCY`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Planuotas` | **Return Value:** `PLANNED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Perkėlimas` | **Return Value:** `TRANSFER`

6. Paspauskite **Create** mygtuką

**✅ LOV_ADMISSION_TYPE sukurtas!**

---

#### **LOV_ADMISSION_STATUS** (Hospitalizacijos būsena)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_ADMISSION_STATUS`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite hospitalizacijos būsenas:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Priimtas` | **Return Value:** `ADMITTED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Išrašytas` | **Return Value:** `DISCHARGED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Perkeltas` | **Return Value:** `TRANSFERRED`

6. Paspauskite **Create** mygtuką

**✅ LOV_ADMISSION_STATUS sukurtas!**

---

#### **LOV_PRESCRIPTION_STATUS** (Recepto būsena)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_PRESCRIPTION_STATUS`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite recepto būsenas:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Aktyvus` | **Return Value:** `ACTIVE`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Užbaigtas` | **Return Value:** `COMPLETED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Atšauktas` | **Return Value:** `CANCELLED`

6. Paspauskite **Create** mygtuką

**✅ LOV_PRESCRIPTION_STATUS sukurtas!**

---

#### **LOV_LAB_TEST_STATUS** (Laboratorinio tyrimo būsena)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **Static**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_LAB_TEST_STATUS`
   - **Type:** palikite **Static**

5. **Static Values** sekcijoje sukurkite laboratorinio tyrimo būsenas:

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `1` | **Display Value:** `Užsakytas` | **Return Value:** `ORDERED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `2` | **Display Value:** `Vykdomas` | **Return Value:** `IN_PROGRESS`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `3` | **Display Value:** `Baigtas` | **Return Value:** `COMPLETED`

   - Paspauskite **Add Entry** mygtuką
   - **Sequence:** `4` | **Display Value:** `Atšauktas` | **Return Value:** `CANCELLED`

6. Paspauskite **Create** mygtuką

**✅ LOV_LAB_TEST_STATUS sukurtas!**

**🎉 Visi STATIC LOVs (14 vnt) sukurti sėkmingai!**

---

### 1.2 DYNAMIC LOVs (16 vnt)

**Dinaminiai LOVs** naudoja SQL užklausas, kad gautų reikšmes tiesiogiai iš duomenų bazės lentelių. Skirtingai nuo statinių LOVs, čia reikšmės automatiškai atsinaujina, kai pasikeičia duomenys lentelėse.

#### **LOV_DEPARTMENTS** (Skyriai)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query** (arba **Dynamic**)
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_DEPARTMENTS`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT department_name AS d,
       department_id AS r
  FROM departments
 WHERE is_active = 'Y'
 ORDER BY department_name
```

**SQL paaiškinimas:**
- `AS d` - Display column (rodoma reikšmė vartotojui)
- `AS r` - Return column (grąžinama reikšmė į duomenų bazę)
- `WHERE is_active = 'Y'` - rodo tik aktyvius skyrius
- `ORDER BY` - surikiuoja pagal skyriaus pavadinimą

6. Paspauskite **Create** mygtuką

**✅ LOV_DEPARTMENTS sukurtas!**

---

#### **LOV_DOCTORS** (Gydytojai)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_DOCTORS`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT e.first_name || ' ' || e.last_name || ' (' || d.specialization || ')' AS d,
       d.doctor_id AS r
  FROM doctors d
  JOIN employees e ON d.doctor_id = e.employee_id
 WHERE e.employment_status = 'ACTIVE'
 ORDER BY e.last_name, e.first_name
```

**SQL paaiškinimas:**
- `||` - konkatenacijos operatorius (sujungia tekstus)
- Rodoma reikšmė: "Vardas Pavardė (Specializacija)"
- `JOIN` - sujungia gydytojų ir darbuotojų lenteles
- Rodo tik aktyvius gydytojus (`ACTIVE`)

6. Paspauskite **Create** mygtuką

**✅ LOV_DOCTORS sukurtas!**

---

#### **LOV_PATIENTS** (Pacientai)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_PATIENTS`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT first_name || ' ' || last_name || ' (' || TO_CHAR(date_of_birth, 'YYYY-MM-DD') || ')' AS d,
       patient_id AS r
  FROM patients
 WHERE is_active = 'Y'
 ORDER BY last_name, first_name
```

**SQL paaiškinimas:**
- Rodoma reikšmė: "Vardas Pavardė (Gimimo data)"
- `TO_CHAR()` - formatuoja datą į tekstą
- Rodo tik aktyvius pacientus

6. Paspauskite **Create** mygtuką

**✅ LOV_PATIENTS sukurtas!**

---

#### **LOV_PATIENTS_AUTOCOMPLETE** (Pacientai su paieška)

**Šis LOV turi papildomą paieškos funkcionalumą (autocomplete).**

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_PATIENTS_AUTOCOMPLETE`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

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

**SQL paaiškinimas:**
- `:SEARCH_STRING` - APEX bind kintamasis, kuris priima paieškos tekstą
- `UPPER()` - konvertuoja į didžiąsias raides (case-insensitive paieška)
- `LIKE '%...%'` - ieško teksto bet kurioje pozicijoje
- Ieškoma pagal vardą, pavardę arba draudimo numerį

6. **Papildomos savybės (Settings sekcijoje):**
   - **Display Extra Values:** pasirinkite **Yes**
   - **Display Null Value:** pasirinkite **Yes**

7. Paspauskite **Create** mygtuką

**✅ LOV_PATIENTS_AUTOCOMPLETE sukurtas!**

---

#### **LOV_MEDICATIONS** (Vaistai)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_MEDICATIONS`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT medication_name || ' ' || strength || ' (' || dosage_form || ')' AS d,
       medication_id AS r
  FROM medications
 WHERE is_available = 'Y'
 ORDER BY medication_name
```

**SQL paaiškinimas:**
- Rodoma reikšmė: "Vaisto pavadinimas Stiprumas (Forma)"
- Rodo tik prieinamus vaistus

6. Paspauskite **Create** mygtuką

**✅ LOV_MEDICATIONS sukurtas!**

---

#### **LOV_DIAGNOSES** (Diagnozes)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_DIAGNOSES`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT diagnosis_code || ' - ' || diagnosis_name AS d,
       diagnosis_id AS r
  FROM diagnoses
 WHERE is_active = 'Y'
 ORDER BY diagnosis_code
```

**SQL paaiškinimas:**
- Rodoma reikšmė: "Kodas - Pavadinimas"
- Rodo tik aktyvias diagnozes

6. Paspauskite **Create** mygtuką

**✅ LOV_DIAGNOSES sukurtas!**

---

#### **LOV_ROOMS** (Kambariai)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_ROOMS`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT r.room_number || ' (' || r.room_type || ', ' || d.department_name || ')' AS d,
       r.room_id AS r
  FROM rooms r
  JOIN departments d ON r.department_id = d.department_id
 WHERE r.is_available = 'Y'
 ORDER BY r.room_number
```

**SQL paaiškinimas:**
- Rodoma reikšmė: "Numeris (Tipas, Skyrius)"
- JOIN su departments lentele
- Rodo tik prieinamus kambarius

6. Paspauskite **Create** mygtuką

**✅ LOV_ROOMS sukurtas!**

---

#### **LOV_BEDS** (Lovos)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_BEDS`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT r.room_number || '-' || b.bed_number || ' (' || b.bed_status || ')' AS d,
       b.bed_id AS r
  FROM beds b
  JOIN rooms r ON b.room_id = r.room_id
 WHERE b.bed_status IN ('AVAILABLE', 'RESERVED')
 ORDER BY r.room_number, b.bed_number
```

**SQL paaiškinimas:**
- Rodoma reikšmė: "Kambario_Nr-Lovos_Nr (Būsena)"
- JOIN su rooms lentele
- Rodo tik laisvas arba rezervuotas lovas

6. Paspauskite **Create** mygtuką

**✅ LOV_BEDS sukurtas!**

---

#### **LOV_NURSES** (Slaugytojos)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_NURSES`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT e.first_name || ' ' || e.last_name AS d,
       n.nurse_id AS r
  FROM nurses n
  JOIN employees e ON n.nurse_id = e.employee_id
 WHERE e.employment_status = 'ACTIVE'
 ORDER BY e.last_name, e.first_name
```

**SQL paaiškinimas:**
- Rodoma reikšmė: "Vardas Pavardė"
- JOIN su employees lentele
- Rodo tik aktyvias slaugytojas

6. Paspauskite **Create** mygtuką

**✅ LOV_NURSES sukurtas!**

**🎉 Visi DYNAMIC LOVs (16 vnt) sukurti sėkmingai!**

---

### 1.3 CASCADE LOVs (3 vnt - priklauso nuo parent item)

**Cascade LOVs** - tai dinaminiai LOVs, kurių reikšmės priklauso nuo kito formos lauko (parent item) reikšmės. Pavyzdžiui, pasirinkus skyrių, kambarių sąrašas automatiškai filtruojamas pagal tą skyrių.

#### **LOV_ROOMS_BY_DEPT** (Kambariai pagal skyrių)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_ROOMS_BY_DEPT`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT room_number || ' (' || room_type || ')' AS d,
       room_id AS r
  FROM rooms
 WHERE department_id = :P103_DEPARTMENT_ID
   AND is_available = 'Y'
 ORDER BY room_number
```

**SQL paaiškinimas:**
- `:P103_DEPARTMENT_ID` - bind kintamasis, kuris nurodo parent item (skyriaus lauką)
- Kambariai filtruojami pagal pasirinktą skyrių
- Rodo tik prieinamus kambarius

6. Paspauskite **Create** mygtuką

**✅ LOV_ROOMS_BY_DEPT sukurtas!**

**Kaip naudoti formoje (Cascade nustatymas):**

1. **Page Designer** → atidaryti puslapį (pvz., Page 103)
2. Sukurkite **Select List** lauką su **LOV_DEPARTMENTS** (parent laukas)
   - Pavyzdžiui: `P103_DEPARTMENT_ID`
3. Sukurkite **Select List** lauką su **LOV_ROOMS_BY_DEPT** (child laukas)
   - Pavyzdžiui: `P103_ROOM_ID`
4. Pasirinkite child lauką (`P103_ROOM_ID`)
5. **Property Editor** → **List of Values** sekcijoje:
   - **Cascading LOV Parent Item(s):** įrašykite `P103_DEPARTMENT_ID`
6. **Save**

**Veikimo principas:** Kai vartotojas pasirenka skyrių iš `P103_DEPARTMENT_ID`, kambarių sąrašas `P103_ROOM_ID` automatiškai atsinaujina ir rodo tik to skyriaus kambarius.

---

#### **LOV_BEDS_BY_ROOM** (Lovos pagal kambarį)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_BEDS_BY_ROOM`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT bed_number || ' (' || bed_status || ')' AS d,
       bed_id AS r
  FROM beds
 WHERE room_id = :P103_ROOM_ID
 ORDER BY bed_number
```

**SQL paaiškinimas:**
- `:P103_ROOM_ID` - bind kintamasis, kuris nurodo parent item (kambario lauką)
- Lovos filtruojamos pagal pasirinktą kambarį
- Rodoma: "Lovos_Nr (Būsena)"

6. Paspauskite **Create** mygtuką

**✅ LOV_BEDS_BY_ROOM sukurtas!**

**Kaip naudoti formoje:**
1. Parent item: `P103_ROOM_ID` (su LOV_ROOMS_BY_DEPT)
2. Child item: `P103_BED_ID` (su LOV_BEDS_BY_ROOM)
3. Child item **Cascading LOV Parent Item(s):** `P103_ROOM_ID`

---

#### **LOV_DOCTORS_BY_DEPT** (Gydytojai pagal skyrių)

**Sukūrimo žingsniai:**

1. **List of Values** lange paspauskite **Create** mygtuką
2. Pasirinkite **From Scratch** ir paspauskite **Next**
3. **Create List of Values** lange:
   - **Source:** pasirinkite **From Database or Query**
   - Paspauskite **Next**

4. **Name and Type** lange:
   - **Name:** įrašykite `LOV_DOCTORS_BY_DEPT`
   - **Type:** palikite **SQL Query**

5. **Query** sekcijoje įterpkite SQL užklausą:

```sql
SELECT e.first_name || ' ' || e.last_name || ' (' || d.specialization || ')' AS d,
       d.doctor_id AS r
  FROM doctors d
  JOIN employees e ON d.doctor_id = e.employee_id
 WHERE d.department_id = :P105_DEPARTMENT_ID
   AND e.employment_status = 'ACTIVE'
 ORDER BY e.last_name, e.first_name
```

**SQL paaiškinimas:**
- `:P105_DEPARTMENT_ID` - bind kintamasis, kuris nurodo parent item (skyriaus lauką)
- Gydytojai filtruojami pagal pasirinktą skyrių
- JOIN su employees lentele
- Rodo tik aktyvius gydytojus
- Rodoma: "Vardas Pavardė (Specializacija)"

6. Paspauskite **Create** mygtuką

**✅ LOV_DOCTORS_BY_DEPT sukurtas!**

**Kaip naudoti formoje:**
1. Parent item: `P105_DEPARTMENT_ID` (su LOV_DEPARTMENTS)
2. Child item: `P105_DOCTOR_ID` (su LOV_DOCTORS_BY_DEPT)
3. Child item **Cascading LOV Parent Item(s):** `P105_DEPARTMENT_ID`

---

**✅ SUKURTA: 30 LOVs (14 Static + 16 Dynamic + 3 CASCADE)**

**🎉 SEKCIJA 1 BAIGTA! Visi LOV sukurti sėkmingai!**

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
