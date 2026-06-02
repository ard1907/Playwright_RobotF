# ==============================================================================
# ts_04b_register_selection_bva.robot  –  Test Suite for the
#                                                     BVA Register Workflow
#                                                     (API-Response Verification)
#
# Target  : https://qs-datenschutzcockpit.dsc.govkg.de/spa/cockpit/datenabfrage
# Pattern : Page Object Model (POM) + shared resources
#
# ── Relation to ts_04 ──────────────────────────────────────────────────────────
# This suite mirrors ts_04_register_selection_bva.robot (TC001–TC012)
# and adds:
#
#   TC013  Verify Test BVA Personal Data API Response Matches Fixture
#            Runs the full BVA workflow, captures the live "Persönliche Daten
#            anfragen" API response, and compares it against the stored JSON
#            fixture (test_data/registers/bva.json).
#            Requires a prior first-run-api execution (see below).
#
#   API First Run: Capture BVA Personal Data API Response Fixture
#            Drives the full BVA workflow, intercepts the API response, and
#            writes it to test_data/registers/bva.json.
#            This test is skipped unless ENABLE_API_FIRST_RUN_TESTS=True.
#
# ── Operating Modes ────────────────────────────────────────────────────────────
#
#   Normal run (TC001–TC013):
#     robot tests/ui/ts_04b_register_selection_bva.robot
#     TC013 is skipped when bva.json is not yet populated.
#
#   First-run-api (capture JSON fixture):
#     robot --include first-run-api \
#           --variable ENABLE_API_FIRST_RUN_TESTS:True \
#           tests/ui/ts_04b_register_selection_bva.robot
#
#   First-run-api with forced overwrite:
#     robot --include first-run-api \
#           --variable ENABLE_API_FIRST_RUN_TESTS:True \
#           --variable API_FIXTURE_FORCE_REGENERATE:True \
#           tests/ui/ts_04b_register_selection_bva.robot
#
# NOTE: This suite requires a successful eID login via AusweisApp.
#       On standard CI it is skipped automatically.
#
# Suite Setup     → Open browser + login once + store suite start timestamp
# Test Setup      → Navigate to register-auswahl in default grid view
# Suite Teardown  → Close any open dialog + logout + close all browsers
#
# Test Cases
# ----------
#   TC001  Select Test BVA Register Card Enables Anfrage Starten
#   TC002  Deselect Test BVA Register Card Returns Empty Selection State
#   TC003  Start BVA Request Navigates To Results Page
#   TC004  Verify Results Page Shows Correct Statistics For BVA
#   TC005  Verify Test BVA Result Entry Is Visible And Collapsed
#   TC006  Expand Test BVA Result Entry Shows Data Tables
#   TC007  Open First Protokolldaten Dialog Shows Initial State
#   TC008  Request Personal Data Shows Inhaltsdaten In Dialog
#   TC009  Verify PDF Download Filename Matches Pattern And Timestamp
#   TC010  Verify PDF Content Contains Current Date As Datenübermittlung Heading
#   TC011  Close Protokolldaten Dialog Returns To Results View
#   TC012  Navigate Back To Register Auswahl Restores Correct URL
#   TC013  Verify Test BVA Personal Data API Response Matches Fixture
#   API First Run: Capture BVA Personal Data API Response Fixture
# ==============================================================================

*** Settings ***
Library     Browser
Library     DateTime
Library     String
Library     OperatingSystem

Resource    ../../resources/dsc_variables.robot
Resource    ../../resources/dsc_setup_teardown.robot
Resource    ../../resources/dsc_shared_keywords.robot

Resource    ../../pages/dsc_authentication_info_page.robot
Resource    ../../pages/dsc_register_selection_page.robot
Resource    ../../pages/dsc_register_selection_bva.robot
Resource    ../../pages/dsc_register_result_page_api.robot

# ── Suite-level browser lifecycle ─────────────────────────────────────────────
Suite Setup     Open Browser And Login For BVA Suite (4b)
Suite Teardown  Close Browser After BVA Suite (4b)
Test Setup      Open Register Auswahl In Default Grid View


*** Variables ***

${SUITE_START_EPOCH}        ${EMPTY}

# ── API Fixture path ───────────────────────────────────────────────────────────
# Resolved at runtime relative to this file:
#   tests/ui/ → ../../test_data/registers/
${BVA_API_FIXTURE_PATH}     ${CURDIR}${/}..${/}..${/}test_data${/}registers${/}bva.json

# ── First-run-api control ──────────────────────────────────────────────────────
# Set to True on the command line to overwrite an existing complete fixture:
#   --variable API_FIXTURE_FORCE_REGENERATE:True
${API_FIXTURE_FORCE_REGENERATE}    ${False}

