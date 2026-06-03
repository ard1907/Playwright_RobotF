*** Settings ***
Documentation       Minimal usage example for the portable InterceptCrypt keyword.
...                 Copy TA/resources/InterceptCryptLibrary.py into the real TA repo.
Library             Browser
Library             ../resources/InterceptCryptLibrary.py


*** Variables ***
${DSC_BASE_URL}             https://qs-datenschutzcockpit.dsc.govkg.de/spa/
${REGISTER_DATA_ENDPOINT}   **/api/register-data/load-data


*** Test Cases ***
Intercept Decrypted Register Data
    [Documentation]    Install the hook before the UI action that triggers encrypted DSC register data.
    New Browser    chromium    headless=${False}
    New Page    ${DSC_BASE_URL}

    # Do the regular login/navigation steps from the real TA suite here.
    # The hook must be installed after the page exists and before the API-triggering click.
    Start Crypt Intercept    ${REGISTER_DATA_ENDPOINT}

    # Example only. Replace with the real action in the TA suite.
    # Click    [data-testid="anfrageStartenBtn"]

    ${response}=    Wait For Crypt Response    matcher=${REGISTER_DATA_ENDPOINT}    timeout=120s    expected_text=antwortListeProtokolldaten
    Should Be Equal    ${response}[algorithm]    AES-GCM
    Should Contain    ${response}[plaintext_xml]    antwortListeProtokolldaten

    Close Browser