# ============================================================================
# dsc_basic_test.robot  -  Standalone beginner suite for Robot Framework
#
# Purpose : Small, readable entry point for newcomers
# Pattern : Single-file suite with local variables, keywords, and tests
# Target  : https://qs-datenschutzcockpit.dsc.govkg.de/spa/
# ============================================================================

*** Settings ***
Library         Browser
Resource        ../../resources/dsc_variables.robot
Resource        ../../resources/dsc_setup_teardown.robot

Suite Setup     Open Application Browser
Suite Teardown  Close Application Browser
Test Setup      Navigate To Landing Page


*** Variables ***

${BASE_URL}                https://qs-datenschutzcockpit.dsc.govkg.de/spa/
${BROWSER}                 chromium
${HEADLESS}                ${False}
${TIMEOUT}                 10s

${TITLE_LANDING}           Datenschutzcockpit
${TITLE_LEICHTE_SPRACHE}   Leichte Sprache

${LP_H1_HEADING}           role=heading[name="Behalten Sie Ihre Daten im Blick"]
${LP_INTRO_TEXT}           text=Im Datenschutzcockpit sehen Sie
${LP_LOGIN_BUTTON}         //button[@id="button-anfrage-starten"]
${LP_FAQ_SECTION_HEADING}  role=heading[name="Häufige Fragen"]
${LP_FAQ_FLOAT_BUTTON}      role=button[name="FAQ"]
${LP_VERSION_TEXT}         text=Datenschutzcockpit Version

${LS_EASY_LANGUAGE_BTN}    role=button[name="Das Datenschutzcockpit in Leichter Sprache"]
${LS_DIALOG}               role=dialog
${LS_H1_HEADING}           (//h1[contains(text(), "Leichte Sprache")])[1]
${LS_COCKPIT_MENTION}      (//a[contains(text(), "Das sehen Sie im Daten-Schutz-Cockpit")])[1]
${LS_CLOSE_BTN}            role=button[name="Menü schließen"]


*** Keywords ***

Open Application Browser
    # New Browser    ${BROWSER}    headless=${HEADLESS}    # Use next line keyworkd to pass self-hosted workflow in docker containter.
    Open Chromium Browser
    New Context    locale=de-DE
    New Page       ${BASE_URL}
    Wait For Load State    networkidle

Close Application Browser
    Close Browser    ALL

Navigate To Landing Page
    Go To    ${BASE_URL}
    Wait For Load State    networkidle

Element Is Visible
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible    timeout=${TIMEOUT}

Verify Page Title Contains
    [Arguments]    ${expected_text}
    ${title}=    Get Title
    Should Contain    ${title}    ${expected_text}

Validate Landing Page
    Verify Page Title Contains    ${TITLE_LANDING}
    Element Is Visible    ${LP_H1_HEADING}
    Element Is Visible    ${LP_INTRO_TEXT}
    Element Is Visible    ${LP_LOGIN_BUTTON}
    Element Is Visible    ${LP_FAQ_SECTION_HEADING}
    Element Is Visible    ${LP_FAQ_FLOAT_BUTTON}
    Element Is Visible    ${LP_VERSION_TEXT}

Open Leichte Sprache Dialog
    Click    ${LS_EASY_LANGUAGE_BTN}
    Wait For Elements State    ${LS_DIALOG}    visible    timeout=${TIMEOUT}

Validate Leichte Sprache Page
    Verify Page Title Contains    ${TITLE_LEICHTE_SPRACHE}
    Element Is Visible    ${LS_DIALOG}
    Element Is Visible    ${LS_H1_HEADING}
    Element Is Visible    ${LS_COCKPIT_MENTION}
    Element Is Visible    ${LS_CLOSE_BTN}


*** Test Cases ***

TC001 - Validate Landing Page
    Validate Landing Page

TC002 - Navigate To Leichte Sprache And Validate
    Open Leichte Sprache Dialog
    Validate Leichte Sprache Page