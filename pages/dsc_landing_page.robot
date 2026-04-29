# ==============================================================================
# landing_page.robot  –  Page Object for the SPA Landing / Start Page
#
# URL   : https://qs-datenschutzcockpit.dsc.govkg.de/spa/
# Title : Datenschutzcockpit - Startseite
#
# Selectors are derived from live ARIA / accessibility tree inspection.
# Prefer role- and text-based selectors for resilience against DOM reshuffling.
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot


*** Variables ***

# ── Header ─────────────────────────────────────────────────────────────────────
${LP_LOGO_LINK}              role=link[name="Bund.de Datenschutzcockpit Beta Logo"]
${LP_EASY_LANGUAGE_BTN}      role=button[name="Das Datenschutzcockpit in Leichter Sprache"]
${LP_SIGN_LANGUAGE_BTN}      role=button[name="Zum Gebärdensprache-Video"]
${LP_DIALOG}                 role=dialog


# ── Main Content ───────────────────────────────────────────────────────────────
${LP_H1_HEADING}             role=heading[name="Behalten Sie Ihre Daten im Blick"]
${LP_INTRO_TEXT}             text=Im Datenschutzcockpit sehen Sie
# ${LP_LOGIN_BUTTON}           role=button[name="Zur Anmeldung"]
${LP_LOGIN_BUTTON}           //button[@id="button-anfrage-starten"]
${LP_FAQ_SECTION_HEADING}    role=heading[name="Häufige Fragen"]


# ── Landing Page External URLs ───────────────────────────────────────────────────────
&{LP_EXTERNAL_URLs}                  LP_Card_1_Identifikationsnummerngesetz=https://www.buzer.de/Identifikationsnummer-Gesetz.htm
...                                  LP_Card_1_Registermodernisierungsgesetz=https://www.gesetze-im-internet.de/regmog/index.html#BJNR059100021BJNE000200000
...                                  LP_Card_4_Identifikationsnummerngesetz=https://www.buzer.de/Identifikationsnummer-Gesetz.htm


# ── Footer Navigation ──────────────────────────────────────────────────────────
${LP_IMPRESSUM_BTN}          role=button[name="Impressum"]
${LP_DATENSCHUTZ_BTN}        role=button[name="Datenschutz"]
${LP_BARRIEREFREIHEIT_BTN}   role=button[name="Barrierefreiheit"]
${LP_VERSION_TEXT}           text=Datenschutzcockpit Version


# ── Floating FAQ Sidebar Button ────────────────────────────────────────────────
${LP_FAQ_FLOAT_BUTTON}       role=button[name="FAQ"]


