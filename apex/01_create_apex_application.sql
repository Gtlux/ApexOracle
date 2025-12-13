-- ============================================================================
-- ORACLE APEX APPLICATION CREATION SCRIPT
-- Ligoninės Valdymo Sistema
-- Oracle APEX 22.1.0
-- ============================================================================
-- Šis scriptas sukuria bazinę APEX aplikaciją naudojant APEX API
-- Po šio scripto paleisti reikės rankiniu būdu sukonfigūruoti puslapius
-- ============================================================================

-- Nustatome workspace (pakeiskite pagal savo workspace)
-- Pastaba: Šis scriptas turi būti vykdomas su APEX workspace administratoriaus privilegijomis

BEGIN
    -- Ištriname seną aplikaciją jei egzistuoja (ID: 100)
    FOR c IN (SELECT application_id FROM apex_applications WHERE application_id = 100) LOOP
        apex_application_install.remove_application(100);
    END LOOP;
END;
/

-- Sukuriame naują aplikaciją
DECLARE
    l_app_id NUMBER := 100;
BEGIN
    -- Nustatome workspace ID (automatiškai)
    apex_application_install.set_workspace_id;

    -- Nustatome schema (DB schema name kur yra lentelės)
    apex_application_install.set_schema(USER);

    -- Sukuriame aplikaciją
    apex_application_install.generate_application_id;

    -- Generuojame offset
    apex_application_install.generate_offset;

    COMMIT;
END;
/

-- ============================================================================
-- APLIKACIJOS PAGRINDINIAI NUSTATYMAI
-- ============================================================================
-- Aplikacijos ID: 100
-- Pavadinimas: Ligoninės Valdymo Sistema
-- Alias: HOSPITAL_MGMT
-- ============================================================================

PROMPT ============================================
PROMPT Sukuriama APEX aplikacija...
PROMPT Aplikacijos ID: 100
PROMPT Pavadinimas: Ligoninės Valdymo Sistema
PROMPT ============================================

-- Aplikacijos kūrimas bus atliekamas per APEX Builder UI
-- Šis scriptas paruošia duomenų bazę ir LOV

-- ============================================================================
-- 1. SHARED COMPONENTS - LOV (List of Values)
-- ============================================================================

PROMPT Kuriami List of Values (LOV)...

-- LOV 1: Departments (Static) - naudojamas filtruose
-- Šis LOV sukurtas automatiškai iš departments lentelės

-- LOV 2: Doctors (Dynamic) - naudojamas visose formose
-- LOV 3: Patients (Dynamic) - autocomplete
-- LOV 4: Medications (Dynamic) - su stock info
-- LOV 5: Diagnoses (Static) - iš katalogo
-- LOV 6: Room Types (Static)
-- LOV 7: Payment Status (Static)
-- LOV 8: Appointment Status (Static)
-- LOV 9: Blood Types (Static)
-- LOV 10: Gender (Static)

-- Sukuriame LOV saugojimo lentelę (jei reikia)
BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE apex_lov_data (
        lov_id NUMBER PRIMARY KEY,
        lov_name VARCHAR2(100),
        display_value VARCHAR2(200),
        return_value VARCHAR2(200),
        lov_order NUMBER
    )';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN NULL; -- table already exists
        ELSE RAISE;
        END IF;
END;
/

-- ============================================================================
-- 2. APPLICATION ITEMS (Global variables)
-- ============================================================================

PROMPT Kuriami Application Items...

-- APP_USER_ID - current user employee_id
-- APP_USER_ROLE - user role (ADMIN/DOCTOR/NURSE/BILLING)
-- APP_USER_DOCTOR_ID - doctor ID if user is doctor
-- APP_USER_DEPARTMENT_ID - user's department
-- APP_CURRENT_DATE - system date

-- Šie bus sukurti per APEX Builder

-- ============================================================================
-- 3. AUTHORIZATION SCHEMES
-- ============================================================================

PROMPT Kuriamos Authorization Schemes...

-- IS_ADMIN
-- IS_DOCTOR
-- IS_NURSE
-- IS_BILLING
-- IS_MEDICAL_STAFF (Doctor OR Nurse)
-- IS_AUTHENTICATED (bet kuris prisijungęs)

-- Šie bus sukurti per APEX Builder

-- ============================================================================
-- 4. NAVIGATION MENU
-- ============================================================================

PROMPT Kuriamas Navigation Menu...

