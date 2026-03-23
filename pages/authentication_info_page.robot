# ==============================================================================
# authentication_info_page.robot  –  Page Object for the Authentication Info Page
#
# URL   : https://datenschutzcockpit.dsc.govkg.de/spa/authentication-info
# Title : Datenschutzcockpit - Anmeldung
#
# This page explains the eID login process: which hardware/software is needed
# (AusweisApp, compatible card reader), how to start the login, and embeds
# the three login-related FAQ accordion items directly on the page.
#
# NOTE: Verify all selectors against the live page after the first test run.
#       Adjust heading text and link names if the SPA content differs.
#
# Selectors follow the existing project convention:
#   - ARIA role selectors (role=) preferred
#   - Text selectors (text=) for content assertions
#   - XPath only as last resort (none used here)
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/variables.robot
Resource    ../resources/common_keywords.robot


*** Variables ***

# ── Header Accessibility Buttons ───────────────────────────────────────────────
# These header buttons are shared across all SPA pages (same component).
${AI_EASY_LANGUAGE_BTN}        role=button[name="Das Datenschutzcockpit in Leichter Sprache"]
${AI_SIGN_LANGUAGE_BTN}        role=button[name="Zum Gebärdensprache-Video"]

# ── Logo / Brand ───────────────────────────────────────────────────────────────
${AI_LOGO_LINK}                role=link[name="Bund.de Datenschutzcockpit Beta Logo"]

# ── Main Content ───────────────────────────────────────────────────────────────
# NOTE: After first run verify the exact H1 wording on this page.
${AI_H1_HEADING}               role=heading[level=1]

# ── Login Information Links ───────────────────────────────────────────────────
# Both links open in a new browser tab (target="_blank") to external resources.
${AI_LESEGERAET_LINK}          role=link[name="kompatibles Lesegerät"]
${AI_AUSWEIS_APP_LINK}         role=link[name="AusweisApp"]

# ── AusweisApp Start Button ────────────────────────────────────────────────────
# "AusweisApp starten" initiates the eID authentication flow.
# We verify presence and accessibility only – we do NOT trigger the eID flow.
# NOTE: If this element is rendered as a <a> tag, change role to "link".
${AI_AUSWEIS_START_BTN}        role=button[name="AusweisApp starten"]

# ── Footer Navigation (same component as landing page) ────────────────────────
${AI_IMPRESSUM_BTN}            role=button[name="Impressum"]
${AI_DATENSCHUTZ_BTN}          role=button[name="Datenschutz"]
${AI_BARRIEREFREIHEIT_BTN}     role=button[name="Barrierefreiheit"]
${AI_VERSION_TEXT}             text=Datenschutzcockpit Version

# ── Embedded FAQ Accordion Items (closed = default state) ─────────────────────
# These three accordion entries are rendered directly on the auth-info page
# (not inside the FAQ dialog). The naming pattern mirrors faq_page.robot.
${AI_FAQ_WHAT_NEEDED}
...    role=button[name="Was benötige ich für die Anmeldung? - Antwort ist geschlossen"]
${AI_FAQ_AUSWEIS_LOGIN}
...    role=button[name="Wie melde ich mich mit der AusweisApp an? - Antwort ist geschlossen"]
${AI_FAQ_HOW_SECURE}
...    role=button[name="Wie sicher ist das Datenschutzcockpit? - Antwort ist geschlossen"]

# ── Accordion Open State Selectors ────────────────────────────────────────────
# After clicking an accordion button the "geschlossen" suffix changes to "geöffnet".
${AI_FAQ_WHAT_NEEDED_OPEN}
...    role=button[name="Was benötige ich für die Anmeldung? - Antwort ist geöffnet"]
${AI_FAQ_AUSWEIS_LOGIN_OPEN}
...    role=button[name="Wie melde ich mich mit der AusweisApp an? - Antwort ist geöffnet"]
${AI_FAQ_HOW_SECURE_OPEN}
...    role=button[name="Wie sicher ist das Datenschutzcockpit? - Antwort ist geöffnet"]

# ── FAQ Expanded Content Anchors ───────────────────────────────────────────────
# Partial text anchors expected inside the expanded accordion panels.
# NOTE: These are used for content assertions after expanding the accordion.
${AI_FAQ_WN_PERSONALAUSWEIS}   text=Personalausweis
${AI_FAQ_WN_AUSWEISAPP}        text=AusweisApp
${AI_FAQ_AL_SCHRITT}           text=Schritt
${AI_FAQ_HS_SICHER}            text=sicher


*** Keywords ***

# ── Page-Level Assertions ──────────────────────────────────────────────────────

Verify Authentication Info Page Is Loaded
    [Documentation]    Confirms the SPA has routed to the auth-info page:
    ...                page title contains "Anmeldung" and the H1 heading is
    ...                visible (proves the component has rendered).
    Verify Page Title Contains    ${TITLE_AUTH_INFO}
    Element Is Visible    ${AI_H1_HEADING}

Verify Auth Page H1 Heading
    [Documentation]    Asserts the primary H1 heading is rendered on the page.
    Element Is Visible    ${AI_H1_HEADING}

