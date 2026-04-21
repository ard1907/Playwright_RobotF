# ==============================================================================
# barrierefreiheit_page.robot  –  Page Object for the Barrierefreiheit Dialog
#
# Triggered by : "Barrierefreiheit" button in the site footer
# Page title   : Datenschutzcockpit - Barrierefreiheit
# Behaviour    : Opens as a modal dialog overlay – URL does not change.
#
# The dialog contains the accessibility statement (Erklärung zur Barrierefreiheit)
# covering BITV compliance, non-accessible content, feedback contacts, and
# the mediation (Schlichtung) process.
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot


*** Variables ***

# ── Dialog Barrierefreiheit Headings ────────────────────────────────────────────────────────────
${BF_H1_HEADING}                       role=heading[name="Erklärung zur Barrierefreiheit"]
${BF_H2_COMPAT}                        role=heading[name="Vereinbarkeit mit den Anforderungen"]
${BF_H2_NOT_BARRIER}                   role=heading[name="Nicht barrierefreie Inhalte"]
${BF_H3_CREATION}                      role=heading[name="Erstellung dieser Erklärung zur Barrierefreiheit"]
${BF_H3_FEEDBACK}                      role=heading[name="Feedback und Kontaktangaben"]
${BF_H3_MEDIATION}                     role=heading[name="Schlichtungsverfahren"]


# ── Dialog Barrierefreiheit - Selectors - Key Content References ───────────────────────────────────
${BF_CONTACT_EMAIL_DSC_01}             (//*[contains(text(), "datenschutzcockpit@finanzen.bremen.de")])[6]
# BITV conformance statement (paragraph text)
${BF_BITV_TEXT}                        //p[contains(text(), "nicht mit der BITV vereinbar")]


# ── Dialog Barrierefreiheit - External Links ──────────────────────────────────────
&{BF_EXTERNAL_URLS}                    BGG_Phone=tel:030185272805
...                                    BGG_Email=mailto:info@schlichtungsstelle-bgg.de
...                                    BGG_Website=https://www.schlichtungsstelle-bgg.de
...                                    DSC_Email=mailto:datenschutzcockpit@finanzen.bremen.de

${BF_BGG_PHONE}                        role=link[name="030 18 527 2805"]
${BF_BGG_EMAIL}                        role=link[name="info@schlichtungsstelle-bgg.de"]
${BF_BGG_WEBSITE}                      role=link[name="www.schlichtungsstelle-bgg.de"]
${BF_DSC_EMAIL}                        role=link[name="datenschutzcockpit@finanzen.bremen.de"]

# ── Close Button ──────────────────────────────────────────────────────────────
${BF_CLOSE_BTN}              role=button[name="Menü schließen"]


*** Keywords ***

# ── Individual Assertions ──────────────────────────────────────────────────────

Verify Barrierefreiheit Dialog Is Open
    [Documentation]    Confirms the Barrierefreiheit dialog is active and the page
    ...                title has updated to "Barrierefreiheit".
    Verify Page Title Contains    ${TITLE_BARRIEREFREIHEIT}
    Element Is Visible    role=dialog

Verify Barrierefreiheit H1 Heading
    [Documentation]    Checks the "Erklärung zur Barrierefreiheit" H1 heading.
    Element Is Visible    ${BF_H1_HEADING}

Verify Barrierefreiheit Compatibility Section
    [Documentation]    Checks the "Vereinbarkeit mit den Anforderungen" H2 section
    ...                heading describing BITV compliance status.
    Element Is Visible    ${BF_H2_COMPAT}

Verify Barrierefreiheit Non-Accessible Section
    [Documentation]    Checks the "Nicht barrierefreie Inhalte" H2 section heading
    ...                listing known barriers.
    Element Is Visible    ${BF_H2_NOT_BARRIER}

Verify Barrierefreiheit Creation Section
    [Documentation]    Checks the H3 heading about when this statement was created.
    Element Is Visible    ${BF_H3_CREATION}

Verify Barrierefreiheit Feedback Section
    [Documentation]    Checks the "Feedback und Kontaktangaben" H3 section heading
    ...                with the contact email for reporting barriers.
    Element Is Visible    ${BF_H3_FEEDBACK}

Verify Barrierefreiheit Mediation Section
    [Documentation]    Checks the "Schlichtungsverfahren" (mediation) H3 section
    ...                heading about escalation for accessibility complaints.
    Element Is Visible    ${BF_H3_MEDIATION}

# Verify Barrierefreiheit BITV Referenced
#     [Documentation]    Confirms the BITV/WCAG standard is explicitly named in
#     ...                the dialog text.
#     Element Is Visible    ${BF_BITV_TEXT}

Verify Barrierefreiheit Contact Email
    [Documentation]    Checks that the feedback contact email address is shown.
    Element Is Visible    ${BF_CONTACT_EMAIL_DSC_01}

Verify Barrierefreiheit BITV Referenced
    [Documentation]    Confirms the BITV standard is explicitly referenced in
    ...                the compatibility statement paragraph of the dialog.
    Element Is Visible    ${BF_BITV_TEXT}

Verify Barrierefreiheit Close Button Is Present
    [Documentation]    Confirms the universal dialog close button is accessible.
    Element Is Visible    ${BF_CLOSE_BTN}


# ── Dialog Lifecycle ───────────────────────────────────────────────────────────

Close Barrierefreiheit Dialog
    [Documentation]    Closes the Barrierefreiheit dialog and waits for it to
    ...                disappear from the DOM.
    Close Currently Open Dialog


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Barrierefreiheit Page
    [Documentation]    Master keyword – runs all Barrierefreiheit dialog assertions.
    Verify Barrierefreiheit Dialog Is Open
    Verify Barrierefreiheit H1 Heading
    Verify Barrierefreiheit Compatibility Section
    Verify Barrierefreiheit Non-Accessible Section
    Verify Barrierefreiheit Creation Section
    Verify Barrierefreiheit Feedback Section
    Verify Barrierefreiheit Mediation Section
    Verify Barrierefreiheit BITV Referenced
    Verify Barrierefreiheit Contact Email
    Verify Barrierefreiheit Close Button Is Present


# ── External Link Validation ──────────────────────────────────────────────

Validate External URLs For Barrierefreiheit Dialog
    [Documentation]    Validates that all external links in the Barrierefreiheit
    ...                dialog carry the correct href values before clicking.
    ...                Covers: DSC feedback email, BGG phone, BGG email, and
    ...                BGG website link.
    Get Attribute    ${BF_DSC_EMAIL}      href    ==    ${BF_EXTERNAL_URLS}[DSC_Email]
    Get Attribute    ${BF_BGG_PHONE}      href    ==    ${BF_EXTERNAL_URLS}[BGG_Phone]
    Get Attribute    ${BF_BGG_EMAIL}      href    ==    ${BF_EXTERNAL_URLS}[BGG_Email]
    Get Attribute    ${BF_BGG_WEBSITE}    href    ==    ${BF_EXTERNAL_URLS}[BGG_Website]


