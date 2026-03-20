# ==============================================================================
# smoke_tests.robot  –  Main Smoke Test Suite
#
# Target  : https://datenschutzcockpit.dsc.govkg.de/spa/
# Pattern : Page Object Model (POM) + shared resources
#
# Suite Setup     → Open browser once for the whole suite
# Test Setup      → Navigate to landing page before each test (clean state)
# Suite Teardown  → Close all browsers
#
# Test Cases
# ----------
#   TC001  Validate Landing Page
#   TC002  Navigate To FAQ And Validate
#   TC003  Navigate To Impressum And Validate
#   TC004  Navigate To Datenschutz And Validate
#   TC005  Navigate To Barrierefreiheit And Validate
#   TC006  Full SPA User Journey (end-to-end smoke)
# ==============================================================================

*** Settings ***
Library         Browser

Resource        ../resources/variables.robot
Resource        ../resources/setup_teardown.robot
Resource        ../resources/common_keywords.robot

Resource        ../pages/landing_page.robot
Resource        ../pages/faq_page.robot
Resource        ../pages/impressum_page.robot
Resource        ../pages/datenschutz_page.robot
Resource        ../pages/barrierefreiheit_page.robot

# Open the browser once; each test starts fresh on the landing page.
Suite Setup     Open Application Browser
Suite Teardown  Close Application Browser
Test Setup      Navigate To Landing Page


*** Test Cases ***

TC001 - Validate Landing Page
    [Documentation]    Verifies all critical elements on the SPA Landing Page
    ...                (Startseite): page title, H1 heading, intro text, CTA
    ...                button, FAQ section, footer navigation, floating FAQ
    ...                button, and version string.
    [Tags]             smoke    landing
    Verify Landing Page Is Loaded
    Verify Landing Page H1 Heading
    Verify Landing Page Intro Text
    Verify Landing Page CTA Button
    Verify Landing Page FAQ Section
    Verify Landing Page Footer Navigation
    Verify Landing Page FAQ Float Button
    Verify Landing Page Version Info


TC002 - Navigate To FAQ And Validate
    [Documentation]    Opens the FAQ dialog via the floating FAQ button and
    ...                checks: dialog visibility, page title change, H1, both
    ...                H2 section headings, and all seven accordion entries.
    [Tags]             smoke    faq
    Open FAQ Dialog
    Verify FAQ Dialog Is Open
    Verify FAQ Main Heading
    Verify FAQ How It Works Section
    Verify FAQ Login Section
    Verify FAQ Accordion Items
    Verify FAQ Login Accordion Items
    Verify FAQ Close Button Is Present
    Close FAQ Dialog


TC003 - Navigate To Impressum And Validate
    [Documentation]    Opens the Impressum dialog via the footer button and
    ...                checks: dialog visibility, page title change, H1, all
    ...                four H2 section headings, and the three key organisations.
    [Tags]             smoke    impressum
    Open Impressum Dialog
    Verify Impressum Dialog Is Open
    Verify Impressum H1 Heading
    Verify Impressum Publisher Section
    Verify Impressum Responsible Section
    Verify Impressum Realization Section
    Verify Impressum Hosting Section
    Verify Impressum Key Organizations
    Verify Impressum Close Button Is Present
    Close Impressum Dialog


TC004 - Navigate To Datenschutz And Validate
    [Documentation]    Opens the Datenschutzerklärung dialog via the footer and
    ...                checks: dialog visibility, page title change, H1, four
    ...                numbered section headings, DSGVO reference, BVA mention,
    ...                and IDNr reference.
    [Tags]             smoke    datenschutz
    Open Datenschutz Dialog
    Verify Datenschutz Dialog Is Open
    Verify Datenschutz H1 Heading
    Verify Datenschutz Section 1
    Verify Datenschutz Section 2
    Verify Datenschutz Section 3
    Verify Datenschutz Section 9
    Verify Datenschutz DSGVO Reference
    Verify Datenschutz BVA Mentioned
    Verify Datenschutz IDNr Reference
    Verify Datenschutz Close Button Is Present
    Close Datenschutz Dialog


TC005 - Navigate To Barrierefreiheit And Validate
    [Documentation]    Opens the Barrierefreiheit dialog via the footer and
    ...                checks: dialog visibility, page title change, H1, two H2
    ...                headings, three H3 headings, BITV reference, and contact
    ...                email presence.
    [Tags]             smoke    barrierefreiheit
    Open Barrierefreiheit Dialog
    Verify Barrierefreiheit Dialog Is Open
    Verify Barrierefreiheit H1 Heading
    Verify Barrierefreiheit Compatibility Section
    Verify Barrierefreiheit Non-Accessible Section
    Verify Barrierefreiheit Creation Section
    Verify Barrierefreiheit Feedback Section
    Verify Barrierefreiheit Mediation Section
    # Verify Barrierefreiheit BITV Referenced
    Verify Barrierefreiheit Contact Email
    Verify Barrierefreiheit Close Button Is Present
    Close Barrierefreiheit Dialog


TC006 - Full SPA User Journey
    [Documentation]    End-to-end smoke run that simulates a real user journey
    ...                through all SPA views in sequence.  Each dialog is opened,
    ...                spot-checked, and closed before the next one is opened –
    ...                mimicking natural navigation behaviour.
    [Tags]             smoke    e2e    journey

    # ── 1. Assert the landing page is healthy ─────────────────────────────────
    Validate Landing Page

    # ── 2. Open FAQ, spot-check, close ────────────────────────────────────────
    Open FAQ Dialog
    Verify FAQ Dialog Is Open
    Verify FAQ Main Heading
    Verify FAQ How It Works Section
    Verify FAQ Login Section
    Verify FAQ Accordion Items
    Close FAQ Dialog

    # ── 3. Open Impressum, spot-check, close ──────────────────────────────────
    Open Impressum Dialog
    Verify Impressum Dialog Is Open
    Verify Impressum H1 Heading
    Verify Impressum Publisher Section
    Verify Impressum Key Organizations
    Close Impressum Dialog

    # ── 4. Open Datenschutz, spot-check, close ────────────────────────────────
    Open Datenschutz Dialog
    Verify Datenschutz Dialog Is Open
    Verify Datenschutz H1 Heading
    Verify Datenschutz Section 2
    Verify Datenschutz DSGVO Reference
    Close Datenschutz Dialog

    # ── 5. Open Barrierefreiheit, spot-check, close ───────────────────────────
    Open Barrierefreiheit Dialog
    Verify Barrierefreiheit Dialog Is Open
    Verify Barrierefreiheit H1 Heading
    Verify Barrierefreiheit Compatibility Section
    Verify Barrierefreiheit Feedback Section
    Close Barrierefreiheit Dialog
