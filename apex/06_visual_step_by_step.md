# VIZUALUS ŽINGSNIS PO ŽINGSNIO VADOVAS
## Kaip sukurti APEX aplikaciją iš esamų lentelių

---

## 🎯 TIKSLUS CLICK-BY-CLICK VADOVAS

### ⭐ PRADŽIA: Prisijungimas

```
┌─────────────────────────────────────────────────┐
│  Oracle APEX                                     │
│                                                  │
│  [Workspace]: HOSPITAL_WORKSPACE                │
│  [Username]:  ADMIN                              │
│  [Password]:  ********                           │
│                                                  │
│           [ Sign In ]                            │
└─────────────────────────────────────────────────┘
```

**Kas matysite:**
```
┌─────────────────────────────────────────────────┐
│ APEX Builder                                     │
├─────────────────────────────────────────────────┤
│                                                  │
│  App Builder    SQL Workshop    Team Development│
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │  [+] Create                               │   │
│  │                                           │   │
│  │  Your Applications:                       │   │
│  │  (empty - dar nėra aplikacijų)           │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

---

## ŽINGSNIS 1: Sukurti Naują Aplikaciją

### 1.1 Spauskite CREATE mygtuką

```
┌─────────────────────────────────────────────────┐
│  Create an Application                          │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐│
│  │   [📱]     │  │   [📊]     │  │   [📂]     ││
│  │   New      │  │   From a   │  │   From a   ││
│  │Application │  │   File     │  │  Database  ││
│  │            │  │            │  │            ││
│  │ ← SPAUSK   │  │            │  │ ← arba čia ││
│  └────────────┘  └────────────┘  └────────────┘│
│                                                  │
└─────────────────────────────────────────────────┘
```

**Spauskite: "New Application"** (kairysis)

---

### 1.2 Application Definition

```
┌─────────────────────────────────────────────────┐
│  Create an Application                          │
├─────────────────────────────────────────────────┤
│                                                  │
│  Name: [Ligoninės Valdymo Sistema        ]     │
│                                                  │
│  Appearance                                      │
│    Theme: [Universal Theme - 42   ▼]            │
│    Color: [Blue      ▼]                         │
│                                                  │
│  Settings                                        │
│    Features: □ Feedback                         │
│              □ Activity Reports                 │
│              ☑ Access Control                   │
│              ☑ Configuration                    │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Užpildykite:**
- Name: `Ligoninės Valdymo Sistema`
- Theme: Palikite `Universal Theme - 42`

---

### 1.3 Pridėti Puslapius

**Scroll žemyn, pamatysite:**

