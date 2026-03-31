# ==============================================================================
# setup_teardown.robot
# Centralised browser lifecycle keywords.
# Suite Setup  → Open Application Browser
# Suite Teardown → Close Application Browser
# Test Setup   → Navigate To Landing Page  (defined in common_keywords.robot)
# ==============================================================================

*** Settings ***
Library     Browser
Resource    variables.robot


*** Keywords ***

Open Application Browser
    [Documentation]    Starts a new Chromium (or configured) browser process,
    ...                creates a fresh isolated context with German locale, opens
    ...                the first page and waits for the SPA to fully hydrate.
    [Arguments]        ${url}=${BASE_URL}    ${browser_type}=${BROWSER}    ${headless_bool}=${HEADLESS}   ${slow_mo}=${SLOW_MOTION}
    IF    ${CI}
        New Browser
        New Context                                                       # viewport={'width': ${WIDTH}, 'height': ${HEIGHT}}
    ELSE
        ${slow_mo}=        IF   "${headless_bool}"=="True" or "${slow_mo}"==""    Set Variable   0:00:00.010   ELSE    Set Variable   ${slow_mo}
        New Browser    browser=${browser_type}    headless=${headless_bool}   slowMo=${slow_mo}    args=["--start-maximized"]
        New Context    viewport=None  locale=de-DE
    END
    New Page               ${url}
    Wait For Load State    networkidle
    ${url}=            Get Url

Open Application Browser OLD
    [Documentation]    Starts a new Chromium (or configured) browser process,
    ...                creates a fresh isolated context with German locale, opens
    ...                the first page and waits for the SPA to fully hydrate.
    New Browser    ${BROWSER}    headless=${HEADLESS}
    New Context    locale=de-DE
    New Page       ${BASE_URL}
    Wait For Load State    networkidle

Close Application Browser
    [Documentation]    Closes ALL open browser instances created during the run.
    Close Browser    ALL
