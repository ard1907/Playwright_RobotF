# ==============================================================================
# smoke_tests.robot  –  Main Smoke Test Suite
#
# Target  : https://qs-datenschutzcockpit.dsc.govkg.de/spa/
# Pattern : Page Object Model (POM) + shared resources
#
# Suite Setup     → Open browser once for the whole suite
# Test Setup      → Navigate to landing page before each test (clean state)
# Suite Teardown  → Close all browsers
#
# Test Cases
# ----------
#   TC001  Validate Landing Page
#   TC002  Verify Header Accessibility Buttons Are Present On Landing Page
#   TC003  Navigate To Leichte Sprache And Validate
#   TC004  Navigate To Gebärdensprache And Validate
#   TC005  Navigate To FAQ And Validate
#   TC006  Verify All FAQ Cards Are Rendered On Landing Page
#   TC007  Verify FAQ Card 'Was ist das Datenschutzcockpit' And Validate Content
#   TC008  Verify FAQ Card 'Was sehe ich im Datenschutzcockpit' And Validate Content
#   TC009  Verify FAQ Card 'Wer betreibt das Datenschutzcockpit' And Validate Content
#   TC010  Verify FAQ Card 'Weitere Informationen' And Validate Content
#   TC011  Navigate To Impressum And Validate
#   TC012  Navigate To Datenschutz And Validate
#   TC013  Navigate To Barrierefreiheit And Validate
#   TC014  Full SPA User Journey (end-to-end smoke)
# ==============================================================================

*** Settings ***
Library         Browser

Resource        ../../resources/dsc_variables.robot
Resource        ../../resources/dsc_setup_teardown.robot
Resource        ../../resources/dsc_shared_keywords.robot

Resource        ../../pages/dsc_landing_page.robot
Resource        ../../pages/dsc_faq_page.robot
Resource        ../../pages/dsc_easy_language_page.robot
Resource        ../../pages/dsc_sign_language_page.robot
Resource        ../../pages/dsc_imprint_legal_notice_page.robot
Resource        ../../pages/dsc_privacy_page.robot
Resource        ../../pages/dsc_accessibility_page.robot

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
    Validate Landing Page


TC002 - Verify Header Accessibility Buttons Are Present On Landing Page
    [Documentation]    Confirms that the logo link and both shared-header
    ...                accessibility buttons are visible and enabled on the
    ...                landing page:
    ...                  • Bund.de Datenschutzcockpit Beta Logo (link)
    ...                  • Das Datenschutzcockpit in Leichter Sprache (button)
    ...                  • Zum Gebärdensprache-Video (button)
    [Tags]             smoke    landing    accessibility
    Verify Landing Page Header Accessibility Buttons


TC003 - Navigate To Leichte Sprache And Validate
    [Documentation]    Clicks the "Das Datenschutzcockpit in Leichter Sprache"
    ...                header button, confirms the dialog opens, and runs all
    ...                Leichte Sprache assertions: title change, dialog visibility,
    ...                H1 heading, body content references, and close button.
    ...                Finally closes the dialog and verifies the page is restored.
    [Tags]             smoke    auth    leichte-sprache    accessibility
    Open Leichte Sprache Dialog
    Validate Leichte Sprache Page
    Validate Internal Links For Leichte Sprache Dialog
    Validate External URLs For Leichte Sprache Dialog
    Close Leichte Sprache Dialog
    Verify Landing Page Is Loaded


TC004 - Navigate To Gebärdensprache And Validate
    [Documentation]    Clicks the "Zum Gebärdensprache-Video" header button,
    ...                confirms the dialog opens, and runs all Gebärdensprache
    ...                assertions: title change, dialog visibility, H1 heading,
    ...                content reference, video element, and close button.
    ...                Finally closes the dialog and verifies the page is restored.
    [Tags]             smoke    auth    gebaerdensprache    accessibility
    Open Gebaerdensprache Dialog
    Validate Gebaerdensprache Page
    Validate External URLs For Gebaerdensprache Dialog
    Close Gebaerdensprache Dialog
    # Confirm we are back on the landing page
    Verify Landing Page Is Loaded


TC005 - Navigate To FAQ And Validate
    [Documentation]    Opens the FAQ dialog via the floating FAQ button and
    ...                checks: dialog visibility, page title change, H1, both
    ...                H2 section headings, and all seven accordion entries.
    [Tags]             smoke    faq
    Open FAQ Dialog
    Validate FAQ Page
    Close FAQ Dialog