```
┌─────────────────────────────────────────────────┐
│  Pages                                           │
├─────────────────────────────────────────────────┤
│                                                  │
│  1. Home                                         │
│     [x] Remove    [Edit]                        │
│                                                  │
│  [ + Add Page ]  ← SPAUSK ČIA                   │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Spauskite: "+ Add Page"**

---

### 1.4 Pasirinkite Page Type

```
┌─────────────────────────────────────────────────┐
│  Add Page                                        │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │ [📊] Interactive Report                   │   │
│  │      Create a report with search and      │   │
│  │      filters                               │   │
│  │                          ← SPAUSK ČIA     │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │ [📝] Form                                  │   │
│  │      Create or edit a single record       │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │ [📅] Calendar                              │   │
│  │      Display events on a calendar         │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │ [👥] Master Detail                         │   │
│  │      Display parent and child records     │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  ... (daugiau options)                          │
│                                                  │
│  [Cancel]                    [Next >]            │
└─────────────────────────────────────────────────┘
```

**Spauskite: "Interactive Report"**

---

### 1.5 Interactive Report Setup

```
┌─────────────────────────────────────────────────┐
│  Create Interactive Report                      │
├─────────────────────────────────────────────────┤
│                                                  │
│  Page Name: [Pacientų Registras           ]    │
│                                                  │
│  Table/View Name: [▼ Select...             ]    │
│                     ↓ Spausk ir ieškokpaščių!   │
│  ┌──────────────────────────────────────────┐   │
│  │  Search: [patients________]              │   │
│  │                                           │   │
│  │  Tables:                                  │   │
│  │  ☑ ADMISSIONS                             │   │
│  │  ☑ APPOINTMENTS                           │   │
│  │  ☑ BEDS                                   │   │
│  │  ☑ BILLS                                  │   │
│  │  ☑ DEPARTMENTS                            │   │
│  │  ☑ DIAGNOSES                              │   │
│  │  ☑ DOCTORS                                │   │
│  │  ☑ EMPLOYEES                              │   │
│  │  ☑ LAB_TESTS                              │   │
│  │  ☑ MEDICATIONS                            │   │
│  │  ☑ NURSES                                 │   │
│  │  ☑ PATIENTS          ← Pasirink!         │   │
│  │  ☑ PATIENT_DIAGNOSES                      │   │
│  │  ☑ PRESCRIPTIONS                          │   │
│  │  ☑ ROOMS                                  │   │
│  │                                           │   │
│  │  Views:                                   │   │
│  │  ☑ V_ADMISSIONS_CURRENT                   │   │
│  │  ☑ V_APPOINTMENTS_CALENDAR                │   │
│  │  ☑ V_BEDS_OCCUPANCY                       │   │
│  │  ☑ V_BILLS_DETAILED                       │   │
│  │  ☑ V_DASHBOARD_STATS                      │   │
│  │  ☑ V_DEPARTMENT_STATS                     │   │
│  │  ☑ V_DOCTORS_FULL                         │   │
│  │  ☑ V_LAB_TESTS_FULL                       │   │
│  │  ☑ V_PATIENTS_FULL    ← Geriau šis!      │   │
│  │  ☑ V_PRESCRIPTIONS_FULL                   │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  Include Form Page?  ● Yes  ○ No                │
│                       ↑ SPAUSK                   │
│                                                  │
│  Form Page Mode:  ● Modal Dialog                │
│                   ○ Inline                       │
│                                                  │
│  Primary Key:  [PATIENT_ID ▼]                   │
│                (auto-detected)                   │
│                                                  │
│  [Cancel]  [< Previous]  [Add Page]             │
│                            ↑ SPAUSK              │
└─────────────────────────────────────────────────┘
```

**Užpildykite:**
1. Page Name: `Pacientų Registras`
2. Table/View: `V_PATIENTS_FULL` (naudokite VIEW!)
3. Include Form: **Yes** (modal dialog)
4. Primary Key: `PATIENT_ID` (auto)

**Spauskite: "Add Page"**

---

### 1.6 Pamatysite Pridėtą Puslapį

```
┌─────────────────────────────────────────────────┐
│  Pages                                           │
├─────────────────────────────────────────────────┤
│                                                  │
│  1. Home                                         │
│     [x] Remove    [Edit]                        │
│                                                  │
│  2. Pacientų Registras (Interactive Report)     │
│     [x] Remove    [Edit]                        │
│                                                  │
│  3. Pacientų Registras - Form                   │
│     [x] Remove    [Edit]                        │
│                                                  │
│  [ + Add Page ]  ← Pridėkite daugiau!           │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Matote? APEX automatiškai sukūrė 2 puslapius:**
- Page 2: Interactive Report
- Page 3: Form (Create/Edit)

---

### 1.7 Pridėkite Daugiau Puslapių

**Pakartokite "Add Page" su kitomis lentelėmis:**

#### Vizitų Kalendorius

**Spauskite: "+ Add Page"**

