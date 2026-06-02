*** Settings ***
Library                            Browser
Resource                           ../../resources/dsc_setup_teardown.robot
Resource                           ../../pages/dsc_landing_page.robot


*** Variables ***
${LUP_TARGET_URL}                  https://datenschutzcockpit.bund.de/spa/
${LUP_BROWSER}                     chromium
${LUP_HEADLESS}                    ${True}
${LUP_SLOW_MOTION}                 0
${LUP_BROWSER_TIMEOUT}             30s
${LUP_EXPECTED_URL_FRAGMENT}       datenschutzcockpit.bund.de/spa/


*** Keywords ***
Open LUP Browser On Landing Page
    Set Browser Timeout    ${LUP_BROWSER_TIMEOUT}
    Open Application Browser    ${LUP_TARGET_URL}    ${LUP_BROWSER}    ${LUP_HEADLESS}    ${LUP_SLOW_MOTION}


Run Landing Page Parallel Probe
    Verify Landing Page Is Loaded
    ${current_url}=    Get Url
    Should Contain    ${current_url}    ${LUP_EXPECTED_URL_FRAGMENT}
    ${metrics}=    Evaluate JavaScript    ${None}
    ...    () => {
    ...        const navigation = performance.getEntriesByType('navigation')[0];
    ...        return JSON.stringify({
    ...            url: window.location.href,
    ...            title: document.title,
    ...            readyState: document.readyState,
    ...            domContentLoadedMs: navigation ? Math.round(navigation.domContentLoadedEventEnd) : null,
    ...            loadEventEndMs: navigation ? Math.round(navigation.loadEventEnd) : null,
    ...            responseEndMs: navigation ? Math.round(navigation.responseEnd) : null
    ...        });
    ...    }
    Log    LUP probe metrics: ${metrics}
    Log To Console    LUP probe metrics: ${metrics}
