# ==============================================================================
# ts_03_smoke_test_register_selection.robot  –  Smoke Test Suite for the
#                                               Register Auswahl Page
#
# Target  : https://qs-datenschutzcockpit.dsc.govkg.de/spa/cockpit/register-auswahl
# Pattern : Page Object Model (POM) + shared resources
#
# NOTE: This page is only accessible after a successful eID login via AusweisApp.
#       On non-self-hosted CI environments the whole suite is skipped by the
#       central setup keyword in the shared resources.
#       Remove or comment out that central suite guard when running in the
#       real DSC infrastructure.
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
#   TC006  Select Single Register Enables Request Start
#   TC007  Toggle Single Register Returns Empty State
#   TC008  Toggle All Registers Select And Deselect
#   TC009  Intro Dialog "Was sehe ich" Opens And Closes
#   TC010  Intro Dialog "Was ist das DSC" Opens And Closes
#   TC011  Floating FAQ Dialog Opens And Closes
#   TC012  Verify IDNr Is Masked By Default
#   TC013  Verify Session Timer Counts Down
#   TC014  Verify Register Cards Expose More-Info Buttons
#   TC015  Reload Keeps Registerauswahl Stable
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
Suite Setup     Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}
Suite Teardown  Close Browser After AusweisApp Suite
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


TC006 - Select Single Register Enables Request Start
    [Documentation]    Selects one register card and verifies the page switches
    ...                from the empty-selection state to a submit-ready state.
    ...                Assertions:
    ...                  • "Anfrage starten" button becomes visible and enabled
    ...                  • Empty-state hint heading is no longer shown
    [Tags]             smoke    register-auswahl    interaction    selection
    Select First Register And Verify Anfrage Starten


TC007 - Toggle Single Register Returns Empty State
    [Documentation]    Selects and then deselects the same register card to
    ...                verify state reset behaviour.
    ...                Assertions:
    ...                  • "Anfrage starten" disappears after deselection
    ...                  • Empty-state hint heading + paragraph are visible again
    [Tags]             smoke    register-auswahl    interaction    toggle
    Toggle First Register Off And Verify Empty Hint


TC008 - Toggle All Registers Select And Deselect
    [Documentation]    Verifies the global selection toggle behaviour of
    ...                "Alle Register auswählen" and "Alle Register abwählen".
    [Tags]             smoke    register-auswahl    interaction    all-registers
    Toggle Alle Register Select And Deselect


TC009 - Intro Dialog "Was sehe ich" Opens And Closes
    [Documentation]    Opens the inline intro dialog for
    ...                "Was sehe ich im Datenschutzcockpit?" and verifies
    ...                title and close behaviour.
    [Tags]             smoke    register-auswahl    dialog    intro
    Open Intro Dialog Was Sehe Ich And Close


TC010 - Intro Dialog "Was ist das DSC" Opens And Closes
    [Documentation]    Opens the inline intro dialog for
    ...                "Was ist das Datenschutzcockpit?" and verifies
    ...                title and close behaviour.
    [Tags]             smoke    register-auswahl    dialog    intro
    Open Intro Dialog Was Ist And Close


TC011 - Floating FAQ Dialog Opens And Closes
    [Documentation]    Opens the FAQ dialog from the floating action bar,
    ...                verifies the FAQ heading/title, then closes it.
    [Tags]             smoke    register-auswahl    dialog    faq
    Open RA FAQ Dialog And Close


TC012 - Verify IDNr Is Masked By Default
    [Documentation]    Confirms the IDNr area is present in masked form and
    ...                the reveal button is available.
    [Tags]             smoke    register-auswahl    security    idnr
    Verify RA IDNr Is Masked By Default


TC013 - Verify Session Timer Counts Down
    [Documentation]    Reads the session timer twice with a short delay and
    ...                verifies that the value changes.
    [Tags]             smoke    register-auswahl    session    timer
    Verify RA Session Timer Counts Down


TC014 - Verify Register Cards Count And More-Info Buttons
    [Documentation]    Verifies at least one register card exists and all the
    ...                "Mehr zum Register lesen" buttons are present.
    [Tags]             smoke    register-auswahl    register-list    content
    Verify Register Cards Count And Link "Mehr zum Register lesen"



TC015 - Reload Keeps Registerauswahl Stable
    [Documentation]    Reloads the page and verifies that core components are
    ...                still visible and the route remains stable.
    [Tags]             smoke    register-auswahl    stability    reload
    Reload Register Auswahl And Verify Core Content
