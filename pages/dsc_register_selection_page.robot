# ==============================================================================
# dsc_registerauswahl_page.robot  –  Page Object for the Registerauswahl Page
#
# URL   : https://qs-datenschutzcockpit.dsc.govkg.de/spa/cockpit/register-auswahl
# Title : Datenschutzcockpit - Registerauswahl
#
# This page ...
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
Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot

*** Variables ***
# ── Header / Logo ────────────────────────────────────────────────────────────
${RA_LOGO_LINK}                   role=link[name="Bund.de Datenschutzcockpit Beta Logo"]
${RA_EASY_LANGUAGE_BTN}           role=button[name="Das Datenschutzcockpit in Leichter Sprache"]
${RA_SIGN_LANGUAGE_BTN}           role=button[name="Zum Gebärdensprache-Video"]

# ── Logged-In State Indicators ────────────────────────────────────────────────
# IDNr display shows the masked tax-ID of the logged-in user.
${RA_IDNR_DISPLAY}                \#id-number
${RA_IDNR_LABEL}                  .id-number__label
${RA_IDNR_MASKED_VALUE}           .id-number__hidden
${RA_SESSION_TIMER}               .session-timer__text

# ── Main Content ─────────────────────────────────────────────────────────────
${RA_H1_HEADING}                  //h1[text()="Wonach wollen Sie suchen?"]
${RA_H2_HEADING}                  //h2[text()="Registerauswahl"]
${RA_INTRO_PARAGRAPH}             //main//p[contains(.,"Mit dem Datenschutzcockpit werden Sie")]
${RA_INTRO_TEXT_WAS_SEHE_ICH}     //main//p[contains(.,'Was sehe ich im Datenschutzcockpit?')]
${RA_INTRO_TEXT_WAS_IST}          //main//p[contains(.,'Was ist das Datenschutzcockpit?')]

