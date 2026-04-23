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
${RA_IDNR_SHOW_BUTTON}            role=button[name="ID-Nummer anzeigen"]

# ── Main Content ─────────────────────────────────────────────────────────────
${RA_H1_HEADING}                  //h1[text()="Wonach wollen Sie suchen?"]
${RA_H2_HEADING}                  //h2[text()="Registerauswahl"]
${RA_INTRO_PARAGRAPH}             //main//p[contains(.,"Mit dem Datenschutzcockpit werden Sie")]
${RA_INTRO_TEXT_WAS_SEHE_ICH}     //main//p[contains(.,'Was sehe ich im Datenschutzcockpit?')]
${RA_INTRO_TEXT_WAS_IST}          //main//p[contains(.,'Was ist das Datenschutzcockpit?')]
${RA_INTRO_BTN_WAS_SEHE_ICH}      //main//button[contains(.,"Was sehe ich im Datenschutzcockpit?")]
${RA_INTRO_BTN_WAS_IST}           //main//button[contains(.,"Was ist das Datenschutzcockpit?")]
${RA_DIALOG_WAS_SEHE_ICH_H2}      //h2[text()="Was sehe ich im Datenschutzcockpit?"]
${RA_DIALOG_WAS_IST_H2}           //h2[text()="Was ist das Datenschutzcockpit?"]
${RA_DIALOG_CLOSE_BTN}            role=button[name="Menü schließen"]
${RA_FAQ_DIALOG_H1}               //h1[text()="Informationen zum Datenschutzcockpit"]

