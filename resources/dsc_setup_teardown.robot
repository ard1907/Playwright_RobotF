# ==============================================================================
# setup_teardown.robot
# Centralised browser lifecycle keywords.
# Standard suites:
#   Suite Setup     → Open Application Browser
#   Suite Teardown  → Close Application Browser
# AusweisApp-dependent suites:
#   Suite Setup     → Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}
#   Suite Teardown  → Close Browser After AusweisApp Suite
# Test Setup   → route-specific navigation (defined in common_keywords.robot)
# ==============================================================================

*** Settings ***
Library     Browser
Resource    dsc_variables.robot
Resource    dsc_shared_keywords.robot


*** Keywords ***

Open Browser And Login For AusweisApp Suite
    [Documentation]    Central suite setup for AusweisApp-dependent suites.
    ...                Evaluates the standard-CI guard exactly once, skips the
    ...                whole suite when the SDK is unavailable, and otherwise
    ...                opens the browser plus login flow.
    ...                Recommended suite usage for future cockpit suites:
    ...                Suite Setup     Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}
    ...                Suite Teardown  Close Browser After AusweisApp Suite
    ...                Disable the temporary skip centrally by commenting out
    ...                the Skip If line in this keyword.
    [Arguments]        ${url}=${AUTH_INFO_URL}
    ${suite_can_run}=    Evaluate    (not ${CI}) or ${CI_SELF_HOSTED}
    Set Suite Variable    ${AUSWEISAPP_SUITE_CAN_RUN}    ${suite_can_run}
    Skip If    not ${AUSWEISAPP_SUITE_CAN_RUN}    No AusweisApp SDK on standard CI. Remove or comment out this central suite guard in the real DSC environment.
    Open Application Browser    ${url}
    Login Into Datenschutzcockpit

Close Browser After AusweisApp Suite
    [Documentation]    Central suite teardown for AusweisApp-dependent suites.
    ...                Logs out only when the suite actually ran, then closes
    ...                all browsers.
    Run Keyword If    ${AUSWEISAPP_SUITE_CAN_RUN}    Logout From Datenschutzcockpit
    Close Application Browser

Open Application Browser
    [Documentation]    Starts a new Chromium (or configured) browser process,
    ...                creates a fresh isolated context with German locale, opens
    ...                the first page and waits for the SPA to fully hydrate.
    [Arguments]        ${url}=${BASE_URL}    ${browser_type}=${BROWSER}    ${headless_bool}=${HEADLESS}   ${slow_mo}=${SLOW_MOTION}
    IF    ${CI}
        Open Chromium Browser
        New Context    tracing=retain-on-failure   locale=de-DE    acceptDownloads=${True}
    ELSE
        ${slow_mo}=    IF   "${headless_bool}"=="True" or "${slow_mo}"==""    Set Variable   0:00:00.010   ELSE    Set Variable   ${slow_mo}
        Open Chromium Browser    ${browser_type}    ${headless_bool}    ${slow_mo}
        New Context    tracing=retain-on-failure   locale=de-DE     viewport=None    acceptDownloads=${True}      # viewport={'width': ${WIDTH}, 'height': ${HEIGHT}}
    END
    New Page               ${url}
    Wait For Load State    networkidle
    ${url}=            Get Url

Open Chromium Browser
    [Documentation]    Opens Chromium with an optional local executable path.
    [Arguments]        ${browser_type}=${BROWSER}    ${headless_bool}=${HEADLESS}    ${slow_mo}=${SLOW_MOTION}
    IF    "${CHROMIUM_EXECUTABLE}" != ""
        # Security patch for selfhosted (!) CI workflow with Docker containers: use a locally installed Chromium binary in Docker container.
        New Browser    browser=${browser_type}    headless=${headless_bool}    slowMo=${slow_mo}    args=["--start-maximized"]    executablePath=${CHROMIUM_EXECUTABLE}
    ELSE
        New Browser    browser=${browser_type}    headless=${headless_bool}    slowMo=${slow_mo}    args=["--start-maximized"]
    END

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