TC006 - Verify All FAQ Cards Are Rendered On Landing Page
    [Documentation]    Confirms the "Häufige Fragen" section and all four FAQ
    ...                accordion cards are visible in their default closed state
    ...                without opening any of them.
    [Tags]             smoke    landing    faq    accordion
    Verify Landing Page FAQ Cards Are Rendered


TC007 - Verify FAQ Card 'Was ist das Datenschutzcockpit' And Validate Content
    [Documentation]    Clicks the "Was ist das Datenschutzcockpit?" accordion on
    ...                the Landing Page and verifies the revealed modal content.
    ...                Assertions:
    ...                  1. Click opens the modal (H1 heading visible)
    ...                  2. Distinctive content anchor visible inside modal
    ...                  3. SPA tab title updates to reflect the open card
    ...                  4. URL remains on the landing page (no navigation)
    ...                  5. All three remaining FAQ cards are still rendered
    [Tags]             smoke    landing    faq    accordion
    Verify Landing Page FAQ Card "Was Ist Das Datenschutzcockpit ..."
    Validate External URLs For Card - Was ist das Datenschutzcockpit ...
    Close Currently Open Dialog


TC008 - Verify FAQ Card 'Was sehe ich im Datenschutzcockpit' And Validate Content
    [Documentation]    Clicks the "Was sehe ich im Datenschutzcockpit?" accordion
    ...                on the Landing Page and verifies the revealed modal content.
    ...                Assertions:
    ...                  1. Click opens the modal (H1 heading visible)
    ...                  2. H2 section heading "Diese Informationen sehen Sie:" visible
    ...                  3. H2 section heading "Diese Informationen können Sie zukünftig sehen:" visible
    ...                  4. SPA tab title updates to reflect the open card
    ...                  5. URL remains on the landing page (no navigation)
    ...                  6. All three remaining FAQ cards are still rendered
    [Tags]             smoke    landing    faq    accordion
    Verify Landing Page FAQ Card "Was Sehe Ich Im Datenschutzcockpit ..."
    Close Currently Open Dialog


TC009 - Verify FAQ Card 'Wer betreibt das Datenschutzcockpit' And Validate Content
    [Documentation]    Clicks the "Wer betreibt das Datenschutzcockpit?" accordion
    ...                on the Landing Page and verifies the revealed modal content.
    ...                Assertions:
    ...                  1. Click opens the modal (H1 heading visible)
    ...                  2. Bundesverwaltungsamt (BVA) mentioned in expanded content
    ...                  3. Dataport mentioned in expanded content
    ...                  4. SPA tab title updates to reflect the open card
    ...                  5. URL remains on the landing page (no navigation)
    ...                  6. All three remaining FAQ cards are still rendered
    [Tags]             smoke    landing    faq    accordion
    Verify Landing Page FAQ Card "Wer Betreibt Das Datenschutzcockpit ..."
    Close Currently Open Dialog


TC010 - Verify FAQ Card 'Weitere Informationen' And Validate Content
    [Documentation]    Clicks the "Weitere Informationen" accordion on the
    ...                Landing Page and verifies the revealed modal content.
    ...                Assertions:
    ...                  1. Click opens the modal (H1 heading visible)
    ...                  2. Distinctive content anchor visible inside modal
    ...                  3. SPA tab title updates to reflect the open card
    ...                  4. URL remains on the landing page (no navigation)
    ...                  5. All three remaining FAQ cards are still rendered
    [Tags]             smoke    landing    faq    accordion
    Verify Landing Page FAQ Card "Weitere Informationen ..."
    Validate External URLs For Card - Weitere Informationen ...
    Close Currently Open Dialog


TC011 - Navigate To Impressum And Validate
    [Documentation]    Opens the Impressum dialog via the footer button and
    ...                checks: dialog visibility, page title change, H1, all
    ...                four H2 section headings, the three key organisations,
    ...                and all four email link href values.
    [Tags]             smoke    impressum
    Open Impressum Dialog
    Validate Impressum Page
    Validate External URLs For Impressum Dialog
    Close Impressum Dialog