-- HOME (Page 1)
-- PACIENTAI
--   ├─ Pacientų Registras (Page 101)
--   ├─ Naujas Pacientas (Page 102)
--   ├─ Paciento Profilis (Page 103)
--   └─ Vizitų Kalendorius (Page 105)
-- PERSONALAS
--   ├─ Gydytojai (Page 201)
--   └─ Darbuotojai (Page 205)
-- SKYRIAI
--   ├─ Skyrių Valdymas (Page 301)
--   ├─ Palatų Valdymas (Page 302)
--   └─ Lovų Užimtumas (Page 303)
-- MEDICININĖ INFORMACIJA
--   ├─ Diagnozės (Page 401)
--   ├─ Receptai (Page 405)
--   └─ Vaistai (Page 406)
-- FINANSAI
--   ├─ Sąskaitos (Page 501)
--   └─ Mokėjimai (Page 502)

-- Šis bus sukurtas per APEX Builder

-- ============================================================================
-- 5. HELPER FUNCTIONS
-- ============================================================================

PROMPT Kuriamos helper funkcijos...

-- Funkcija gauti employee_id pagal APEX username
CREATE OR REPLACE FUNCTION get_employee_id_by_username(
    p_username VARCHAR2
) RETURN NUMBER
IS
    l_employee_id NUMBER;
BEGIN
    -- Paprastas mapping (realybėje būtų sudėtingesnis)
    -- Darome assumption kad APEX username = employee email prefix
    SELECT employee_id
    INTO l_employee_id
    FROM employees
    WHERE LOWER(SUBSTR(email, 1, INSTR(email, '@') - 1)) = LOWER(p_username)
    AND ROWNUM = 1;

    RETURN l_employee_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

-- Funkcija gauti user role
CREATE OR REPLACE FUNCTION get_user_role(
    p_employee_id NUMBER
) RETURN VARCHAR2
IS
    l_role VARCHAR2(50);
BEGIN
    -- Tikriname ar doctor
    BEGIN
        SELECT 'DOCTOR' INTO l_role
        FROM doctors
        WHERE doctor_id = p_employee_id;
        RETURN l_role;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- Tikriname ar nurse
    BEGIN
        SELECT 'NURSE' INTO l_role
        FROM nurses
        WHERE nurse_id = p_employee_id;
        RETURN l_role;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- Default - BILLING arba ADMIN (paprastumo dėlei)
    RETURN 'BILLING';
END;
/

-- ============================================================================
-- 6. APEX SESSION STATE SETUP
-- ============================================================================

-- Process kuris bus vykdomas application initialization
-- (sukuriamas per APEX Builder kaip Application Process)

/*
PL/SQL Code for Application Process "SET_USER_INFO":

BEGIN
    -- Set user info
    :APP_USER_ID := get_employee_id_by_username(:APP_USER);
    :APP_USER_ROLE := get_user_role(:APP_USER_ID);
    :APP_CURRENT_DATE := TO_CHAR(SYSDATE, 'YYYY-MM-DD');

    -- If doctor, set doctor_id
    IF :APP_USER_ROLE = 'DOCTOR' THEN
        :APP_USER_DOCTOR_ID := :APP_USER_ID;

        -- Get department
        SELECT department_id INTO :APP_USER_DEPARTMENT_ID
        FROM doctors
        WHERE doctor_id = :APP_USER_ID;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Default values
        :APP_USER_ID := NULL;
        :APP_USER_ROLE := 'BILLING';
END;
*/

-- ============================================================================
-- 7. SAMPLE USERS FOR TESTING
-- ============================================================================

PROMPT Kuriami test users...

-- Sukuriame APEX workspace users (jei galima)
-- Tai turi būti daroma per APEX Administration

/*
Test Users:
1. admin - Administrator (pilna prieiga)
2. doctor1 - Dr. Jonas Petraitis (jonas.petraitis@hospital.lt)
3. doctor2 - Dr. Rūta Kazlauskienė (ruta.kazlauskiene@hospital.lt)
4. nurse1 - Vida Paulauskienė (vida.paulauskiene@hospital.lt)
5. billing1 - Billing user

Passwords: (nustatomi per APEX admin)
*/

-- ============================================================================
-- PABAIGA
-- ============================================================================

PROMPT ============================================
PROMPT APEX Application Setup Complete!
PROMPT ============================================
PROMPT
PROMPT Kiti žingsniai:
PROMPT 1. Prisijunkite į APEX Builder
PROMPT 2. Sukurkite naują aplikaciją (ID: 100) arba importuokite
PROMPT 3. Sukonfigūruokite Authentication Scheme
PROMPT 4. Sukurkite puslapius pagal apex/02_apex_pages_guide.md
PROMPT 5. Sukurkite LOV pagal apex/03_apex_lovs.sql
PROMPT 6. Testuokite aplikaciją
PROMPT ============================================

COMMIT;
