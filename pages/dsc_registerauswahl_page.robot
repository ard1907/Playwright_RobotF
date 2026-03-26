# ==============================================================================
# dsc_registerauswahl_page.robot  –  Page Object for the Registerauswahl Page
#
# URL   : https://datenschutzcockpit.dsc.govkg.de/spa/cockpit/register-auswahl
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
Resource    ../resources/variables.robot
Resource    ../resources/common_keywords.robot

*** Variables ***
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
    