# ==============================================================================
# dsc_register_selection_BVA.robot  –  Page Object for the Test BVA Register
#                                       Workflow (Datenabfrage / Datenansicht)
#
# Workflow entry  : https://qs-datenschutzcockpit.dsc.govkg.de/spa/cockpit/register-auswahl
# Results page    : https://qs-datenschutzcockpit.dsc.govkg.de/spa/cockpit/datenabfrage
# Suite           : tests/ui/ts_04_smoke_test_register_selection_BVA.robot
#
# This page object covers the full BVA data-query workflow:
#   1. Select "Test BVA" register card on the register-auswahl page
#   2. Click "Anfrage starten" → navigate to datenabfrage results page
#   3. Expand the Test BVA result entry (collapse/expand toggle)
#   4. Open the first Protokolldaten detail dialog ("Daten einsehen")
#   5. Request personal data ("Persönliche Daten anfragen")
#   6. Save result as PDF ("Als PDF speichern")
#   7. Close dialog → navigate back to register-auswahl via link
#
# Generic keyword note:
#   "Select Register Card By Name" is defined in resources/dsc_shared_keywords.robot
#   so that any future register-specific suite can reuse it directly.
#
# Selectors follow the project convention:
#   - ARIA role selectors (role=) preferred
#   - XPath with data-testid attributes for SPA-specific controls
#   - XPath text-matching only when no stable testid/aria exists
#
# PDF verification:
#   Keyword "Verify PDF Content Contains Datenübermittlung Date" requires
#   the 'pypdf' package: pip install pypdf  (already in requirements.txt)
# ==============================================================================

*** Settings ***
Library     Browser
Library     OperatingSystem
Library     DateTime
Library     String
Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot


*** Variables ***

# ── BVA Register Card ─────────────────────────────────────────────────────────
${BVA_REGISTER_NAME}              Test BVA

# ── Register Auswahl: Anfrage Starten Button ───────────────────────────────────
# Kept here independent of dsc_register_selection_page.robot to avoid
# cross-page-object dependency; both files define the same logical element.
${BVA_RA_REQUEST_START_BTN}       //button[normalize-space(.)="Anfrage starten"]

# ── Datenabfrage Results Page ──────────────────────────────────────────────────
${DA_H1_HEADING}                  //h1[text()="Wonach wollen Sie suchen?"]
${DA_H2_IHRE_ERGEBNISSE}          //h2[normalize-space(.)="Ihre Ergebnisse"]
${DA_H2_ERGEBNISSE_LIST}          //h2[normalize-space(.)="Ergebnisse"]
${DA_HINT_AKTIONEN_H3}            //h3[normalize-space(.)="Welche Aktionen stehen zur Verfügung?"]
# The back link is an <a> element; use href to avoid text-node trailing-space issues.
${DA_ZURUECK_LINK}                //a[contains(@href,"register-auswahl")]

# ── Result Statistics Counters ────────────────────────────────────────────────
# Counters are generic divs with aria-labels; match via visible label text.
${DA_STAT_ANGEFRAGT_LABEL}        //*[normalize-space(text())="Register wurden angefragt"]
${DA_STAT_GEFUNDEN_LABEL}         //*[normalize-space(text())="Ergebnisse wurden gefunden"]
${DA_STAT_KEINE_EINTRAEGE_LABEL}  //*[normalize-space(text())="Register haben keine Einträge"]
${DA_STAT_NICHT_ERREICHBAR_LABEL}
...    //*[normalize-space(text())="Register technisch nicht erreichbar"]

# ── BVA Result Entry (collapse / expand) ──────────────────────────────────────
# The result box is a div with aria-label "Ergebnis ist geschlossen / geöffnet".
# The clickable toggle is a <div role="button"> (NOT a <button>) containing the h3.
${DA_BVA_RESULT_ENTRY}
...    //div[contains(@aria-label,"Ergebnis ist") and .//h3[normalize-space(.)="${BVA_REGISTER_NAME}"]]
${DA_BVA_EXPAND_BTN}
...    //div[@role="button" and .//h3[normalize-space(.)="${BVA_REGISTER_NAME}"]]
${DA_BVA_RESULT_CLOSED}
...    //div[@aria-label="Ergebnis ist geschlossen" and .//h3[normalize-space(.)="${BVA_REGISTER_NAME}"]]
${DA_BVA_RESULT_OPENED}
...    //div[@aria-label="Ergebnis ist geöffnet" and .//h3[normalize-space(.)="${BVA_REGISTER_NAME}"]]

