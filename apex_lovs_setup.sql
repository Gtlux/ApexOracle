-- ============================================================================
-- APEX LOVs SETUP - List of Values
-- Application ID: 10100
-- APEX 22.1.0
-- ============================================================================
-- SVARBU: Paleisk šį scriptą per SQL Workshop → SQL Scripts
-- po f10100.sql importavimo!
-- ============================================================================

-- Nustatome application kontekstą
BEGIN
    apex_application_install.set_application_id(10100);
    apex_application_install.set_workspace_id(1508853877858231372);
    apex_application_install.set_schema('STUD_581');
END;
/

PROMPT === Kuriami Static LOVs ===

-- ============================================================================
-- STATIC LOV 1: GENDER
-- ============================================================================
BEGIN
    apex_util.create_list_of_values(
        p_list_name => 'LOV_GENDER',
        p_list_query => null,
        p_list_type => 'STATIC'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_GENDER',
        p_sequence => 1,
        p_display_value => 'Vyras',
        p_return_value => 'M'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_GENDER',
        p_sequence => 2,
        p_display_value => 'Moteris',
        p_return_value => 'F'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_GENDER',
        p_sequence => 3,
        p_display_value => 'Kita',
        p_return_value => 'O'
    );
END;
/

-- ============================================================================
-- STATIC LOV 2: BLOOD_TYPE
-- ============================================================================
BEGIN
    apex_util.create_list_of_values(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_list_query => null,
        p_list_type => 'STATIC'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_sequence => 1,
        p_display_value => 'A+',
        p_return_value => 'A+'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_sequence => 2,
        p_display_value => 'A-',
        p_return_value => 'A-'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_sequence => 3,
        p_display_value => 'B+',
        p_return_value => 'B+'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_sequence => 4,
        p_display_value => 'B-',
        p_return_value => 'B-'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_sequence => 5,
        p_display_value => 'AB+',
        p_return_value => 'AB+'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_sequence => 6,
        p_display_value => 'AB-',
        p_return_value => 'AB-'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_sequence => 7,
        p_display_value => 'O+',
        p_return_value => 'O+'
    );

    apex_util.create_static_lov_data(
        p_list_name => 'LOV_BLOOD_TYPE',
        p_sequence => 8,
        p_display_value => 'O-',
        p_return_value => 'O-'
    );
END;
/

PROMPT === Kuriami Dynamic LOVs ===

-- ============================================================================
-- DYNAMIC LOV 3: DEPARTMENTS
-- ============================================================================
BEGIN
    apex_util.create_list_of_values(
        p_list_name => 'LOV_DEPARTMENTS',
        p_list_query => 'SELECT department_name AS d, department_id AS r FROM departments WHERE is_active = ''Y'' ORDER BY department_name',
        p_list_type => 'DYNAMIC'
    );
END;
/

-- ============================================================================
-- DYNAMIC LOV 4: DOCTORS
-- ============================================================================
BEGIN
    apex_util.create_list_of_values(
        p_list_name => 'LOV_DOCTORS',
        p_list_query => 'SELECT e.first_name || '' '' || e.last_name || '' ('' || d.specialization || '')'' AS d, d.doctor_id AS r FROM doctors d JOIN employees e ON d.doctor_id = e.employee_id WHERE e.employment_status = ''ACTIVE'' ORDER BY e.last_name',
        p_list_type => 'DYNAMIC'
    );
END;
/

-- ============================================================================
-- DYNAMIC LOV 5: PATIENTS
-- ============================================================================
BEGIN
    apex_util.create_list_of_values(
        p_list_name => 'LOV_PATIENTS',
        p_list_query => 'SELECT first_name || '' '' || last_name AS d, patient_id AS r FROM patients WHERE is_active = ''Y'' ORDER BY last_name',
        p_list_type => 'DYNAMIC'
    );
END;
/

PROMPT
PROMPT ============================================================================
PROMPT LOVs Sukurti Sėkmingai!
PROMPT ============================================================================
PROMPT
PROMPT ✅ Sukurta 5 LOVs:
PROMPT    1. LOV_GENDER (Static)
PROMPT    2. LOV_BLOOD_TYPE (Static)
PROMPT    3. LOV_DEPARTMENTS (Dynamic)
PROMPT    4. LOV_DOCTORS (Dynamic)
PROMPT    5. LOV_PATIENTS (Dynamic)
PROMPT
PROMPT SEKANTIS ŽINGSNIS:
PROMPT    Pridėk likusius LOVs per APEX UI:
PROMPT    Shared Components → List of Values → Create
PROMPT
PROMPT    ARBA pridėk daugiau LOVs į šį scriptą naudojant
PROMPT    apex_util.create_list_of_values() metodą.
PROMPT
PROMPT PATARIMAS:
PROMPT    Dabar naudok Create App Wizard:
PROMPT    App Builder → Create → New Application → From Tables
PROMPT    APEX automatiškai sukurs visus puslapius!
PROMPT
PROMPT ============================================================================

COMMIT;
