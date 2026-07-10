# Register Test Logic

This document explains the register-testing logic used by three related suites:

- `ts_05_register_selection_bva_ui_api.robot`
- `ts_06_register_cards_generic_dom_test.robot`
- `ts_07_register_cards_generic_api_test.robot`

The difference is simple:

- `ts_05` proves the API-based approach on one fixed example: BVA.
- `ts_06` validates registers through visible dialog content and YAML fixtures.
- `ts_07` generalizes the API-based approach for multiple registers and uses JSON fixtures.

## What the logic is meant to verify

The register tests should not only click through the UI.
They should also verify the business flow:

- was the correct register selected?
- did the user reach the expected results page?
- was the right result block opened?
- can the detail dialog be opened?
- do the shown or delivered data match the expected register?

## Main building blocks

The core files are:

- `pages/dsc_register_selection_page.robot`
- `pages/dsc_register_result_page.robot`
- `pages/dsc_register_result_page_api.robot`
- `resources/dsc_shared_keywords.robot`
- `test_data/registers/*.yaml`
- `test_data/registers/*.json`
- `test_data/registers/*_raw.json`

In short:

- the suite controls the overall flow
- the page objects encapsulate the UI steps
- Python helpers read and write fixtures
- fixtures provide the comparison baseline for normal verification

## Variant 1: DOM-based verification with YAML

`ts_06_register_cards_generic_dom_test.robot` is the everyday suite.
It works with YAML files such as `bva.yaml` or `dguv.yaml`.

The flow is:

1. Load the fixture.
2. Check whether `first_run.completed` is set.
3. Reset the register-selection page into a clean state.
4. Select the target register card.
5. Start the request.
6. Open the matching result block.
7. Open the detail dialog.
8. Request personal data.
9. Compare sender and data fields with the YAML fixture.

The YAML fixture describes, for example:

- the technical register tag
- the visible register name
- the expected sender
- expected field keys and optional values
- optional PDF verification settings

## Why the suite resets the selection first

The application can keep UI state between actions.
If a previous test left another register selected, the next test might see the wrong result.

That is why the suites enforce:

- fresh navigation to register selection
- switching back to grid view
- restoring the empty selection state

This keeps the tests deterministic.

## Variant 2: API-based verification with JSON

The API-based variant focuses less on visible layout and more on the business payload.
It hooks into the moment when the dialog requests personal data.

Important detail:

- the application does not simply receive finished plain text
- the response is processed and decrypted inside the browser
- the suite attaches itself to that browser-side flow

The JSON fixtures then store two views:

- `<tag>.json`: processed, comparison-friendly business data
- `<tag>_raw.json`: raw decrypted XML payload kept as evidence

## The role of `ts_05`

`ts_05_register_selection_bva_ui_api.robot` is the controlled entry point into API verification.
It uses exactly one known case: BVA.

That makes sense because the new approach is first stabilized on a fixed workflow:

- the same business flow as in `ts_04`
- plus an extra API comparison against `bva.json`
- plus a dedicated `first-run-api` test to generate the first reference fixture

So `ts_05` is the bridge between a fixed single-suite workflow and the later generic approach.

## The role of `ts_07`

`ts_07_register_cards_generic_api_test.robot` turns the BVA pattern into a reusable standard.
It is no longer limited to BVA, as long as a JSON fixture exists for the target register.

At the moment the suite covers:

- `bva.json`
- `dguv.json`

For each register there are two types of test cases:

- one normal verification test
- one `first-run-api` test that creates or refreshes the JSON files

## Why volatile fields are excluded

API responses often include values that legitimately change on every run.
Examples are:

- tokens
- timestamps
- technical IDs

If those values were compared one-to-one, the tests would be unnecessarily unstable.
That is why the API comparison excludes known volatile fields.

The goal is not byte-for-byte equality.
The goal is stable business equality.

## First-run and first-run-api

Both modes are intentionally opt-in.
They do not run just because somebody starts the suite normally.

Dialog/YAML first-run:

```bash
robotcode --profile default --profile first-run robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

API first-run:

```bash
robotcode --profile default --profile first-run-api robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
```

Optional overwrite of existing data:

- `--profile first-run-force` for YAML
- `--profile first-run-api-force` for JSON

## When to use which suite

- `ts_04`: when you need a fixed BVA end-to-end flow with UI and PDF checks
- `ts_05`: when that same BVA flow should also be verified through the API payload
- `ts_06`: when multiple registers should be verified through visible dialog data
- `ts_07`: when multiple registers should be verified through stable API business data

## Adding a new register card

For the dialog-based path:

1. Create a YAML file under `test_data/registers/`.
2. Add a verification test in `ts_06`.
3. Add an optional `first-run` test in `ts_06`.
4. Run `first-run` explicitly and review the result.

For the API-based path:

1. Add a verification test in `ts_07`.
2. Add a `first-run-api` test in `ts_07`.
3. Run `first-run-api` explicitly.
4. Review `json` and `raw.json` and commit them.

## Practical rule of thumb

If the visible dialog layout is stable and sufficient, `ts_06` is often enough.
If the business payload matters more and the layout may change, `ts_07` is usually more robust.

That is why both lines exist side by side.

- run first-run
- read the YAML once
- if needed, clean up the fields so they are easier to understand

## Typical commands

Normal run:

```bash
robotcode --profile default robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

Only one normal test case:

```bash
robotcode --profile default robot --test "Verify Register Card Workflow: Test BVA"
```

Explicit first-run:

```bash
robotcode --profile default --profile first-run robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

Explicit first-run with overwrite of completed fixtures:

```bash
robotcode --profile default --profile first-run-force robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

Normal API run:

```bash
robotcode --profile default robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
```

Explicit API first-run:

```bash
robotcode --profile default --profile first-run-api robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
```

Explicit API first-run with overwrite of completed fixtures:

```bash
robotcode --profile default --profile first-run-api-force robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
```

## Short summary

The register-card tests now work like this:

- `ts_05` verifies the fixed BVA API flow against `bva.json`
- `ts_06` verifies generic register dialogs against YAML fixtures
- `ts_07` verifies generic register API payloads against JSON fixtures
- `first-run` and `first-run-api` create or refresh fixtures
- both capture modes are intentionally opt-in
- incomplete fixtures are regenerated automatically during first-run
- completed fixtures are only replaced with force-regenerate
- selection and dialog opening are bound to the correct register card
- key/value verification is stricter and more meaningful

## Related docs

- `README_Tests_Overview_EN.md`
- `README_Tests_UI_Overview_EN.md`
- `LogikRegisterTests.md`
