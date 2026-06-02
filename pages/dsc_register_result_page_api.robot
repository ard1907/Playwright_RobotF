# ==============================================================================
# dsc_register_result_page_api.robot  –  API-Response-Based Keywords for the
#                                        Register Card Verification Workflow
#
# Extends the existing dsc_register_result_page.robot with keywords that verify
# register card data against the captured API response JSON, instead of the
# rendered dialog DOM content.
#
# ── Two Operating Modes (mirrors the YAML-based ts_05 pattern) ────────────────
#
#   First-run-api mode (data capture):
#     Drives the full register card workflow, intercepts the
#     "Persönliche Daten anfragen" API response, and writes the full response
#     body to a JSON fixture file:
#       test_data/registers/<tag>.json
#
#   Verification mode (default):
#     Loads the stored JSON fixture, re-runs the full workflow, intercepts the
#     fresh API response, and compares it against the stored reference body.
#     Volatile keys (tokens, timestamps, request-IDs, etc.) are excluded from
#     the comparison automatically.
#
# ── Fixture File Convention ────────────────────────────────────────────────────
#   test_data/registers/<tag>.json   (e.g. bva.json, dguv.json)
#   Same directory as the YAML fixtures; different extension.
#
# ── Dependencies ───────────────────────────────────────────────────────────────
#   pages/dsc_register_result_page.robot
#     → shared navigation, dialog, and API-response keywords / variables
#   resources/libraries/dsc_register_api_fixture_library.py
#     → JSON fixture I/O and response comparison logic
#
# ── New Keywords ───────────────────────────────────────────────────────────────
#   Fetch Personal Data And Return Api Response
#     Clicks "Persönliche Daten anfragen", captures the API response, waits for
#     "Daten abgerufen" state, and RETURNS the Browser Library response object.
#
#   Run Full Register Workflow And Return Api Response
#     Composite: runs the complete register workflow and returns the API response.
#
#   Generate Register Api Fixture From Response
#     First-run: saves the captured response body to a JSON fixture file.
#
#   Run Register Api Card Verification
#     Verification: loads the fixture, runs the workflow, compares API response.
# ==============================================================================

*** Settings ***
Library     Browser
Library     OperatingSystem
Library     Collections

Resource    ../resources/dsc_variables.robot
Resource    ../resources/dsc_shared_keywords.robot
Resource    ../pages/dsc_register_result_page.robot

Library     ../resources/libraries/dsc_register_api_fixture_library.py


*** Variables ***

${REG_DIALOG_DATA_API_RESPONSE_MATCHER}
...    response => response.url().endsWith('/api/register-inhalts-data') && response.request().method() === 'POST'


*** Keywords ***

# ── Personal Data Fetch: Returns API Response ──────────────────────────────────

Fetch Personal Data And Return Api Response
    [Documentation]    Clicks "Persönliche Daten anfragen" inside the open
    ...                Protokolldaten dialog, captures the API response, waits
    ...                for the "Daten abgerufen" confirmation state, and returns
    ...                the raw Browser Library response object.
    ...
    ...                This is a variant of "Fetch Personal Data In Register Dialog"
    ...                (from dsc_register_result_page.robot) that additionally
    ...                returns the captured API response so it can be saved as a
    ...                JSON fixture or compared against one.
    ...
    ...                Returns ${None} when no matching response was captured
    ...                within the timeout (see REG_DIALOG_API_RESPONSE_MATCHER).
    ...
    ...                Arguments:
    ...                  ${register_name}  – Register card name (for error/skip msgs)
    [Arguments]    ${register_name}=Unknown Register
    Wait For Elements State    ${REG_DIALOG_ANFRAGEN_BTN}    visible    timeout=${TIMEOUT}
    ${response_promise}=    Promise To    Wait For Response
    ...    ${REG_DIALOG_DATA_API_RESPONSE_MATCHER}
    ...    timeout=30s
    Click    ${REG_DIALOG_ANFRAGEN_BTN}
    ${api_response}=    Wait For And Log Captured Api Response
    ...    personal data request (api-fixture capture)
    ...    ${response_promise}
    ${response_error}=    Get First Known Register Data Error From Response    ${api_response}
    IF    '${response_error}' != ''
        Report Register Backend Failure And Skip
        ...    personal data request (api-fixture capture)
        ...    ${register_name}
        ...    ${response_error}
        ...    ${api_response}
    END
    Wait For Personal Data Or Skip On Known Error    ${register_name}    ${api_response}
    RETURN    ${api_response}


# ── Composite Workflow: Full Run Returning API Response ────────────────────────

Run Full Register Workflow And Return Api Response
    [Documentation]    Drives the complete register card workflow up to and
    ...                including the personal data fetch, and returns the captured
    ...                Browser Library response object from the
    ...                "Persönliche Daten anfragen" API call.
    ...
    ...                Steps:
    ...                  1. Navigate to datenabfrage (register selected + request started)
    ...                  2. Expand the register result entry
    ...                  3. Open the first Protokolldaten dialog
    ...                  4. Fetch personal data and capture API response
    ...
    ...                Returns the Browser Library response object.
    ...                Returns ${None} when the response was not captured in time.
    ...
    ...                Arguments:
    ...                  ${register_name}  – Exact h3 text of the register card
    [Arguments]    ${register_name}
    Navigate To Register Results Page             ${register_name}
    Expand Register Result Entry                  ${register_name}
    Open First Register Protokolldaten Dialog     ${register_name}
    ${api_response}=    Fetch Personal Data And Return Api Response    ${register_name}
    RETURN    ${api_response}


