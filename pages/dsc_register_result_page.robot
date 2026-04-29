# ==============================================================================
# dsc_register_result_page.robot  –  Generic Page Object for the Datenabfrage
#                                     Results Page and Protokolldaten Dialog
#
# Provides fully-parameterised keywords for any register card workflow on the
# Datenschutzcockpit datenabfrage / Protokolldaten pages.
# Every keyword receives ${register_name} as an argument so it can be reused
# for Test BVA, Test BA, Test KBA, or any future register card.
#
# ── Two operating modes ────────────────────────────────────────────────────────
# Known-data mode  : Fixture YAML already has data → call Verify keywords
# First-run mode   : No YAML or re-generate → call Generate Register Fixture
#                    From Dialog after the full workflow is driven
#
# ── Dependency chain ──────────────────────────────────────────────────────────
#   Browser Library (Playwright)
#   resources/dsc_variables.robot          → ${TIMEOUT}, URLs
#   resources/dsc_shared_keywords.robot    → Select Register Card By Name
#   resources/dsc_register_fixture_library.py → YAML I/O (Python library)
#   pages/dsc_register_selection_page.robot   → Switch Register Auswahl To Grid View
#
# ── First-run JavaScript notes ─────────────────────────────────────────────────
# Capture Dialog Sender Via JavaScript:
#   Traverses sibling elements after the dialog H1 and returns the first
#   non-heading, non-interactive text node with length > 10 chars.
#
# Capture Dialog Data Fields Via JavaScript:
#   Attempts two DOM patterns in order:
#     1. <dt>/<dd> definition list pairs
#     2. <tr> table rows with ≥ 2 <td> cells
#   Returns [{key, value}, …]
#
# If the live app uses a different DOM structure, update the JS strings in
# those two keywords and re-run the first-run tests.
# ==============================================================================

*** Settings ***
Library     Browser
Library     OperatingSystem
Library     DateTime
Library     String
Library     Collections

Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot
Library     ../resources/dsc_register_fixture_library.py

Resource    ../pages/dsc_register_selection_page.robot


*** Variables ***

# ── Shared Anfrage Starten Button ─────────────────────────────────────────────
# Same button for all register cards; defined here to avoid importing the
# BVA-specific page object.
${REG_REQUEST_START_BTN}          //button[normalize-space(.)="Anfrage starten"]

# ── Protokolldaten Dialog ─────────────────────────────────────────────────────
# Dialog structure is identical for all register cards.
# Scope all selectors to the visible (aria-hidden=false) dialog instance.
${REG_DIALOG}
...    //div[@role="dialog" and @aria-hidden="false"]
${REG_DIALOG_H1}
...    //div[@role="dialog" and @aria-hidden="false"]//h1[contains(.,"Datenübermittlung am")]
${REG_DIALOG_ANFRAGEN_BTN}
...    //button/span[@data-testid="inhaltsdatenAbfragenBtn"]
${REG_DATEN_ABGERUFEN_BTN}
...    //div[@role="dialog" and @aria-hidden="false"]//button[contains(.,"Daten abgerufen")]
${REG_DIALOG_CLOSE_BTN}
...    //div[@role="dialog" and @aria-hidden="false"]//button[@data-testid="closeModalBtn"]
*** Keywords ***

# ── Navigation ─────────────────────────────────────────────────────────────────

Navigate To Register Results Page
    [Documentation]    Generic entry sequence for any register card:
    ...                  1. Navigate to register-auswahl (authenticated session)
    ...                  2. Select the named register card
    ...                  3. Click "Anfrage starten"
    ...                  4. Wait for the datenabfrage results page to load
    ...                  5. Wait for the register result entry to appear (async API)
    ...
    ...                Arguments:
    ...                  ${register_name}  – Exact h3 text of the register card
    [Arguments]    ${register_name}
    Navigate To Register Auswahl Page
    Switch Register Auswahl To Grid View
    Ensure RA Empty Selection State
    Select Register Card By Name    ${register_name}
    Wait For Elements State    ${REG_REQUEST_START_BTN}    visible    timeout=${TIMEOUT}
    Click    ${REG_REQUEST_START_BTN}
    Wait For Load State    networkidle
    ${url}=    Get Url
    Should Contain    ${url}    datenabfrage
    ${result_entry}=    Set Variable
    ...    //div[contains(@aria-label,"Ergebnis ist") and .//h3[normalize-space(.)="${register_name}"]]
    Wait For Elements State    ${result_entry}    visible    timeout=30s


