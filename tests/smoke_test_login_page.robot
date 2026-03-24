# ==============================================================================
# smoke_test_login_page.robot  –  Smoke Test Suite for the Authentication Info Page
#
# Target  : https://datenschutzcockpit.dsc.govkg.de/spa/authentication-info
# Pattern : Page Object Model (POM) + shared resources
#
# Suite Setup     → Open browser once for the whole suite
# Test Setup      → Navigate to auth-info page before each test (clean state)
# Suite Teardown  → Close all browsers
#
# Test Cases
# ----------
#   TC001  Validate Authentication Info Page
#   TC002  Verify Header Accessibility Buttons Are Present
#   TC003  Navigate To Leichte Sprache And Validate
#   TC004  Navigate To Gebärdensprache And Validate
#   TC005  AusweisApp Link Navigates To External Page
#   TC006  Kompatibles Lesegerät Link Navigates To External Page
#   TC007  Verify AusweisApp Starten Button Is Accessible
#   TC008  Expand FAQ Was Benoetige Ich Und Validate Content
#   TC009  Expand FAQ Wie Melde Ich Mich An Und Validate Content
#   TC010  Expand FAQ Wie Sicher Ist Das Cockpit Und Validate Content
#   TC011  Full Login Page User Journey
# ==============================================================================

*** Settings ***
Library         Browser

Resource        ../resources/variables.robot
Resource        ../resources/setup_teardown.robot
Resource        ../resources/common_keywords.robot

Resource        ../pages/authentication_info_page.robot
Resource        ../pages/leichte_sprache_page.robot
Resource        ../pages/gebaerdensprache_page.robot
Resource        ../pages/dsc_registerauswahl_page.robot

# ── Suite-level browser lifecycle ─────────────────────────────────────────────
Suite Setup     Open Application Browser    ${AUTH_INFO_URL}
Suite Teardown  Close Application Browser
# Navigate fresh to the auth-info page before every test so tests are isolated.
Test Setup      Navigate To Authentication Info Page


*** Test Cases ***

TC001 - Validate Authentication Info Page
    [Documentation]    Verifies all critical elements on the Authentication Info
    ...                page: page title, H1 heading, logo, both header accessibility
    ...                buttons, all footer nav buttons, version string, two external
    ...                information links, the AusweisApp starten button, and all
    ...                three embedded FAQ accordion items.
    [Tags]             smoke    auth    login
    Validate Authentication Info Page


TC002 - Verify Header Accessibility Buttons Are Present
    [Documentation]    Confirms that both shared-header accessibility buttons are
    ...                visible and enabled on the auth-info route:
    ...                  • Das Datenschutzcockpit in Leichter Sprache
    ...                  • Zum Gebärdensprache-Video
    [Tags]             smoke    auth    accessibility
    Verify Auth Page Header Accessibility Buttons
    # Confirm the buttons are enabled (not just present)
    ${ls_states}=    Get Element States    ${AI_EASY_LANGUAGE_BTN}
    Should Contain    ${ls_states}    enabled
    ${gs_states}=    Get Element States    ${AI_SIGN_LANGUAGE_BTN}
    Should Contain    ${gs_states}    enabled


TC003 - Navigate To Leichte Sprache And Validate
    [Documentation]    Clicks the "Das Datenschutzcockpit in Leichter Sprache"
    ...                header button, confirms the dialog opens, and runs all
    ...                Leichte Sprache assertions: title change, dialog visibility,
    ...                H1 heading, body content references, and close button.
    ...                Finally closes the dialog and verifies the page is restored.
    [Tags]             smoke    auth    leichte-sprache    accessibility
    Open Leichte Sprache Dialog From Auth Page
    Validate Leichte Sprache Page
    Close Leichte Sprache Dialog
    Verify Authentication Info Page Is Loaded


TC004 - Navigate To Gebärdensprache And Validate
    [Documentation]    Clicks the "Zum Gebärdensprache-Video" header button,
    ...                confirms the dialog opens, and runs all Gebärdensprache
    ...                assertions: title change, dialog visibility, H1 heading,
    ...                content reference, video element, and close button.
    ...                Finally closes the dialog and verifies the page is restored.
    [Tags]             smoke    auth    gebaerdensprache    accessibility
    Open Gebaerdensprache Dialog From Auth Page
    Validate Gebaerdensprache Page
    Close Gebaerdensprache Dialog
    # Confirm we are back on the auth-info page
    Verify Authentication Info Page Is Loaded


TC005 - AusweisApp Link Navigates To External Page
    [Documentation]    Clicks the "AusweisApp" in-text link, which opens the
    ...                official AusweisApp website in a new browser tab.
    ...                Assertions on the target page:
    ...                  -- URL contains "ausweisapp"
    ...                  -- Page title is not empty
    ...                  -- Title contains "AusweisApp"
    ...                  -- At least one H1 heading is visible
    ...                After verification the new tab is closed and focus returns.
    [Tags]             smoke    auth    external-link    ausweisapp
    Open AusweisApp External Tab And Validate


TC006 - Kompatibles Lesegerät Link Navigates To External Page
    [Documentation]    Clicks the "kompatibles Lesegerät" in-text link, which
    ...                opens the list of compatible card readers in a new tab.
    ...                Assertions on the target page:
    ...                  -- URL is not empty (navigation succeeded)
    ...                  -- Page title is not empty
    ...                  -- At least one heading is visible
    ...                After verification the new tab is closed and focus returns.
    [Tags]             smoke    auth    external-link    lesegeraet
    Open Lesegeraet External Tab And Validate