# ── First-Run: Save API Response as JSON Fixture ───────────────────────────────

Generate Register Api Fixture From Response
    [Documentation]    Saves the captured Browser Library API response to a JSON
    ...                fixture file (test_data/registers/<tag>.json).
    ...
    ...                By default skips writing when the fixture already exists and
    ...                is marked as completed.  Pass ${force_regenerate}=${True}
    ...                to overwrite an existing completed fixture.
    ...
    ...                Logs a warning when an incomplete (placeholder) fixture is
    ...                regenerated without explicit force_regenerate.
    ...
    ...                Arguments:
    ...                  ${api_response}     – Browser Library response object
    ...                                        (must not be ${None})
    ...                  ${register_name}    – Exact register card h3 text
    ...                  ${register_tag}     – Short tag (e.g. "bva")
    ...                  ${fixture_path}     – Absolute path to the .json output file
    ...                  ${force_regenerate} – Overwrite existing file (default: False)
    [Arguments]    ${api_response}    ${register_name}    ${register_tag}    ${fixture_path}    ${force_regenerate}=${False}
    IF    $api_response is None
        Fail
        ...    Cannot generate API fixture for "${register_name}": API response was not captured (None). Check the API response matcher and network conditions.
    END
    ${exists}=    Api Fixture Exists    ${fixture_path}
    ${existing}=    Set Variable    ${None}
    ${is_complete}=    Set Variable    ${False}
    IF    ${exists}
        ${existing}=    Load Api Response Fixture    ${fixture_path}
        ${is_complete}=    Is Api Fixture Completed    ${existing}
    END
    IF    ${exists} and ${is_complete} and not ${force_regenerate}
        Log    API fixture already exists and is completed; skipping write: ${fixture_path}    WARN
        RETURN
    END
    IF    ${exists} and not ${is_complete}
        Log    API fixture exists but is incomplete; regenerating: ${fixture_path}    WARN
    END
    ${fixture_data}=    Build Api First Run Fixture
    ...    register_name=${register_name}
    ...    register_tag=${register_tag}
    ...    response_status=${api_response}[status]
    ...    response_url=${api_response}[url]
    ...    body_bytes=${api_response}[body]
    ...    existing_fixture=${existing}
    Write Api Fixture    ${fixture_path}    ${fixture_data}
    Log    API first-run: fixture written to ${fixture_path} – please review and commit.


# ── Verification: Compare API Response Against Fixture ─────────────────────────

Run Register Api Card Verification
    [Documentation]    Composite verification keyword: loads the JSON fixture,
    ...                drives the full register card workflow, captures the live
    ...                API response, compares it against the stored reference body,
    ...                and closes the Protokolldaten dialog.
    ...
    ...                Behaviour:
    ...                  1. Load JSON fixture from ${fixture_path}
    ...                  2. Skip (not fail) when fixture is not yet populated
    ...                  3. Run the full workflow for the register from the fixture
    ...                  4. Capture the "Persönliche Daten anfragen" API response
    ...                  5. Compare current body against the stored reference body
    ...                     – Volatile keys (tokens, timestamps …) are skipped
    ...                     – Extra skip_keys from fixture[comparison][skip_keys]
    ...                       are also excluded
    ...                  6. Fail when differences are found
    ...                  7. Close the Protokolldaten dialog
    ...
    ...                Arguments:
    ...                  ${fixture_path}  – Absolute path to the .json fixture file
    [Arguments]    ${fixture_path}
    # ── Load and guard the fixture ─────────────────────────────────────────────
    ${fixture}=    Load Api Response Fixture    ${fixture_path}
    ${is_complete}=    Is Api Fixture Completed    ${fixture}
    Skip If    not ${is_complete}
    ...    API fixture not yet populated by first-run-api: ${fixture_path}\nRun: robot --include first-run-api --variable ENABLE_API_FIRST_RUN_TESTS:True tests/ui/ts_05b_register_cards_generic.robot
    ${register_name}=    Get Api Fixture Register Name    ${fixture}
    # ── Run the full workflow and capture the live API response ────────────────
    ${api_response}=    Run Full Register Workflow And Return Api Response    ${register_name}
    IF    $api_response is None
        Fail
        ...    Live API response was not captured for "${register_name}". Check network conditions and the API response matcher.
    END
    # ── Compare bodies ─────────────────────────────────────────────────────────
    ${reference_body}=    Get Api Response Body    ${fixture}
    ${current_body}=    Parse Api Response Body Bytes    ${api_response}[body]
    ${extra_skip_keys}=    Get Comparison Skip Keys    ${fixture}
    ${diffs}=    Compare Api Response Bodies
    ...    ${reference_body}
    ...    ${current_body}
    ...    ${extra_skip_keys}
    ${diff_count}=    Get Length    ${diffs}
    IF    ${diff_count} > 0
        ${diff_text}=    Catenate    SEPARATOR=\n    @{diffs}
        Fail
        ...    API response for "${register_name}" differs from fixture (${diff_count} difference(s)):\n${diff_text}
    END
    Log
    ...    API response matches fixture for register "${register_name}" – 0 differences found.
    # ── Cleanup ────────────────────────────────────────────────────────────────
    Close Register Protokolldaten Dialog
