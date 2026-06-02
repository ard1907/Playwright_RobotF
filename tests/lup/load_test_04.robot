*** Settings ***
Resource    ./lup_common.robot

Suite Setup    Open LUP Browser On Landing Page
Suite Teardown    Close Application Browser

*** Test Cases ***
Open Landing Page
    [Tags]    load    performance    landing    production
    Run Landing Page Parallel Probe