```
┌─────────────────────────────────────────────────┐
│  Add Page                                        │
├─────────────────────────────────────────────────┤
│                                                  │
│  [📅] Calendar    ← SPAUSK                      │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Calendar Setup:**
```
┌─────────────────────────────────────────────────┐
│  Create Calendar                                 │
├─────────────────────────────────────────────────┤
│                                                  │
│  Page Name: [Vizitų Kalendorius           ]    │
│                                                  │
│  Table/View: [APPOINTMENTS            ▼]        │
│                                                  │
│  Display Column:  [Select column...    ▼]       │
│                                                  │
│    ↓ Čia galite sukurti custom:                 │
│    SQL Expression:                               │
│    ┌──────────────────────────────────────┐     │
│    │ (SELECT p.first_name || ' ' ||       │     │
│    │         p.last_name                  │     │
│    │  FROM patients p                     │     │
│    │  WHERE p.patient_id =                │     │
│    │        appointments.patient_id)      │     │
│    └──────────────────────────────────────┘     │
│                                                  │
│  Start Date Column: [APPOINTMENT_DATE    ▼]     │
│                                                  │
│  End Date Column:   [APPOINTMENT_DATE    ▼]     │
│                                                  │
│  Primary Key: [APPOINTMENT_ID            ▼]     │
│                                                  │
│  [Add Page]                                      │
└─────────────────────────────────────────────────┘
```

---

### 1.8 Pakartokite su Visomis Lentelėmis

**Rekomenduojami puslapiai:**

```
┌─────────────────────────────────────────────────┐
│  Pages Summary                                   │
├─────────────────────────────────────────────────┤
│                                                  │
│  ✅ 1. Home (Blank)                             │
│  ✅ 2. Pacientų Registras (IR)                  │
│  ✅ 3. Pacientų Registras - Form                │
│  ✅ 4. Vizitų Kalendorius (Calendar)            │
│  ✅ 5. Gydytojų Katalogas (IR)                  │
│  ✅ 6. Gydytojų Katalogas - Form                │
│  ✅ 7. Skyrių Valdymas (IR)                     │
│  ✅ 8. Skyrių Valdymas - Form                   │
│  ✅ 9. Palatų Valdymas (IR)                     │
│  ✅ 10. Palatų Valdymas - Form                  │
│  ✅ 11. Lovų Užimtumas (IR)                     │
│  ✅ 12. Vaistų Katalogas (IR)                   │
│  ✅ 13. Vaistų Katalogas - Form                 │
│  ✅ 14. Receptų Valdymas (IR)                   │
│  ✅ 15. Receptų Valdymas - Form                 │
│  ✅ 16. Sąskaitų Registras (IR)                 │
│  ✅ 17. Sąskaitų Registras - Form               │
│  ✅ 18. Lab Tyrimai (IR)                        │
│  ✅ 19. Lab Tyrimai - Form                      │
│                                                  │
│  Viso: 19 puslapių                              │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

### 1.9 Create Application!

**Scroll žemyn ir spauskite:**

```
┌─────────────────────────────────────────────────┐
│                                                  │
│  [ < Previous ]    [ Create Application ]       │
│                            ↑                     │
│                         SPAUSK!                  │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Kas nutinka:**
```
┌─────────────────────────────────────────────────┐
│  Creating Application...                         │
│                                                  │
│  ████████████████████░░░░░  75%                 │
│                                                  │
│  Creating pages...                               │
│  Creating navigation...                          │
│  Creating validations...                         │
│  Creating processes...                           │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Po ~30 sekundžių:**
```
┌─────────────────────────────────────────────────┐
│  ✓ Application Created Successfully!             │
│                                                  │
│  Application ID: 100                             │
│  Name: Ligoninės Valdymo Sistema                │
│                                                  │
│  [Run Application]  [Edit Application]          │
│          ↑               ↑                       │
│       Testuoti        Redaguoti                  │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

## ŽINGSNIS 2: Paleidimas ir Testavimas

### 2.1 Run Application

**Spauskite: "Run Application"**

```
┌─────────────────────────────────────────────────┐
│  Ligoninės Valdymo Sistema                      │
│                                                  │
│  Username: [ADMIN              ]                │
│  Password: [********           ]                │
│                                                  │
│  [ Sign In ]                                     │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

### 2.2 Pamatysite Aplikaciją!

