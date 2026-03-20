# ==============================================================================
# faq_page.robot  –  Page Object for the FAQ Dialog
#
# Triggered by : Floating "FAQ" button (always visible on landing page)
# Page title   : Datenschutzcockpit - FAQ
# Behaviour    : Opens as a modal dialog overlay – same URL is kept.
#
# Selectors captured from live ARIA tree inspection.
# Accordion buttons carry state suffix " - Antwort ist geschlossen" when closed.
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/variables.robot
Resource    ../resources/common_keywords.robot


*** Variables ***

# ── Dialog Structure ───────────────────────────────────────────────────────────
${FAQ_H1_HEADING}          role=heading[name="Informationen zum Datenschutzcockpit"]
${FAQ_H2_HOW_IT_WORKS}     role=heading[name="Wie funktioniert das Datenschutzcockpit?"]
${FAQ_H2_HOW_TO_LOGIN}     role=heading[name="Wie funktioniert die Anmeldung?"]

# ── "How it works" Accordion Items (closed / default state) ───────────────────
${FAQ_ITEM_WHAT_IS}
...    role=button[name="Was ist das Datenschutzcockpit? - Antwort ist geschlossen"]
${FAQ_ITEM_WHAT_SEE}
...    role=button[name="Was sehe ich im Datenschutzcockpit? - Antwort ist geschlossen"]
${FAQ_ITEM_WHO_OPERATES}
...    role=button[name="Wer betreibt das Datenschutzcockpit? - Antwort ist geschlossen"]
${FAQ_ITEM_MORE_INFO}
...    role=button[name="Weitere Informationen - Antwort ist geschlossen"]

# ── "Login" Accordion Items (closed / default state) ─────────────────────────
${FAQ_ITEM_WHAT_NEEDED}
...    role=button[name="Was benötige ich für die Anmeldung? - Antwort ist geschlossen"]
${FAQ_ITEM_AUSWEIS_LOGIN}
...    role=button[name="Wie melde ich mich mit der AusweisApp an? - Antwort ist geschlossen"]
${FAQ_ITEM_HOW_SECURE}
...    role=button[name="Wie sicher ist das Datenschutzcockpit? - Antwort ist geschlossen"]


*** Keywords ***

# ── Individual Assertions ──────────────────────────────────────────────────────

Verify FAQ Dialog Is Open
    [Documentation]    Confirms the FAQ dialog is visible and the SPA has updated
    ...                its title to include "FAQ".
    Verify Page Title Contains    ${TITLE_FAQ}
    Element Is Visible    role=dialog

Verify FAQ Main Heading
    [Documentation]    Checks the H1 heading "Informationen zum Datenschutzcockpit"
    ...                is displayed inside the opened dialog.
    Element Is Visible    ${FAQ_H1_HEADING}

Verify FAQ How It Works Section
    [Documentation]    Checks the section heading "Wie funktioniert das
    ...                Datenschutzcockpit?" is present.
    Element Is Visible    ${FAQ_H2_HOW_IT_WORKS}

Verify FAQ Login Section
    [Documentation]    Checks the section heading "Wie funktioniert die Anmeldung?"
    ...                is displayed in the dialog.
    Element Is Visible    ${FAQ_H2_HOW_TO_LOGIN}

Verify FAQ Accordion Items
    [Documentation]    Checks that all four "How it works" accordion buttons are
    ...                rendered in their default closed state.
    Element Is Visible    ${FAQ_ITEM_WHAT_IS}
    Element Is Visible    ${FAQ_ITEM_WHAT_SEE}
    Element Is Visible    ${FAQ_ITEM_WHO_OPERATES}
    Element Is Visible    ${FAQ_ITEM_MORE_INFO}

Verify FAQ Login Accordion Items
    [Documentation]    Checks that all three "Login" accordion buttons are rendered
    ...                in their default closed state.
    Element Is Visible    ${FAQ_ITEM_WHAT_NEEDED}
    Element Is Visible    ${FAQ_ITEM_AUSWEIS_LOGIN}
    Element Is Visible    ${FAQ_ITEM_HOW_SECURE}

Verify FAQ Close Button Is Present
    [Documentation]    Confirms the universal dialog close button is accessible.
    Element Is Visible    role=button[name="Menü schließen"]


# ── Dialog Lifecycle ───────────────────────────────────────────────────────────

Close FAQ Dialog
    [Documentation]    Closes the FAQ dialog via the shared "Menü schließen"
    ...                button and waits until the dialog button is gone from DOM.
    Close Currently Open Dialog


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate FAQ Page
    [Documentation]    Master keyword – runs all FAQ dialog smoke assertions.
    Verify FAQ Dialog Is Open
    Verify FAQ Main Heading
    Verify FAQ How It Works Section
    Verify FAQ Login Section
    Verify FAQ Accordion Items
    Verify FAQ Login Accordion Items
    Verify FAQ Close Button Is Present
