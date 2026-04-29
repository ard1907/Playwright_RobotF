# ==============================================================================
# authentication_info_page.robot  –  Page Object for the Authentication Info Page
#
# URL   : https://qs-datenschutzcockpit.dsc.govkg.de/spa/authentication-info
# Title : Datenschutzcockpit - Anmeldung
#
# This page explains the eID login process: which hardware/software is needed
# (AusweisApp, compatible card reader), how to start the login, and embeds
# the three login-related FAQ card items directly on the page.
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
Library     OperatingSystem
Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot

*** Variables ***

# ── Header Accessibility Buttons ───────────────────────────────────────────────
# These header buttons are shared across all SPA pages (same component).
${AI_EASY_LANGUAGE_BTN}        role=button[name="Das Datenschutzcockpit in Leichter Sprache"]
${AI_SIGN_LANGUAGE_BTN}        role=button[name="Zum Gebärdensprache-Video"]
${AI_DIALOG}                   role=dialog


# ── Logo / Brand ───────────────────────────────────────────────────────────────
${AI_LOGO_LINK}                role=link[name="Bund.de Datenschutzcockpit Beta Logo"]


# ── Main Content ───────────────────────────────────────────────────────────────
# NOTE: After first run verify the exact H1 wording on this page.
# ${AI_H1_HEADING}               role=heading[level=1]
${AI_H1_HEADING}               //h1[text()="Anmeldung"]

# ── Login Page External URLs ───────────────────────────────────────────────────────
&{AI_EXTERNAL_URLs}                  AusweisApp=https://www.ausweisapp.bund.de/software/downloads/
...                                  Lesegeraete=https://www.ausweisapp.bund.de/kompatible-kartenleser
...                                  AI_Card_1_PIN=https://www.personalausweisportal.de/Webs/PA/DE/buergerinnen-und-buerger/online-ausweisen/pin-brief/pin-brief-node.html
...                                  AI_Card_1_Kartenleser=https://www.ausweisapp.bund.de/kompatible-kartenleser
...                                  AI_Card_1_Software=https://www.personalausweisportal.de/Webs/PA/DE/buergerinnen-und-buerger/online-ausweisen/software/software-node.html
...                                  AI_Card_2_Mehr_Infos=https://www.ausweisapp.bund.de/home/
...                                  AI_Card_2_Mehr_Infos_2=https://www.ausweisapp.bund.de/
...                                  AI_Card_2_Personalausweis=https://www.personalausweisportal.de/Webs/PA/DE/startseite/startseite-node.html


# ── Login Page Information Links ───────────────────────────────────────────────────
# Both links open in a new browser tab (target="_blank") to external resources.
# ${AI_LESEGERAET_LINK}          role=link[name="kompatibles Lesegerät"]
${AI_LESEGERAET_LINK}          //a[text()="kompatibles Lesegerät"]
# ${AI_AUSWEIS_APP_LINK}         role=link[name="AusweisApp"]
${AI_AUSWEIS_APP_LINK}         //a[text()="AusweisApp"]


