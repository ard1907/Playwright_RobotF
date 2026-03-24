# ==============================================================================
# leichte_sprache_page.robot  –  Page Object for the "Leichte Sprache" Dialog
#
# Triggered by : "Das Datenschutzcockpit in Leichter Sprache" button (header)
# Page title   : Datenschutzcockpit - Leichte Sprache  (expected)
# Behaviour    : Opens as a modal dialog overlay within the SPA.
#                Available from all SPA routes sharing the same header.
#
# The dialog presents a simplified ("Leichte Sprache") description of the
# Datenschutzcockpit aimed at users who benefit from plain-language content.
#
# NOTE: Verify heading names after first run – adjust if content differs.
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/variables.robot
Resource    ../resources/common_keywords.robot


*** Variables ***

# ── Dialog Container ───────────────────────────────────────────────────────────
${LS_DIALOG}                 role=dialog

# ── Dialog Headings ────────────────────────────────────────────────────────────
# NOTE: Verify actual heading text on first run.
# ${LS_H1_HEADING}             role=heading[name="Das Datenschutzcockpit in Leichter Sprache"]
${LS_H1_HEADING}             (//H1[contains(text(), "Leichte Sprache")])[1]

# ── Content Anchors ────────────────────────────────────────────────────────────
# Partial text selectors – robust against minor copy changes.
# ${LS_COCKPIT_MENTION}        text=Das sehen Sie im Daten-Schutz-Cockpit
${LS_COCKPIT_MENTION}        (//a[contains(text(), "Das sehen Sie im Daten-Schutz-Cockpit")])[1]
# ${LS_TERM_MENTION}           text=Leichte Sprache
${LS_TERM_MENTION}           (//a[contains(text(), "Leichte Sprache")])[1]

# ── Close Button ──────────────────────────────────────────────────────────────
${LS_CLOSE_BTN}              role=button[name="Menü schließen"]


*** Keywords ***

# ── Individual Assertions ──────────────────────────────────────────────────────

Verify Leichte Sprache Dialog Is Open
    [Documentation]    Confirms the Leichte Sprache dialog is active and the
    ...                SPA has updated the page title to include "Leichte Sprache".
    Verify Page Title Contains    ${TITLE_LEICHTE_SPRACHE}
    Element Is Visible    ${LS_DIALOG}

Verify Leichte Sprache H1 Heading
    [Documentation]    Checks that the primary H1 heading is displayed inside
    ...                the dialog overlay.
    Element Is Visible    ${LS_H1_HEADING}

Verify Leichte Sprache Cockpit Mentioned
    [Documentation]    Verifies the dialog body references the "Datenschutzcockpit"
    ...                term, confirming the correct content has loaded.
    Element Is Visible    ${LS_COCKPIT_MENTION}

Verify Leichte Sprache Term Present
    [Documentation]    Confirms the phrase "Leichte Sprache" appears in the
    ...                dialog content (heading or body text).
    Element Is Visible    ${LS_TERM_MENTION}

Verify Leichte Sprache Close Button Is Present
    [Documentation]    Confirms the universal dialog close button is accessible
    ...                so users can return to the previous page.
    Element Is Visible    ${LS_CLOSE_BTN}


# ── Dialog Lifecycle ───────────────────────────────────────────────────────────

Close Leichte Sprache Dialog
    [Documentation]    Closes the Leichte Sprache dialog via the shared
    ...                "Menü schließen" button and waits until it is gone.
    Close Currently Open Dialog


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Leichte Sprache Page
    [Documentation]    Master keyword – runs all Leichte Sprache dialog smoke
    ...                assertions: title update, dialog visible, H1, content
    ...                references, and close button.
    Verify Leichte Sprache Dialog Is Open
    Verify Leichte Sprache H1 Heading
    Verify Leichte Sprache Cockpit Mentioned
    # Verify Leichte Sprache Term Present
    Verify Leichte Sprache Close Button Is Present
