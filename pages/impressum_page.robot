# ==============================================================================
# impressum_page.robot  –  Page Object for the Impressum Dialog
#
# Triggered by : "Impressum" button in the site footer (role=contentinfo)
# Page title   : Datenschutzcockpit - Impressum
# Behaviour    : Opens as a modal dialog overlay – URL does not change.
#
# Key facts verified:
#   - Publisher / Operator : Bundesverwaltungsamt (BVA)
#   - Content owner        : Senator für Finanzen, Freie Hansestadt Bremen
#   - Realisation          : Governikus GmbH & Co. KG
#   - Hosting              : Dataport AöR
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/variables.robot
Resource    ../resources/common_keywords.robot


*** Variables ***

# ── Dialog Headings ────────────────────────────────────────────────────────────
${IMP_H1_HEADING}        role=heading[name="Impressum"]
${IMP_H2_PUBLISHER}      role=heading[name="Herausgeber und verantwortliche Stelle für den Betrieb:"]
${IMP_H2_RESPONSIBLE}    role=heading[name="Verantwortlich für den Inhalt:"]
${IMP_H2_REALIZATION}    role=heading[name="Realisierung und technischer Betrieb:"]
${IMP_H2_HOSTING}        role=heading[name="Hosting / technischer Betreiber:"]

# ── Key Organisation Names (text selector – robust partial match) ──────────────
${IMP_BVA_TEXT}          (//p[text()="Bundesverwaltungsamt"])[1]    # text=Bundesverwaltungsamt
${IMP_GOVERNIKUS_TEXT}   text=Governikus GmbH & Co. KG
${IMP_DATAPORT_TEXT}     text=Dataport AöR
# ${IMP_CLOSE_BUTTON}      role=button[name="Menü schließen"]
${IMP_CLOSE_BUTTON}      (//button[@data-testid="closeModalBtn"])[11]


*** Keywords ***

# ── Individual Assertions ──────────────────────────────────────────────────────

Verify Impressum Dialog Is Open
    [Documentation]    Confirms the Impressum dialog is active and the page title
    ...                has updated to "Impressum".
    Verify Page Title Contains    ${TITLE_IMPRESSUM}
    Element Is Visible    role=dialog

Verify Impressum H1 Heading
    [Documentation]    Checks the "Impressum" H1 heading inside the dialog.
    ...                Note: selector uses role=heading to avoid matching the
    ...                footer button that also bears that label.
    Element Is Visible    ${IMP_H1_HEADING}

Verify Impressum Publisher Section
    [Documentation]    Checks the "Herausgeber und verantwortliche Stelle für
    ...                den Betrieb:" H2 section heading is displayed.
    Element Is Visible    ${IMP_H2_PUBLISHER}

Verify Impressum Responsible Section
    [Documentation]    Checks the "Verantwortlich für den Inhalt:" H2 section
    ...                heading (Freie Hansestadt Bremen team) is displayed.
    Element Is Visible    ${IMP_H2_RESPONSIBLE}

Verify Impressum Realization Section
    [Documentation]    Checks the "Realisierung und technischer Betrieb:" H2
    ...                section heading is displayed.
    Element Is Visible    ${IMP_H2_REALIZATION}

Verify Impressum Hosting Section
    [Documentation]    Checks the "Hosting / technischer Betreiber:" H2 section
    ...                heading is displayed.
    Element Is Visible    ${IMP_H2_HOSTING}

Verify Impressum Key Organizations
    [Documentation]    Verifies that the three main organizations (BVA, Governikus,
    ...                Dataport) are mentioned in the dialog content.
    Element Is Visible    ${IMP_BVA_TEXT}
    Element Is Visible    ${IMP_GOVERNIKUS_TEXT}
    Element Is Visible    ${IMP_DATAPORT_TEXT}

Verify Impressum Close Button Is Present
    [Documentation]    Confirms the universal dialog close button is accessible.
    Element Is Visible    ${IMP_CLOSE_BUTTON}


# ── Dialog Lifecycle ───────────────────────────────────────────────────────────

Close Impressum Dialog
    [Documentation]    Closes the Impressum dialog and waits for it to disappear.
    Close Currently Open Dialog


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Impressum Page
    [Documentation]    Master keyword – runs all Impressum dialog smoke assertions.
    Verify Impressum Dialog Is Open
    Verify Impressum H1 Heading
    Verify Impressum Publisher Section
    Verify Impressum Responsible Section
    Verify Impressum Realization Section
    Verify Impressum Hosting Section
    Verify Impressum Key Organizations
    Verify Impressum Close Button Is Present