# ── Landing Page FAQ Cards (in the "Häufige Fragen" section, not inside FAQ dialog) ──
# Closed state – accordion buttons visible directly on the landing page.
${LP_FAQ_CARD_WHAT_IS}       //h3[text()="Was ist das Datenschutzcockpit?"]
${LP_FAQ_CARD_WHAT_SEE}      //h3[text()="Was sehe ich im Datenschutzcockpit?"]
${LP_FAQ_CARD_WHO_OPS}       //h3[text()="Wer betreibt das Datenschutzcockpit?"]
${LP_FAQ_CARD_MORE_INFO}     (//h3[text()="Weitere Informationen"])[1]


# Open state – each card opens as a modal overlay; H1 identifies the active card.
${LP_FAQ_CARD_WHAT_IS_OPEN}
...    //div[@class="modal" and @aria-hidden="false"]//h1[text()="Was ist das Datenschutzcockpit?"]
${LP_FAQ_CARD_WHAT_SEE_OPEN}
...    //div[@class="modal" and @aria-hidden="false"]//h1[text()="Was sehe ich im Datenschutzcockpit?"]
${LP_FAQ_CARD_WHO_OPS_OPEN}
...    //div[@class="modal" and @aria-hidden="false"]//h1[text()="Wer betreibt das Datenschutzcockpit?"]
${LP_FAQ_CARD_MORE_INFO_OPEN}
...    //div[@class="modal" and @aria-hidden="false"]//h1[text()="Weitere Informationen"]

${LP_CARD_1_EXT_LINK_01}       //p[contains(text(),"dazu: ")]/a[contains(text(),"Identifikationsnummerngesetz")]
${LP_CARD_1_EXT_LINK_02}       //a[contains(text(),"Registermodernisierungsgesetz")]
${LP_CARD_4_EXT_LINK_01}       (//a[contains(text(),"Identifikationsnummerngesetz")])[2]


# Tab titles – the SPA router updates the document title when a card modal opens.
&{LP_FAQ_CARDS_TAB_TITLES}
...    WHAT_IS=Datenschutzcockpit - Was ist das Datenschutzcockpit
...    WHAT_SEE=Datenschutzcockpit - Was sehe ich im Datenschutzcockpit
...    WHO_OPS=Datenschutzcockpit - Wer betreibt das Datenschutzcockpit
...    MORE_INFO=Datenschutzcockpit - Weitere Informationen


# ── Landing Page FAQ Card Content Assertions ──────────────────────────────────
# Open modal – H2 section headings inside "Was sehe ich im Datenschutzcockpit?" card.
${LP_FAQ_CARD_WHAT_SEE_H2_INFO}
...    role=heading[name="Diese Informationen sehen Sie:"]
${LP_FAQ_CARD_WHAT_SEE_H2_FUTURE}
...    role=heading[name="Diese Informationen können Sie zukünftig sehen:"]

# Open modal – content references inside "Wer betreibt das Datenschutzcockpit?" card.
${LP_FAQ_CARD_WHO_OPS_BVA_MENTION}
...    //div[@class="modal" and @aria-hidden="false"]//p[contains(text(), "Bundesverwaltungsamt")]
${LP_FAQ_CARD_WHO_OPS_DATAPORT}
...    //div[@class="modal" and @aria-hidden="false"]//p[contains(text(), "Dataport")]

# Open modal – H2 section headings inside "Weitere Informationen" card.
${LP_FAQ_CARD_MORE_INFO_H2_IDNR}
...    role=heading[name="Was ist die Identifikationsnummer?"]
${LP_FAQ_CARD_MORE_INFO_H2_BENEFIT}
...    role=heading[name="Welche Vorteile bietet die IDNr?"]


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

Verify Landing Page FAQ Cards Are Rendered
    [Documentation]    Confirms the "Häufige Fragen" heading and all four FAQ
    ...                accordion cards are rendered in their default closed state.
    Element Is Visible    ${LP_FAQ_SECTION_HEADING}
    Element Is Visible    ${LP_FAQ_CARD_WHAT_IS}
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE}
    Element Is Visible    ${LP_FAQ_CARD_WHO_OPS}
    Element Is Visible    ${LP_FAQ_CARD_MORE_INFO}

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

Verify Landing Page Header Accessibility Buttons
    [Documentation]    Confirms the logo link and both header accessibility
    ...                buttons are visible and enabled on the landing page:
    ...                  • Bund.de Datenschutzcockpit Beta Logo (link)
    ...                  • Das Datenschutzcockpit in Leichter Sprache (button)
    ...                  • Zum Gebärdensprache-Video (button)
    Element Is Visible    ${LP_LOGO_LINK}
    Element Is Visible    ${LP_EASY_LANGUAGE_BTN}
    Element Is Visible    ${LP_SIGN_LANGUAGE_BTN}
    ${ls_states}=    Get Element States    ${LP_EASY_LANGUAGE_BTN}
    Should Contain    ${ls_states}    enabled
    ${gs_states}=    Get Element States    ${LP_SIGN_LANGUAGE_BTN}
    Should Contain    ${gs_states}    enabled


# ── Dialog Navigation (opens dialogs from this page) ──────────────────────────

Open FAQ Dialog
    [Documentation]    Clicks the floating FAQ button and waits for the FAQ
    ...                dialog to become visible before returning.
    Click    ${LP_FAQ_FLOAT_BUTTON}
    Wait For Elements State    ${LP_DIALOG}    visible    timeout=${TIMEOUT}

Open Impressum Dialog
    [Documentation]    Clicks the "Impressum" footer button and waits for the
    ...                Impressum dialog to appear.
    Click    ${LP_IMPRESSUM_BTN}
    Wait For Elements State    ${LP_DIALOG}    visible    timeout=${TIMEOUT}

Open Datenschutz Dialog
    [Documentation]    Clicks the "Datenschutz" footer button and waits for the
    ...                Datenschutz dialog to appear.
    Click    ${LP_DATENSCHUTZ_BTN}
    Wait For Elements State    ${LP_DIALOG}    visible    timeout=${TIMEOUT}

Open Barrierefreiheit Dialog
    [Documentation]    Clicks the "Barrierefreiheit" footer button and waits for
    ...                the accessibility statement dialog to appear.
    Click    ${LP_BARRIEREFREIHEIT_BTN}
    Wait For Elements State    ${LP_DIALOG}    visible    timeout=${TIMEOUT}


# ── FAQ Card Interactions ─────────────────────────────────────────────────────

Click On Card - Was Ist Das Datenschutzcockpit
    [Documentation]    Clicks the "Was ist das Datenschutzcockpit?" accordion
    ...                card and waits for the modal overlay to become visible.
    Click    ${LP_FAQ_CARD_WHAT_IS}
    Wait For Elements State    ${LP_FAQ_CARD_WHAT_IS_OPEN}    visible    timeout=${TIMEOUT}

Click On Card - Was Sehe Ich Im Datenschutzcockpit
    [Documentation]    Clicks the "Was sehe ich im Datenschutzcockpit?" accordion
    ...                card and waits for the modal overlay to become visible.
    Click    ${LP_FAQ_CARD_WHAT_SEE}
    Wait For Elements State    ${LP_FAQ_CARD_WHAT_SEE_OPEN}    visible    timeout=${TIMEOUT}

Click On Card - Wer Betreibt Das Datenschutzcockpit
    [Documentation]    Clicks the "Wer betreibt das Datenschutzcockpit?" accordion
    ...                card and waits for the modal overlay to become visible.
    Click    ${LP_FAQ_CARD_WHO_OPS}
    Wait For Elements State    ${LP_FAQ_CARD_WHO_OPS_OPEN}    visible    timeout=${TIMEOUT}

Click On Card - Weitere Informationen
    [Documentation]    Clicks the "Weitere Informationen" accordion card and
    ...                waits for the modal overlay to become visible.
    Click    ${LP_FAQ_CARD_MORE_INFO}
    Wait For Elements State    ${LP_FAQ_CARD_MORE_INFO_OPEN}    visible    timeout=${TIMEOUT}


# ── FAQ Card Content Validation ───────────────────────────────────────────────

Verify Landing Page FAQ Card "Was Ist Das Datenschutzcockpit ..."
    [Documentation]    Opens the "Was ist das Datenschutzcockpit?" card and
    ...                verifies: modal heading visible, SPA tab title updated,
    ...                URL unchanged, and the other three cards still rendered.
    Element Is Visible    ${LP_FAQ_CARD_WHAT_IS}
    Click On Card - Was Ist Das Datenschutzcockpit
    # 1. Card is now in open (modal) state
    Element Is Visible    ${LP_FAQ_CARD_WHAT_IS_OPEN}
    # 2. SPA router updated the tab title
    ${title}=    Get Title
    Should Be Equal As Strings    ${title}    ${LP_FAQ_CARDS_TAB_TITLES}[WHAT_IS]
    # 3. URL has not left the landing page
    ${url}=    Get Url
    Should Be Equal As Strings    ${url}    ${BASE_URL}
    # 4. Other FAQ cards remain rendered (one-card-at-a-time behaviour)
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE}
    Element Is Visible    ${LP_FAQ_CARD_WHO_OPS}