# Explicit opt-in so first-run-api tests never run during a default suite run:
#   --include first-run-api --variable ENABLE_API_FIRST_RUN_TESTS:True
${ENABLE_API_FIRST_RUN_TESTS}      ${False}


*** Keywords ***

Open Browser And Login For BVA Suite (4b)
    [Documentation]    Suite setup: stores the suite start epoch timestamp (used
    ...                for PDF timestamp validation in TC009) and delegates to the
    ...                shared AusweisApp login keyword.
    ${start_epoch}=    Get Current Date    result_format=epoch
    Set Suite Variable    ${SUITE_START_EPOCH}    ${start_epoch}
    Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}


Close Browser After BVA Suite (4b)
    [Documentation]    Suite teardown: closes any open Protokolldaten dialog
    ...                before logout (prevents an open dialog from blocking the
    ...                logout trigger button after a test failure).
    ...                Then delegates to the shared AusweisApp teardown.
    Close Register Dialog If Open
    Close Browser After AusweisApp Suite


Open Register Auswahl In Default Grid View
    [Documentation]    Default Test Setup: hard-navigates to register-auswahl
    ...                (clears any SPA state carry-over) and resets the view to
    ...                the default grid layout.
    Go To    ${REGISTER_AUSWAHL_URL}
    Wait For Load State    networkidle
    Switch Register Auswahl To Grid View


Navigate To BVA Results Setup
    [Documentation]    Test Setup helper: drives the full entry path from
    ...                register-auswahl through "Anfrage starten" to the
    ...                datenabfrage results page with Test BVA selected.
    Open Register Auswahl In Default Grid View
    Navigate To BVA Results Page


Navigate To Expanded BVA Result Setup
    [Documentation]    Test Setup helper: drives the full entry path to the
    ...                datenabfrage page with the BVA result entry expanded
    ...                (Datenübermittlung tables visible).
    Navigate To BVA Results Setup
    Expand BVA Result Entry


Navigate To Open BVA Dialog Setup
    [Documentation]    Test Setup helper: drives the full entry path to the open
    ...                Protokolldaten detail dialog (before data fetch).
    Navigate To Expanded BVA Result Setup
    Open First Protokolldaten Dialog


Navigate To BVA Dialog With Data Setup
    [Documentation]    Test Setup helper: drives the full BVA workflow to the
    ...                open Protokolldaten dialog with personal data already fetched
    ...                ("Daten abgerufen" state).
    Navigate To Open BVA Dialog Setup
    Fetch Personal Data In Dialog


Require Explicit Api First Run Mode
    [Documentation]    Guards first-run-api capture tests so they only execute when
    ...                the suite is explicitly started with first-run-api intent.
    Skip If    not ${ENABLE_API_FIRST_RUN_TESTS}
    ...    API first-run tests are opt-in. Run with: robot --include first-run-api --variable ENABLE_API_FIRST_RUN_TESTS:True tests/ui/ts_04b_register_selection_bva.robot


Run BVA Api Card First Run Capture
    [Documentation]    Composite first-run-api keyword for BVA:
    ...                  1. Drives the full BVA workflow
    ...                  2. Captures the "Persönliche Daten anfragen" API response
    ...                  3. Writes the response body to ${BVA_API_FIXTURE_PATH}
    ...                  4. Closes the Protokolldaten dialog
    ...
    ...                Controlled by ${API_FIXTURE_FORCE_REGENERATE} (default False).
    ${api_response}=    Run Full Register Workflow And Return Api Response    ${BVA_REGISTER_NAME}
    Generate Register Api Fixture From Response
    ...    api_response=${api_response}
    ...    register_name=${BVA_REGISTER_NAME}
    ...    register_tag=bva
    ...    fixture_path=${BVA_API_FIXTURE_PATH}
    ...    force_regenerate=${API_FIXTURE_FORCE_REGENERATE}
    Close Register Protokolldaten Dialog
    Log    BVA API first-run complete. Please review and commit: ${BVA_API_FIXTURE_PATH}


*** Test Cases ***

# ==============================================================================
# TC001–TC012 – Same BVA workflow tests as ts_04.
# These tests use identical keywords and page objects; they are reproduced here
# so ts_04b is a self-contained, runnable suite.
# ==============================================================================

