*** Settings ***
Resource       ./lup_common.robot

Test Setup     Open LUP Browser On Landing Page
Test Teardown  Close Application Browser


*** Test Cases ***
LUP Probe Test 01
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 02
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 03
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 04
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 05
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 06
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 07
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 08
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 09
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 10
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 11
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 12
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 13
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 14
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 15
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 16
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 17
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 18
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 19
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe

LUP Probe Test 20
    [Tags]    load    performance    landing    production    testlevelsplit
    Run Landing Page Parallel Probe