TC007 - Verify AusweisApp Starten Button Is Accessible
    [Documentation]    Verifies the "AusweisApp starten" button is present,
    ...                visible, and enabled. The eID flow is intentionally NOT
    ...                triggered – this is a pure accessibility/presence check.
    ...                Assertions:
    ...                  1. Button is visible on the page
    ...                  2. Button state includes "enabled"
    ...                  3. Page URL remains on authentication-info after check
    ...                  4. Button inner text contains "AusweisApp"
    ...                  5. Button is keyboard-focusable (state includes "visible")
    [Tags]             smoke    auth    ausweisapp-starten
    Verify AusweisApp Start Button Is Present
    Verify AusweisApp Start Button After Click
    Login Into Datenschutzcockpit
    Logout From Datenschutzcockpit


# TC008 - Verify FAQ Card "Was Benoetige ich ..." And Validate Content
#     [Documentation]    Verifies the "Was benötige ich für die Anmeldung?" card
#     ...                on the auth-info page and verifies the revealed content.
#     ...                Assertions:
#     ...                  1. Click on card switches to "geöffnet" (open) state
#     ...                  2. "Personalausweis" is mentioned in the expanded content
#     ...                  3. "AusweisApp" is mentioned in the expanded content
#     ...                  4. Page URL has not changed (still on auth-info)
#     ...                  5. The other two FAQ cards are still present
#     [Tags]             smoke    auth    faq    accordion
#     Verify Auth Page FAQ Card "Was Benötige Ich ..."


# TC009 - Verify FAQ Card "Wie Melde Ich Mich ..." And Validate Content
#     [Documentation]    Clicks on the "Wie melde ich mich mit der AusweisApp an?"
#     ...                card and verifies the revealed step-by-step content.
#     ...                Assertions:
#     ...                  1. Click on card switches to "geöffnet" (open) state
#     ...                  2. Step/instruction text is visible ("Schritt")
#     ...                  3. "AusweisApp" is mentioned in the expanded content
#     ...                  4. Page URL has not changed (still on auth-info)
#     ...                  5. The other two FAQ accordions are still present
#     [Tags]             smoke    auth    faq    accordion
#     Verify FAQ Card "Wie Melde Ich Mich ..."


# TC010 - Verify FAQ Card "Wie Sicher Ist Das Cockpit ..." And Validate Content
#     [Documentation]    Clicks on the "Wie sicher ist das Datenschutzcockpit?"
#     ...                card and verifies the security-focused content.
#     ...                Assertions:
#     ...                  1. Click on card switches to "geöffnet" (open) state
#     ...                  2. The word "sicher" is visible in expanded content
#     ...                  3. "Datenschutzcockpit" is referenced in expanded content
#     ...                  4. Page URL has not changed (still on auth-info)
#     ...                  5. The other two FAQ accordions are still present
#     [Tags]             smoke    auth    faq    accordion
#     Verify FAQ Card "Wie Sicher Ist Das Cockpit ..."


# # TC011 - Full Login Page User Journey
# #     [Documentation]    End-to-end smoke run simulating a user arriving at the
# #     ...                auth-info page and exploring all its key interactions in
# #     ...                sequence – mirroring real navigation behaviour.
# #     [Tags]             smoke    auth    e2e    journey

# #     # ── 1. Verify the auth-info page is healthy ────────────────────────────────
# #     Validate Authentication Info Page

# #     # ── 2. Open Leichte Sprache dialog, spot-check, close ─────────────────────
# #     Open Leichte Sprache Dialog From Auth Page
# #     Verify Leichte Sprache Dialog Is Open
# #     Verify Leichte Sprache H1 Heading
# #     Verify Leichte Sprache Close Button Is Present
# #     Close Leichte Sprache Dialog

# #     # ── 3. Open Gebärdensprache dialog, spot-check, close ─────────────────────
# #     Open Gebaerdensprache Dialog From Auth Page
# #     Verify Gebaerdensprache Dialog Is Open
# #     Verify Gebaerdensprache H1 Heading
# #     Verify Gebaerdensprache Close Button Is Present
# #     Close Gebaerdensprache Dialog

# #     # ── 4. Expand all three FAQ accordions (verify each opens correctly) ───────
# #     Expand FAQ Accordion Was Benoetige Ich
# #     Element Is Visible    ${AI_FAQ_WHAT_NEEDED_OPEN}

# #     Expand FAQ Accordion Wie Melde Ich Mich An
# #     Element Is Visible    ${AI_FAQ_AUSWEIS_LOGIN_OPEN}

# #     Expand FAQ Accordion Wie Sicher
# #     Element Is Visible    ${AI_FAQ_HOW_SECURE_OPEN}

# #     # ── 5. Confirm page footer navigation is intact ────────────────────────────
# #     Verify Auth Page Footer Navigation
# #     Verify Auth Page Version Info

# #     # ── 6. External links – open each in new tab, validate, close ─────────────
# #     Open AusweisApp External Tab And Validate
# #     Verify Authentication Info Page Is Loaded
# #     Open Lesegeraet External Tab And Validate
# #     Verify Authentication Info Page Is Loaded
