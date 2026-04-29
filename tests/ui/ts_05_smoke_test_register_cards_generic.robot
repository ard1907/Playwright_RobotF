# ==============================================================================
# ts_05_smoke_test_register_cards_generic.robot  –  Generic Register Card
#                                                    Smoke Test Suite
#
# Tests any number of register cards generically against YAML fixture files.
# Each register card is one test case (static list); adding a new card means
# adding one test case + one YAML fixture file.
#
# ── Two operating modes ────────────────────────────────────────────────────────
#
#   Normal mode (default run):
#     robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
#     Loads each fixture YAML and verifies the live dialog against expected data.
#     Requires: fixture populated by a prior first-run (first_run.completed: true).
#     Skip note: if a fixture is not yet populated the test is skipped with a
#                clear message pointing to the first-run command.
#
#   First-run mode (data capture):
#     robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True \
#           tests/ui/ts_05_smoke_test_register_cards_generic.robot
#     Drives the full workflow, captures sender + data fields from the live dialog,
#     and writes/updates the YAML fixture.
#     By default, skips writing if a fixture already exists.
#
#   First-run with forced overwrite:
#     robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True \
#           --variable FIXTURE_FORCE_REGENERATE:True \
#           tests/ui/ts_05_smoke_test_register_cards_generic.robot
#
# ── Fixture file convention ────────────────────────────────────────────────────
#   test_data/registers/<tag>.yaml  (e.g. bva.yaml, ba.yaml, kba.yaml)
#
# ── Adding a new register card ─────────────────────────────────────────────────
#   1. Create test_data/registers/<newtag>.yaml (copy bva.yaml, adjust name/tag)
#   2. Add one "Verify Register Card Workflow: <Name>" test case below
#   3. Add one "First Run: Capture … <Name>" test case below
#   4. Run first-run to populate the fixture, review, and commit.
#
# ── Suite lifecycle ────────────────────────────────────────────────────────────
#   Suite Setup     → Login once (AusweisApp eID)
#   Test Setup      → Navigate to register-auswahl in default grid view
#   Suite Teardown  → Logout + close all browsers
#
# NOTE: AusweisApp SDK must be available. On standard CI the suite is skipped
#       automatically by the shared Open Browser And Login For AusweisApp Suite
#       keyword; see resources/dsc_setup_teardown.robot for the CI guard.
# ==============================================================================

*** Settings ***
Library     Browser
Library     DateTime

Resource    ../../resources/dsc_variables.robot
Resource    ../../resources/dsc_setup_teardown.robot
Resource    ../../resources/dsc_shared_keywords.robot

Resource    ../../pages/dsc_authentication_info_page.robot
Resource    ../../pages/dsc_register_selection_page.robot
Resource    ../../pages/dsc_register_result_page.robot

Suite Setup     Open Browser And Login For Generic Register Suite
Suite Teardown  Close Browser After Generic Register Suite
Test Setup      Open Register Auswahl In Default Grid View


*** Variables ***

# ── Fixture directory ──────────────────────────────────────────────────────────
# Resolved at runtime relative to this file:
#   tests/ui/ → ../../test_data/registers/
${FIXTURES_DIR}                   ${CURDIR}${/}..${/}..${/}test_data${/}registers

# ── First-run control ──────────────────────────────────────────────────────────
# Set to True on the command line to overwrite existing fixture files:
#   --variable FIXTURE_FORCE_REGENERATE:True
${FIXTURE_FORCE_REGENERATE}       ${False}
# Explicit opt-in so first-run tests never execute during a default suite run.
#   --include first-run --variable ENABLE_FIRST_RUN_TESTS:True
${ENABLE_FIRST_RUN_TESTS}         ${False}


*** Keywords ***

Open Browser And Login For Generic Register Suite
    [Documentation]    Suite setup: opens the browser and logs in via AusweisApp
    ...                eID exactly once for the whole suite.
    Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}


Close Browser After Generic Register Suite
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


Require Explicit First Run Mode
    [Documentation]    Guards first-run capture tests so they only execute when
    ...                the suite is started with explicit first-run intent.
    Skip If    not ${ENABLE_FIRST_RUN_TESTS}
    ...    First-run tests are opt-in. Run with: robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot


