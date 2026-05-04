# ==============================================================================
# Get Cookies After Login From Authentication Info Page
#
# Target  : https://qs-datenschutzcockpit.dsc.govkg.de/spa/authentication-info
#
# Suite Setup     → Open browser once for the whole suite
# Test Setup      → Navigate to auth-info page before each test (clean state)
# Suite Teardown  → Close all browsers
#
# Test Cases
# ----------
#   TC001  Get Cookies From Authentication Info Page
# ==============================================================================

*** Settings ***
Library         Browser
Resource        ../../resources/dsc_variables.robot
Resource        ../../resources/dsc_setup_teardown.robot
Resource        ../../resources/dsc_shared_keywords.robot
Resource        ../../pages/dsc_authentication_info_page.robot
Resource        ../../pages/dsc_register_selection_page.robot

# ── Suite-level browser lifecycle ─────────────────────────────────────────────
Suite Setup     Open Application Browser For Cookie Testing
Suite Teardown  Close Application Browser
# Navigate fresh to the auth-info page before every test so tests are isolated.
Test Setup      Navigate To Authentication Info Page

*** Keywords ***
Open Application Browser For Cookie Testing
    [Documentation]    Starts a new Chromium (or configured) browser process,
    ...                creates a fresh isolated context with German locale, opens
    ...                the first page and waits for the SPA to fully hydrate.
    New Browser            ${BROWSER}    headless=${HEADLESS}
    New Context            locale=de-DE
    New Page               ${BASE_URL}
    Wait For Load State    networkidle


*** Test Cases ***

TC001 - Get Cookies From Authentication Info Page
    [Documentation]    Retrieves and logs all cookies set on the authentication info page. 
    ...                This is a basic check to confirm that cookies are being set as expected when the page loads.
    [Tags]             smoke    auth    cookies
    Login Into Datenschutzcockpit
    ${cookies}=        Get Cookies
    Log Many           ${cookies}
    # ${response_anmeldung}=  Wait For Request    matcher=**/anmeldung
    # # ${response_login}=    Wait For Response    matcher=**/login
    # # ${response_auth}=     Wait For Response    matcher=**/auth
    Logout From Datenschutzcockpit