TC001 - Select Test BVA Register Card Enables Anfrage Starten
    [Documentation]    Selects the "Test BVA" register card on the register-auswahl
    ...                page using the generic register-card-by-name keyword and
    ...                verifies the page transitions to the submit-ready state:
    ...                  • "Anfrage starten" button becomes visible and enabled
    ...                  • Empty-state hint heading is no longer shown
    [Tags]    bva    register-auswahl    selection
    Select Register Card By Name    ${BVA_REGISTER_NAME}
    Wait For Elements State    ${BVA_RA_REQUEST_START_BTN}    visible    timeout=${TIMEOUT}
    ${btn_states}=    Get Element States    ${BVA_RA_REQUEST_START_BTN}
    Should Contain    ${btn_states}    enabled
    Wait For Elements State    ${RA_HINT_H3}    detached    timeout=${TIMEOUT}


TC002 - Deselect Test BVA Register Card Returns Empty Selection State
    [Documentation]    Selects and then deselects the "Test BVA" card to verify
    ...                that the page correctly returns to the empty-selection state:
    ...                  • "Anfrage starten" button disappears after deselection
    ...                  • Empty-state hint heading "Bitte wählen Sie mindestens
    ...                    ein Register" becomes visible again
    [Tags]    bva    register-auswahl    selection    toggle
    Select Register Card By Name    ${BVA_REGISTER_NAME}
    Wait For Elements State    ${BVA_RA_REQUEST_START_BTN}    visible    timeout=${TIMEOUT}
    Select Register Card By Name    ${BVA_REGISTER_NAME}
    Wait For Elements State    ${BVA_RA_REQUEST_START_BTN}    detached    timeout=${TIMEOUT}
    Element Is Visible    ${RA_HINT_H3}


TC003 - Start BVA Request Navigates To Results Page
    [Documentation]    Selects "Test BVA", clicks "Anfrage starten", and verifies
    ...                the SPA navigates to the datenabfrage results route.
    [Tags]    bva    datenabfrage    navigation
    [Setup]    Navigate To BVA Results Setup
    Validate Datenabfrage Results Page


TC004 - Verify Results Page Shows Correct Statistics For BVA
    [Documentation]    Verifies that all four result statistics counter labels are
    ...                visible on the datenabfrage page after a single-register
    ...                BVA query.
    [Tags]    bva    datenabfrage    statistics
    [Setup]    Navigate To BVA Results Setup
    Verify BVA Statistics Counters Are Visible


TC005 - Verify Test BVA Result Entry Is Visible And Collapsed
    [Documentation]    Verifies that the Test BVA result box appears in its initial
    ...                collapsed state on the datenabfrage results page.
    [Tags]    bva    datenabfrage    result-entry
    [Setup]    Navigate To BVA Results Setup
    Verify BVA Result Entry Is Visible And Collapsed


TC006 - Expand Test BVA Result Entry Shows Data Tables
    [Documentation]    Clicks the expand toggle on the Test BVA result entry and
    ...                verifies the entry transitions to "Ergebnis ist geöffnet"
    ...                with Datenübermittlung tables and "Daten einsehen" controls.
    [Tags]    bva    datenabfrage    result-entry    expand
    [Setup]    Navigate To Expanded BVA Result Setup
    Verify BVA Result Entry Is Expanded With Tables


TC007 - Open First Protokolldaten Dialog Shows Initial State
    [Documentation]    Opens the Protokolldaten detail dialog for the first
    ...                Datenübermittlung entry and verifies its initial state
    ...                (before personal data has been fetched).
    [Tags]    bva    datenabfrage    dialog    protokolldaten
    [Setup]    Navigate To Open BVA Dialog Setup
    Verify Protokolldaten Dialog Initial State


TC008 - Request Personal Data Shows Inhaltsdaten In Dialog
    [Documentation]    Clicks "Persönliche Daten anfragen" inside the Protokolldaten
    ...                dialog and verifies the dialog transitions to the data-loaded
    ...                state (same assertion as ts_04 TC008 – dialog-content based).
    [Tags]    bva    datenabfrage    dialog    personal-data
    [Setup]    Navigate To BVA Dialog With Data Setup
    Verify Protokolldaten Dialog After Data Fetch


TC009 - Verify PDF Download Filename Matches Pattern And Timestamp
    [Documentation]    Clicks "Als PDF speichern" and verifies the downloaded file:
    ...                  • Filename matches pattern: Datenschutzcockpit-DD_MM_YYYY-HH_MM_uhr.pdf
    ...                  • Date part equals today's date
    ...                  • Time part falls within 30 min before suite start
    [Tags]    bva    datenabfrage    dialog    pdf    download
    [Setup]    Navigate To BVA Dialog With Data Setup
    ${file_obj}=    Download BVA PDF And Get File Info
    ${suggested_name}=    Set Variable    ${file_obj}[suggestedFilename]
    Verify PDF Filename Matches Pattern    ${suggested_name}
    Verify PDF Filename Date Is Today    ${suggested_name}
    Verify PDF Filename Timestamp Within 30 Minutes Of Suite Start
    ...    ${suggested_name}    ${SUITE_START_EPOCH}
    Save PDF To Downloads Directory    ${file_obj}[saveAs]    ${suggested_name}
    Verify PDF File Exists In Downloads Directory    ${suggested_name}


