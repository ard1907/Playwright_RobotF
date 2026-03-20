# ==============================================================================
# landing_page.robot  –  Page Object for the SPA Landing / Start Page
#
# URL   : https://datenschutzcockpit.dsc.govkg.de/spa/
# Title : Datenschutzcockpit - Startseite
#
# Selectors are derived from live ARIA / accessibility tree inspection.
# Prefer role- and text-based selectors for resilience against DOM reshuffling.
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/variables.robot
Resource    ../resources/common_keywords.robot


*** Variables ***

# ── Header ─────────────────────────────────────────────────────────────────────
${LP_LOGO_LINK}              role=link[name="Bund.de Datenschutzcockpit Beta Logo"]
${LP_EASY_LANGUAGE_BTN}      role=button[name="Das Datenschutzcockpit in Leichter Sprache"]
${LP_SIGN_LANGUAGE_BTN}      role=button[name="Zum Gebärdensprache-Video"]

# ── Main Content ───────────────────────────────────────────────────────────────
${LP_H1_HEADING}             role=heading[name="Behalten Sie Ihre Daten im Blick"]
${LP_INTRO_TEXT}             text=Im Datenschutzcockpit sehen Sie
${LP_LOGIN_BUTTON}           role=button[name="Zur Anmeldung"]
${LP_FAQ_SECTION_HEADING}    role=heading[name="Häufige Fragen"]

# ── Footer Navigation ──────────────────────────────────────────────────────────
${LP_IMPRESSUM_BTN}          role=button[name="Impressum"]
${LP_DATENSCHUTZ_BTN}        role=button[name="Datenschutz"]
${LP_BARRIEREFREIHEIT_BTN}   role=button[name="Barrierefreiheit"]
${LP_VERSION_TEXT}           text=Datenschutzcockpit Version

# ── Floating FAQ Sidebar Button ────────────────────────────────────────────────
${LP_FAQ_FLOAT_BUTTON}       role=button[name="FAQ"]


*** Keywords ***

# ── Individual Assertions ──────────────────────────────────────────────────────

Verify Landing Page Is Loaded
    [Documentation]    Checks the page title contains "Startseite" and that the
    ...                main H1 heading is visible – confirms SPA route is active.
    Verify Page Title Contains    ${TITLE_LANDING}
    Element Is Visible    ${LP_H1_HEADING}

Verify Landing Page H1 Heading
    [Documentation]    Asserts the primary "Behalten Sie Ihre Daten im Blick"
    ...                heading is rendered on the page.
    Element Is Visible    ${LP_H1_HEADING}

Verify Landing Page Intro Text
    [Documentation]    Checks the introductory paragraph is visible. Uses a
    ...                partial text match to avoid coupling to the full sentence.
    Element Is Visible    ${LP_INTRO_TEXT}

Verify Landing Page CTA Button
    [Documentation]    Checks the "Zur Anmeldung" call-to-action button exists
    ...                and is interactive.
    Element Is Visible    ${LP_LOGIN_BUTTON}

Verify Landing Page FAQ Section
    [Documentation]    Checks the "Häufige Fragen" (Frequently Asked Questions)
    ...                section heading is present on the landing page.
    Element Is Visible    ${LP_FAQ_SECTION_HEADING}

Verify Landing Page Footer Navigation
    [Documentation]    Verifies all three footer navigation buttons are visible:
    ...                Impressum, Datenschutz, and Barrierefreiheit.
    Element Is Visible    ${LP_IMPRESSUM_BTN}
    Element Is Visible    ${LP_DATENSCHUTZ_BTN}
    Element Is Visible    ${LP_BARRIEREFREIHEIT_BTN}

Verify Landing Page FAQ Float Button
    [Documentation]    Checks that the floating FAQ sidebar button is reachable
    ...                (keyboard/mouse accessible).
    Element Is Visible    ${LP_FAQ_FLOAT_BUTTON}

Verify Landing Page Version Info
    [Documentation]    Checks that the application version string is present in
    ...                the footer. Matches partially to avoid version coupling.
    Element Is Visible    ${LP_VERSION_TEXT}


# ── Dialog Navigation (opens dialogs from this page) ──────────────────────────

Open FAQ Dialog
    [Documentation]    Clicks the floating FAQ button and waits for the FAQ
    ...                dialog to become visible before returning.
    Click    ${LP_FAQ_FLOAT_BUTTON}
    Wait For Elements State    role=dialog    visible    timeout=${TIMEOUT}

Open Impressum Dialog
    [Documentation]    Clicks the "Impressum" footer button and waits for the
    ...                Impressum dialog to appear.
    Click    ${LP_IMPRESSUM_BTN}
    Wait For Elements State    role=dialog    visible    timeout=${TIMEOUT}

Open Datenschutz Dialog
    [Documentation]    Clicks the "Datenschutz" footer button and waits for the
    ...                Datenschutz dialog to appear.
    Click    ${LP_DATENSCHUTZ_BTN}
    Wait For Elements State    role=dialog    visible    timeout=${TIMEOUT}

Open Barrierefreiheit Dialog
    [Documentation]    Clicks the "Barrierefreiheit" footer button and waits for
    ...                the accessibility statement dialog to appear.
    Click    ${LP_BARRIEREFREIHEIT_BTN}
    Wait For Elements State    role=dialog    visible    timeout=${TIMEOUT}


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Landing Page
    [Documentation]    Master keyword – runs all Landing Page smoke assertions.
    ...                Call this from the test suite for a full page health-check.
    Verify Landing Page Is Loaded
    Verify Landing Page H1 Heading
    Verify Landing Page Intro Text
    Verify Landing Page CTA Button
    Verify Landing Page FAQ Section
    Verify Landing Page Footer Navigation
    Verify Landing Page FAQ Float Button
    Verify Landing Page Version Info
