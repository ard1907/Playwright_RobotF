# Register Card Test Logic

This document explains the register-card test logic in simple language.
It is both documentation and a practical guide.

## What is this about?

The Datenschutzcockpit UI contains register cards.
Each card stands for one register, for example `Test BVA` or `Test-DGUV`.

The tests should answer these questions:

- Can the register card be selected?
- Can the test reach the result page?
- Can the correct result entry be opened?
- Can the detail dialog be opened?
- Does the dialog show the expected data?

There are two styles of tests:

- specific tests for one fixed case, for example BVA
- generic tests for many register cards through YAML files

The generic suite is `tests/ui/ts_05_smoke_test_register_cards_generic.robot`.

## Which files belong together?

The core logic is spread across these files:

- `tests/ui/ts_05_smoke_test_register_cards_generic.robot`
- `pages/dsc_register_result_page.robot`
- `pages/dsc_register_selection_page.robot`
- `resources/dsc_shared_keywords.robot`
- `resources/libraries/dsc_register_fixture_library.py`
- `test_data/registers/*.yaml`

In short:

- the suite starts the test cases
- the page objects click through the UI
- the Python library reads and writes YAML fixtures
- the YAML files store the expected data for each register card

## Main idea of the generic suite

The generic suite should avoid building a completely new flow for every new register card.
Instead, each register card gets:

- one YAML file in `test_data/registers/`
- one normal verification test
- optionally one first-run test for creating or refreshing the YAML data

Examples:

- `bva.yaml`
- `dguv.yaml`

## The normal run

The normal run is the day-to-day mode.
It compares live dialog data with expected data from the YAML file.

Example:

```bash
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

For each register card, the flow is roughly this:

1. Load the YAML fixture.
2. Check whether `first_run.completed` is `true`.
3. If not, skip the test cleanly.
4. Navigate to the register-selection page.
5. Reset the page to a clean empty selection state.
6. Click the target register card.
7. Click `Anfrage starten`.
8. On the result page, find the result entry for exactly that register card.
9. Expand exactly that result entry.
10. Open the first detail dialog inside exactly that result entry.
11. Fetch the personal data.
12. Verify sender and data fields.

## Why is the selection reset first?

The cockpit can keep UI state.
For example, a previous test may have left another register card selected.

If that happens, the generic flow might:

- submit multiple registers at once
- see the wrong result entry
- open the wrong dialog

That is why the flow now resets the state before selecting the target card:

- switch to grid view
- restore the empty selection state
- only then select the target register card

This makes the test more deterministic.

## The YAML fixtures

Each YAML file describes one register card.

Example structure:

```yaml
register:
  name: Test BVA
  tag: bva
first_run:
  completed: true
  captured_at: '2026-04-29T10:15:51'
dialog:
  sender: Bundesverwaltungsamt, Registermodernisierungsbehoerde
  assert_sender: true
  data_fields:
    - key: Identifikationsnummer
      value: '08214967384'
      assert_value: true
pdf:
  verify: false
```

Important fields:

- `register.name`: exact card name in the UI
- `register.tag`: short technical name
- `first_run.completed`: was the fixture successfully filled?
- `dialog.sender`: expected sender text
- `dialog.data_fields`: expected fields in the dialog

## How does field verification work?

Earlier, the test only checked this:

- does the key text appear anywhere?
- does the value text appear anywhere?

That was too weak.
A value could belong to the wrong key and the test could still pass.

Now the logic is stricter.

There are two levels:

1. First, the visible dialog text is normalized.
2. Then the test checks whether key and value appear in the correct sequence.

If the DOM structure is unusual, there is a fallback:

- JavaScript reads structured key/value pairs from the dialog
- those pairs are used as a secondary verification source

This keeps the check robust, but more meaningful than before.

## What is first-run?

First-run is a special mode.
It is not meant for every normal test execution.

First-run does this:

1. It drives the same UI flow into the detail dialog.
2. It reads sender and field data from the live dialog.
3. It writes that data into a YAML file.

This is useful when:

- a new register card is added
- a YAML file is still empty or incomplete
- real dialog data has changed

## Important rule: first-run is now opt-in

First-run no longer executes just because the suite is started normally.

That is intentional.

Before this change, first-run tests could accidentally run during a normal suite execution.
That mixed verification logic with capture and write logic.

Now the rule is:

- normal `robot tests/ui/ts_05_smoke_test_register_cards_generic.robot` does not run real first-run work
- first-run tests only execute with explicit permission

The required command is:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Both parts matter:

- `--include first-run`
- `--variable ENABLE_FIRST_RUN_TESTS:True`

Using the tag alone is intentionally not enough.

## What happens with incomplete fixtures?

A fixture file can exist but still be incomplete.

Example:

- the file is already there
- but `first_run.completed` is still `false`

Earlier this caused a problem.
The logic only checked whether the file existed.
That meant the write step could be skipped even though the fixture was not finished.

Now the rule is:

- if the fixture does not exist: create it
- if it exists but is incomplete: regenerate it during first-run
- if it exists and is completed: only overwrite it with force-regenerate

## Force-regenerate

If you want to rewrite an already completed fixture on purpose, use:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True --variable FIXTURE_FORCE_REGENERATE:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

This is useful when real dialog data has changed and the existing YAML should be replaced.

## How to add a new register card

If a new register card should be tested, follow these steps:

1. Create a new YAML file in `test_data/registers/`.
2. Fill in the register name and tag.
3. Add one normal verification test in `ts_05_smoke_test_register_cards_generic.robot`.
4. Add one first-run test in the same suite.
5. Run first-run explicitly.
6. Review the generated YAML.
7. Clean up the YAML manually if needed.
8. Run the normal verification mode.

## Why does generated YAML sometimes need manual review?

Not every dialog uses the same DOM structure.
Some dialogs are clean and structured.
Others join several texts together.

Because of that, an automatically generated fixture can still need small cleanup.

Typical cases:

- a section title is glued to a field key
- a value is glued to the key
- the technical capture is correct enough, but not easy to read

The recommended workflow is:

- run first-run
- read the YAML once
- if needed, clean up the fields so they are easier to understand

## Typical commands

Normal run:

```bash
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Only one normal test case:

```bash
robot --test "Verify Register Card Workflow: Test BVA" tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Explicit first-run:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Explicit first-run with overwrite of completed fixtures:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True --variable FIXTURE_FORCE_REGENERATE:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

## Short summary

The register-card tests now work like this:

- normal tests verify against YAML fixtures
- first-run creates or refreshes fixtures
- first-run is intentionally opt-in
- incomplete fixtures are regenerated automatically during first-run
- completed fixtures are only replaced with force-regenerate
- selection and dialog opening are bound to the correct register card
- key/value verification is stricter and more meaningful

## Related docs

- `README_Tests_Overview_EN.md`
- `README_Tests_UI_Overview_EN.md`
- `LogikRegisterTests.md`