# ── Composite Verification Keyword ─────────────────────────────────────────────

Run Register Card Verification
    [Documentation]    Loads the given YAML fixture and drives the full register
    ...                card verification workflow:
    ...                  1. Load and validate fixture
    ...                  2. Skip if first-run not yet completed
    ...                  3. Navigate → expand result → open dialog → fetch data
    ...                  4. Verify sender  (when assert_sender: true)
    ...                  5. Verify data fields  (key always; value when assert_value: true)
    ...                  6. Close dialog
    ...
    ...                Arguments:
    ...                  ${fixture_path}  – Absolute path to the register YAML fixture
    [Arguments]    ${fixture_path}
    # Load fixture and guard against unpopulated files
    ${fixture}=    Load Register Fixture    ${fixture_path}
    ${is_complete}=    Is First Run Completed    ${fixture}
    Skip If    not ${is_complete}
    ...    Fixture not yet populated by first-run: ${fixture_path}\nRun: robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
    # Navigate full workflow to the open, data-loaded dialog
    ${register_name}=    Get Register Name    ${fixture}
    Run Full Register Workflow To Dialog Data    ${register_name}
    # Verify sender organisation (when configured)
    ${assert_sender}=    Is Sender Assertion Enabled    ${fixture}
    IF    ${assert_sender}
        ${expected_sender}=    Get Expected Sender    ${fixture}
        Verify Register Dialog Sender    ${expected_sender}
    END
    # Verify data fields (key always; value conditional on assert_value)
    ${data_fields}=    Get Data Fields To Verify    ${fixture}
    Verify Register Dialog Data Fields    ${data_fields}
    
    # Verify PDF Download if configured
    ${pdf_config}=    Get Pdf Configuration    ${fixture}
    IF    ${pdf_config}[verify]
        Verify Register Dialog PDF Download Matches Pattern    ${pdf_config}[filename_pattern]
    END

    # Cleanup
    Close Register Protokolldaten Dialog


# ── Composite First-Run Keyword ─────────────────────────────────────────────────

Run Register First Run Capture
    [Documentation]    Drives the full register card workflow, captures the live
    ...                dialog data (sender + data fields) via JavaScript, and
    ...                writes the result to the given YAML fixture file.
    ...
    ...                By default, skips writing only when the fixture already
    ...                exists and is marked as completed.
    ...                Pass --variable FIXTURE_FORCE_REGENERATE:True to overwrite.
    ...
    ...                Arguments:
    ...                  ${register_name}  – Exact h3 text of the register card
    ...                  ${register_tag}   – Short tag (e.g. "bva")
    ...                  ${fixture_path}   – Absolute path to the .yaml output file
    [Arguments]    ${register_name}    ${register_tag}    ${fixture_path}
    Run Full Register Workflow To Dialog Data    ${register_name}
    Generate Register Fixture From Dialog
    ...    fixture_path=${fixture_path}
    ...    register_name=${register_name}
    ...    register_tag=${register_tag}
    ...    force_regenerate=${FIXTURE_FORCE_REGENERATE}
    Close Register Protokolldaten Dialog
    Log    First-run complete. Please review the fixture and commit: ${fixture_path}


*** Test Cases ***

# ==============================================================================
# NORMAL VERIFICATION TESTS
# Run without any filter to execute these tests.
# Prerequisite: fixture YAML must be populated (first_run.completed: true).
# Skip behaviour: test is skipped (not failed) when fixture is not yet populated.
# ==============================================================================

Verify Register Card Workflow: Test BVA
    [Documentation]    Loads test_data/registers/bva.yaml and verifies the full
    ...                BVA register card workflow against expected fixture data:
    ...                  • Dialog sender "Bundesverwaltungsamt, ..." is visible
    ...                  • All expected data field keys are visible in the dialog
    ...                  • Fields with assert_value:true also have matching values
    ...
    ...                Skip: when bva.yaml is not yet populated by a first-run.
    [Tags]    smoke    bva    register-card    generic
    Run Register Card Verification    ${FIXTURES_DIR}${/}bva.yaml