```
┌─────────────────────────────────────────────────┐
│  Ligoninės Valdymo Sistema                      │
├─────────────────────────────────────────────────┤
│  ☰                                       [👤]   │
├─────────────────────────────────────────────────┤
│                                                  │
│  Home                                            │
│                                                  │
│  Welcome to Ligoninės Valdymo Sistema           │
│                                                  │
└─────────────────────────────────────────────────┘

┌─ Navigation (kairėje) ──────────────────────────┐
│                                                  │
│  🏠 Home                                         │
│  📋 Pacientų Registras                          │
│  📅 Vizitų Kalendorius                          │
│  👨‍⚕️ Gydytojų Katalogas                          │
│  🏥 Skyrių Valdymas                             │
│  🛏️ Palatų Valdymas                             │
│  🛏️ Lovų Užimtumas                              │
│  💊 Vaistų Katalogas                            │
│  📝 Receptų Valdymas                            │
│  💰 Sąskaitų Registras                          │
│  🔬 Lab Tyrimai                                 │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

### 2.3 Atidarykite Pacientų Registrą

**Spauskite: "Pacientų Registras"**

```
┌─────────────────────────────────────────────────────────────┐
│  Pacientų Registras                                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  🔍 Search: [____________]  [Go]  [ Create ]                │
│                                           ↑                  │
│                                      Naujas pacientas        │
│                                                              │
│  Actions ▼  Format ▼  Download ▼                            │
│                                                              │
├──────┬─────────────┬─────┬────────┬──────────┬──────────────┤
│  ID  │  Full Name  │ Age │ Gender │  Phone   │    City      │
├──────┼─────────────┼─────┼────────┼──────────┼──────────────┤
│  1   │ Petras S.   │ 60  │ Vyras  │+370 601..│   Vilnius    │
│  2   │ Ona J.      │ 47  │ Moteris│+370 602..│   Vilnius    │
│  3   │ Marija U.   │ 15  │ Moteris│+370 603..│   Vilnius    │
│  4   │ Antanas G.  │ 73  │ Vyras  │+370 604..│   Vilnius    │
│  5   │ Jurgita V.  │ 33  │ Moteris│+370 605..│   Vilnius    │
│  ...                                                         │
├──────┴─────────────┴─────┴────────┴──────────┴──────────────┤
│  1 - 5 of 10                          ◀ 1 2 ▶               │
└─────────────────────────────────────────────────────────────┘
```

**Matote VISUS pacientus iš DB!** ✅

---

### 2.4 Sukurti Naują Pacientą

**Spauskite: "Create" mygtuką**

**Atsidarys Modal Dialog:**

```
┌─────────────────────────────────────────────────┐
│  Pacientų Registras                        [×]  │
├─────────────────────────────────────────────────┤
│                                                  │
│  Vardas *                                        │
│  [_____________________________]                │
│                                                  │
│  Pavardė *                                       │
│  [_____________________________]                │
│                                                  │
│  Gimimo Data *                                   │
│  [____/__/____] 📅                              │
│                                                  │
│  Lytis *                                         │
│  ○ Vyras  ○ Moteris  ○ Kita                    │
│                                                  │
│  Kraujo Grupė                                    │
│  [Select...                ▼]                   │
│   A+, A-, B+, B-, AB+, AB-, O+, O-              │
│                                                  │
│  Telefonas *                                     │
│  [_____________________________]                │
│                                                  │
│  El. Paštas                                      │
│  [_____________________________]                │
│                                                  │
│  ... (daugiau laukų)                            │
│                                                  │
│  [ Cancel ]               [ Create ]            │
│                                ↑                 │
│                            Išsaugoti             │
│                                                  │
└─────────────────────────────────────────────────┘
```

**Visi laukai automatiškai sugeneruoti iš PATIENTS lentelės!** ✅

---

## ŽINGSNIS 3: Customization (Post-Generation)

### 3.1 Grįžkite į App Builder

**Spauskite "Developer Toolbar" (apačioje):**

```
┌─────────────────────────────────────────────────┐
│  🔧 Developer Toolbar                            │
├─────────────────────────────────────────────────┤
│                                                  │
│  [ Edit Page 2 ]  [ Session ]  [ Debug ]        │
│        ↑                                         │
│     SPAUSK                                       │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

### 3.2 Edit Page Designer