Expand Register Result Entry
    [Documentation]    Clicks the expand-toggle (div[role="button"]) for the
    ...                named register result entry and waits until the entry
    ...                transitions to "Ergebnis ist geöffnet" state with at
    ...                least one Datenübermittlung table heading visible.
    ...
    ...                Arguments:
    ...                  ${register_name}  – Exact h3 text of the register card
    [Arguments]    ${register_name}
    ${expand_btn}=    Set Variable
    ...    //div[@role="button" and .//h3[normalize-space(.)="${register_name}"]]
    ${result_opened}=    Set Variable
    ...    //div[@aria-label="Ergebnis ist geöffnet" and .//h3[normalize-space(.)="${register_name}"]]
    ${table_h4}=    Set Variable
    ...    (//div[@aria-label="Ergebnis ist geöffnet"]//h4[contains(normalize-space(.),"Datenübermittlung am")])[1]
    Wait For Elements State    ${expand_btn}    visible    timeout=${TIMEOUT}
    Click    ${expand_btn}
    Wait For Elements State    ${result_opened}    visible    timeout=${TIMEOUT}
    Wait For Elements State    ${table_h4}         visible    timeout=30s


Open First Register Protokolldaten Dialog
    [Documentation]    Clicks the first "Daten einsehen" button inside the
    ...                expanded register result entry and waits until the
    ...                Protokolldaten dialog is open and its H1 is visible.
    ...                Arguments:
    ...                  ${register_name}  – Exact h3 text of the expanded result entry
    [Arguments]    ${register_name}
    ${open_result}=    Set Variable
    ...    //div[@aria-label="Ergebnis ist geöffnet" and .//h3[normalize-space(.)="${register_name}"]]
    ${dialog_btn}=    Set Variable
    ...    (${open_result}//button[@data-testid="protkolldatenEinsehenBtn"])[1]
    Wait For Elements State    ${dialog_btn}    visible    timeout=${TIMEOUT}
    Click    ${dialog_btn}
    Wait For Elements State    ${REG_DIALOG}     visible    timeout=${TIMEOUT}
    Wait For Elements State    ${REG_DIALOG_H1}  visible    timeout=${TIMEOUT}


Fetch Personal Data In Register Dialog
    [Documentation]    Clicks "Persönliche Daten anfragen" inside the open
    ...                Protokolldaten dialog and waits for the "Daten abgerufen"
    ...                confirmation button, confirming that the data has loaded.
    Wait For Elements State    ${REG_DIALOG_ANFRAGEN_BTN}    visible    timeout=${TIMEOUT}
    Click    ${REG_DIALOG_ANFRAGEN_BTN}
    Wait For Elements State    ${REG_DATEN_ABGERUFEN_BTN}    visible    timeout=${TIMEOUT}


Close Register Protokolldaten Dialog
    [Documentation]    Closes the open Protokolldaten dialog via the scoped
    ...                close button and waits until the dialog is fully detached.
    Wait For Elements State    ${REG_DIALOG_CLOSE_BTN}    visible    timeout=${TIMEOUT}
    Click    ${REG_DIALOG_CLOSE_BTN}
    Wait For Elements State    ${REG_DIALOG}    detached    timeout=${TIMEOUT}


Close Register Dialog If Open
    [Documentation]    Safely closes the Protokolldaten dialog if it is currently
    ...                open. Does nothing (no error) when no dialog is visible.
    ...                Use in Suite Teardown to avoid logout being blocked by
    ...                an open dialog after a test failure.
    ${count}=    Get Element Count    ${REG_DIALOG}
    IF    ${count} > 0
        Run Keyword And Ignore Error    Click    ${REG_DIALOG_CLOSE_BTN}
        Run Keyword And Ignore Error
        ...    Wait For Elements State    ${REG_DIALOG}    detached    timeout=${TIMEOUT}
    END


Run Full Register Workflow To Dialog Data
    [Documentation]    Composite keyword that drives the complete register card
    ...                workflow up to and including the personal data fetch:
    ...                  1. Navigate to datenabfrage (register selected)
    ...                  2. Expand the register result entry
    ...                  3. Open the first Protokolldaten dialog
    ...                  4. Fetch personal data
    ...                Returns when the dialog is open and data is loaded.
    ...
    ...                Arguments:
    ...                  ${register_name}  – Exact h3 text of the register card
    [Arguments]    ${register_name}
    Navigate To Register Results Page    ${register_name}
    Expand Register Result Entry          ${register_name}
    Open First Register Protokolldaten Dialog    ${register_name}
    Fetch Personal Data In Register Dialog


# ── Assertion Keywords ─────────────────────────────────────────────────────────

Verify Register Dialog Sender
    [Documentation]    Asserts that the expected sender organisation name is
    ...                visible inside the open Protokolldaten dialog.
    ...                Uses [1] to avoid strict-mode violation when the text
    ...                appears in multiple spans (header + data rows).
    ...
    ...                Arguments:
    ...                  ${expected_sender}  – Organisation name text to match
    [Arguments]    ${expected_sender}
    ${sender_sel}=    Set Variable
    ...    (//div[@role="dialog" and @aria-hidden="false"]//*[normalize-space(text())="${expected_sender}"])[1]
    Wait For Elements State    ${sender_sel}    visible    timeout=${TIMEOUT}


Verify Register Dialog Data Fields
    [Documentation]    Iterates over the fixture data_fields list and verifies
    ...                each field against the open Protokolldaten dialog:
    ...                  • Field key (label text) must be visible  (always)
    ...                  • Field value text must be visible         (only when assert_value: true)
    ...
    ...                Arguments:
    ...                  ${data_fields}  – List of dicts:
    ...                                   {key: str, value: str, assert_value: bool}
    [Arguments]    ${data_fields}
    ${dialog_text}=    Get Text    ${REG_DIALOG}
    ${live_fields}=    Capture Dialog Data Fields Via JavaScript
    FOR    ${field}    IN    @{data_fields}
        ${has_key}=    Dialog Contains Field Key    ${dialog_text}    ${field}[key]
        IF    not ${has_key}
            ${has_key}=    Has Data Field Key    ${live_fields}    ${field}[key]
        END
        Should Be True    ${has_key}    Missing dialog field key: ${field}[key]
        IF    ${field}[assert_value]
            ${pair_in_text}=    Dialog Contains Field Pair
            ...    ${dialog_text}
            ...    ${field}[key]
            ...    ${field}[value]
            IF    not ${pair_in_text}
                ${live_value}=    Get Data Field Value    ${live_fields}    ${field}[key]
                Should Be Equal As Strings    ${live_value}    ${field}[value]
                ...    msg=Unexpected dialog value for key '${field}[key]'
            END
        END
    END


# ── First-Run: Data Capture via JavaScript ─────────────────────────────────────

Capture Dialog Sender Via JavaScript
    [Documentation]    Captures the sender organisation text from the currently
    ...                open Protokolldaten dialog using JavaScript.
    ...
    ...                Strategy: starting from the dialog H1, walks forward
    ...                through sibling elements and returns the first non-heading,
    ...                non-interactive element whose text is longer than 10 chars.
    ...
    ...                Returns the captured text. If the DOM structure does not
    ...                match, an empty string is returned; update the YAML manually.
    ${sender}=    Evaluate JavaScript
    ...    //div[@role="dialog" and @aria-hidden="false"]
    ...    (dialog) => { const h1=dialog.querySelector('h1'); if(!h1)return ''; const SKIP=['BUTTON','INPUT','SELECT','SCRIPT','STYLE','H1','H2','H3','H4','H5','H6']; const w=document.createTreeWalker(dialog,NodeFilter.SHOW_TEXT,null); let past=false; while(w.nextNode()){const n=w.currentNode; if(!past){if(h1.contains(n)){past=true;}continue;} const t=(n.textContent||'').trim(); if(t.length<10)continue; let el=n.parentElement; let bad=false; while(el&&el!==dialog){if(SKIP.includes(el.tagName)){bad=true;break;}el=el.parentElement;} if(!bad)return t;} return ''; }
    RETURN    ${sender}


Capture Dialog Data Fields Via JavaScript
    [Documentation]    Captures all data field key/value pairs from the open
    ...                Protokolldaten dialog using JavaScript.
    ...
    ...                Tries two DOM patterns in sequence:
    ...                  1. <dt>/<dd> definition list pairs
    ...                  2. <tr> rows with ≥ 2 <td> cells
    ...
    ...                Returns a list of dicts: [{key: ..., value: ...}, …]
    ...                Empty keys are excluded automatically.
    ...
    ...                If neither pattern matches (unknown DOM structure), an
    ...                empty list is returned; update the YAML manually.
    ${fields}=    Evaluate JavaScript
    ...    //div[@role="dialog" and @aria-hidden="false"]
    ...    (dialog) => { const f=[]; const clean=t=>(t||'').trim().replace(/:$/,''); const INLINE=['SPAN','P','STRONG','EM','B','I','LABEL']; const INL_OR_BLOCK=['SPAN','P','STRONG','EM','B','I','LABEL','DIV','LI']; const addIfValid=(k,v)=>{if(k&&k.length>=2&&k.length<100&&!k.match(/^\d+$/)&&v.length<300)f.push({key:k,value:v});}; const dts=[...dialog.querySelectorAll('dt')]; if(dts.length>0){dts.forEach(dt=>{const dd=dt.nextElementSibling; if(dd&&dd.tagName==='DD'){const k=clean(dt.textContent); const v=clean(dd.textContent); addIfValid(k,v);}});if(f.length>0)return f;} const rows=[...dialog.querySelectorAll('tr')]; rows.forEach(tr=>{const cells=[...tr.querySelectorAll('td')]; if(cells.length>=2){const k=clean(cells[0].textContent); const v=clean(cells[1].textContent); addIfValid(k,v);}});if(f.length>0)return f; const seen=new Set(); [...dialog.querySelectorAll('*')].forEach(el=>{const ch=[...el.children]; if(ch.length===2&&INL_OR_BLOCK.includes(ch[0].tagName)&&INL_OR_BLOCK.includes(ch[1].tagName)&&ch[0].children.length===0&&ch[1].children.length===0){const k=clean(ch[0].textContent); const v=clean(ch[1].textContent); const sig=k+'|'+v; if(!seen.has(sig)){seen.add(sig);addIfValid(k,v);}}}); if(f.length>0)return f; const SKIP_TAGS=['BUTTON','INPUT','SELECT','SCRIPT','STYLE','H1','H2','H3','H4','H5','H6']; const w=document.createTreeWalker(dialog,NodeFilter.SHOW_TEXT,null); const texts=[]; while(w.nextNode()){const n=w.currentNode; let el=n.parentElement; let bad=false; while(el&&el!==dialog){if(SKIP_TAGS.includes(el.tagName)){bad=true;break;}el=el.parentElement;} if(bad)continue; const t=(n.textContent||'').trim(); if(t.length>=2&&t.length<100)texts.push(t);} const SEC_RE=/^[A-ZÄÖÜ][a-zäöüß ]+[a-zäöüß]$/; const cleaned=texts.filter(t=>!SEC_RE.test(t)||t.split(' ').length<=2); for(let i=0;i+1<cleaned.length;i+=2){const k=clean(cleaned[i]); const v=clean(cleaned[i+1]); addIfValid(k,v);} return f; }
    RETURN    ${fields}


Generate Register Fixture From Dialog
    [Documentation]    Captures the sender text and data fields from the currently
    ...                open (and data-loaded) Protokolldaten dialog via JavaScript,
    ...                then builds and writes a YAML fixture file.
    ...
    ...                Call this AFTER Fetch Personal Data In Register Dialog
    ...                (the dialog must show real data, not the loading state).
    ...
    ...                By default, skips writing if the fixture file already
    ...                exists. Pass ${force_regenerate}=${True} (or set the
    ...                suite variable FIXTURE_FORCE_REGENERATE) to overwrite.
    ...
    ...                Arguments:
    ...                  ${fixture_path}     – Absolute path to the .yaml output file
    ...                  ${register_name}    – Register card name (h3 text)
    ...                  ${register_tag}     – Short tag (e.g. "bva")
    ...                  ${force_regenerate} – Overwrite existing file (default: False)
    [Arguments]    ${fixture_path}    ${register_name}    ${register_tag}    ${force_regenerate}=${False}
    ${exists}=    Fixture Exists    ${fixture_path}
    ${existing}=    Set Variable    ${None}
    ${is_complete}=    Set Variable    ${False}
    IF    ${exists}
        ${existing}=    Load Register Fixture    ${fixture_path}
        ${is_complete}=    Is First Run Completed    ${existing}
    END
    IF    ${exists} and ${is_complete} and not ${force_regenerate}
        Log    Fixture already exists and is already completed; skipping write: ${fixture_path}    WARN
        RETURN
    END
    IF    ${exists} and not ${is_complete}
        Log    Fixture exists but is incomplete; regenerating fixture data: ${fixture_path}    WARN
    END
    # Capture live data from the open dialog
    ${sender}=    Capture Dialog Sender Via JavaScript
    ${fields}=    Capture Dialog Data Fields Via JavaScript
    Log    First-run: captured sender: ${sender}
    Log    First-run: captured fields: ${fields}
    # Build and write YAML
    ${fixture_data}=    Build First Run Fixture
    ...    register_name=${register_name}
    ...    register_tag=${register_tag}
    ...    sender=${sender}
    ...    data_fields=${fields}
    ...    existing_fixture=${existing}
    Write Register Fixture    ${fixture_path}    ${fixture_data}
    Log    First-run: fixture written to ${fixture_path} – please review and commit.
