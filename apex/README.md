# ORACLE APEX APLIKACIJA
## Ligoninės Valdymo Sistema

**Aplikacijos ID:** 100
**APEX Versija:** 22.1.0
**Schema:** HOSPITAL_DB

---

## 📁 FAILŲ STRUKTŪRA

```
apex/
├── README.md                           # Šis failas
├── 01_create_apex_application.sql      # Helper funkcijos ir setup
├── 02_create_lovs.sql                  # 30 LOV aprašymai
├── 03_apex_pages_complete_guide.md     # Visų puslapių specifikacijos
└── 04_apex_import_instructions.md      # Detalios diegimo instrukcijos
```

---

## 🎯 APLIKACIJOS APŽVALGA

### Puslapiai (20+)

| Page | Pavadinimas | Tipas | Reikalavimas |
|------|-------------|-------|--------------|
| 1 | Dashboard | Blank | - |
| 101 | Pacientų Registras | Interactive Report | ✅ REQ 3 |
| 102 | Paciento Forma | Form (Modal) | ✅ REQ 3 CRUD |
| 103 | Paciento Profilis | Master-Detail | ✅ REQ 5 |
| 105 | Vizitų Kalendorius | Calendar | ✅ REQ 6 |
| 106 | Naujo Vizito Forma | Form (Modal) | - |
| 201 | Gydytojų Katalogas | Cards | - |
| 202 | Gydytojo Profilis | Display | - |
| 205 | Darbuotojų Valdymas | Interactive Grid | - |
| 301 | Skyrių Valdymas | Interactive Report | - |
| 302 | Palatų Valdymas | Interactive Grid | - |
| 303 | Lovų Užimtumas | Classic Report | - |
| 401 | Diagnozių Katalogas | Interactive Grid | - |
| 405 | Receptų Valdymas | Interactive Report | Multiple LOVs |
| 406 | Vaistų Katalogas | Interactive Grid | - |
| 407 | Naujo Recepto Forma | Form (Modal) | - |
| 408 | Lab Tyrimai | Interactive Report | - |
| 501 | Sąskaitų Registras | Interactive Report | ✅ REQ 4 (VIEW) |
| 502 | Mokėjimo Priėmimas | Form (Modal) | - |
| 503 | Naujos Sąskaitos Forma | Form (Modal) | - |

---

## 📊 LIST OF VALUES (30)

### Static LOV (14)
1. Gender (Lytis)
2. Blood Type (Kraujo grupė)
3. Room Type (Palatos tipas)
4. Bed Status (Lovos statusas)
5. Appointment Type (Vizito tipas)
6. Appointment Status (Vizito statusas)
7. Payment Status (Mokėjimo statusas)
8. Payment Method (Mokėjimo būdas)
9. Employment Status (Darbo statusas)
10. Shift Preference (Pamaina)
11. Dosage Form (Vaisto forma)
12. Test Type (Tyrimo tipas)
13. Admission Type (Priėmimo tipas)
14. Yes/No (Taip/Ne)

### Dynamic LOV (16)
15. Departments (Skyriai)
16. Doctors (Gydytojai)
17. Doctors by Department (CASCADE)
18. Nurses (Seserys)
19. Patients (AUTOCOMPLETE)
20. Medications (POPUP with search)
21. Medications in Stock
22. Diagnoses (POPUP with search)
23. Rooms (Palatai)
24. Available Beds (Laisvos lovos)
25. Available Beds by Department (CASCADE)
26. Active Admissions
27. Patient Appointments (CASCADE)
28. Specializations
29. Medication Categories
30. Diagnosis Categories

**CASCADE LOV:** 3
**POPUP/AUTOCOMPLETE LOV:** 3

---

## ✅ REIKALAVIMŲ ATITIKIMAS

### Privalomi Reikalavimai

1. **REQ 1:** ✅ Pradinis puslapis su navigacija
   - **Page 1** - Dashboard su KPI cards ir navigacijos mygtukais

2. **REQ 2:** ✅ Patogu navigacija
   - Desktop Navigation Menu su hierarchija
   - Breadcrumbs
   - Mygtukai tarp puslapių

3. **REQ 3:** ✅ Interactive Report su filtrais ir CRUD
   - **Page 101** - Pacientų Registras
   - 4 filtrai (miestas, lytis, kraujo grupė, hospitalizuoti)
   - CRUD operacijos (Create, Read, Update, Delete)
   - Validacijos ir klaidos pranešimai
   - Mygtukai: Naujas, Redaguoti, Ištrinti

4. **REQ 4:** ✅ Report naudojant VIEW su kelių lentelių duomenimis
   - **Page 501** - Sąskaitų Registras
   - Naudoja **v_bills_detailed** VIEW
   - JOIN: bills + patients + admissions + appointments
   - 5 filtrai
   - CRUD operacijos

