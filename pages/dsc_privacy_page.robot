# ==============================================================================
# datenschutz_page.robot  –  Page Object for the Datenschutzerklärung Dialog
#
# Triggered by : "Datenschutz" button in the site footer (role=contentinfo)
# Page title   : Datenschutzcockpit - Datenschutzerklärung
# Behaviour    : Opens as a modal dialog overlay – URL does not change.
#
# The dialog contains the full GDPR / DSGVO privacy declaration in nine
# numbered sections.  Assertions cover the title, H1, representative sections,
# and key regulatory references to give fast regression coverage.
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot


*** Variables ***

# ── Dialog H1 ─────────────────────────────────────────────────────────────────
${DS_H1_HEADING}       role=heading[name="Datenschutzerklärung"]

# ── Numbered Section H2 Headings ──────────────────────────────────────────────
${DS_H2_SECTION_1}
...    role=heading[name="1. Wie lautet die Bezeichnung der Verarbeitungstätigkeit?"]
${DS_H2_SECTION_2}
...    role=heading[name="2. Wer ist für die Datenverarbeitung verantwortlich?"]
${DS_H2_SECTION_3}
...    role=heading[name="3. An wen können Sie sich in Datenschutzfragen wenden?"]
${DS_H2_SECTION_9}
...    role=heading[name="9. Betroffenenrechte"]

# ── Key Regulatory / Content References ───────────────────────────────────────
${DS_DSGVO_INTRO}      text=Datenschutz-Grundverordnung
${DS_BVA_TEXT}         (//p[text()="Bundesverwaltungsamt"])[3]    # text=Bundesverwaltungsamt
# ${DS_IDNr_TEXT}        text=Identifikationsnummer (IDNr)
${DS_IDNr_TEXT}        (//*[contains(text(), "Identifikationsnummer (IDNr)")])[4]
${DS_CLOSE_BUTTON}     (//button[@data-testid="closeModalBtn"])[12]


*** Keywords ***

# ── Individual Assertions ──────────────────────────────────────────────────────

Verify Datenschutz Dialog Is Open
    [Documentation]    Confirms the Datenschutz dialog is active and the page
    ...                title has updated to "Datenschutzerklärung".
    Verify Page Title Contains    ${TITLE_DATENSCHUTZ}
    Element Is Visible    role=dialog

Verify Datenschutz H1 Heading
    [Documentation]    Checks the "Datenschutzerklärung" H1 heading is visible.
    Element Is Visible    ${DS_H1_HEADING}

Verify Datenschutz Section 1
    [Documentation]    Checks section 1: designation of the processing activity.
    Element Is Visible    ${DS_H2_SECTION_1}

Verify Datenschutz Section 2
    [Documentation]    Checks section 2: the responsible data-processing party
    ...                (Bundesverwaltungsamt).
    Element Is Visible    ${DS_H2_SECTION_2}

Verify Datenschutz Section 3
    [Documentation]    Checks section 3: data-protection contact details.
    Element Is Visible    ${DS_H2_SECTION_3}

Verify Datenschutz Section 9
    [Documentation]    Checks section 9: data subject rights (Betroffenenrechte).
    Element Is Visible    ${DS_H2_SECTION_9}

Verify Datenschutz DSGVO Reference
    [Documentation]    Confirms the DSGVO (Datenschutz-Grundverordnung) is
    ...                explicitly referenced in the dialog content.
    Element Is Visible    ${DS_DSGVO_INTRO}

Verify Datenschutz BVA Mentioned
    [Documentation]    Verifies Bundesverwaltungsamt (BVA) is named as the
    ...                responsible authority in the dialog content.
    Element Is Visible  ${DS_BVA_TEXT}
    
Verify Datenschutz IDNr Reference
    [Documentation]    Checks that the Identifikationsnummer (IDNr) concept is
    ...                mentioned, confirming the correct document is displayed.
    Element Is Visible    ${DS_IDNr_TEXT}

Verify Datenschutz Close Button Is Present
    [Documentation]    Confirms the universal dialog close button is accessible.
    Element Is Visible    ${DS_CLOSE_BUTTON}


# ── Dialog Lifecycle ───────────────────────────────────────────────────────────

Close Datenschutz Dialog
    [Documentation]    Closes the Datenschutz dialog and waits for it to disappear.
    Close Currently Open Dialog


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Datenschutz Page
    [Documentation]    Master keyword – runs all Datenschutz dialog smoke assertions.
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