TC012 - Navigate To Datenschutz And Validate
    [Documentation]    Opens the Datenschutzerklärung dialog via the footer and
    ...                checks: dialog visibility, page title change, H1, four
    ...                numbered section headings, DSGVO reference, BVA mention,
    ...                and IDNr reference.
    [Tags]             smoke    datenschutz
    Open Datenschutz Dialog
    Validate Datenschutz Page
    Close Datenschutz Dialog


TC013 - Navigate To Barrierefreiheit And Validate
    [Documentation]    Opens the Barrierefreiheit dialog via the footer and
    ...                checks: dialog visibility, page title change, H1, two H2
    ...                headings, three H3 headings, BITV reference, contact
    ...                email presence, and all external link href values.
    [Tags]             smoke    barrierefreiheit
    Open Barrierefreiheit Dialog
    Validate Barrierefreiheit Page
    Validate External URLs For Barrierefreiheit Dialog
    Close Barrierefreiheit Dialog


TC014 - Full SPA User Journey
    [Documentation]    End-to-end smoke run that simulates a real user journey
    ...                through all SPA views in sequence.  Each dialog is opened,
    ...                spot-checked, and closed before the next one is opened –
    ...                mimicking natural navigation behaviour.
    ...                Step 8 expands all four Landing Page FAQ cards in sequence.
    [Tags]             smoke    e2e    journey

    # ── 1. Assert the landing page is healthy ─────────────────────────────────
    Validate Landing Page

    # ── 2. Open Leichte Sprache, spot-check, close ────────────────────────────────────────
    Open Leichte Sprache Dialog
    Verify Leichte Sprache Dialog Is Open
    Verify Leichte Sprache H1 Heading
    Close Leichte Sprache Dialog
    Verify Landing Page Is Loaded

    # ── 3. Open Gebärdensprache, spot-check, close ────────────────────────────────────────
    Open Gebaerdensprache Dialog
    Verify Gebaerdensprache Dialog Is Open
    Verify Gebaerdensprache H1 Heading
    Verify Gebaerdensprache Video Is Present
    Close Gebaerdensprache Dialog
    # Confirm we are back on the landing page
    Verify Landing Page Is Loaded

    # ── 4. Open FAQ, spot-check, close ────────────────────────────────────────
    Open FAQ Dialog
    Verify FAQ Dialog Is Open
    Verify FAQ Main Heading
    Verify FAQ How It Works Section
    Verify FAQ Login Section
    Verify FAQ Card Items
    Close FAQ Dialog

    # ── 5. Expand each Landing Page FAQ card, spot-check, close ───────────────
    Click On Card - Was Ist Das Datenschutzcockpit
    Element Is Visible    ${LP_FAQ_CARD_WHAT_IS_OPEN}
    Close Currently Open Dialog

    Click On Card - Was Sehe Ich Im Datenschutzcockpit
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE_OPEN}
    Close Currently Open Dialog

    Click On Card - Wer Betreibt Das Datenschutzcockpit
    Element Is Visible    ${LP_FAQ_CARD_WHO_OPS_OPEN}
    Close Currently Open Dialog

    Click On Card - Weitere Informationen
    Element Is Visible    ${LP_FAQ_CARD_MORE_INFO_OPEN}
    Close Currently Open Dialog


    # ── 6. Open Impressum, spot-check, close ──────────────────────────────────
    Open Impressum Dialog
    Verify Impressum Dialog Is Open
    Verify Impressum H1 Heading
    Verify Impressum Publisher Section
    Verify Impressum Key Organizations
    Close Impressum Dialog

    # ── 7. Open Datenschutz, spot-check, close ────────────────────────────────
    Open Datenschutz Dialog
    Verify Datenschutz Dialog Is Open
    Verify Datenschutz H1 Heading
    Verify Datenschutz Section 2
    Verify Datenschutz DSGVO Reference
    Close Datenschutz Dialog

    # ── 8. Open Barrierefreiheit, spot-check, close ───────────────────────────
    Open Barrierefreiheit Dialog
    Verify Barrierefreiheit Dialog Is Open
    Verify Barrierefreiheit H1 Heading
    Verify Barrierefreiheit Compatibility Section
    Verify Barrierefreiheit Feedback Section
    Close Barrierefreiheit Dialog

    # Confirm the landing page is still intact after all card interactions
    Verify Landing Page Is Loaded