# ── AusweisApp Start Button ────────────────────────────────────────────────────
# "AusweisApp starten" initiates the eID authentication flow.
# We verify presence and accessibility only – we do NOT trigger the eID flow.
# Use the stable data-testid from the live page to avoid role-selector timing issues.
${AI_AUSWEIS_START_BTN}                      data-testid=anmeldungAusweisBtn
${AI_AUSWEIS_START_BTN_TITLE}                id=authentication-title
${AI_AUSWEIS_START_BTN_INSTALL}              //div[text()="Installation"]
${AI_AUSWEIS_START_BTN_ALREADY_INSTALLED}    data-testid=redirectToNPABtn
${AI_POPUP_CLOSE_BTN}                        (//button[@aria-label="Popup schließen"])[2]
${AI_LOGIN_SUCCESS_HEADING}                   //h1[text()="Wonach wollen Sie suchen?"]


# ── Footer Navigation (same component as landing page) ────────────────────────
${AI_IMPRESSUM_BTN}            role=button[name="Impressum"]
${AI_DATENSCHUTZ_BTN}          role=button[name="Datenschutz"]
${AI_BARRIEREFREIHEIT_BTN}     role=button[name="Barrierefreiheit"]
${AI_VERSION_TEXT}             text=Datenschutzcockpit Version

# ── Floating FAQ Sidebar Button ────────────────────────────────────────────────
${AI_FAQ_FLOAT_BUTTON}         role=button[name="FAQ"]


# ── Auth Info Cards Variables ─────────────────────────────────────────────────
&{AI_CARDS_TAB_TITLES}          NEEDED_TAB_TITLE=Datenschutzcockpit - Was benötige ich für die Anmeldung 
...                            REGISTER_TAB_TITLE=Datenschutzcockpit - Wie melde ich mich mit der AusweisApp an
...                            SECURE_TAB_TITLE=Datenschutzcockpit - Wie sicher ist das Datenschutzcockpit


# ── Card: Was benötige ich für die Anmeldung? ─────────────────────────────────
${AI_FAQ_CARD_NEEDED}
...    //h3[text()="Was benötige ich für die Anmeldung?"]                     # closed state = default state
${AI_FAQ_CARD_NEEDED_OPEN}
...    //div[@class="modal" and @aria-hidden="false"]//h1[text()="Was benötige ich für die Anmeldung?"]   # open state has H1 instead of H3
${AI_FAQ_WN_PERSONALAUSWEIS}   (//li[contains(text(),"Personalausweis")])[2]
${AI_FAQ_WN_TITEL_H2}          //h2[contains(text(),"Sie benötigen für die Anmeldung:")]
${AI_FAQ_WN_EXT_LINK_01}       //a[contains(text(),"Mehr Informationen zur PIN")]
${AI_FAQ_WN_EXT_LINK_02}       //a[contains(text(),"Mehr Informationen zu geeigneten Smartphones und Kartenlesern")]
${AI_FAQ_WN_EXT_LINK_03}       //a[contains(text(),"Mehr Informationen zur Software")]


# ── Card: Wie melde ich mich mit der AusweisApp an? ────────────────────────────
${AI_FAQ_CARD_REGISTER}
...    //h3[text()="Wie melde ich mich mit der AusweisApp an?"]               # closed state = default state

${AI_FAQ_CARD_REGISTER_OPEN}
...    //div[@class="modal" and @aria-hidden="false"]//h1[text()="Wie melde ich mich mit der AusweisApp an?"]   # open state has H1 instead of H3
${AI_FAQ_AL_SCHRITT}           text=Schritt

${AI_FAQ_AL_EXT_LINK_01}       (//a[contains(text(),"Online-Ausweisfunktion")])[1]
${AI_FAQ_AL_EXT_LINK_02}       (//a[contains(text(),"Online-Ausweisfunktion")])[2]
${AI_FAQ_AL_EXT_LINK_03}       //a[contains(text(),"Personalausweisportal")]


# ── Card: Wie sicher ist das Datenschutzcockpit? ───────────────────────────────
${AI_FAQ_CARD_SECURE}
...    //h3[text()="Wie sicher ist das Datenschutzcockpit?"]                  # closed state = default state
${AI_FAQ_CARD_SECURE_OPEN}
...    //div[@class="modal" and @aria-hidden="false"]//h1[text()="Wie sicher ist das Datenschutzcockpit?"]   # open state has H1 instead of H3
${AI_FAQ_HS_SICHER}              text=sicher >> nth=2
${AI_FAQ_HS_YOUR_LOGIN}          //h2[contains(text(),"Ihre Anmeldung")]
${AI_FAQ_HS_YOUR_DATA}           //h2[contains(text(),"Datenübermittlungen anzeigen")]
${AI_FAQ_HS_YOUR_LOGOUT}         //h2[contains(text(),"Ihre Abmeldung")]
# ─────────────────────────────────────────────────────────────────────────────────

*** Keywords ***

# ── Page-Level Assertions ──────────────────────────────────────────────────────
Login Into Datenschutzcockpit
    [Documentation]    Navigates to the authentication info page URL and waits
    ...                for the main H1 heading to be visible, confirming the
    ...                page has loaded and rendered. Then clicks button  "AusweisApp starten"
    ...                and login into Datenschutzcockpit with AusweisApp (Docker).
    Skip Current Test If AusweisApp Environment Is Missing
    ${url}=            Get Url
    IF    "authentication-info" not in """${url}"""
        Navigate To Authentication Info Page
    END
    # If running in CI and on a self-hosted environment, ensure AusweisApp links opened by the SPA are redirected to the SDK service
    ${_ausw_url}=    Get Environment Variable    AUSWEISAPP_URL    ${EMPTY}
    IF   ${CI} and ${CI_SELF_HOSTED}
        Evaluate JavaScript    ${None}    () => { window.open = (function(orig) { return function(url, name, features) { try { url = url.replace('http://127.0.0.1:24727', '${_ausw_url}'); } catch (error) {} return orig.apply(this, [url, name, features]); }; })(window.open); }
    END

    Click                    ${AI_AUSWEIS_START_BTN}
    Click                    ${AI_AUSWEIS_START_BTN_ALREADY_INSTALLED}
    Sleep                    2s       #ARD: Just for Demo purposes. Plse remove in real test run to avoid unnecessary wait time.
    Element Is Visible       ${AI_LOGIN_SUCCESS_HEADING}
    Sleep                    3s       #ARD: Just for Demo purposes. Plse remove in real test run to avoid unnecessary wait time.

Verify Authentication Info Page Is Loaded
    [Documentation]    Confirms the SPA has routed to the auth-info page:
    ...                page title contains "Anmeldung" and the H1 heading is
    ...                visible (proves the component has rendered).
    Verify Page Title Contains    ${TITLE_AUTH_INFO}
    Element Is Visible    ${AI_H1_HEADING}

Verify Auth Page H1 Heading
    [Documentation]    Asserts the primary H1 heading is rendered on the page.
    Element Is Visible    ${AI_H1_HEADING}

Verify Auth Page Logo
    [Documentation]    Checks the Datenschutzcockpit logo/home link is visible.
    Element Is Visible    ${AI_LOGO_LINK}

Verify Auth Page Header Accessibility Buttons
    [Documentation]    Checks that the logo link and both accessibility buttons
    ...                in the shared SPA header are visible and enabled on this page:
    ...                  • Bund.de Datenschutzcockpit Beta Logo (link)
    ...                  • Das Datenschutzcockpit in Leichter Sprache (button)
    ...                  • Zum Gebärdensprache-Video (button)
    Element Is Visible    ${AI_LOGO_LINK}
    ${logo_states}=    Get Element States    ${AI_LOGO_LINK}
    Should Contain    ${logo_states}    enabled
    Element Is Visible    ${AI_EASY_LANGUAGE_BTN}
    ${ls_states}=    Get Element States    ${AI_EASY_LANGUAGE_BTN}
    Should Contain    ${ls_states}    enabled
    Element Is Visible    ${AI_SIGN_LANGUAGE_BTN}
    ${gs_states}=    Get Element States    ${AI_SIGN_LANGUAGE_BTN}
    Should Contain    ${gs_states}    enabled

Verify Auth Page Footer Navigation
    [Documentation]    Verifies all three footer navigation buttons are visible
    ...                and enabled, consistent with all SPA routes sharing the
    ...                same footer.
    Element Is Visible    ${AI_IMPRESSUM_BTN}
    ${imp_states}=    Get Element States    ${AI_IMPRESSUM_BTN}
    Should Contain    ${imp_states}    enabled
    Element Is Visible    ${AI_DATENSCHUTZ_BTN}
    ${dat_states}=    Get Element States    ${AI_DATENSCHUTZ_BTN}
    Should Contain    ${dat_states}    enabled
    Element Is Visible    ${AI_BARRIEREFREIHEIT_BTN}
    ${bar_states}=    Get Element States    ${AI_BARRIEREFREIHEIT_BTN}
    Should Contain    ${bar_states}    enabled

Verify Auth Page Version Info
    [Documentation]    Checks that the application version string is present in
    ...                the footer, confirming the correct asset bundle loaded.
    Element Is Visible    ${AI_VERSION_TEXT}

Verify Auth Page FAQ Float Button
    [Documentation]    Checks that the floating FAQ button is visible and enabled
    ...                on the auth-info page, consistent with all SPA routes that
    ...                share the same floating action bar.
    Element Is Visible    ${AI_FAQ_FLOAT_BUTTON}
    ${faq_states}=    Get Element States    ${AI_FAQ_FLOAT_BUTTON}
    Should Contain    ${faq_states}    enabled

Verify AusweisApp Link Is Present
    [Documentation]    Checks the "AusweisApp" in-text link is visible on the page
    ...                so users can download / open the app.
    Element Is Visible    ${AI_AUSWEIS_APP_LINK}

Verify Lesegeraet Link Is Present
    [Documentation]    Checks the "kompatibles Lesegerät" in-text link is visible.
    Element Is Visible    ${AI_LESEGERAET_LINK}

Verify AusweisApp Start Button Is Present
    [Documentation]    Confirms the "AusweisApp starten" button is visible and
    ...                enabled on the page.
    Element Is Visible    ${AI_AUSWEIS_START_BTN}
    ${states}=    Get Element States    ${AI_AUSWEIS_START_BTN}
    Should Contain    ${states}    enabled
    ${url}=    Get Url
    Should Contain    ${url}    authentication-info
    ${text}=    Get Text    ${AI_AUSWEIS_START_BTN}
    Should Contain    ${text}    AusweisApp
    Should Contain    ${states}    visible    

Verify AusweisApp Start Button After Click
    [Documentation]    After "AusweisApp starten" button clicked, 
    ...                verifies if buttons "Installation" and "Bereits installiert"
    ...                are visible and enabled on the page. 
    ...                Does NOT click – avoids triggering
    ...                the live eID authentication flow during smoke testing.
    Click                  ${AI_AUSWEIS_START_BTN}
    Element Is Visible     ${AI_AUSWEIS_START_BTN_TITLE}    
    ${text}=    Get Text   ${AI_AUSWEIS_START_BTN_INSTALL}
    Should Be Equal As Strings    ${text}    Installation
    ${states}=    Get Element States    ${AI_AUSWEIS_START_BTN_INSTALL}
    Should Contain    ${states}    enabled  visible
    ${url}=    Get Url
    Should Contain    ${url}    authentication-info

    ${states}=    Get Element States    ${AI_AUSWEIS_START_BTN_ALREADY_INSTALLED}
    Should Contain    ${states}    enabled  visible
    ${text}=    Get Text    ${AI_AUSWEIS_START_BTN_ALREADY_INSTALLED}
    Should Be Equal As Strings    ${text}    Bereits installiert
    Click    ${AI_POPUP_CLOSE_BTN}

Verify Auth Page FAQ Card "Was Benötige Ich ..."
    [Documentation]    Checks the presence of the "Was benötige ich für die Anmeldung?"
    ...                FAQ card on the auth-info page in its default closed state.
    Element Is Visible    ${AI_FAQ_CARD_NEEDED}
    Click On Card - Was Benötige Ich ...
    # 1. Card is now in open state
    Element Is Visible    ${AI_FAQ_CARD_NEEDED_OPEN}
    # 2 & 3. Key terms exist in the now-visible expanded panel
    Element Is Visible    ${AI_FAQ_WN_PERSONALAUSWEIS}
    Element Is Visible    ${AI_FAQ_WN_TITEL_H2}
    Element Is Visible    ${AI_FAQ_WN_EXT_LINK_01}
    Element Is Visible    ${AI_FAQ_WN_EXT_LINK_02}
    Element Is Visible    ${AI_FAQ_WN_EXT_LINK_03}
    # 4. URL still on auth-info page
    ${url}=      Get Url
    Should Contain    ${url}    authentication-info
    ${title}=    Get Title
    Should Be Equal As Strings   ${title}    ${AI_CARDS_TAB_TITLES}[NEEDED_TAB_TITLE]
    # 5. Other cards are still rendered
    Element Is Visible    ${AI_FAQ_CARD_REGISTER}
    Element Is Visible    ${AI_FAQ_CARD_SECURE}

Verify Auth Page FAQ Card "Wie Melde Ich Mich ..."
    [Documentation]    Checks the presence of the "Wie melde ich mich mit der AusweisApp an?"
    ...                FAQ card on the auth-info page in its default closed state.
    Element Is Visible    ${AI_FAQ_CARD_REGISTER}
    Click On Card - Wie Melde Ich Mich An ...
    # 1. Card is now in open state
    Element Is Visible    ${AI_FAQ_CARD_REGISTER_OPEN}
    # 2 & 3. Key terms exist in the now-visible expanded panel
    Element Is Visible    ${AI_FAQ_AL_SCHRITT}
    # 4. URL still on auth-info page
    ${url}=      Get Url
    Should Contain    ${url}    authentication-info
    ${title}=    Get Title
    Should Be Equal As Strings   ${title}    ${AI_CARDS_TAB_TITLES}[REGISTER_TAB_TITLE]
    # 5. Other cards are still rendered
    Element Is Visible    ${AI_FAQ_CARD_NEEDED}
    Element Is Visible    ${AI_FAQ_CARD_SECURE}

Verify Auth Page FAQ Card "Wie Sicher Ist Das Cockpit ..."
    [Documentation]    Checks the presence of the "Wie sicher ist das Datenschutzcockpit?"
    ...                FAQ card on the auth-info page in its default closed state.
    Element Is Visible    ${AI_FAQ_CARD_SECURE}
    Click On Card - Wie Sicher ist ...
    # 1. Card is now in open state
    Element Is Visible    ${AI_FAQ_CARD_SECURE_OPEN}
    # 2 & 3. Key terms exist in the now-visible expanded panel
    Element Is Visible    ${AI_FAQ_HS_SICHER}
    Element Is Visible    ${AI_FAQ_HS_YOUR_LOGIN}
    Element Is Visible    ${AI_FAQ_HS_YOUR_DATA}
    Element Is Visible    ${AI_FAQ_HS_YOUR_LOGOUT}
    # 4. URL still on auth-info page
    ${url}=      Get Url
    Should Contain    ${url}    authentication-info
    ${title}=    Get Title
    Should Be Equal As Strings   ${title}    ${AI_CARDS_TAB_TITLES}[SECURE_TAB_TITLE]
    # 5. Other cards are still rendered
    Element Is Visible    ${AI_FAQ_CARD_REGISTER}
    Element Is Visible    ${AI_FAQ_CARD_NEEDED}

Verify Auth Page FAQ Card Items
    [Documentation]    Checks all three embedded FAQ card buttons are
    ...                rendered in their default closed state.
    Element Is Visible    ${AI_FAQ_CARD_NEEDED}
    Element Is Visible    ${AI_FAQ_CARD_REGISTER}
    Element Is Visible    ${AI_FAQ_CARD_SECURE}


# ── Dialog Navigation ──────────────────────────────────────────────────────────

Open Leichte Sprache Dialog From Auth Page
    [Documentation]    Clicks the "Leichte Sprache" header button on the auth-info
    ...                page and waits for the corresponding dialog to appear.
    Click    ${AI_EASY_LANGUAGE_BTN}
    Wait For Elements State    ${AI_DIALOG}    visible    timeout=${TIMEOUT}

Open Gebaerdensprache Dialog From Auth Page
    [Documentation]    Clicks the "Gebärdensprache-Video" header button on the
    ...                auth-info page and waits for the dialog to appear.
    Click    ${AI_SIGN_LANGUAGE_BTN}
    Wait For Elements State    ${AI_DIALOG}    visible    timeout=${TIMEOUT}


# ── FAQ Card Interactions ─────────────────────────────────────────────────

Click On Card - Was Benötige Ich ...
    [Documentation]    Clicks the "Was benötige ich für die Anmeldung?" card
    ...                button and waits for it to switch to the open state.
    Click    ${AI_FAQ_CARD_NEEDED}
    Wait For Elements State    ${AI_FAQ_CARD_NEEDED_OPEN}    visible    timeout=${TIMEOUT}

Click On Card - Wie Melde Ich Mich An ...
    [Documentation]    Clicks the "Wie melde ich mich mit der AusweisApp an?"
    ...                card button and waits for it to switch to open state.
    Click    ${AI_FAQ_CARD_REGISTER}
    Wait For Elements State    ${AI_FAQ_CARD_REGISTER_OPEN}    visible    timeout=${TIMEOUT}

Click On Card - Wie Sicher ist ...
    [Documentation]    Clicks the "Wie sicher ist das Datenschutzcockpit?"
    ...                card button and waits for it to switch to open state.
    Click    ${AI_FAQ_CARD_SECURE}
    Wait For Elements State    ${AI_FAQ_CARD_SECURE_OPEN}    visible    timeout=${TIMEOUT}


# ── Aggregate Validation ───────────────────────────────────────────────────────

Validate Authentication Info Page
    [Documentation]    Master keyword – runs all auth-info page smoke assertions.
    ...                Covers: title, H1, logo, header buttons, FAQ float button,
    ...                external links, AusweisApp starten button, footer, version,
    ...                and FAQ items.
    Verify Authentication Info Page Is Loaded
    Verify Auth Page H1 Heading
    Verify Auth Page Logo
    Verify Auth Page Header Accessibility Buttons
    Verify Auth Page FAQ Float Button
    Verify Auth Page Footer Navigation
    Verify Auth Page Version Info
    Verify AusweisApp Link Is Present
    Verify Lesegeraet Link Is Present
    Verify AusweisApp Start Button Is Present
    Verify Auth Page FAQ Card Items


# ── New-Tab External Link Flows ────────────────────────────────────────────────

Open AusweisApp External Tab And Validate
    [Documentation]    Clicks the "AusweisApp" in-text link, which opens the
    ...                official AusweisApp website in a new browser tab.
    ...                Assertions on the target page:
    ...                  -- URL contains "ausweisapp"
    ...                  -- Page title is not empty
    ...                  -- Title contains "AusweisApp"
    ...                  -- At least one H1 heading is visible
    ...                After verification the new tab is closed and focus returns.
    Verify AusweisApp Link Is Present
    Click    ${AI_AUSWEIS_APP_LINK}
    Switch To Newly Opened Tab
    # ── Assertions on the AusweisApp external page ─────────────────────────────
    ${url}=                       Get Url
    Should Be Equal As Strings    ${url}    ${ASWAPP_DWLD_URL}
    ${title}=                     Get Title
    Should Not Be Empty           ${title}
    Should Be Equal As Strings    ${title}    ${ASWAPP_DWLD_TITLE}
    Element Is Visible            ${ASWAPP_DWLD_H1}
    # ── Return to auth-info page ───────────────────────────────────────────────
    Close Current Tab And Return

Open Lesegeraet External Tab And Validate
    [Documentation]    Clicks the "kompatibles Lesegerät" in-text link, which
    ...                opens the list of compatible card readers in a new tab.
    ...                Assertions on the target page:
    ...                  -- URL is not empty (navigation succeeded)
    ...                  -- Page title is not empty
    ...                  -- At least one heading is visible
    ...                After verification the new tab is closed and focus returns.
    Verify Lesegeraet Link Is Present
    Click    ${AI_LESEGERAET_LINK}
    Switch To Newly Opened Tab
    # ── Assertions on the Lesegerät reference page ─────────────────────────────
    ${url}=    Get Url
    Should Not Be Empty    ${url}
    Should Be Equal As Strings    ${url}    ${ASWAPP_DEVICES_URL}
    ${title}=    Get Title
    Should Not Be Empty    ${title}
    Should Be Equal As Strings    ${title}    ${ASWAPP_DEVICES_TITLE}
    Element Is Visible    ${ASWAPP_DEVICES_H1}
    # ── Return to auth-info page ───────────────────────────────────────────────
    Close Current Tab And Return

Validate External URL For AusweisApp
    [Documentation]    Validates that the "AusweisApp" in-text link has the correct href URL before clicking.
    ...                This is a pre-click check to ensure the link points to the expected external resource, 
    ...                without relying on the new tab navigation.
    Get Attribute    ${AI_AUSWEIS_APP_LINK}   href   ==   ${AI_EXTERNAL_URLs}[AusweisApp]

Validate External URL For Lesegeraet
    [Documentation]    Validates that the "kompatibles Lesegerät" in-text link has the correct href URL before clicking.
    ...                This is a pre-click check to ensure the link points to the expected external resource, 
    ...                without relying on the new tab navigation.
    Get Attribute    ${AI_LESEGERAET_LINK}   href   ==    ${AI_EXTERNAL_URLs}[Lesegeraete]

Validate External URLs For Card - Was Benötige Ich ...
    [Documentation]    Validates that all three external links in the "Was benötige ich für die Anmeldung?" FAQ card have the correct href URLs before clicking.
    ...                This is a pre-click check to ensure the links point to the expected external resources, without relying on the new tab navigation.
    # Click On Card - Was Benötige Ich ...
    Get Attribute    ${AI_FAQ_WN_EXT_LINK_01}   href   ==   ${AI_EXTERNAL_URLs}[AI_Card_1_PIN]
    Get Attribute    ${AI_FAQ_WN_EXT_LINK_02}   href   ==   ${AI_EXTERNAL_URLs}[AI_Card_1_Kartenleser]
    Get Attribute    ${AI_FAQ_WN_EXT_LINK_03}   href   ==   ${AI_EXTERNAL_URLs}[AI_Card_1_Software]

Validate External URLs For Card - Wie Melde Ich Mich ...
    [Documentation]    Validates that all three external links in the "Wie melde ich mich mit der AusweisApp an?" FAQ card have the correct href URLs before clicking.
    ...                This is a pre-click check to ensure the links point to the expected external resources, without relying on the new tab navigation.
    # Click On Card - Wie Melde Ich Mich An ...
    Get Attribute    ${AI_FAQ_AL_EXT_LINK_01}   href   ==   ${AI_EXTERNAL_URLs}[AI_Card_2_Mehr_Infos]
    Get Attribute    ${AI_FAQ_AL_EXT_LINK_02}   href   ==   ${AI_EXTERNAL_URLs}[AI_Card_2_Mehr_Infos_2]
    Get Attribute    ${AI_FAQ_AL_EXT_LINK_03}   href   ==   ${AI_EXTERNAL_URLs}[AI_Card_2_Personalausweis]
     