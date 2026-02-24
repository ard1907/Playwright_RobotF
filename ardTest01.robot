*** Settings ***
# auto_closing_level=MANUAL verhindert das automatische Schließen  'TEST'
# Library    Browser    auto_closing_level=KEEP
Library    Browser
Library    Dialogs

*** Test Cases ***
Simple Login
    New Browser    chromium    headless=${False}
    New Page       https://rahulshettyacademy.com/client/#/auth/login
    Fill Text      id=userEmail    duck@duck.com
    Fill Text      id=userPassword    Hello122U
    Click          id=login
    Wait For Elements State    text=Automation Practice    visible
    Pause Execution
    # Close Browser
