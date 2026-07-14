# ===============================================================================
# ts_07_register_cards_generic_api_test.robot  –  Generic Register Card
#                                          Test Suite
#                                                     (API-Response Verification)
#
# Tests any number of register cards by comparing the live
# "Persönliche Daten anfragen" API response after browser-side decryption
# against stored JSON fixtures.
# Each register card is one test case (static list); adding a new card means
# adding one verification test + one first-run-api test + two JSON fixtures.
#
# ── Relation to ts_06 ─────────────────────────────────────────────────────────
# This suite is the API-response counterpart of
# ts_06_register_cards_generic_dom_test.robot:
#
#   ts_06  → dialog-content verification against DOM / YAML fixtures
#             (test_data/registers/<tag>.yaml)
#   ts_07 → API-response verification against decrypted JSON fixtures
#             (test_data/registers/<tag>.json + <tag>_raw.json)
#
# Both suites exist independently; neither modifies the other.
# The decryption uses a BrowserLibrary JS extension to capture XHR traffic
# and crypto.subtle.decrypt calls from the app's main thread.
#
# ── Two Operating Modes ───────────────────────────────────────────────────────
#
#   Normal mode (default run):
#     robotcode --profile default robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
#     Loads each JSON fixture and compares the live API response against it.
#     Requires: fixture populated by a prior first-run-api execution.
#     Skip note: test is skipped (not failed) when the fixture is absent or
#                not yet marked as completed.
#
#   First-run-api mode (data capture):
#     robotcode --profile default --profile first-run-api robot \
#           --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
#     Drives the full workflow, captures the encrypted API response, decrypts it
#     in the browser, and writes (or updates) the JSON fixture pair.
#     By default, skips writing when a fixture already exists and is completed.
#
#   First-run-api with forced overwrite:
#     robotcode --profile default --profile first-run-api-force robot \
#           --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
#
# ── Fixture File Convention ───────────────────────────────────────────────────
#   test_data/registers/<tag>.json       processed decrypted key/value payload
#   test_data/registers/<tag>_raw.json   verbatim decrypted XML payload
#   Same directory as YAML fixtures; different extension.
#
# ── Adding a New Register Card ─────────────────────────────────────────────────
#   1. Add one "Verify Register Api Workflow: <Name>" test case below
#   2. Add one "API First Run: Capture … <Name>" test case below
#   3. Run first-run-api to populate both JSON fixtures, review, and commit.
#   (No YAML file needed for this suite; only the JSON fixture pair.)
#
# ── Suite Lifecycle ───────────────────────────────────────────────────────────
#   Suite Setup     → Login once (AusweisApp eID)
#   Test Setup      → Navigate to register-auswahl in default grid view
#   Suite Teardown  → Close any open dialog + logout + close all browsers
#
# NOTE: AusweisApp SDK must be available. On standard CI the suite is skipped
#       automatically by the shared Open Browser And Login For AusweisApp Suite
#       keyword; see resources/dsc_setup_teardown.robot for the CI guard.
# ===============================================================================

*** Settings ***
Library     Browser
Library     DateTime

Resource    ../../resources/dsc_variables.robot
Resource    ../../resources/dsc_setup_teardown.robot
Resource    ../../resources/dsc_shared_keywords.robot

Resource    ../../pages/dsc_authentication_info_page.robot
Resource    ../../pages/dsc_register_selection_page.robot
Resource    ../../pages/dsc_register_result_page.robot
Resource    ../../pages/dsc_register_result_page_api.robot

Suite Setup     Open Browser And Login For Generic Api Register Suite
Suite Teardown  Close Browser After Generic Api Register Suite
Test Setup      Open Register Auswahl In Default Grid View


*** Variables ***

# ── API Fixture Directory ──────────────────────────────────────────────────────
# Resolved at runtime relative to this file:
#   tests/ui/ → ../../test_data/registers/
# JSON fixtures live in the same directory as YAML fixtures.
${API_FIXTURES_DIR}                  ${CURDIR}${/}..${/}..${/}test_data${/}registers