5. **REQ 5:** ✅ Master-Detail forma (Side by Side)
   - **Page 103** - Paciento Profilis
   - Master: Paciento informacija (kairė)
   - Detail: 6 tabs su susijusiais duomenimis (dešinė)
   - **Side by Side layout** (NE stacked!)
   - Editable details (diagnozės per Interactive Grid)
   - Validacijos

6. **REQ 6:** ✅ Kalendorius su įrašų perkėlimu ir redagavimu
   - **Page 105** - Vizitų Kalendorius
   - Drag & Drop enabled
   - Edit on click
   - Create new appointment
   - Validacija: no overlapping appointments

7. **LOV Requirement:** ✅ 3+ LOV, bent vienas dinaminis
   - **30 LOV total!**
   - 14 Static LOV
   - 16 Dynamic LOV
   - 3 CASCADE LOV (priklauso nuo parent)
   - 3 POPUP/Autocomplete LOV

8. **Visos lentelės panaudotos:** ✅ 15/15
   - DEPARTMENTS, ROOMS, BEDS
   - EMPLOYEES, DOCTORS, NURSES
   - PATIENTS, APPOINTMENTS, ADMISSIONS
   - DIAGNOSES, PATIENT_DIAGNOSES
   - MEDICATIONS, PRESCRIPTIONS
   - LAB_TESTS, BILLS

9. **Duomenų kontrolė:** ✅
   - Validacijos kiekviename forme
   - Required fields
   - Format masks (phone, email, date)
   - Business logic triggers
   - Aiškūs klaidos pranešimai lietuvių kalba

10. **Lietuvių kalba:** ✅
    - Visos etiketės lietuvių kalba
    - Taisyklinga gramatika
    - Aiškūs pranešimai
    - Help text lietuviškai

---

## 🚀 GREITAS STARTAS

### 1. Prieš Pradedant

Įsitikinkite, kad turite:
- ✅ Oracle Database 12c+
- ✅ Oracle APEX 22.1.0+
- ✅ Paleisti DB schema scripts:
  ```bash
  @database/schema/01_create_tables.sql
  @database/schema/02_create_triggers.sql
  @database/schema/03_create_views.sql
  @database/sample_data/04_insert_sample_data.sql
  @apex/01_create_apex_application.sql
  ```

### 2. Import Instrukcijos

**Sekite detalias instrukcijas:**
📖 `04_apex_import_instructions.md`

**Greitas kelias:**
1. Sukurkite workspace
2. Sukurkite aplikaciją (ID: 100)
3. Sukurkite 30 LOV (`02_create_lovs.sql`)
4. Sukurkite puslapius (`03_apex_pages_complete_guide.md`)
5. Testuokite!

### 3. Prioritetiniai Puslapiai (MVP)

Jei norite greitai testuoti, sukurkite šiuos puslapius pirmiausia:

**Privalomi (atitinka reikalavimus):**
1. Page 1 - Dashboard
2. Page 101 - Pacientų Registras (REQ 3)
3. Page 102 - Paciento Forma (REQ 3 CRUD)
4. Page 103 - Paciento Profilis (REQ 5 Master-Detail)
5. Page 105 - Vizitų Kalendorius (REQ 6)
6. Page 501 - Sąskaitos (REQ 4 VIEW)

**Papildomi (funkcionalumas):**
7. Page 405 - Receptai (daug LOV)
8. Page 406 - Vaistai (stock management)
9. Page 303 - Lovų Užimtumas (real-time board)

---

## 📖 DOKUMENTACIJA

### Failai

1. **`01_create_apex_application.sql`**
   - Helper funkcijos
   - Application items
   - Initial setup

2. **`02_create_lovs.sql`**
   - Visi 30 LOV
   - SQL queries
   - APEX Builder instrukcijos

3. **`03_apex_pages_complete_guide.md`**
   - Detali kiekvieno puslapio specifikacija
   - SQL queries
   - Page items
   - Validations
   - Processes
   - Navigation

4. **`04_apex_import_instructions.md`**
   - Žingsnis po žingsnio instrukcijos
   - Workspace setup
   - Page creation
   - Testing
   - Troubleshooting

---

## 🧪 TESTAVIMAS

### Test Users

Sukurkite šiuos test users:

```
Username: admin
Email: admin@hospital.lt
Groups: ADMIN
---
Username: jonas.petraitis
Email: jonas.petraitis@hospital.lt
Groups: DOCTOR
---
Username: vida.paulauskiene
Email: vida.paulauskiene@hospital.lt
Groups: NURSE
---
Username: billing
Email: billing@hospital.lt
Groups: BILLING
```