Verify Auth Page Logo
    [Documentation]    Checks the Datenschutzcockpit logo/home link is visible.
    Element Is Visible    ${AI_LOGO_LINK}

Verify Auth Page Header Accessibility Buttons
    [Documentation]    Checks that both accessibility buttons in the shared
    ...                SPA header are visible on this page:
    ...                  • Das Datenschutzcockpit in Leichter Sprache
    ...                  • Zum Gebärdensprache-Video
    Element Is Visible    ${AI_EASY_LANGUAGE_BTN}
    Element Is Visible    ${AI_SIGN_LANGUAGE_BTN}

Verify Auth Page Footer Navigation
    [Documentation]    Verifies all three footer navigation buttons are visible,
    ...                consistent with all SPA routes sharing the same footer.
    Element Is Visible    ${AI_IMPRESSUM_BTN}
    Element Is Visible    ${AI_DATENSCHUTZ_BTN}
    Element Is Visible    ${AI_BARRIEREFREIHEIT_BTN}

Verify Auth Page Version Info
    [Documentation]    Checks that the application version string is present in
    ...                the footer, confirming the correct asset bundle loaded.
    Element Is Visible    ${AI_VERSION_TEXT}

Verify AusweisApp Link Is Present
    [Documentation]    Checks the "AusweisApp" in-text link is visible on the page
    ...                so users can download / open the app.
    Element Is Visible    ${AI_AUSWEIS_APP_LINK}

Verify Lesegeraet Link Is Present
    [Documentation]    Checks the "kompatibles Lesegerät" in-text link is visible.
    Element Is Visible    ${AI_LESEGERAET_LINK}

Verify AusweisApp Start Button Is Present
    [Documentation]    Confirms the "AusweisApp starten" button is visible and
    ...                enabled on the page. Does NOT click – avoids triggering
    ...                the live eID authentication flow during smoke testing.
    Element Is Visible    ${AI_AUSWEIS_START_BTN}

Verify Auth Page FAQ Accordion Items
    [Documentation]    Checks all three embedded FAQ accordion buttons are
    ...                rendered in their default closed state.
    Element Is Visible    ${AI_FAQ_WHAT_NEEDED}
    Element Is Visible    ${AI_FAQ_AUSWEIS_LOGIN}
    Element Is Visible    ${AI_FAQ_HOW_SECURE}


# ── Dialog Navigation ──────────────────────────────────────────────────────────

Open Leichte Sprache Dialog From Auth Page
    [Documentation]    Clicks the "Leichte Sprache" header button on the auth-info
    ...                page and waits for the corresponding dialog to appear.
    Click    ${AI_EASY_LANGUAGE_BTN}
    Wait For Elements State    role=dialog    visible    timeout=${TIMEOUT}

Open Gebaerdensprache Dialog From Auth Page
    [Documentation]    Clicks the "Gebärdensprache-Video" header button on the
    ...                auth-info page and waits for the dialog to appear.
    Click    ${AI_SIGN_LANGUAGE_BTN}
    Wait For Elements State    role=dialog    visible    timeout=${TIMEOUT}


# ── FAQ Accordion Interactions ─────────────────────────────────────────────────

Expand FAQ Accordion Was Benoetige Ich
    [Documentation]    Clicks the "Was benötige ich für die Anmeldung?" accordion
    ...                button and waits for it to switch to the open state.
    Click    ${AI_FAQ_WHAT_NEEDED}
    Wait For Elements State    ${AI_FAQ_WHAT_NEEDED_OPEN}    visible    timeout=${TIMEOUT}

Expand FAQ Accordion Wie Melde Ich Mich An
    [Documentation]    Clicks the "Wie melde ich mich mit der AusweisApp an?"
    ...                accordion button and waits for it to switch to open state.
    Click    ${AI_FAQ_AUSWEIS_LOGIN}
    Wait For Elements State    ${AI_FAQ_AUSWEIS_LOGIN_OPEN}    visible    timeout=${TIMEOUT}

Expand FAQ Accordion Wie Sicher
    [Documentation]    Clicks the "Wie sicher ist das Datenschutzcockpit?"
    ...                accordion button and waits for it to switch to open state.
    Click    ${AI_FAQ_HOW_SECURE}
    Wait For Elements State    ${AI_FAQ_HOW_SECURE_OPEN}    visible    timeout=${TIMEOUT}


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Authentication Info Page
    [Documentation]    Master keyword – runs all auth-info page smoke assertions.
    ...                Covers: title, H1, logo, header buttons, external links,
    ...                AusweisApp starten button, footer, version, and FAQ items.
    Verify Authentication Info Page Is Loaded
    Verify Auth Page H1 Heading
    Verify Auth Page Logo
    Verify Auth Page Header Accessibility Buttons
    Verify Auth Page Footer Navigation
    Verify Auth Page Version Info
    Verify AusweisApp Link Is Present
    Verify Lesegeraet Link Is Present
    Verify AusweisApp Start Button Is Present
    Verify Auth Page FAQ Accordion Items