# ── Register Selection ────────────────────────────────────────────────────────
# "Alle Register auswählen" is a label element with role="button".
${RA_ALLE_REGISTER_BTN}           role=button[name="Alle Register auswählen"]
# At least one register list item (each contains an h3 card heading).
${RA_REGISTER_FIRST_ITEM}         (//ul//li[.//h3])[1]
# View toggle: grid (default, active) and list view buttons.
${RA_VIEW_GRID_BTN}               //div[contains(@class,"registerFinderBtn") and contains(@class,"active")]
${RA_VIEW_LIST_BTN}               //div[@role="button" and contains(@class,"registerFinderBtn")]
# Hint shown when no register is selected yet.
${RA_HINT_H3}                     //h3[text()="Bitte wählen Sie mindestens ein Register"]
${RA_HINT_PARAGRAPH}              //p[contains(.,"Mit einem Klick auf die Kacheln")]

# ── Footer Navigation ─────────────────────────────────────────────────────────
${RA_IMPRESSUM_BTN}               role=button[name="Impressum"]
${RA_DATENSCHUTZ_BTN}             role=button[name="Datenschutz"]
${RA_BARRIEREFREIHEIT_BTN}        role=button[name="Barrierefreiheit"]

# ── Floating Action Bar ───────────────────────────────────────────────────────
${RA_FAQ_FLOAT_BUTTON}            role=button[name="FAQ"]
${RA_FEEDBACK_BTN}                role=button[name="Feedback hinterlassen"]

# ── Logout Flow (already used by Logout From Datenschutzcockpit below) ────────
${RA_LOGOUT_BUTTON_1}        //button[@data-testid="logoutPopUpTriggerBtn"]
${RA_LOGOUT_BUTTON_2}        //button[@data-testid="logoutBtn"]
${RA_LOGOUT_BUTTON_3}        //button[@data-testid="logoutPopUpOkBtn"]
${RA_H1_LOGOUT_HEADING_1}    //h1[text()="Möchten Sie sich wirklich abmelden?"]
${RA_H1_LOGOUT_HEADING_2}    //h1[text()="Sie wurden erfolgreich abgemeldet"]
${RA_H1_LOGOUT_HEADING_3}    //h1[text()="Behalten Sie Ihre Daten im Blick"]

*** Keywords ***

Logout From Datenschutzcockpit
    [Documentation]    Logs out of the Datenschutzcockpit if currently logged in.
    IF   ${CI} and not ${CI_SELF_HOSTED}              RETURN   #ARD: Just to test Github Actions Workflow in my personal Repository. Plse remove in real DSC Repository.
    Click                    ${RA_LOGOUT_BUTTON_1}
    Wait For Elements State  ${RA_H1_LOGOUT_HEADING_1}  visible
    Click                    ${RA_LOGOUT_BUTTON_2}
    Wait For Elements State  ${RA_H1_LOGOUT_HEADING_2}  visible
    Click                    ${RA_LOGOUT_BUTTON_3}
    Wait For Elements State  ${RA_H1_LOGOUT_HEADING_3}  visible


# ── Page-Level Assertions ──────────────────────────────────────────────────────

Verify Register Auswahl Page Is Loaded
    [Documentation]    Confirms the SPA has routed to the register-auswahl page:
    ...                the base Datenschutzcockpit title is visible and the H1
    ...                heading is visible (proves the component has rendered).
    # Verify Page Title Contains    ${TITLE_REGISTER_AUSWAHL}    #ARD: prüfen !
    Verify Page Title Contains    ${TITLE_BASE}
    Element Is Visible    ${RA_H1_HEADING}

Validate Register Auswahl Page
    [Documentation]    Verifies all critical elements on the Register Auswahl
    ...                page (cockpit entry point after login):
    ...                  • Page title contains "Registerauswahl"
    ...                  • H1 heading "Wonach wollen Sie suchen?" is visible
    ...                  • H2 heading "Registerauswahl" is visible
    ...                  • IDNr display (logged-in indicator) is visible
    ...                  • Session timer is visible
    ...                  • Logout trigger button is visible and enabled
    ...                  • Intro paragraph text is visible
    IF   ${CI} and not ${CI_SELF_HOSTED}    RETURN    #ARD: No AusweisApp SDK on standard CI. Remove in real DSC Repository.
    Verify Register Auswahl Page Is Loaded
    Element Is Visible    ${RA_H2_HEADING}
    Element Is Visible    ${RA_IDNR_DISPLAY}
    Element Is Visible    ${RA_SESSION_TIMER}
    Element Is Visible    ${RA_LOGOUT_BUTTON_1}
    ${logout_states}=    Get Element States    ${RA_LOGOUT_BUTTON_1}
    Should Contain    ${logout_states}    enabled
    Element Is Visible    ${RA_INTRO_PARAGRAPH}

Verify RA Header Accessibility Buttons
    [Documentation]    Checks that the logo link and both shared-header
    ...                accessibility buttons are visible and enabled on the
    ...                register-auswahl page:
    ...                  • Bund.de Datenschutzcockpit Beta Logo (link)
    ...                  • Das Datenschutzcockpit in Leichter Sprache (button)
    ...                  • Zum Gebärdensprache-Video (button)
    IF   ${CI} and not ${CI_SELF_HOSTED}    RETURN    #ARD: No AusweisApp SDK on standard CI. Remove in real DSC Repository.
    Element Is Visible    ${RA_LOGO_LINK}
    ${logo_states}=    Get Element States    ${RA_LOGO_LINK}
    Should Contain    ${logo_states}    enabled
    Element Is Visible    ${RA_EASY_LANGUAGE_BTN}
    ${ls_states}=    Get Element States    ${RA_EASY_LANGUAGE_BTN}
    Should Contain    ${ls_states}    enabled
    Element Is Visible    ${RA_SIGN_LANGUAGE_BTN}
    ${gs_states}=    Get Element States    ${RA_SIGN_LANGUAGE_BTN}
    Should Contain    ${gs_states}    enabled

Verify RA FAQ Float Button
    [Documentation]    Checks that the floating FAQ button is visible and enabled
    ...                on the register-auswahl page.
    IF   ${CI} and not ${CI_SELF_HOSTED}    RETURN    #ARD: No AusweisApp SDK on standard CI. Remove in real DSC Repository.
    Element Is Visible    ${RA_FAQ_FLOAT_BUTTON}
    ${faq_states}=    Get Element States    ${RA_FAQ_FLOAT_BUTTON}
    Should Contain    ${faq_states}    enabled

Verify RA Footer Navigation
    [Documentation]    Verifies all three footer navigation buttons are visible
    ...                and enabled on the register-auswahl page.
    IF   ${CI} and not ${CI_SELF_HOSTED}    RETURN    #ARD: No AusweisApp SDK on standard CI. Remove in real DSC Repository.
    Element Is Visible    ${RA_IMPRESSUM_BTN}
    ${imp_states}=    Get Element States    ${RA_IMPRESSUM_BTN}
    Should Contain    ${imp_states}    enabled
    Element Is Visible    ${RA_DATENSCHUTZ_BTN}
    ${dat_states}=    Get Element States    ${RA_DATENSCHUTZ_BTN}
    Should Contain    ${dat_states}    enabled
    Element Is Visible    ${RA_BARRIEREFREIHEIT_BTN}
    ${bar_states}=    Get Element States    ${RA_BARRIEREFREIHEIT_BTN}
    Should Contain    ${bar_states}    enabled

Verify RA Register List Is Rendered
    [Documentation]    Verifies the register selection section is fully rendered:
    ...                  • "Alle Register auswählen" control visible and enabled
    ...                  • At least one register list item with heading visible
    ...                  • Grid view toggle is present (active default state)
    ...                  • List view toggle is present
    ...                  • Hint heading "Bitte wählen Sie mindestens ein Register" visible
    ...                  • Hint instruction paragraph visible
    IF   ${CI} and not ${CI_SELF_HOSTED}    RETURN    #ARD: No AusweisApp SDK on standard CI. Remove in real DSC Repository.
    Element Is Visible    ${RA_ALLE_REGISTER_BTN}
    ${alle_states}=    Get Element States    ${RA_ALLE_REGISTER_BTN}
    Should Contain    ${alle_states}    enabled
    Element Is Visible    ${RA_REGISTER_FIRST_ITEM}
    Element Is Visible    ${RA_VIEW_GRID_BTN}
    Element Is Visible    ${RA_VIEW_LIST_BTN}
    Element Is Visible    ${RA_HINT_H3}
    Element Is Visible    ${RA_HINT_PARAGRAPH}

Verify RA Intro Content Buttons
    [Documentation]    Verifies both inline intro content phrases are visible in
    ...                the register selection page text:
    ...                  • "Was sehe ich im Datenschutzcockpit?"
    ...                  • "Was ist das Datenschutzcockpit?"
    IF   ${CI} and not ${CI_SELF_HOSTED}    RETURN    #ARD: No AusweisApp SDK on standard CI. Remove in real DSC Repository.
    Element Is Visible    ${RA_INTRO_TEXT_WAS_SEHE_ICH}
    Element Is Visible    ${RA_INTRO_TEXT_WAS_IST}

Verify RA Feedback Button
    [Documentation]    Verifies the "Feedback hinterlassen" button in the floating
    ...                action bar is visible and enabled. This button is unique to
    ...                the authenticated cockpit pages and not present on public pages.
    IF   ${CI} and not ${CI_SELF_HOSTED}    RETURN    #ARD: No AusweisApp SDK on standard CI. Remove in real DSC Repository.
    Element Is Visible    ${RA_FEEDBACK_BTN}
    ${fb_states}=    Get Element States    ${RA_FEEDBACK_BTN}
    Should Contain    ${fb_states}    enabled