### Test Scenarios

**1. Pacientų modulis (Pages 101-103):**
- [ ] Sukurti naują pacientą
- [ ] Filtruoti pagal miestą, lytį, kraujo grupę
- [ ] Redaguoti pacientą
- [ ] Ištrinti pacientą
- [ ] Atidaryti paciento profilį
- [ ] Peržiūrėti 6 tabs profiliui

**2. Kalendorius (Page 105):**
- [ ] Sukurti naują vizitą
- [ ] Perkelti vizitą drag & drop
- [ ] Redaguoti vizitą
- [ ] Validacija: overlapping appointments

**3. Sąskaitos (Pages 501-502):**
- [ ] Report rodo duomenis iš VIEW
- [ ] Filtruoti pagal 5 parametrus
- [ ] Priimti mokėjimą
- [ ] Automatic status update

**4. LOV:**
- [ ] Static LOV veikia
- [ ] Dynamic LOV rodo duomenis
- [ ] CASCADE LOV priklauso nuo parent
- [ ] Popup/Autocomplete search veikia

---

## 🔧 KONFIGŪRACIJA

### Application Items

```
APP_USER_ID - NUMBER
APP_USER_ROLE - VARCHAR2
APP_USER_DOCTOR_ID - NUMBER
APP_USER_DEPARTMENT_ID - NUMBER
APP_CURRENT_DATE - VARCHAR2
```

### Authorization Schemes

```
IS_AUTHENTICATED
IS_ADMIN
IS_DOCTOR
IS_MEDICAL_STAFF
IS_BILLING
```

### Globalization

```
Primary Language: Lithuanian (lt)
Date Format: YYYY-MM-DD
Number Format: 999G999G999G990D00
```

---

## 📊 STATISTIKA

- **Puslapių:** 20+
- **LOV:** 30 (14 static + 16 dynamic)
- **Regions:** 50+
- **Forms:** 10+
- **Reports:** 15+
- **Lentelių panaudota:** 15/15
- **Views panaudota:** 10+
- **Validacijų:** 30+

---

## 🎨 THEME

**Universal Theme 42**
- Modern, responsive
- Mobile-friendly
- Customizable
- Built-in components

---

## 📝 PASTABOS

### Svarbios Detalės

1. **Master-Detail Layout:**
   - Naudokite **Side by Side**, NE Stacked
   - Master kairėje, Details dešinėje su tabs

2. **LOV:**
   - Sukurkite VISUS 30 LOV
   - Naudokite CASCADE LOV kur tinka
   - Popup LOV su search functionality

3. **Validations:**
   - Visi required laukai pažymėti *
   - Email, phone format validation
   - Business logic validation
   - Aiškūs lietuviški pranešimai

4. **Navigation:**
   - Desktop Navigation Menu
   - Breadcrumbs
   - Back buttons
   - Clear structure

---

## 🆘 TROUBLESHOOTING

### Dažniausios Problemos

**1. "Table or view does not exist"**
```sql
-- Solution:
@database/schema/03_create_views.sql
```

**2. LOV negrąžina duomenų**
```sql
-- Solution:
@database/sample_data/04_insert_sample_data.sql
```

**3. Trigger klaidos**
```sql
-- Solution:
SELECT trigger_name, status FROM user_triggers WHERE status = 'INVALID';
ALTER TRIGGER trigger_name COMPILE;
```

**Daugiau:** Žiūrėkite `04_apex_import_instructions.md` → Troubleshooting

---

## 📞 SUPPORT

- **Documentation:** Šis folder
- **Issues:** GitHub repository
- **Email:** Jūsų kontaktas

---

## ✅ CHECKLIST

### Prieš Įdiegiant

- [ ] Oracle DB 12c+ instaliuota
- [ ] APEX 22.1.0+ instaliuota
- [ ] Schema sukurta
- [ ] Lentelės sukurtos (15)
- [ ] Triggers sukurti (~20)
- [ ] Views sukurti (~15)
- [ ] Testiniai duomenys įterpti

### Diegimo Metu

- [ ] Workspace sukurtas
- [ ] Aplikacija sukurta (ID: 100)
- [ ] Application Items sukurti
- [ ] Authorization Schemes sukurti
- [ ] LOV sukurti (30)
- [ ] Navigation Menu sukurtas
- [ ] Puslapiai sukurti (20+)

### Po Diegimo

- [ ] Test users sukurti
- [ ] User groups sukurti
- [ ] Visi puslapiai testuojami
- [ ] Visos funkcijos veikia
- [ ] Atitinka reikalavimus

---

**Sėkmės kuriant aplikaciją!** 🚀