Verify Register Card Workflow: Test-DGUV
    [Documentation]    Loads test_data/registers/dguv.yaml and verifies the full
    ...                DGUV register card workflow against expected fixture data:
    ...                  • Dialog sender is visible
    ...                  • All expected data field keys are visible in the dialog
    ...                  • Fields with assert_value:true also have matching values
    ...
    ...                Skip: when dguv.yaml is not yet populated by a first-run.
    [Tags]    smoke    dguv    register-card    generic
    Run Register Card Verification    ${FIXTURES_DIR}${/}dguv.yaml

# ── Template for additional register cards ─────────────────────────────────────
# Copy the block below, adjust name/tag/fixture-path, and create the YAML:
#
# Verify Register Card Workflow: Test BA
#     [Documentation]    Verifies the Test BA register card against ba.yaml.
#     [Tags]    smoke    ba    register-card    generic
#     Run Register Card Verification    ${FIXTURES_DIR}${/}ba.yaml
#
# Verify Register Card Workflow: Test KBA
#     [Documentation]    Verifies the Test KBA register card against kba.yaml.
#     [Tags]    smoke    kba    register-card    generic
#     Run Register Card Verification    ${FIXTURES_DIR}${/}kba.yaml


# ==============================================================================
# FIRST-RUN DATA CAPTURE TESTS
# Run with: robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
# Forced overwrite: add --variable FIXTURE_FORCE_REGENERATE:True
#
# These tests are guarded explicitly and skip unless ENABLE_FIRST_RUN_TESTS=True.
# ==============================================================================

First Run: Capture And Generate Fixture For Test BVA
    [Documentation]    Drives the full BVA register card workflow, captures all
    ...                dialog data (sender + data fields) via JavaScript, and
    ...                writes the result to test_data/registers/bva.yaml.
    ...
    ...                Run once before the normal verification tests:
    ...                  robot --include first-run \
    ...                        --variable ENABLE_FIRST_RUN_TESTS:True \
    ...                        tests/ui/ts_05_smoke_test_register_cards_generic.robot
    ...
    ...                To overwrite an existing bva.yaml:
    ...                  robot --include first-run \
    ...                        --variable ENABLE_FIRST_RUN_TESTS:True \
    ...                        --variable FIXTURE_FORCE_REGENERATE:True \
    ...                        tests/ui/ts_05_smoke_test_register_cards_generic.robot
    ...
    ...                After the run: review the generated YAML and commit it.
    [Setup]    Require Explicit First Run Mode
    [Tags]    first-run    bva
    Run Register First Run Capture    Test BVA    bva    ${FIXTURES_DIR}${/}bva.yaml

First Run: Capture And Generate Fixture For Test-DGUV
    [Documentation]    Drives the full Test-DGUV register card workflow, captures all
    ...                dialog data (sender + data fields) via JavaScript, and
    ...                writes the result to test_data/registers/dguv.yaml.
    ...
    ...                Run once before the normal verification tests:
    ...                  robot --include first-run \
    ...                        --variable ENABLE_FIRST_RUN_TESTS:True \
    ...                        tests/ui/ts_05_smoke_test_register_cards_generic.robot
    ...
    ...                To overwrite an existing dguv.yaml:
    ...                  robot --include first-run \
    ...                        --variable ENABLE_FIRST_RUN_TESTS:True \
    ...                        --variable FIXTURE_FORCE_REGENERATE:True \
    ...                        tests/ui/ts_05_smoke_test_register_cards_generic.robot
    ...
    ...                After the run: review the generated YAML and commit it.
    [Setup]    Require Explicit First Run Mode
    [Tags]    first-run    dguv
    Run Register First Run Capture    Test-DGUV    dguv    ${FIXTURES_DIR}${/}dguv.yaml

# ── Template for first-run tests for additional register cards ─────────────────
#
# First Run: Capture And Generate Fixture For Test BA
#     [Documentation]    Captures live Test BA dialog data → writes ba.yaml.
#     [Tags]    first-run    ba
#     Run Register First Run Capture    Test BA    ba    ${FIXTURES_DIR}${/}ba.yaml
#
# First Run: Capture And Generate Fixture For Test KBA
#     [Documentation]    Captures live Test KBA dialog data → writes kba.yaml.
#     [Tags]    first-run    kba
#     Run Register First Run Capture    Test KBA    kba    ${FIXTURES_DIR}${/}kba.yaml