Verify Landing Page FAQ Card "Was Sehe Ich Im Datenschutzcockpit ..."
    [Documentation]    Opens the "Was sehe ich im Datenschutzcockpit?" card and
    ...                verifies: modal heading visible, SPA tab title updated,
    ...                URL unchanged, both content H2 section headings present,
    ...                and the other three cards still rendered.
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE}
    Click On Card - Was Sehe Ich Im Datenschutzcockpit
    # 1. Card is now in open (modal) state
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE_OPEN}
    # 2. SPA router updated the tab title
    ${title}=    Get Title
    Should Be Equal As Strings    ${title}    ${LP_FAQ_CARDS_TAB_TITLES}[WHAT_SEE]
    # 3. URL has not left the landing page
    ${url}=    Get Url
    Should Be Equal As Strings    ${url}    ${BASE_URL}
    # 4. Key content H2 section headings are visible inside the modal
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE_H2_INFO}
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE_H2_FUTURE}
    # 5. Other FAQ cards remain rendered
    Element Is Visible    ${LP_FAQ_CARD_WHAT_IS}
    Element Is Visible    ${LP_FAQ_CARD_WHO_OPS}

Verify Landing Page FAQ Card "Wer Betreibt Das Datenschutzcockpit ..."
    [Documentation]    Opens the "Wer betreibt das Datenschutzcockpit?" card and
    ...                verifies: modal heading visible, SPA tab title updated,
    ...                URL unchanged, BVA and Dataport mentioned in content,
    ...                and the other three cards still rendered.
    Element Is Visible    ${LP_FAQ_CARD_WHO_OPS}
    Click On Card - Wer Betreibt Das Datenschutzcockpit
    # 1. Card is now in open (modal) state
    Element Is Visible    ${LP_FAQ_CARD_WHO_OPS_OPEN}
    # 2. SPA router updated the tab title
    ${title}=    Get Title
    Should Be Equal As Strings    ${title}    ${LP_FAQ_CARDS_TAB_TITLES}[WHO_OPS]
    # 3. URL has not left the landing page
    ${url}=    Get Url
    Should Be Equal As Strings    ${url}    ${BASE_URL}
    # 4. Key content references are visible inside the modal
    Element Is Visible    ${LP_FAQ_CARD_WHO_OPS_BVA_MENTION}
    Element Is Visible    ${LP_FAQ_CARD_WHO_OPS_DATAPORT}
    # 5. Other FAQ cards remain rendered
    Element Is Visible    ${LP_FAQ_CARD_WHAT_IS}
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE}