# ── First-run-api Control ──────────────────────────────────────────────────────
# Overwrite existing complete fixtures via the first-run-api-force profile.
${API_FIXTURE_FORCE_REGENERATE}      ${False}

# Explicit opt-in so first-run-api tests never execute during a default run:
#   robotcode --profile default --profile first-run-api robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
${ENABLE_API_FIRST_RUN_TESTS}        ${False}


*** Keywords ***

Open Browser And Login For Generic Api Register Suite
    [Documentation]    Suite setup: opens the browser and logs in via AusweisApp
    ...                eID exactly once for the whole suite.
    Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}


Close Browser After Generic Api Register Suite
    [Documentation]    Suite teardown: closes any open Protokolldaten dialog
    ...                before logout (prevents the open dialog from blocking the
    ...                logout trigger button after a test failure).
    ...                Then delegates to the shared AusweisApp teardown.
    Close Register Dialog If Open
    Close Browser After AusweisApp Suite


Open Register Auswahl In Default Grid View
    [Documentation]    Default Test Setup: hard-navigates to register-auswahl
    ...                (clears any SPA state carry-over) and resets the view
    ...                to the default grid layout.
    Go To    ${REGISTER_AUSWAHL_URL}
    Wait For Load State    networkidle
    Switch Register Auswahl To Grid View


Require Explicit Api First Run Mode
    [Documentation]    Guards first-run-api capture tests so they only execute when
    ...                the suite is started with explicit first-run-api intent.
    Skip If    not ${ENABLE_API_FIRST_RUN_TESTS}
    ...    API first-run tests are opt-in. Run with: robotcode --profile default --profile first-run-api robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"


# ── Composite First-Run-Api Keyword ────────────────────────────────────────────

Run Register Api Card First Run Capture
    [Documentation]    Drives the full register card workflow, captures the live
    ...                "Persönliche Daten anfragen" API response, decrypts it in
    ...                the browser, and writes both the processed fixture and the
    ...                companion raw decrypted XML fixture.
    ...
    ...                By default, skips writing when the fixture already exists and
    ...                is marked as completed.
    ...                Use the first-run-api-force profile to overwrite.
    ...
    ...                Arguments:
    ...                  ${register_name}  – Exact h3 text of the register card
    ...                  ${register_tag}   – Short tag (e.g. "bva")
    ...                  ${fixture_path}   – Absolute path to the .json output file
    [Arguments]    ${register_name}    ${register_tag}    ${fixture_path}
    ${api_response}=    Run Full Register Workflow And Return Api Response    ${register_name}
    Generate Register Api Fixture From Response
    ...    api_response=${api_response}
    ...    register_name=${register_name}
    ...    register_tag=${register_tag}
    ...    fixture_path=${fixture_path}
    ...    force_regenerate=${API_FIXTURE_FORCE_REGENERATE}
    Close Register Protokolldaten Dialog
    ${raw_fixture_path}=    Replace String    ${fixture_path}    .json    _raw.json
    Log    API first-run complete. Please review the fixtures and commit: ${fixture_path} | ${raw_fixture_path}


*** Test Cases ***

# ===============================================================================
# NORMAL VERIFICATION TESTS
# Run without any filter to execute these tests.
# Prerequisite: JSON fixture must be populated (first_run.completed: true).
# Skip behaviour: test is skipped (not failed) when the fixture is absent or
#                 not yet populated.
# ===============================================================================

Verify Register Api Workflow: Test BVA
    [Documentation]    Loads test_data/registers/bva.json and verifies the live
    ...                BVA "Persönliche Daten anfragen" API response against the
    ...                stored decrypted reference body:
    ...                  • Full workflow is driven (same as ts_05 BVA test)
    ...                  • Live API response body is compared against the fixture
    ...                  • Volatile keys (tokens, timestamps …) are excluded
    ...
    ...                Skip: when bva.json is absent or not yet populated by a
    ...                first-run-api execution.
    [Tags]    bva    api-response    generic
    Run Register Api Card Verification    ${API_FIXTURES_DIR}${/}bva.json

