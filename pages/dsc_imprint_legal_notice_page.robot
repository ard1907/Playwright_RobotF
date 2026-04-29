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
Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot


*** Variables ***

# ── Dialog Headings ────────────────────────────────────────────────────────────
${IMP_DIALOG}            role=dialog
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


# ── Impressum Email Links ───────────────────────────────────────────────
&{IMP_EXTERNAL_URLS}     BVA_Email=mailto:poststelle@bva.bund.de
...                      DSC_Email=mailto:datenschutzcockpit@finanzen.bremen.de
...                      BVA_DSB_Email=mailto:datenschutzbeauftragter@bva.bund.de
...                      BFDI_Email=mailto:poststelle@bfdi.bund.de

${IMP_BVA_EMAIL}         role=link[name="poststelle@bva.bund.de"]
${IMP_DSC_EMAIL}         role=link[name="datenschutzcockpit@finanzen.bremen.de"]
${IMP_BVA_DSB_EMAIL}     role=link[name="datenschutzbeauftragter@bva.bund.de"]
${IMP_BFDI_EMAIL}        role=link[name="poststelle@bfdi.bund.de"]


*** Keywords ***

# ── Individual Assertions ──────────────────────────────────────────────────────

Verify Impressum Dialog Is Open
    [Documentation]    Confirms the Impressum dialog is active and the page title
    ...                has updated to "Impressum".
    Verify Page Title Contains    ${TITLE_IMPRESSUM}
    Element Is Visible    ${IMP_DIALOG}

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

# ── Email Link Validation ─────────────────────────────────────────────────

Validate External URLs For Impressum Dialog
    [Documentation]    Validates that all email links in the Impressum dialog
    ...                carry the correct mailto href values before clicking.
    ...                Covers: BVA contact, DSC content, BVA data-protection
    ...                officer, and Federal Commissioner for Data Protection.
    Get Attribute    ${IMP_BVA_EMAIL}       href    ==    ${IMP_EXTERNAL_URLS}[BVA_Email]
    Get Attribute    ${IMP_DSC_EMAIL}       href    ==    ${IMP_EXTERNAL_URLS}[DSC_Email]
    Get Attribute    ${IMP_BVA_DSB_EMAIL}   href    ==    ${IMP_EXTERNAL_URLS}[BVA_DSB_Email]
    Get Attribute    ${IMP_BFDI_EMAIL}      href    ==    ${IMP_EXTERNAL_URLS}[BFDI_Email]