```
┌────────────────────────────────────────────────────────────────┐
│  Application 100 > Page 2                                       │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─ Rendering ────────┬─ Layout ─────────┬─ Properties ─────┐ │
│  │                    │                  │                   │ │
│  │ Page 2             │  ┌──────────────┐│  Region:          │ │
│  │  ├─ Pacientų Reg.  │  │  Search Bar  ││  Name: Pacientų R.│ │
│  │  │  └─ Columns     │  ├──────────────┤│  Type: IR         │ │
│  │  │     ├─ PATIENT..│  │              ││  Source:          │ │
│  │  │     ├─ FULL_NAM │  │  [Report]    ││  SELECT...        │ │
│  │  │     ├─ AGE      │  │  [Grid]      ││                   │ │
│  │  │     ├─ GENDER   │  │  [Cards]     ││  ┌──────────────┐ │ │
│  │  │     └─ ...      │  │              ││  │ [Edit]       │ │ │
│  │  │                 │  │              ││  └──────────────┘ │ │
│  │  └─ Region Butto..│  │              ││                   │ │
│  │     └─ CREATE     │  └──────────────┘│                   │ │
│  │                    │                  │                   │ │
│  └────────────────────┴──────────────────┴───────────────────┘ │
│                                                                 │
│  [ Save ]  [ Run ]                                             │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

### 3.3 Pridėti Filtrus

**1. Kairėje (Rendering Tree):**

```
Right-click ant "Pacientų Registras"
→ Create Page Item
```

**2. Properties (dešinėje):**

```
┌─────────────────────────────────────────────────┐
│  Page Item Properties                            │
├─────────────────────────────────────────────────┤
│                                                  │
│  Name: [P2_CITY                    ]            │
│                                                  │
│  Type: [Select List                ▼]          │
│                                                  │
│  Label: [Miestas                   ]            │
│                                                  │
│  ───────────────────────────────────            │
│  List of Values                                  │
│                                                  │
│  Type: ● SQL Query                               │
│                                                  │
│  SQL Query:                                      │
│  ┌──────────────────────────────────────────┐   │
│  │ SELECT DISTINCT city AS d, city AS r     │   │
│  │ FROM patients                             │   │
│  │ WHERE city IS NOT NULL                    │   │
│  │ ORDER BY city                             │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  Display Null: ☑                                │
│  Null Value: [- Visi -               ]         │
│                                                  │
└─────────────────────────────────────────────────┘
```

**3. Modifikuokite Report SQL:**

```
Kairėje: Pacientų Registras region
→ Properties (dešinė)
→ Source → SQL Query:

┌──────────────────────────────────────────────────┐
│ SELECT *                                          │
│ FROM v_patients_full                              │
│ WHERE 1=1                                         │
│   AND (:P2_CITY IS NULL OR city = :P2_CITY)      │
│   AND (:P2_GENDER IS NULL OR gender = :P2_GENDER)│
│ ORDER BY last_name, first_name                   │
└──────────────────────────────────────────────────┘
```

**Spauskite: Save → Run**

---

### 3.4 Pamatysite Filtrus!

```
┌─────────────────────────────────────────────────────────────┐
│  Pacientų Registras                                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Miestas: [- Visi -        ▼]                               │
│  Lytis:   [- Visi -        ▼]                               │
│                                                              │
│  🔍 Search: [____________]  [Go]  [ Create ]                │
│                                                              │
├──────┬─────────────┬─────┬────────┬──────────┬──────────────┤
│  ID  │  Full Name  │ Age │ Gender │  Phone   │    City      │
├──────┼─────────────┼─────┼────────┼──────────┼──────────────┤
│  1   │ Petras S.   │ 60  │ Vyras  │+370 601..│   Vilnius    │
│  ...                                                         │
└─────────────────────────────────────────────────────────────┘
```

**Filtrai veikia!** ✅

---

## ŽINGSNIS 4: Master-Detail

### 4.1 Create Master-Detail Page

**App Builder → Create Page**

```
┌─────────────────────────────────────────────────┐
│  Add Page                                        │
├─────────────────────────────────────────────────┤
│                                                  │
│  [👥] Master Detail                              │
│       ↑ SPAUSK                                   │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

### 4.2 Master-Detail Wizard

```
┌─────────────────────────────────────────────────┐
│  Create Master Detail                            │
├─────────────────────────────────────────────────┤
│                                                  │
│  Page Name: [Paciento Profilis           ]     │
│                                                  │
│  Master Table: [PATIENTS              ▼]        │
│                                                  │
│  Master Primary Key: [PATIENT_ID       ▼]       │
│                (auto-detected)                   │
│                                                  │
│  Detail Table: [APPOINTMENTS          ▼]        │
│                                                  │
│  Detail Foreign Key: [PATIENT_ID       ▼]       │
│                 (auto-detected!)                 │
│                                                  │
│  Master Detail Layout:                           │
│    ● Stacked                                     │
│    ○ Side by Side      ← Pasirink šį!           │
│    ○ Drill Down                                  │
│                                                  │
│  [Create]                                        │
│                                                  │
└─────────────────────────────────────────────────┘
```