Verify Register Api Workflow: Test-DGUV
    [Documentation]    Loads test_data/registers/dguv.json and verifies the live
    ...                DGUV "Persönliche Daten anfragen" API response against the
    ...                stored decrypted reference body.
    ...
    ...                Skip: when dguv.json is absent or not yet populated by a
    ...                first-run-api execution.
    [Tags]    smoke    dguv    api-response    generic
    Run Register Api Card Verification    ${API_FIXTURES_DIR}${/}dguv.json

# ── Template for additional register cards ─────────────────────────────────────
# Copy the block below, adjust name/tag/fixture-path, and run first-run-api:
#
# Verify Register Api Workflow: Test BA
#     [Documentation]    Verifies the Test BA API response against ba.json.
#     [Tags]    smoke    ba    api-response    generic
#     Run Register Api Card Verification    ${API_FIXTURES_DIR}${/}ba.json
#
# Verify Register Api Workflow: Test KBA
#     [Documentation]    Verifies the Test KBA API response against kba.json.
#     [Tags]    smoke    kba    api-response    generic
#     Run Register Api Card Verification    ${API_FIXTURES_DIR}${/}kba.json


# ==============================================================================
# FIRST-RUN-API DATA CAPTURE TESTS
# Run with:
#   robotcode --profile default --profile first-run-api robot \
#         --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
# Forced overwrite: use --profile first-run-api-force instead
#
# These tests are guarded and skip unless ENABLE_API_FIRST_RUN_TESTS=True.
# ==============================================================================

API First Run: Capture And Generate Fixture For Test BVA
    [Documentation]    Drives the full BVA register card workflow, intercepts the
    ...                "Persönliche Daten anfragen" API response, decrypts it in
    ...                the browser, and writes it to test_data/registers/bva.json
    ...                plus test_data/registers/bva_raw.json.
    ...
    ...                Run once before the normal verification tests:
    ...                  robotcode --profile default --profile first-run-api robot \
    ...                        --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
    ...
    ...                To overwrite an existing bva.json:
    ...                  robotcode --profile default --profile first-run-api-force robot \
    ...                        --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
    ...
    ...                After the run: review test_data/registers/bva.json and
    ...                test_data/registers/bva_raw.json, then commit.
    [Setup]    Require Explicit Api First Run Mode
    [Tags]    first-run-api    bva
    Run Register Api Card First Run Capture
    ...    Test BVA    bva    ${API_FIXTURES_DIR}${/}bva.json

API First Run: Capture And Generate Fixture For Test-DGUV
    [Documentation]    Drives the full Test-DGUV register card workflow, intercepts
    ...                the "Persönliche Daten anfragen" API response, decrypts it
    ...                in the browser, and writes it to test_data/registers/dguv.json
    ...                plus test_data/registers/dguv_raw.json.
    ...
    ...                Run once before the normal verification tests:
    ...                  robotcode --profile default --profile first-run-api robot \
    ...                        --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
    ...
    ...                To overwrite an existing dguv.json:
    ...                  robotcode --profile default --profile first-run-api-force robot \
    ...                        --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
    ...
    ...                After the run: review test_data/registers/dguv.json and
    ...                test_data/registers/dguv_raw.json, then commit.
    [Setup]    Require Explicit Api First Run Mode
    [Tags]    first-run-api    dguv
    Run Register Api Card First Run Capture
    ...    Test-DGUV    dguv    ${API_FIXTURES_DIR}${/}dguv.json

# ── Template for first-run-api tests for additional register cards ──────────────
#
# API First Run: Capture And Generate Fixture For Test BA
#     [Documentation]    Captures live Test BA API response → writes ba.json.
#     [Setup]    Require Explicit Api First Run Mode
#     [Tags]    first-run-api    ba
#     Run Register Api Card First Run Capture    Test BA    ba    ${API_FIXTURES_DIR}${/}ba.json
#
# API First Run: Capture And Generate Fixture For Test KBA
#     [Documentation]    Captures live Test KBA API response → writes kba.json.
#     [Setup]    Require Explicit Api First Run Mode
#     [Tags]    first-run-api    kba
#     Run Register Api Card First Run Capture    Test KBA    kba    ${API_FIXTURES_DIR}${/}kba.json

