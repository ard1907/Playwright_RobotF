*** Settings ***
# auto_closing_level=MANUAL verhindert das automatische Schließen  'TEST'
# Library    Browser    auto_closing_level=KEEP
Library    Browser
Library    Dialogs

*** Test Cases ***
Simple Login
    New Browser    chromium    headless=${False}
    New Page       https://www.digitale-verwaltung.de/Webs/DV/DE/startseite/startseite-node.html
    #Fill Text      id=userEmail    duck@duck.com
    # Fill Text      id=userPassword    Hello122U
    Click           id=n-3    #//*[@id="n-3"]
    Wait For Elements State    text=Zeitplan zur Umsetzung der Registermodernisierung    visible
    Pause Execution
    # Close Browser