**APEX automatiškai atpažino Foreign Key!** ✅

---

### 4.3 Master-Detail Result

```
┌────────────────────────────────────────────────────────┐
│  Paciento Profilis                                      │
├────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─ Master (Paciento Info) ─────────────────────────┐  │
│  │                                                   │  │
│  │  Vardas: Petras Sabonis                          │  │
│  │  Gimimo Data: 1965-04-12                         │  │
│  │  Amžius: 60                                       │  │
│  │  Lytis: Vyras                                     │  │
│  │  Telefonas: +370 601 11111                       │  │
│  │                                                   │  │
│  │  [ Edit ]                                         │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
│  ┌─ Details (Vizitai) ─────────────────────────────┐   │
│  │                                                   │  │
│  │  ┌─────┬──────────┬────────┬────────┬──────────┐│  │
│  │  │ ID  │  Data    │ Laikas │ Gydyt. │ Statusas ││  │
│  │  ├─────┼──────────┼────────┼────────┼──────────┤│  │
│  │  │ 1   │2025-12-13│ 09:00  │Dr.Jon..│CONFIRMED││  │
│  │  │ 6   │2025-11-13│ 09:30  │Dr.Jon..│COMPLETED││  │
│  │  └─────┴──────────┴────────┴────────┴──────────┘│  │
│  │                                                   │  │
│  │  [ Add Vizitas ]                                 │  │
│  └───────────────────────────────────────────────────┘  │
│                                                         │
└────────────────────────────────────────────────────────┘
```

**Automatiškai sukurta Master-Detail forma!** ✅

---

## SUMMARY: KAS AUTOMATIŠKAI SUGENERUOJAMA

### ✅ Interactive Report:
- Visi stulpeliai iš lentelės
- Search bar
- Actions menu (Download, Filter, etc.)
- Pagination
- Edit link (jei include form)
- Create button

### ✅ Form:
- Visi form items
- Automatic data types
  - VARCHAR2 → Text Field
  - NUMBER → Number Field
  - DATE → Date Picker
  - CHAR(1) → Radio/Checkbox (jei matomas pattern)
- NOT NULL → Required (*)
- Primary Key → Hidden
- Foreign Keys → Select List (bet reikia customize į LOV)
- Save button
- Cancel button
- Delete button (edit mode)
- Automatic DML (INSERT/UPDATE/DELETE)

### ✅ Calendar:
- Month/Week/Day/List views
- Event display
- Click to view
- Drag & drop support
- Color coding

### ✅ Master-Detail:
- Master form/display
- Detail report
- Automatic JOIN per FK
- Add detail button
- Edit detail inline

### ✅ Navigation:
- Desktop menu
- Mobile menu
- Breadcrumbs
- Home button

---

## KO REIKIA CUSTOMIZE (Post-Generation)

### 1. Foreign Keys → Better LOV
```
Vietoj:
  [1, 2, 3, 4]  ← Patient ID (neaiškus)

Pakeiskite į:
  [Petras Sabonis, Ona Jakutienė, ...]  ← Vardas
```

### 2. Labels → Lithuanian
```
Vietoj:
  "First Name"  → "Vardas"
  "Last Name"   → "Pavardė"
  "Phone Number" → "Telefonas"
```

### 3. Format Masks
```
Phone: +370 000 00000
Date:  YYYY-MM-DD
Money: €999,990.00
```

### 4. Validations
```
Email format
Phone format
Date ranges
Business rules
```

### 5. Conditional Display
```
IF status = 'ADMITTED' THEN show discharge button
IF balance > 0 THEN show payment button
```

---

## TIMELINE

**Automatinis Generavimas:**
- Create app wizard: **15 min**
- Add 15 tables × 2 min: **30 min**
- **TOTAL: 45 min** → Turite 30+ puslapių aplikaciją!

**Customization:**
- FK → LOV: **1 val**
- Labels lietuviškai: **30 min**
- Validations: **1 val**
- Filters: **1 val**
- Testing: **30 min**
- **TOTAL: ~4 val**

**GRAND TOTAL: ~5 valandos** vietoj 10+ val manual!

---

Ar norėtumėte kad parodysiu kaip customize konkretų puslapį? Pvz. kaip pakeisti Foreign Key į gražų LOV su paciento vardu?