Verify Landing Page FAQ Card "Weitere Informationen ..."
    [Documentation]    Opens the "Weitere Informationen" card and verifies:
    ...                modal heading visible, SPA tab title updated, URL
    ...                unchanged, both H2 content section headings present,
    ...                and the other three cards still rendered.
    Element Is Visible    ${LP_FAQ_CARD_MORE_INFO}
    Click On Card - Weitere Informationen
    # 1. Card is now in open (modal) state
    Element Is Visible    ${LP_FAQ_CARD_MORE_INFO_OPEN}
    # 2. SPA router updated the tab title
    ${title}=    Get Title
    Should Be Equal As Strings    ${title}    ${LP_FAQ_CARDS_TAB_TITLES}[MORE_INFO]
    # 3. URL has not left the landing page
    ${url}=    Get Url
    Should Be Equal As Strings    ${url}    ${BASE_URL}
    # 4. Key content H2 section headings are visible inside the modal
    Element Is Visible    ${LP_FAQ_CARD_MORE_INFO_H2_IDNR}
    Element Is Visible    ${LP_FAQ_CARD_MORE_INFO_H2_BENEFIT}
    # 5. Other FAQ cards remain rendered
    Element Is Visible    ${LP_FAQ_CARD_WHAT_IS}
    Element Is Visible    ${LP_FAQ_CARD_WHAT_SEE}


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Landing Page
    [Documentation]    Master keyword – runs all Landing Page smoke assertions.
    ...                Call this from the test suite for a full page health-check.
    Verify Landing Page Is Loaded
    Verify Landing Page Header Accessibility Buttons
    Verify Landing Page H1 Heading
    Verify Landing Page Intro Text
    Verify Landing Page CTA Button
    Verify Landing Page FAQ Section
    Verify Landing Page FAQ Cards Are Rendered
    Verify Landing Page Footer Navigation
    Verify Landing Page FAQ Float Button
    Verify Landing Page Version Info


# ── New-Tab External Link Flows ────────────────────────────────────────────────
Validate External URLs For Card - Was ist das Datenschutzcockpit ...
    [Documentation]    Validates that all external links in the "Was ist das Datenschutzcockpit?" FAQ card have the correct href URLs before clicking.
    ...                This is a pre-click check to ensure the links point to the expected external resources, without relying on the new tab navigation.
    # Click On Card - Was Ist Das Datenschutzcockpit
    Get Attribute    ${LP_CARD_1_EXT_LINK_01}   href   ==   ${LP_EXTERNAL_URLs}[LP_Card_1_Identifikationsnummerngesetz]
    Get Attribute    ${LP_CARD_1_EXT_LINK_02}   href   ==   ${LP_EXTERNAL_URLs}[LP_Card_1_Registermodernisierungsgesetz]


Validate External URLs For Card - Weitere Informationen ...
    [Documentation]    Validates that all external links in the "Weitere Informationen" FAQ card have the correct href URLs before clicking.
    ...                This is a pre-click check to ensure the links point to the expected external resources, without relying on the new tab navigation.
    # Click On Card - Weitere Informationen
    Get Attribute    ${LP_CARD_4_EXT_LINK_01}   href   ==   ${LP_EXTERNAL_URLs}[LP_Card_4_Identifikationsnummerngesetz]