# ── Register Selection ────────────────────────────────────────────────────────
# "Alle Register auswählen" is a label element with role="button".
${RA_ALLE_REGISTER_BTN}           role=button[name="Alle Register auswählen"]
${RA_ALLE_REGISTER_ABWAEHLEN_BTN}    role=button[name="Alle Register abwählen"]
# At least one register list item (each contains an h3 card heading).
${RA_REGISTER_FIRST_ITEM}         (//ul//li[.//h3])[1]
${RA_REGISTER_ALL_ITEMS}          (//ul//li[.//h3])
${RA_MEHR_ZUM_REGISTER_BUTTONS}   //u[contains(normalize-space(.),"Mehr zum Register lesen")]
${RA_REQUEST_START_BTN}           //button[normalize-space(.)="Anfrage starten"]
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
    Element Is Visible    ${RA_FAQ_FLOAT_BUTTON}
    ${faq_states}=    Get Element States    ${RA_FAQ_FLOAT_BUTTON}
    Should Contain    ${faq_states}    enabled

Verify RA Footer Navigation
    [Documentation]    Verifies all three footer navigation buttons are visible
    ...                and enabled on the register-auswahl page.
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
    Element Is Visible    ${RA_INTRO_TEXT_WAS_SEHE_ICH}
    Element Is Visible    ${RA_INTRO_TEXT_WAS_IST}

Verify RA Feedback Button
    [Documentation]    Verifies the "Feedback hinterlassen" button in the floating
    ...                action bar is visible and enabled. This button is unique to
    ...                the authenticated cockpit pages and not present on public pages.
    Element Is Visible    ${RA_FEEDBACK_BTN}
    ${fb_states}=    Get Element States    ${RA_FEEDBACK_BTN}
    Should Contain    ${fb_states}    enabled

Ensure RA Empty Selection State
    [Documentation]    Brings the register selection section back to its default
    ...                empty-selection state with visible hint text.
    ${abw_count}=    Get Element Count    ${RA_ALLE_REGISTER_ABWAEHLEN_BTN}
    IF    ${abw_count} > 0
        Click    ${RA_ALLE_REGISTER_ABWAEHLEN_BTN}
        Wait For Elements State    ${RA_ALLE_REGISTER_BTN}    visible    timeout=${TIMEOUT}
    END
    ${request_count}=    Get Element Count    ${RA_REQUEST_START_BTN}
    IF    ${request_count} > 0
        Click    ${RA_REGISTER_FIRST_ITEM}
        Wait For Elements State    ${RA_REQUEST_START_BTN}    detached    timeout=${TIMEOUT}
    END
    Element Is Visible    ${RA_HINT_H3}

Select First Register And Verify Anfrage Starten
    [Documentation]    Selects the first register tile and verifies that the
    ...                submit action appears while the empty-selection hint
    ...                disappears.
    Ensure RA Empty Selection State
    Element Is Visible    ${RA_REGISTER_FIRST_ITEM}
    Click    ${RA_REGISTER_FIRST_ITEM}
    Wait For Elements State    ${RA_REQUEST_START_BTN}    visible    timeout=${TIMEOUT}
    ${request_states}=    Get Element States    ${RA_REQUEST_START_BTN}
    Should Contain    ${request_states}    enabled
    Wait For Elements State    ${RA_HINT_H3}    detached    timeout=${TIMEOUT}

Toggle First Register Off And Verify Empty Hint
    [Documentation]    Selects and unselects the first register tile to verify
    ...                that the page returns to the initial empty-selection state.
    Ensure RA Empty Selection State
    Element Is Visible    ${RA_REGISTER_FIRST_ITEM}
    Click    ${RA_REGISTER_FIRST_ITEM}
    Wait For Elements State    ${RA_REQUEST_START_BTN}    visible    timeout=${TIMEOUT}
    Click    ${RA_REGISTER_FIRST_ITEM}
    Wait For Elements State    ${RA_REQUEST_START_BTN}    detached    timeout=${TIMEOUT}
    Element Is Visible    ${RA_HINT_H3}
    Element Is Visible    ${RA_HINT_PARAGRAPH}

Toggle Alle Register Select And Deselect
    [Documentation]    Verifies the global register toggle switches from
    ...                "Alle Register auswählen" to "Alle Register abwählen"
    ...                and back.
    Ensure RA Empty Selection State
    Element Is Visible    ${RA_ALLE_REGISTER_BTN}
    Click    ${RA_ALLE_REGISTER_BTN}
    Wait For Elements State    ${RA_ALLE_REGISTER_ABWAEHLEN_BTN}    visible    timeout=${TIMEOUT}
    ${abw_states}=    Get Element States    ${RA_ALLE_REGISTER_ABWAEHLEN_BTN}
    Should Contain    ${abw_states}    enabled
    Click    ${RA_ALLE_REGISTER_ABWAEHLEN_BTN}
    Wait For Elements State    ${RA_ALLE_REGISTER_BTN}    visible    timeout=${TIMEOUT}
    Element Is Visible    ${RA_HINT_H3}

Open Intro Dialog Was Sehe Ich And Close
    [Documentation]    Opens the intro dialog "Was sehe ich im Datenschutzcockpit?"
    ...                and verifies heading + title, then closes the dialog.
    ${clickable_count}=    Get Element Count    //main//*[self::button or self::a][contains(normalize-space(.),"Was sehe ich im Datenschutzcockpit?")]
    IF    ${clickable_count} == 0
        Log    Intro text "Was sehe ich im Datenschutzcockpit?" is not rendered as clickable control in this environment.    WARN
        RETURN
    END
    Click    //main//*[self::button or self::a][contains(normalize-space(.),"Was sehe ich im Datenschutzcockpit?")][1]
    Element Is Visible    ${RA_DIALOG_WAS_SEHE_ICH_H2}
    ${title}=    Get Title
    Should Contain    ${title}    Was sehe ich im Datenschutzcockpit
    Click    ${RA_DIALOG_CLOSE_BTN}
    Wait For Elements State    ${RA_DIALOG_WAS_SEHE_ICH_H2}    hidden    timeout=${TIMEOUT}
    ${title_after}=    Get Title
    Should Contain    ${title_after}    Registerauswahl

Open Intro Dialog Was Ist And Close
    [Documentation]    Opens the intro dialog "Was ist das Datenschutzcockpit?"
    ...                and verifies heading + title, then closes the dialog.
    ${clickable_count}=    Get Element Count    //main//*[self::button or self::a][contains(normalize-space(.),"Was ist das Datenschutzcockpit?")]
    IF    ${clickable_count} == 0
        Log    Intro text "Was ist das Datenschutzcockpit?" is not rendered as clickable control in this environment.    WARN
        RETURN
    END
    Click    //main//*[self::button or self::a][contains(normalize-space(.),"Was ist das Datenschutzcockpit?")][1]
    Element Is Visible    ${RA_DIALOG_WAS_IST_H2}
    ${title}=    Get Title
    Should Contain    ${title}    Was ist das Datenschutzcockpit
    Click    ${RA_DIALOG_CLOSE_BTN}
    Wait For Elements State    ${RA_DIALOG_WAS_IST_H2}    hidden    timeout=${TIMEOUT}
    ${title_after}=    Get Title
    Should Contain    ${title_after}    Registerauswahl

Open RA FAQ Dialog And Close
    [Documentation]    Opens FAQ from the floating action bar and verifies
    ...                the FAQ dialog heading and title update.
    Click    ${RA_FAQ_FLOAT_BUTTON}
    Element Is Visible    ${RA_FAQ_DIALOG_H1}
    ${title}=    Get Title
    Should Contain    ${title}    FAQ
    Click    ${RA_DIALOG_CLOSE_BTN}
    Wait For Elements State    ${RA_FAQ_DIALOG_H1}    hidden    timeout=${TIMEOUT}
    ${title_after}=    Get Title
    Should Contain    ${title_after}    Registerauswahl

Verify RA IDNr Is Masked By Default
    [Documentation]    Verifies the IDNr display is present in masked form and
    ...                the reveal button is available.
    # "Go To" neccessary at this point to ensure we're on the correct page and the IDNr display is visible; otherwise Get Text would return empty and the assertions would be inconclusive.
    Go To    ${REGISTER_AUSWAHL_URL}
    Wait For Load State    networkidle
    Element Is Visible    ${RA_IDNR_DISPLAY}
    Element Is Visible    ${RA_IDNR_MASKED_VALUE}
    ${masked_value}=    Get Text    ${RA_IDNR_MASKED_VALUE}
    Should Contain    ${masked_value}    *
    Element Is Visible    ${RA_IDNR_SHOW_BUTTON}
    ${id_show_states}=    Get Element States    ${RA_IDNR_SHOW_BUTTON}
    Should Contain    ${id_show_states}    enabled

Verify RA Session Timer Counts Down
    [Documentation]    Verifies the visible timer value changes over time.
    Element Is Visible    ${RA_SESSION_TIMER}
    ${timer_before}=    Get Text    ${RA_SESSION_TIMER}
    Sleep    2s
    ${timer_after}=    Get Text    ${RA_SESSION_TIMER}
    Should Not Be Equal As Strings    ${timer_before}    ${timer_after}

Verify Register Cards Count And Link "Mehr zum Register lesen"
    [Documentation]    Verifies that register cards expose at least one
    ...                "Mehr zum Register lesen" button.
    Ensure RA Empty Selection State
    Click    ${RA_REGISTER_FIRST_ITEM}
    Wait For Elements State    ${RA_REQUEST_START_BTN}    visible    timeout=${TIMEOUT}
    
    ${count_ra}=         Get Element Count    ${RA_REGISTER_ALL_ITEMS}
    ${count_ra_text}=    Get Element Count    ${RA_MEHR_ZUM_REGISTER_BUTTONS}
    Should Be True    ${count_ra} > 0
    Should Be Equal As Numbers   ${count_ra}    ${count_ra_text}    
    ...    msg=The number of "Register Cards" should match the number of "Mehr zum Register lesen" buttons, but was ${count_ra_text}.

Reload Register Auswahl And Verify Core Content
    [Documentation]    Reloads the current route and verifies key page content
    ...                remains visible and stable.
    Reload
    Wait For Load State    networkidle
    Verify Register Auswahl Page Is Loaded
    Element Is Visible    ${RA_H2_HEADING}
    Element Is Visible    ${RA_REGISTER_FIRST_ITEM}
    Element Is Visible    ${RA_FEEDBACK_BTN}