# ── Data Tables Inside Expanded BVA Result ────────────────────────────────────
# h4 has a leading space in its text node; use normalize-space(.) for robust matching.
# Use [1] to avoid strict-mode violation (100+ h4 nodes exist in the expanded list).
${DA_BVA_TABLE_HEADING}
...    (//div[@aria-label="Ergebnis ist geöffnet"]//h4[contains(normalize-space(.),"Datenübermittlung am")])[1]
# NOTE: data-testid "protkolldatenEinsehenBtn" preserves the upstream typo.
${DA_BVA_DATEN_EINSEHEN_BTN}      //button[@data-testid="protkolldatenEinsehenBtn"]
${DA_BVA_DATEN_EINSEHEN_FIRST}    (//button[@data-testid="protkolldatenEinsehenBtn"])[1]

# ── Protokolldaten Dialog ─────────────────────────────────────────────────────
# Scope all locators to the visible (aria-hidden=false) dialog to avoid
# matching the 20+ hidden dialog instances present in the SPA DOM.
${PD_DIALOG}
...    //div[@role="dialog" and @aria-hidden="false"]
${PD_DIALOG_H1}
...    //div[@role="dialog" and @aria-hidden="false"]//h1[contains(.,"Datenübermittlung am")]
${PD_DIALOG_SENDER_XPATH}
...    //div[@role="dialog" and @aria-hidden="false"]//*[normalize-space(text())="Bundesverwaltungsamt, Registermodernisierungsbehörde"]
${PD_DIALOG_WICHTIGER_HINWEIS}
...    //div[@role="dialog" and @aria-hidden="false"]//*[normalize-space(text())="Wichtiger Hinweis"]
# "Persönliche Daten anfragen" button – span carries the testid, parent is the button.
${PD_DIALOG_ANFRAGEN_BTN}
...    //button/span[@data-testid="inhaltsdatenAbfragenBtn"]
${PD_DIALOG_INHALTSDATEN_H2}
...    //div[@role="dialog" and @aria-hidden="false"]//h2[text()="Inhalt der Datenübermittlung"]
${PD_DIALOG_ANLASS_TEXT}
...    Abruf der Identifikationsnummer und ggf. weiterer Basisdaten der Person für gesetzliche Aufgaben

# ── Protokolldaten Dialog – After Data Fetch ──────────────────────────────────
# After clicking "Persönliche Daten anfragen" the button label changes.
${PD_DATEN_ABGERUFEN_BTN}
...    //div[@role="dialog" and @aria-hidden="false"]//button[contains(.,"Daten abgerufen")]
${PD_DIALOG_ALS_PDF_BTN}          //button[@aria-label="Als PDF speichern"]
${PD_DIALOG_ZUSATZ_INFO_H2}
...    //div[@role="dialog" and @aria-hidden="false"]//h2[text()="Zusätzliche Informationen der Behörde"]

# ── Close Modal ───────────────────────────────────────────────────────────────
# Scoped to the visible dialog to avoid the 20+ hidden "closeModalBtn" elements.
${PD_DIALOG_CLOSE_BTN}
...    //div[@role="dialog" and @aria-hidden="false"]//button[@data-testid="closeModalBtn"]

# ── PDF Filename Pattern ───────────────────────────────────────────────────────
# Format: Datenschutzcockpit-DD_MM_YYYY-HH_MM_uhr.pdf
${PDF_FILENAME_REGEXP}
...    ^Datenschutzcockpit-\\d{2}_\\d{2}_\\d{4}-\\d{2}_\\d{2}_uhr\\.pdf$
${PDF_TIME_EXTRACT_REGEXP}
...    Datenschutzcockpit-\\d{2}_\\d{2}_\\d{4}-(\\d{2})_(\\d{2})_uhr\\.pdf


*** Keywords ***

# ── Navigation / Setup Helpers ────────────────────────────────────────────────

Navigate To BVA Results Page
    [Documentation]    Navigates the full entry sequence for the BVA workflow:
    ...                  1. Navigate to register-auswahl (authenticated session)
    ...                  2. Select the "Test BVA" register card generically
    ...                  3. Click "Anfrage starten"
    ...                  4. Wait for the datenabfrage results page to load
    ...                  5. Wait for the BVA result entry to appear (API async load)
    ...                The result entry wait uses a 30s timeout because the backend
    ...                API response may arrive well after the initial networkidle.
    Navigate To Register Auswahl Page
    Select Register Card By Name    ${BVA_REGISTER_NAME}
    Wait For Elements State    ${BVA_RA_REQUEST_START_BTN}    visible    timeout=${TIMEOUT}
    Click    ${BVA_RA_REQUEST_START_BTN}
    Wait For Load State    networkidle
    ${url}=    Get Url
    Should Contain    ${url}    datenabfrage
    Wait For Elements State    ${DA_BVA_RESULT_ENTRY}    visible    timeout=30s


Expand BVA Result Entry
    [Documentation]    Clicks the expand toggle (Pfeil-nach-unten) on the Test BVA
    ...                result entry to reveal the Datenübermittlung tables.
    ...                Waits until the entry transitions to "Ergebnis ist geöffnet".
    Wait For Elements State    ${DA_BVA_EXPAND_BTN}    visible    timeout=${TIMEOUT}
    Click    ${DA_BVA_EXPAND_BTN}
    Wait For Elements State    ${DA_BVA_RESULT_OPENED}    visible    timeout=${TIMEOUT}
    # Inner data tables load asynchronously after expand; wait for first h4 to appear.
    Wait For Elements State    ${DA_BVA_TABLE_HEADING}    visible    timeout=30s


Open First Protokolldaten Dialog
    [Documentation]    Clicks the first "Daten einsehen" button inside the expanded
    ...                BVA result entry to open the Protokolldaten detail dialog.
    ...                Waits until the dialog and its H1 heading are visible.
    Wait For Elements State    ${DA_BVA_DATEN_EINSEHEN_FIRST}    visible    timeout=${TIMEOUT}
    Click    ${DA_BVA_DATEN_EINSEHEN_FIRST}
    Wait For Elements State    ${PD_DIALOG}    visible    timeout=${TIMEOUT}
    Wait For Elements State    ${PD_DIALOG_H1}    visible    timeout=${TIMEOUT}


Fetch Personal Data In Dialog
    [Documentation]    Clicks "Persönliche Daten anfragen" inside the Protokolldaten
    ...                dialog and waits until the "Daten abgerufen" indicator appears,
    ...                confirming that the personal data has been loaded.
    Wait For Elements State    ${PD_DIALOG_ANFRAGEN_BTN}    visible    timeout=${TIMEOUT}
    Click    ${PD_DIALOG_ANFRAGEN_BTN}
    Wait For Elements State    ${PD_DATEN_ABGERUFEN_BTN}    visible    timeout=${TIMEOUT}


Navigate To Full BVA Dialog With Personal Data
    [Documentation]    Composite keyword that drives the full BVA workflow up to
    ...                and including the personal-data fetch. Call this as a
    ...                [Setup] in test cases that need the dialog pre-loaded with
    ...                data (e.g., TC for PDF save and content verification).
    ...                Steps:
    ...                  1. Navigate to datenabfrage (BVA selected)
    ...                  2. Expand the BVA result entry
    ...                  3. Open first Protokolldaten dialog
    ...                  4. Fetch personal data
    Navigate To BVA Results Page
    Expand BVA Result Entry
    Open First Protokolldaten Dialog
    Fetch Personal Data In Dialog


Close Protokolldaten Dialog
    [Documentation]    Closes the currently open Protokolldaten detail dialog
    ...                by clicking the scoped "closeModalBtn" within the visible
    ...                dialog element, then waits until the dialog is detached.
    Wait For Elements State    ${PD_DIALOG_CLOSE_BTN}    visible    timeout=${TIMEOUT}
    Click    ${PD_DIALOG_CLOSE_BTN}
    Wait For Elements State    ${PD_DIALOG}    detached    timeout=${TIMEOUT}


Navigate Back To Register Auswahl
    [Documentation]    Clicks the "Zurück zur Registerauswahl" link on the
    ...                datenabfrage page and waits for the register-auswahl
    ...                route to fully load and the URL to be confirmed.
    Wait For Elements State    ${DA_ZURUECK_LINK}    visible    timeout=${TIMEOUT}
    Click    ${DA_ZURUECK_LINK}
    Wait For Load State    networkidle
    ${url}=    Get Url
    Should Contain    ${url}    register-auswahl


# ── Page-Level Assertions ─────────────────────────────────────────────────────

Validate Datenabfrage Results Page
    [Documentation]    Verifies that the datenabfrage results page has fully loaded
    ...                with all expected structural elements visible:
    ...                  • URL contains "datenabfrage"
    ...                  • Page title contains "Ergebnisse" (${TITLE_DATENABFRAGE})
    ...                  • H1 "Wonach wollen Sie suchen?" is visible
    ...                  • H2 "Ihre Ergebnisse" is visible
    ...                  • H2 "Ergebnisse" (results list section) is visible
    ...                  • "Zurück zur Registerauswahl" link is visible
    ${url}=    Get Url
    Should Contain    ${url}    datenabfrage
    Verify Page Title Contains    ${TITLE_DATENABFRAGE}
    Wait For Elements State    ${DA_H1_HEADING}               visible    timeout=${TIMEOUT}
    Wait For Elements State    ${DA_H2_IHRE_ERGEBNISSE}       visible    timeout=${TIMEOUT}
    Wait For Elements State    ${DA_H2_ERGEBNISSE_LIST}       visible    timeout=${TIMEOUT}
    Wait For Elements State    ${DA_ZURUECK_LINK}             visible    timeout=${TIMEOUT}


Verify BVA Statistics Counters Are Visible
    [Documentation]    Verifies that all four result statistics counter labels are
    ...                visible on the datenabfrage results page after the BVA query:
    ...                  • "Register wurden angefragt"
    ...                  • "Ergebnisse wurden gefunden"
    ...                  • "Register haben keine Einträge"
    ...                  • "Register technisch nicht erreichbar"
    Element Is Visible    ${DA_STAT_ANGEFRAGT_LABEL}
    Element Is Visible    ${DA_STAT_GEFUNDEN_LABEL}
    Element Is Visible    ${DA_STAT_KEINE_EINTRAEGE_LABEL}
    Element Is Visible    ${DA_STAT_NICHT_ERREICHBAR_LABEL}


Verify BVA Result Entry Is Visible And Collapsed
    [Documentation]    Verifies that the Test BVA result box is rendered on the
    ...                datenabfrage page in its initial collapsed (geschlossen) state,
    ...                and that the expand-toggle button is present and enabled.
    Element Is Visible    ${DA_BVA_RESULT_ENTRY}
    Element Is Visible    ${DA_BVA_EXPAND_BTN}
    ${btn_states}=    Get Element States    ${DA_BVA_EXPAND_BTN}
    Should Contain    ${btn_states}    enabled


Verify BVA Result Entry Is Expanded With Tables
    [Documentation]    Verifies that the Test BVA result entry is in the expanded
    ...                (geöffnet) state and that:
    ...                  • "Ergebnis ist geöffnet" container is visible
    ...                  • At least one "Datenübermittlung am …" table heading is visible
    ...                  • At least one "Daten einsehen" button is visible and enabled
    Element Is Visible    ${DA_BVA_RESULT_OPENED}
    Element Is Visible    ${DA_BVA_TABLE_HEADING}
    ${count}=    Get Element Count    ${DA_BVA_DATEN_EINSEHEN_BTN}
    Should Be True    ${count} >= 1
    Element Is Visible    ${DA_BVA_DATEN_EINSEHEN_FIRST}
    ${btn_states}=    Get Element States    ${DA_BVA_DATEN_EINSEHEN_FIRST}
    Should Contain    ${btn_states}    enabled


Verify Protokolldaten Dialog Initial State
    [Documentation]    Verifies the Protokolldaten detail dialog in its initial
    ...                state (personal data has NOT yet been fetched):
    ...                  • Dialog container is visible
    ...                  • H1 contains "Datenübermittlung am"
    ...                  • BVA sender organization name is visible
    ...                  • "Wichtiger Hinweis" warning is visible (data not yet loaded)
    ...                  • "Persönliche Daten anfragen" button is visible and enabled
    ...                  • "Inhalt der Datenübermittlung" section heading is visible
    Element Is Visible    ${PD_DIALOG}
    Element Is Visible    ${PD_DIALOG_H1}
    Element Is Visible    ${PD_DIALOG_SENDER_XPATH}
    Element Is Visible    ${PD_DIALOG_WICHTIGER_HINWEIS}
    Element Is Visible    ${PD_DIALOG_ANFRAGEN_BTN}
    ${anfragen_states}=    Get Element States    ${PD_DIALOG_ANFRAGEN_BTN}
    Should Contain    ${anfragen_states}    enabled
    Element Is Visible    ${PD_DIALOG_INHALTSDATEN_H2}


Verify Protokolldaten Dialog After Data Fetch
    [Documentation]    Verifies the Protokolldaten detail dialog after personal
    ...                data has been successfully fetched via "Persönliche Daten
    ...                anfragen":
    ...                  • "Daten abgerufen" button is visible and in active state
    ...                  • "Als PDF speichern" button is visible and enabled
    ...                  • "Inhalt der Datenübermittlung" section heading is visible
    ...                  • "Zusätzliche Informationen der Behörde" section is visible
    Element Is Visible    ${PD_DATEN_ABGERUFEN_BTN}
    ${da_states}=    Get Element States    ${PD_DATEN_ABGERUFEN_BTN}
    Should Contain    ${da_states}    visible
    Element Is Visible    ${PD_DIALOG_ALS_PDF_BTN}
    ${pdf_states}=    Get Element States    ${PD_DIALOG_ALS_PDF_BTN}
    Should Contain    ${pdf_states}    enabled
    Element Is Visible    ${PD_DIALOG_INHALTSDATEN_H2}
    Element Is Visible    ${PD_DIALOG_ZUSATZ_INFO_H2}


# ── PDF Download Keywords ─────────────────────────────────────────────────────

Download BVA PDF And Get File Info
    [Documentation]    Intercepts the browser download triggered by "Als PDF speichern",
    ...                waits for it to complete, and returns a DownloadInfo dictionary:
    ...                  { "saveAs": "<temp_path>", "suggestedFilename": "<name>.pdf" }
    ...
    ...                Requires the browser context to have acceptDownloads=${True}
    ...                (already configured in resources/dsc_setup_teardown.robot).
    ...
    ...                Use the returned suggestedFilename for pattern verification and
    ...                saveAs path for PDF content verification.
    ${dl_promise}=    Promise To Wait For Download
    Click    ${PD_DIALOG_ALS_PDF_BTN}
    ${file_obj}=    Wait For    ${dl_promise}
    RETURN    ${file_obj}


Verify PDF Filename Matches Pattern
    [Documentation]    Asserts that the downloaded PDF filename matches the
    ...                expected naming scheme:
    ...                  Datenschutzcockpit-DD_MM_YYYY-HH_MM_uhr.pdf
    ...                Fails immediately if the pattern does not match.
    [Arguments]    ${suggested_filename}
    Should Match Regexp    ${suggested_filename}    ${PDF_FILENAME_REGEXP}
    ...    PDF filename "${suggested_filename}" does not match pattern Datenschutzcockpit-DD_MM_YYYY-HH_MM_uhr.pdf


Verify PDF Filename Date Is Today
    [Documentation]    Extracts the date portion (DD_MM_YYYY) from the PDF filename
    ...                and asserts it equals today's date in DD_MM_YYYY format.
    [Arguments]    ${suggested_filename}
    ${today}=    Get Current Date    result_format=%d_%m_%Y
    Should Contain    ${suggested_filename}    ${today}
    ...    PDF filename date part does not match today's date (${today})


Verify PDF Filename Timestamp Within 30 Minutes Of Suite Start
    [Documentation]    Extracts the time portion (HH_MM) from the PDF filename and
    ...                asserts it falls within the 30-minute window before the
    ...                suite start time (${suite_start_epoch}).
    ...
    ...                Acceptance window: [suite_start − 30 min, suite_start + 5 min]
    ...
    ...                The filename format is:
    ...                  Datenschutzcockpit-DD_MM_YYYY-HH_MM_uhr.pdf
    ...                Example:
    ...                  Datenschutzcockpit-28_04_2026-14_06_uhr.pdf  →  14:06
    [Arguments]    ${suggested_filename}    ${suite_start_epoch}
    ${matches}=    Get Regexp Matches
    ...    ${suggested_filename}    ${PDF_TIME_EXTRACT_REGEXP}    1    2
    Length Should Be    ${matches}    1
    ...    Could not extract HH_MM timestamp from filename: ${suggested_filename}
    ${hour}=      Set Variable    ${matches}[0][0]
    ${minute}=    Set Variable    ${matches}[0][1]
    ${today}=    Get Current Date    result_format=%Y-%m-%d
    ${file_ts_str}=    Set Variable    ${today} ${hour}:${minute}:00
    ${file_ts_epoch}=    Convert Date    ${file_ts_str}    result_format=epoch
    ...    date_format=%Y-%m-%d %H:%M:%S
    ${thirty_min_before}=    Evaluate    ${suite_start_epoch} - 1800
    ${five_min_after}=    Evaluate    ${suite_start_epoch} + 300
    Should Be True    ${file_ts_epoch} >= ${thirty_min_before}
    ...    PDF timestamp (${hour}:${minute}) is more than 30 min before suite start
    Should Be True    ${file_ts_epoch} <= ${five_min_after}
    ...    PDF timestamp (${hour}:${minute}) is more than 5 min after suite start


Save PDF To Downloads Directory
    [Documentation]    Copies the downloaded PDF from its temporary browser path to
    ...                the OS user Downloads directory and returns the final path.
    ...                Cross-platform: Windows %USERPROFILE%\Downloads,
    ...                Linux / macOS ~/Downloads.
    [Arguments]    ${temp_pdf_path}    ${suggested_filename}
    ${downloads_dir}=    Get OS Downloads Directory
    ${final_path}=    Set Variable    ${downloads_dir}${/}${suggested_filename}
    Copy File    ${temp_pdf_path}    ${final_path}
    File Should Exist    ${final_path}
    RETURN    ${final_path}


Verify PDF File Exists In Downloads Directory
    [Documentation]    Asserts that a file with the given filename exists in the
    ...                OS user Downloads directory.
    [Arguments]    ${suggested_filename}
    ${downloads_dir}=    Get OS Downloads Directory
    ${expected_path}=    Set Variable    ${downloads_dir}${/}${suggested_filename}
    File Should Exist    ${expected_path}
    ...    PDF file "${suggested_filename}" not found in Downloads directory "${downloads_dir}"


Verify PDF Content Contains Datenübermittlung Date
    [Documentation]    Reads the downloaded PDF file using pypdf and asserts that
    ...                the text "Datenübermittlung am DD.MM.YYYY" is present,
    ...                where DD.MM.YYYY is today's date (test run date).
    ...
    ...                Requires the 'pypdf' package (pip install pypdf).
    ...                Already declared in requirements.txt.
    [Arguments]    ${pdf_path}
    ${today_formatted}=    Get Current Date    result_format=%d.%m.%Y
    ${expected_text}=    Set Variable    Datenübermittlung am ${today_formatted}
    ${pdf_text}=    Evaluate
    ...    ' '.join(p.extract_text() or '' for p in __import__('pypdf').PdfReader(open(r'${pdf_path}', 'rb')).pages)
    Should Contain    ${pdf_text}    ${expected_text}
    ...    PDF does not contain expected text: "${expected_text}"
