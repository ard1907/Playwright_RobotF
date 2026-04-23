# ==============================================================================
# common_keywords.robot
# Reusable utility keywords shared across all page objects and test suites.
# Browser Library (Playwright) is the sole driver – no hard sleeps.
# ==============================================================================

*** Settings ***
Library     Browser
Library     String
Resource    dsc_variables.robot


*** Variables ***

${LOGIN_BUTTON}           //button[@id="button-anfrage-starten"]
&{AUSWEIS_URLS}           AusweisApp=https://www.ausweisapp.bund.de/
...                       AusweisAppHome=https://www.ausweisapp.bund.de/home/
...                       Personalausweisportal=https://www.personalausweisportal.de/Webs/PA/DE/startseite/startseite-node.html
${DIALOG_SELECTOR}        //div[contains(@class,"modal") and @aria-hidden="false"]


*** Keywords ***

Skip Current Test If AusweisApp Environment Is Missing
    [Documentation]    Central temporary guard for individual AusweisApp-
    ...                dependent tests or keywords. Comment out the Skip If
    ...                line when standard CI should execute these flows.
    ...                Use this only for isolated login-dependent tests;
    ...                full cockpit suites should prefer the suite-level guard
    ...                in dsc_setup_teardown.robot.
    ${is_available}=    Evaluate    (not ${CI}) or ${CI_SELF_HOSTED}
    Skip If    not ${is_available}    No AusweisApp SDK on standard CI. Remove or comment out this central guard in the real DSC environment.

# ── Navigation ─────────────────────────────────────────────────────────────────

Navigate To Landing Page
    [Documentation]    Navigates the current page to the SPA base URL and waits
    ...                for the network to become idle (handles SPA hydration).
    Go To               ${BASE_URL}
    Wait For Load State    networkidle
    ${url}=             Get Url
    Should Be Equal As Strings    ${url}    ${BASE_URL}

Navigate To Authentication Info Page
    [Documentation]    Navigates the current page to the SPA Authentication Info
    ...                (Login) route and waits for the network to become idle.
    ${url}=             Get Url
    IF  "${url}" == "${AUTH_INFO_URL}"   
        RETURN
    ELSE
        Go To               ${AUTH_INFO_URL}
        Wait For Load State    networkidle       
    END
    ${url}=             Get Url
    IF  "${url}" != "${AUTH_INFO_URL}"
        Click               ${LOGIN_BUTTON}
        Wait For Load State    networkidle
        ${url}=             Get Url
        Should Contain    ${url}    authentication-info
        ${title}=           Get Title
    END

Navigate To Register Auswahl Page
    [Documentation]    Navigates to the Register Auswahl page in the cockpit area.
    ...                Requires an active, authenticated session.
    ${url}=             Get Url
    IF    "register-auswahl" not in """${url}"""
        Go To               ${REGISTER_AUSWAHL_URL}
    END
    
    Wait For Load State    networkidle
    ${url}=             Get Url
    Should Contain      ${url}    register-auswahl


# ── Generic Assertions ─────────────────────────────────────────────────────────

Verify Page Title Contains
    [Documentation]    Asserts that the current document title contains the
    ...                provided text fragment (case-sensitive).
    [Arguments]    ${expected_text}
    ${url}=      Get Url
    ${title}=    Get Title
    Should Contain    ${title}    ${expected_text}

Element Is Visible
    [Documentation]    Waits until the element matched by *selector* is present
    ...                in the DOM and has a non-zero bounding box (visible).
    ...                Uses the global ${TIMEOUT} so tests fail fast on breakage.
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible    timeout=${TIMEOUT}
    ${ele_state}=    Get Element States    ${selector}

Verify Application Version String Is Correct
    [Documentation]    Verifies that the application version string in the page
    ...                footer is visible and matches the expected version number
    ...                defined by ${APP_VERSION} in dsc_variables.robot.
    ...                Assertions:
    ...                  1. Full version text "Datenschutzcockpit Version X.Y.Z" is visible
    ...                  2. Visible text contains the expected version number
    ${full_version}=    Set Variable    Datenschutzcockpit Version ${APP_VERSION}
    Element Is Visible    text=${full_version}
    ${actual_text}=    Get Text    text=Datenschutzcockpit Version
    Should Contain    ${actual_text}    ${APP_VERSION}


