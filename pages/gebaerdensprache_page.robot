# ==============================================================================
# gebaerdensprache_page.robot  –  Page Object for the "Gebärdensprache" Dialog
#
# Triggered by : "Zum Gebärdensprache-Video" button (header)
# Page title   : Datenschutzcockpit - Gebärdensprache  (expected)
# Behaviour    : Opens as a modal dialog overlay with embedded sign-language video.
#                Available from all SPA routes sharing the same header.
#
# The dialog presents a sign-language (DGS) video that explains the purpose of
# the Datenschutzcockpit for deaf and hard-of-hearing users.
#
# NOTE: Verify heading name and video element selector after first test run.
#       If no <video> tag is used (e.g. iframe embed), adjust ${GS_VIDEO_ELEMENT}.
# ==============================================================================

*** Settings ***
Library     Browser
Resource    ../resources/variables.robot
Resource    ../resources/common_keywords.robot


*** Variables ***

# ── Dialog Container ───────────────────────────────────────────────────────────
${GS_DIALOG}                 role=dialog
${GS_TAB_TITLE_GEBAERDENSPRACHE}   Datenschutzcockpit - Gebärdensprache

# ── Dialog Headings ────────────────────────────────────────────────────────────
# NOTE: Verify actual heading text on first run.
# ${GS_H1_HEADING}             role=heading[name="Gebärdensprache"]
${GS_H1_HEADING}             //h1[contains(text(), "Informationen in Gebärdensprache")]

# ── Content Anchors ────────────────────────────────────────────────────────────
# ${GS_SIGN_LANG_MENTION}      text=Gebärdensprache
${GS_SIGN_LANG_MENTION}      //h2[contains(text(), "Informationen zur Erklärung der Barrierefreiheit")]

# ── Video Element ─────────────────────────────────────────────────────────────
# Checks that a playable video element exists inside the dialog.
# Fallback: if the video is embedded via an <iframe>, adjust to css=iframe.
# ${GS_VIDEO_ELEMENT}          css=video
${GS_SIGN_LANGUAGE_BTN}      role=button[name="Zum Gebärdensprache-Video"]
${GS_VIDEO_ELEMENT_01}       (//a[contains(text(), "Hier geht´s zum Video.")])[1]
${GS_VIDEO_ELEMENT_02}       (//a[contains(text(), "Hier geht´s zum Video.")])[2]

&{GS_EXTERNAL_URLS}          Video_DSC=https://dataportlms.web.hamburg.de/ilp/pages/mediacontent.jsf?mediaId=10779559&catalogId=10779436
...                          Video_Barrierefreiheit=https://dataportlms.web.hamburg.de/ilp/pages/mediacontent.jsf?mediaId=10779579&catalogId=10779436

# ── Close Button ──────────────────────────────────────────────────────────────
${GS_CLOSE_BTN}              role=button[name="Menü schließen"]


*** Keywords ***

# ── Individual Assertions ──────────────────────────────────────────────────────

Verify Gebaerdensprache Dialog Is Open
    [Documentation]    Confirms the Gebärdensprache dialog is active and the
    ...                SPA has updated the page title to include "Gebärdensprache".
    Verify Page Title Contains    ${GS_TAB_TITLE_GEBAERDENSPRACHE}
    Element Is Visible    ${GS_DIALOG}

Verify Gebaerdensprache H1 Heading
    [Documentation]    Checks that the primary heading is visible inside the
    ...                dialog overlay.
    Element Is Visible    ${GS_H1_HEADING}

Verify Gebaerdensprache Content Present
    [Documentation]    Verifies the dialog body references "Gebärdensprache",
    ...                confirming the correct content section has loaded.
    Element Is Visible    ${GS_SIGN_LANG_MENTION}

Verify Gebaerdensprache Video Is Present
    [Documentation]    Checks that a <video> element exists in the dialog,
    ...                confirming the sign-language video embed has rendered.
    Element Is Visible    ${GS_VIDEO_ELEMENT_01}
    Element Is Visible    ${GS_VIDEO_ELEMENT_02}

Verify Gebaerdensprache Close Button Is Present
    [Documentation]    Confirms the universal dialog close button is accessible.
    Element Is Visible    ${GS_CLOSE_BTN}


# ── Dialog Lifecycle ───────────────────────────────────────────────────────────

Open Gebaerdensprache Dialog
    [Documentation]    Clicks the "Gebärdensprache-Video" header button on the
    ...                auth-info page and waits for the dialog to appear.
    Click    ${GS_SIGN_LANGUAGE_BTN}
    Wait For Elements State    role=dialog    visible    timeout=${TIMEOUT}

Close Gebaerdensprache Dialog
    [Documentation]    Closes the Gebärdensprache dialog via the shared
    ...                "Menü schließen" button and waits until it is gone.
    Close Currently Open Dialog


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Gebaerdensprache Page
    [Documentation]    Master keyword – runs all Gebärdensprache dialog smoke
    ...                assertions: title update, dialog visible, H1, content
    ...                reference, video element, and close button.
    Verify Gebaerdensprache Dialog Is Open
    Verify Gebaerdensprache H1 Heading
    Verify Gebaerdensprache Content Present
    Verify Gebaerdensprache Video Is Present
    Verify Gebaerdensprache Close Button Is Present


# ── New-Tab External Link Flows ────────────────────────────────────────────────
Validate External URLs For Gebaerdensprache Dialog
    [Documentation]    Validates that all external links in the Gebärdensprache dialog have the correct href URLs before clicking.
    ...                This is a pre-click check to ensure the links point to the expected external resources, without relying on the new tab navigation.
    # Open Gebaerdensprache Dialog
    Get Attribute    ${GS_VIDEO_ELEMENT_01}   href   ==   ${GS_EXTERNAL_URLS}[Video_DSC]
    Get Attribute    ${GS_VIDEO_ELEMENT_02}   href   ==   ${GS_EXTERNAL_URLS}[Video_Barrierefreiheit]