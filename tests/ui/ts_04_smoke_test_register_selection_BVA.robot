# ==============================================================================
# ts_04_smoke_test_register_selection_BVA.robot  –  Smoke Test Suite for the
#                                                   Test BVA Register Workflow
#
# Target  : https://qs-datenschutzcockpit.dsc.govkg.de/spa/cockpit/datenabfrage
# Pattern : Page Object Model (POM) + shared resources
#
# NOTE: This suite is only accessible after a successful eID login via AusweisApp.
#       On non-self-hosted CI environments the whole suite is skipped by the
#       central setup keyword in the shared resources.
#       Remove or comment out that central suite guard when running in the
#       real DSC infrastructure.
#
# NOTE: PDF download tests (TC009, TC010) require the 'pypdf' package:
#         pip install pypdf  (already declared in requirements.txt)
#
# Suite Setup     → Open browser + login once + store suite start timestamp
# Test Setup      → Navigate to register-auswahl in default grid view
#                    (individual tests override this via [Setup] when needed)
# Suite Teardown  → Logout + close all browsers
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
Resource    ../../pages/dsc_register_selection_BVA.robot

# ── Suite-level browser lifecycle ─────────────────────────────────────────────
# Login once for the whole suite; each test navigates fresh via [Setup].
Suite Setup     Open Browser And Login For BVA Suite
Suite Teardown  Close Browser After AusweisApp Suite
# Default: navigate to register-auswahl in grid view before each test.
# Individual tests override this with their own [Setup] keyword as needed.
Test Setup      Open Register Auswahl In Default Grid View


*** Keywords ***

Open Browser And Login For BVA Suite
    [Documentation]    Suite setup for the BVA workflow test suite.
    ...                Stores the suite start epoch timestamp (used for PDF
    ...                timestamp validation) before delegating to the shared
    ...                AusweisApp login keyword.
    ${start_epoch}=    Get Current Date    result_format=epoch
    Set Suite Variable    ${SUITE_START_EPOCH}    ${start_epoch}
    Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}


Open Register Auswahl In Default Grid View
    [Documentation]    Default Test Setup: always forces a hard navigation to
    ...                register-auswahl (regardless of current URL) to avoid
    ...                SPA state carry-over from previous tests, then resets
    ...                the register chooser to the default grid view.
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
    ...                open Protokolldaten dialog with personal data already
    ...                fetched ("Daten abgerufen" state).
    Navigate To Open BVA Dialog Setup
    Fetch Personal Data In Dialog


*** Test Cases ***

TC001 - Select Test BVA Register Card Enables Anfrage Starten
    [Documentation]    Selects the "Test BVA" register card on the register-auswahl
    ...                page using the generic register-card-by-name keyword and
    ...                verifies the page transitions to the submit-ready state:
    ...                  • "Anfrage starten" button becomes visible and enabled
    ...                  • Empty-state hint heading is no longer shown
    ...
    ...                Demonstrates that Select Register Card By Name works
    ...                generically for any register name (not just BVA).
    [Tags]             smoke    bva    register-auswahl    selection
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
    [Tags]             smoke    bva    register-auswahl    selection    toggle
    Select Register Card By Name    ${BVA_REGISTER_NAME}
    Wait For Elements State    ${BVA_RA_REQUEST_START_BTN}    visible    timeout=${TIMEOUT}
    Select Register Card By Name    ${BVA_REGISTER_NAME}
    Wait For Elements State    ${BVA_RA_REQUEST_START_BTN}    detached    timeout=${TIMEOUT}
    Element Is Visible    ${RA_HINT_H3}


TC003 - Start BVA Request Navigates To Results Page
    [Documentation]    Selects "Test BVA", clicks "Anfrage starten", and verifies
    ...                the SPA navigates to the datenabfrage results route:
    ...                  • URL contains "datenabfrage"
    ...                  • Page title is "Datenschutzcockpit - Ergebnisse"
    ...                  • H1 heading "Wonach wollen Sie suchen?" is visible
    ...                  • H2 heading "Ihre Ergebnisse" is visible
    ...                  • H2 "Ergebnisse" (result list) is visible
    ...                  • "Zurück zur Registerauswahl" link is visible
    [Tags]             smoke    bva    datenabfrage    navigation
    [Setup]    Navigate To BVA Results Setup
    Validate Datenabfrage Results Page


TC004 - Verify Results Page Shows Correct Statistics For BVA
    [Documentation]    Verifies that all four result statistics counter labels are
    ...                visible on the datenabfrage page after a single-register
    ...                BVA query:
    ...                  • "Register wurden angefragt"
    ...                  • "Ergebnisse wurden gefunden"
    ...                  • "Register haben keine Einträge"
    ...                  • "Register technisch nicht erreichbar"
    [Tags]             smoke    bva    datenabfrage    statistics
    [Setup]    Navigate To BVA Results Setup
    Verify BVA Statistics Counters Are Visible