# ── Dialog Helpers ─────────────────────────────────────────────────────────────

Check If Dialog Is Open
    [Documentation]    Returns TRUE if at least one modal/dialog with
    ...                aria-hidden="false" is currently present; FALSE otherwise.
    ...                NOTE: Previously used Run Keyword And Return Status which
    ...                always returned TRUE because Get Element Count never raises.
    ${count}=    Get Element Count    ${DIALOG_SELECTOR}
    ${is_open}=  Evaluate    ${count} > 0
    RETURN       ${is_open}

Close Currently Open Dialog
    [Documentation]    Closes the currently open modal/dialog by clicking the
    ...                standard "Menü schließen" button present in all SPA
    ...                dialogs, then waits until that button is detached from
    ...                the DOM (guarantees the dialog is fully gone before the
    ...                next action is performed).
    Click    role=button[name="Menü schließen"]
    Wait For Elements State
    ...    role=button[name="Menü schließen"]
    ...    detached
    ...    timeout=${TIMEOUT}


# ── New-Tab Helpers ────────────────────────────────────────────────────────────
Open External Tab And Validate
    [Documentation]    Clicks the "AusweisApp" in-text link, which opens the
    ...                official AusweisApp website in a new browser tab.
    ...                Assertions on the target page:
    ...                  -- URL contains given argument "expected_h1_url_fragment"
    ...                  -- Page title is not empty
    ...                  -- Title contains given argument "expected_h1_url_fragment"
    ...                  -- At least one H1 heading is visible
    ...                After verification the new tab is closed and focus returns.
    [Arguments]             ${expected_h1_url_fragment}
    ${h1_selector}=         Replace String    //h1[contains(text(), "XXXX")]    XXXX    ${expected_h1_url_fragment}
    ${lower_url_fragment}=  Convert To Lowercase    ${expected_h1_url_fragment}
    ${link_url_selector}=   Replace String    //a[contains(@href, "XXXX") and contains(@target, "blank")]    XXXX    ${lower_url_fragment}
    Element Is Visible      ${link_url_selector}
    Click                   ${link_url_selector}
    Switch To Newly Opened Tab
    ${url}=                 Get Url
    Should Contain          ${url}    ${lower_url_fragment}
    ${title}=               Get Title
    Should Not Be Empty     ${title}
    Should Contain          ${title}    ${expected_h1_url_fragment}
    Element Is Visible      ${h1_selector}
    Close Current Tab And Return

Open External Tab And Validate Just URL
    [Documentation]    Clicks the "AusweisApp" in-text link, which opens the
    ...                official AusweisApp or Personalausweis website in a new browser tab.
    ...                Assertions on the target page:
    ...                  -- just external URL is checked, no title or content assertions
    ...                After verification the new tab is closed and focus returns.
    [Arguments]             ${expected_h1_url_fragment}
    Log    ${AUSWEIS_URLS}[${expected_h1_url_fragment}]
    ${link_url_selector}=   Set Variable    //a[contains(@href, "${AUSWEIS_URLS}[${expected_h1_url_fragment}]") and contains(@target, "blank")]
    Element Is Visible      ${link_url_selector}
    Click                   ${link_url_selector}
    Switch To Newly Opened Tab
    ${url}=                 Get Url
    Should Contain          ${url}    ${AUSWEIS_URLS}[${expected_h1_url_fragment}]
    Close Current Tab And Return


Switch To Newly Opened Tab
    [Documentation]    Switches the active page context to the most recently
    ...                opened browser tab and waits for it to fully load.
    ...                Call this immediately after clicking a link that opens
    ...                a new tab (target=_blank).
    Switch Page    NEW
    Wait For Load State    networkidle

Close Current Tab And Return
    [Documentation]    Closes the currently active tab and restores the browser
    ...                context to the previous (original) tab. Use after
    ...                external-link navigation tests to restore the suite state.
    ${page_ids}=       Get Page Ids
    Log    Current Page IDs: ${page_ids}
    Close Page
    Switch Page    ${page_ids}[0]
    Wait For Load State    networkidle

