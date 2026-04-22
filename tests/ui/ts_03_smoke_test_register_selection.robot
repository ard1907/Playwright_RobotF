# ==============================================================================
# ts_03_smoke_test_register_selection.robot  –  Smoke Test Suite for the
#                                               Register Auswahl Page
#
# Target  : https://qs-datenschutzcockpit.dsc.govkg.de/spa/cockpit/register-auswahl
# Pattern : Page Object Model (POM) + shared resources
#
# NOTE: This page is only accessible after a successful eID login via AusweisApp.
#       On non-self-hosted CI environments the login flow is skipped and all
#       test cases return early (no AusweisApp SDK available).
#       Remove the CI guards when running in the real DSC infrastructure.
#
# Suite Setup     → Open browser + login once for the whole suite
# Test Setup      → Navigate to register-auswahl before each test (clean state)
# Suite Teardown  → Logout + close all browsers
#
# Test Cases
# ----------
#   TC001  Validate Register Selection Page
#   TC002  Verify Header Accessibility And Navigation Buttons Are Present
#   TC003  Verify Register List Elements Are Rendered
#   TC004  Verify Intro Content Links Are Present
#   TC005  Verify Feedback Button Is Present
# ==============================================================================

*** Settings ***
Library         Browser

Resource        ../../resources/dsc_variables.robot
Resource        ../../resources/dsc_setup_teardown.robot
Resource        ../../resources/dsc_shared_keywords.robot

Resource        ../../pages/dsc_authentication_info_page.robot
Resource        ../../pages/dsc_register_selection_page.robot

# ── Suite-level browser lifecycle ─────────────────────────────────────────────
# Login once for the whole suite; each test navigates fresh to register-auswahl.
Suite Setup     Run Keywords
...             Open Application Browser    ${AUTH_INFO_URL}    AND
...             Login Into Datenschutzcockpit
Suite Teardown  Run Keywords
...             Logout From Datenschutzcockpit    AND
...             Close Application Browser
# Navigate fresh to the register-auswahl page before every test for isolation.
Test Setup      Navigate To Register Auswahl Page


*** Test Cases ***

TC001 - Validate Register Selection Page
    [Documentation]    Verifies all critical elements on the Register Auswahl
    ...                page (cockpit entry point after eID login):
    ...                  • Page title contains "Registerauswahl"
    ...                  • H1 heading "Wonach wollen Sie suchen?" is visible
    ...                  • H2 heading "Registerauswahl" is visible
    ...                  • IDNr display (masked tax-ID) is visible – confirms login
    ...                  • Session timer is visible
    ...                  • Logout trigger button is visible and enabled
    ...                  • Intro paragraph text is visible
    [Tags]             smoke    register-auswahl    cockpit
    Validate Register Auswahl Page


TC002 - Verify Header Accessibility And Navigation Buttons Are Present
    [Documentation]    Confirms that the logo link, both shared-header accessibility
    ...                buttons, the floating FAQ button, all three footer navigation
    ...                buttons, and the application version string are visible and
    ...                enabled on the register-auswahl page:
    ...                  • Bund.de Datenschutzcockpit Beta Logo (link)
    ...                  • Das Datenschutzcockpit in Leichter Sprache (button)
    ...                  • Zum Gebärdensprache-Video (button)
    ...                  • FAQ (floating button)
    ...                  • Impressum (footer button)
    ...                  • Datenschutz (footer button)
    ...                  • Barrierefreiheit (footer button)
    ...                  • Datenschutzcockpit Version ${APP_VERSION} (footer text)
    [Tags]             smoke    register-auswahl    accessibility    cockpit
    Verify RA Header Accessibility Buttons
    Verify RA FAQ Float Button
    Verify RA Footer Navigation
    Verify Application Version String Is Correct


TC003 - Verify Register List Elements Are Rendered
    [Documentation]    Verifies the register selection section renders all expected
    ...                UI controls in their default state (no register selected):
    ...                  • "Alle Register auswählen" checkbox button visible + enabled
    ...                  • At least one register card (with h3 heading) is visible
    ...                  • Grid view toggle is present and active (default view)
    ...                  • List view toggle is present
    ...                  • Hint heading "Bitte wählen Sie mindestens ein Register" visible
    ...                  • Hint instruction paragraph visible
    [Tags]             smoke    register-auswahl    register-list    cockpit
    Verify RA Register List Is Rendered


TC004 - Verify Intro Content Links Are Present
    [Documentation]    Confirms the two inline content buttons inside the intro
    ...                paragraph are visible and enabled. These buttons open the
    ...                corresponding FAQ dialog overlays:
    ...                  • "Was sehe ich im Datenschutzcockpit?" button
    ...                  • "Was ist das Datenschutzcockpit?" button
    [Tags]             smoke    register-auswahl    content    cockpit
    Verify RA Intro Content Buttons


TC005 - Verify Feedback Button Is Present
    [Documentation]    Verifies the "Feedback hinterlassen" button in the floating
    ...                action sidebar is visible and enabled. This button is
    ...                exclusive to the authenticated cockpit pages and therefore
    ...                not tested in the landing-page or auth-info test suites.
    [Tags]             smoke    register-auswahl    feedback    cockpit
    Verify RA Feedback Button