TC005 - Verify Test BVA Result Entry Is Visible And Collapsed
    [Documentation]    Verifies that the Test BVA result box appears in its
    ...                initial collapsed state on the datenabfrage results page:
    ...                  • "Test BVA" result entry container is visible
    ...                  • Expand toggle button is visible and enabled
    [Tags]             smoke    bva    datenabfrage    result-entry
    [Setup]    Navigate To BVA Results Setup
    Verify BVA Result Entry Is Visible And Collapsed


TC006 - Expand Test BVA Result Entry Shows Data Tables
    [Documentation]    Clicks the expand toggle on the Test BVA result entry and
    ...                verifies the entry transitions to "Ergebnis ist geöffnet"
    ...                with Datenübermittlung tables and "Daten einsehen" controls:
    ...                  • "Ergebnis ist geöffnet" container is visible
    ...                  • At least one "Datenübermittlung am …" table heading visible
    ...                  • At least one "Daten einsehen" button is visible and enabled
    [Tags]             smoke    bva    datenabfrage    result-entry    expand
    [Setup]    Navigate To Expanded BVA Result Setup
    Verify BVA Result Entry Is Expanded With Tables


TC007 - Open First Protokolldaten Dialog Shows Initial State
    [Documentation]    Opens the Protokolldaten detail dialog for the first
    ...                Datenübermittlung entry and verifies its initial state
    ...                (before personal data has been fetched):
    ...                  • Dialog container is visible
    ...                  • H1 heading contains "Datenübermittlung am"
    ...                  • BVA sender organization name is visible
    ...                  • "Wichtiger Hinweis" warning text is visible
    ...                  • "Persönliche Daten anfragen" button is visible + enabled
    ...                  • "Inhalt der Datenübermittlung" section heading is visible
    [Tags]             smoke    bva    datenabfrage    dialog    protokolldaten
    [Setup]    Navigate To Open BVA Dialog Setup
    Verify Protokolldaten Dialog Initial State


TC008 - Request Personal Data Shows Inhaltsdaten In Dialog
    [Documentation]    Clicks "Persönliche Daten anfragen" inside the Protokolldaten
    ...                dialog and verifies the dialog transitions to the data-loaded
    ...                state:
    ...                  • "Daten abgerufen" button is visible and in active state
    ...                  • "Als PDF speichern" button is visible and enabled
    ...                  • "Inhalt der Datenübermittlung" section heading remains visible
    ...                  • "Zusätzliche Informationen der Behörde" section is visible
    [Tags]             smoke    bva    datenabfrage    dialog    personal-data
    [Setup]    Navigate To BVA Dialog With Data Setup
    Verify Protokolldaten Dialog After Data Fetch


TC009 - Verify PDF Download Filename Matches Pattern And Timestamp
    [Documentation]    Clicks "Als PDF speichern" and verifies the downloaded file:
    ...                  • Filename matches pattern: Datenschutzcockpit-DD_MM_YYYY-HH_MM_uhr.pdf
    ...                  • Date part (DD_MM_YYYY) equals today's date
    ...                  • Time part (HH_MM) falls within 30 minutes before suite
    ...                    start and 5 minutes after (${SUITE_START_EPOCH})
    ...                  • File is saved to the OS user Downloads directory
    ...                    (Windows: %USERPROFILE%\Downloads, Linux: ~/Downloads)
    [Tags]             smoke    bva    datenabfrage    dialog    pdf    download
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
    [Tags]             smoke    bva    datenabfrage    dialog    pdf    content
    [Setup]    Navigate To BVA Dialog With Data Setup
    ${file_obj}=    Download BVA PDF And Get File Info
    Verify PDF Content Contains Datenübermittlung Date    ${file_obj}[saveAs]


TC011 - Close Protokolldaten Dialog Returns To Results View
    [Documentation]    Closes the Protokolldaten detail dialog via the scoped
    ...                "closeModalBtn" and verifies that:
    ...                  • The dialog container is detached (fully removed)
    ...                  • The datenabfrage results page is visible again
    ...                  • Page title reverts to "Datenschutzcockpit - Ergebnisse"
    [Tags]             smoke    bva    datenabfrage    dialog    close
    [Setup]    Navigate To Open BVA Dialog Setup
    Close Protokolldaten Dialog
    Wait For Elements State    ${DA_H1_HEADING}    visible    timeout=${TIMEOUT}
    Verify Page Title Contains    ${TITLE_DATENABFRAGE}


TC012 - Navigate Back To Register Auswahl Restores Correct URL
    [Documentation]    Clicks "Zurück zur Registerauswahl" on the datenabfrage page
    ...                and verifies the SPA correctly routes back to register-auswahl:
    ...                  • URL is exactly ${REGISTER_AUSWAHL_URL}
    ...                  • Page title contains "Registerauswahl"
    ...                  • H1 heading "Wonach wollen Sie suchen?" is visible
    [Tags]             smoke    bva    datenabfrage    navigation    back
    [Setup]    Navigate To BVA Results Setup
    Navigate Back To Register Auswahl
    ${url}=    Get Url
    Should Be Equal As Strings    ${url}    ${REGISTER_AUSWAHL_URL}
    Verify Page Title Contains    ${TITLE_REGISTER_AUSWAHL}
    Element Is Visible    ${RA_H1_HEADING}
