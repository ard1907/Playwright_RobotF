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
Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot


*** Variables ***

# ── Dialog Container ───────────────────────────────────────────────────────────
${LS_DIALOG}                 role=dialog

# ── Dialog Headings ────────────────────────────────────────────────────────────
# NOTE: Verify actual heading text on first run.
# ${LS_H1_HEADING}             role=heading[name="Das Datenschutzcockpit in Leichter Sprache"]
${LS_H1_HEADING}             (//H1[contains(text(), "Leichte Sprache")])[1]
${LS_EASY_LANGUAGE_BTN}        role=button[name="Das Datenschutzcockpit in Leichter Sprache"]

# ── Content Anchors ────────────────────────────────────────────────────────────
# Partial text selectors – robust against minor copy changes.
# ${LS_COCKPIT_MENTION}        text=Das sehen Sie im Daten-Schutz-Cockpit
${LS_COCKPIT_MENTION}        (//a[contains(text(), "Das sehen Sie im Daten-Schutz-Cockpit")])[1]
# ${LS_TERM_MENTION}           text=Leichte Sprache
${LS_TERM_MENTION}           (//a[contains(text(), "Leichte Sprache")])[1]

# ── Dialog Leichte Sprache Internal Links ────────────────────────────────────────────────────────
&{LS_INTERNAL_URLS}                    DasSehenSie=#header-linkTitle1
...                                    SoMeldenSieSichAn=#header-linkTitle2
...                                    SoBenutzenSie=#header-linkTitle3
...                                    ErklaerungZur=#header-linkTitle4


# ── Dialog Leichte Sprache External Links ────────────────────────────────────────────────────────
&{LS_EXTERNAL_URLS}                    MailtoDSC01=mailto:datenschutzcockpit@finanzen.bremen.de
...                                    LinkMitInfosPersonalAusweis=https://www.personalausweisportal.de/Webs/PA/DE/service/leichte-sprache/das_personalausweisportal/das_personalausweisportal_node.html
...                                    LinkMitInfosAusweisApp=https://www.ausweisapp.bund.de/leichte-sprache
...                                    MailtoDSC02=mailto:datenschutzcockpit@finanzen.bremen.de
...                                    SchlichtungsStelle01=https://www.schlichtungsstelle-bgg.de
...                                    Telefon=tel:+4930185272805
...                                    MailtoBGG=mailto:info@schlichtungsstelle-bgg.de
...                                    SchlichtungsStelle02=https://www.schlichtungsstelle-bgg.de


# ── Dialog Leichte Sprache - Selectors - Key Content References ───────────────────────────────────
${LS_DAS_SEHEN_SIE_ELEMENT}            role=link[name="Das sehen Sie im Daten-Schutz-Cockpit"]
${LS_SO_MELDEN_SIE_SICH_AN_ELEMENT}    role=link[name="So melden Sie sich an"]
${LS_SO_BENUTZEN_SIE_ELEMENT}          role=link[name="So benutzen Sie die Start-Seite"]
${LS_ERKLAERUNG_ZUR_ELEMENT}           role=link[name="Erklärung zur Barriere-Freiheit"]

${LS_CONTACT_EMAIL_DSC_01}             (//*[contains(text(), "datenschutzcockpit@finanzen.bremen.de")])[1]
${LS_INFO_PERSONALAUSWEIS_ELEMENT}     role=link[name="Link mit Infos zur Online-Ausweis-Funktion"]
${LS_INFO_AUSWEISAPP_ELEMENT}          role=link[name="Link mit Infos zur AusweisApp"]

${LS_CONTACT_EMAIL_DSC_02}             (//*[contains(text(), "datenschutzcockpit@finanzen.bremen.de")])[2]
${LS_SCHLICHTUNGSSTELLE_ELEMENT_01}    role=link[name="www.schlichtungsstelle-bgg.de"] >> nth=0
${LS_TELEFON_ELEMENT}                  role=link[name="030 18 527 2805"]
${LS_CONTACT_EMAIL_BGG}                (//*[contains(text(), "info@schlichtungsstelle-bgg.de")])[1]
${LS_SCHLICHTUNGSSTELLE_ELEMENT_02}    role=link[name="www.schlichtungsstelle-bgg.de"] >> nth=1


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
Open Leichte Sprache Dialog
    [Documentation]    Clicks the "Leichte Sprache" header button on the landing
    ...                page and waits for the corresponding dialog to appear.
    Click    ${LS_EASY_LANGUAGE_BTN}
    Wait For Elements State    role=dialog    visible    timeout=${TIMEOUT}

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


# ── New-Tab External Link Flows ────────────────────────────────────────────────
Validate External URLs For Leichte Sprache Dialog
    [Documentation]    Validates that all external links in the Leichte Sprache dialog have the correct href URLs before clicking.
    ...                This is a pre-click check to ensure the links point to the expected external resources, without relying on the new tab navigation.
    # Open Leichte Sprache Dialog
    Get Attribute    ${LS_CONTACT_EMAIL_DSC_01}   href   ==   ${LS_EXTERNAL_URLS}[MailtoDSC01]
    Get Attribute    ${LS_INFO_PERSONALAUSWEIS_ELEMENT}   href   ==   ${LS_EXTERNAL_URLS}[LinkMitInfosPersonalAusweis]
    Get Attribute    ${LS_INFO_AUSWEISAPP_ELEMENT}   href   ==   ${LS_EXTERNAL_URLS}[LinkMitInfosAusweisApp]
    Get Attribute    ${LS_CONTACT_EMAIL_DSC_02}   href   ==   ${LS_EXTERNAL_URLS}[MailtoDSC02]
    Get Attribute    ${LS_SCHLICHTUNGSSTELLE_ELEMENT_01}   href   ==   ${LS_EXTERNAL_URLS}[SchlichtungsStelle01]
    Get Attribute    ${LS_TELEFON_ELEMENT}   href   ==   ${LS_EXTERNAL_URLS}[Telefon]
    Get Attribute    ${LS_CONTACT_EMAIL_BGG}   href   ==   ${LS_EXTERNAL_URLS}[MailtoBGG]
    Get Attribute    ${LS_SCHLICHTUNGSSTELLE_ELEMENT_02}   href   ==   ${LS_EXTERNAL_URLS}[SchlichtungsStelle02]


# ── Internal Link Flows ────────────────────────────────────────────────
Validate Internal Links For Leichte Sprache Dialog
    [Documentation]    Validates that all internal links in the Leichte Sprache dialog have the correct href URLs before clicking.
    ...                This is a pre-click check to ensure the links point to the expected internal resources.
    # Open Leichte Sprache Dialog
    Get Attribute    ${LS_DAS_SEHEN_SIE_ELEMENT}   href   ==   ${LS_INTERNAL_URLS}[DasSehenSie]
    Get Attribute    ${LS_SO_MELDEN_SIE_SICH_AN_ELEMENT}   href   ==   ${LS_INTERNAL_URLS}[SoMeldenSieSichAn]
    Get Attribute    ${LS_SO_BENUTZEN_SIE_ELEMENT}   href   ==   ${LS_INTERNAL_URLS}[SoBenutzenSie]
    Get Attribute    ${LS_ERKLAERUNG_ZUR_ELEMENT}   href   ==   ${LS_INTERNAL_URLS}[ErklaerungZur]