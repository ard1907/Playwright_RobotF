# ==============================================================================
# common_keywords.robot
# Reusable utility keywords shared across all page objects and test suites.
# Browser Library (Playwright) is the sole driver – no hard sleeps.
# ==============================================================================

*** Settings ***
Library     Browser
Resource    variables.robot


*** Keywords ***

# ── Navigation ─────────────────────────────────────────────────────────────────

Navigate To Landing Page
    [Documentation]    Navigates the current page to the SPA base URL and waits
    ...                for the network to become idle (handles SPA hydration).
    Go To               ${BASE_URL}
    Wait For Load State    networkidle

Navigate To Authentication Info Page
    [Documentation]    Navigates the current page to the SPA Authentication Info
    ...                (Login) route and waits for the network to become idle.
    Go To               ${AUTH_INFO_URL}
    Wait For Load State    networkidle


# ── Generic Assertions ─────────────────────────────────────────────────────────

Verify Page Title Contains
    [Documentation]    Asserts that the current document title contains the
    ...                provided text fragment (case-sensitive).
    [Arguments]    ${expected_text}
    ${title}=    Get Title
    Should Contain    ${title}    ${expected_text}

Element Is Visible
    [Documentation]    Waits until the element matched by *selector* is present
    ...                in the DOM and has a non-zero bounding box (visible).
    ...                Uses the global ${TIMEOUT} so tests fail fast on breakage.
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible    timeout=${TIMEOUT}


# ── Dialog Helpers ─────────────────────────────────────────────────────────────

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
    Close Page
    Switch Page    PREVIOUS
    Wait For Load State    networkidle

# Pause
#     [Documentation]    Stoppt den Test im Browser für Debugging
#     Evaluate JavaScript    debugger