TC010 - Verify PDF Content Contains Current Date As Datenübermittlung Heading
    [Documentation]    Downloads the BVA result PDF and reads its text content to
    ...                verify that the string "Datenübermittlung am DD.MM.YYYY"
    ...                is present, where DD.MM.YYYY is today's test run date.
    ...
    ...                Requires: pip install pypdf  (declared in requirements.txt)
    [Tags]    bva    datenabfrage    dialog    pdf    content
    [Setup]    Navigate To BVA Dialog With Data Setup
    ${file_obj}=    Download BVA PDF And Get File Info
    Verify PDF Content Contains Datenübermittlung Date    ${file_obj}[saveAs]


TC011 - Close Protokolldaten Dialog Returns To Results View
    [Documentation]    Closes the Protokolldaten detail dialog via the scoped
    ...                "closeModalBtn" and verifies the datenabfrage results page
    ...                is visible again.
    [Tags]    bva    datenabfrage    dialog    close
    [Setup]    Navigate To Open BVA Dialog Setup
    Close Protokolldaten Dialog
    Wait For Elements State    ${DA_H1_HEADING}    visible    timeout=${TIMEOUT}
    Verify Page Title Contains    ${TITLE_DATENABFRAGE}


TC012 - Navigate Back To Register Auswahl Restores Correct URL
    [Documentation]    Clicks "Zurück zur Registerauswahl" on the datenabfrage page
    ...                and verifies the SPA correctly routes back to register-auswahl.
    [Tags]    bva    datenabfrage    navigation    back
    [Setup]    Navigate To BVA Results Setup
    Navigate Back To Register Auswahl
    ${url}=    Get Url
    Should Be Equal As Strings    ${url}    ${REGISTER_AUSWAHL_URL}
    Verify Page Title Contains    ${TITLE_REGISTER_AUSWAHL}
    Element Is Visible    ${RA_H1_HEADING}


# ==============================================================================
# TC013 – New API-response-based verification test.
# Verifies the "Persönliche Daten anfragen" response against the JSON fixture.
# Requires: bva.json populated by a prior first-run-api execution.
# ==============================================================================

TC013 - Verify Test BVA Personal Data API Response Matches Fixture
    [Documentation]    Drives the full BVA register card workflow and captures
    ...                the live "Persönliche Daten anfragen" API response.
    ...                Compares the response body against the stored reference in
    ...                test_data/registers/bva.json.
    ...
    ...                Volatile fields (tokens, timestamps, etc.) are excluded
    ...                from the comparison automatically.
    ...
    ...                Skip: when bva.json is not yet populated by a first-run-api.
    ...
    ...                To generate bva.json run:
    ...                  robot --include first-run-api \
    ...                        --variable ENABLE_API_FIRST_RUN_TESTS:True \
    ...                        tests/ui/ts_04b_register_selection_bva.robot
    [Tags]    bva    api-response    api-verification
    Run Register Api Card Verification    ${BVA_API_FIXTURE_PATH}


# ==============================================================================
# API FIRST-RUN DATA CAPTURE TEST
# Run with:
#   robot --include first-run-api \
#         --variable ENABLE_API_FIRST_RUN_TESTS:True \
#         tests/ui/ts_04b_register_selection_bva.robot
#
# Forced overwrite of an existing fixture:
#   robot --include first-run-api \
#         --variable ENABLE_API_FIRST_RUN_TESTS:True \
#         --variable API_FIXTURE_FORCE_REGENERATE:True \
#         tests/ui/ts_04b_register_selection_bva.robot
#
# This test is guarded and skips unless ENABLE_API_FIRST_RUN_TESTS=True.
# ==============================================================================

API First Run: Capture BVA Personal Data API Response Fixture
    [Documentation]    Drives the full BVA register card workflow, intercepts the
    ...                "Persönliche Daten anfragen" API response, and writes the
    ...                complete response body to test_data/registers/bva.json.
    ...
    ...                Run once before TC013:
    ...                  robot --include first-run-api \
    ...                        --variable ENABLE_API_FIRST_RUN_TESTS:True \
    ...                        tests/ui/ts_04b_register_selection_bva.robot
    ...
    ...                To overwrite an existing bva.json add:
    ...                        --variable API_FIXTURE_FORCE_REGENERATE:True
    ...
    ...                After the run: review test_data/registers/bva.json and commit.
    [Setup]    Require Explicit Api First Run Mode
    [Tags]    first-run-api    bva
    Run BVA Api Card First Run Capture
