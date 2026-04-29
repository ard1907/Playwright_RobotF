# Playwright_RobotF

Robot Framework and Playwright-based end-to-end smoke tests for the Datenschutzcockpit SPA.

This repository focuses on automated UI checks for the landing page, authentication info page, dialogs, FAQ content, legal notice, privacy notice, accessibility information, external links, and selected login/logout flows.
It also includes dedicated suites for the authenticated cockpit area: the register-selection page, a BVA-specific result workflow, and a generic register-card workflow that can verify multiple register cards via YAML fixtures.

## What is in this repository

- `tests/ui/` contains the main smoke suites.
- `tests/helpers/` contains smaller helper suites and focused checks.
- `tests/examples/` contains example and exploratory Robot suites.
- `pages/` contains page-object style Robot Framework keywords and selectors.
- `resources/` contains shared browser setup, navigation helpers, and variables.
- `docker/` and `docker2/` contain container setups for local and CI-style execution.
- `tools/` contains helper scripts for working with test results.
- `results/`, `results2/`, `log.html`, `report.html`, and `output.xml` are generated test artifacts.

## Main test coverage

The suite currently covers:

- the landing page and its FAQ dialog
- the authentication info page
- accessibility header controls and footer navigation
- Leichte Sprache and Gebärdensprache dialogs
- legal notice, privacy, and accessibility dialogs
- external links to AusweisApp and compatible card-reader pages
- the register-selection page after successful login, including grid and list views, selection behavior, dialogs, FAQ access, timer checks, and reload stability
- the generic register-card result workflow after login, including fixture-based verification and controlled first-run fixture generation
- a safe cookie collection flow and related login helpers

For a file-by-file overview of the suites and keywords, see `README_Tests_Overview_EN.md`.
For a simple explanation of the register-card testing logic, see `LogicRegisterTests.md`.

## Requirements

The project uses:

- Python
- Robot Framework
- `robotframework-browser`
- supporting libraries such as `robotframework-requests`, `robotframework-jsonlibrary`, `robotframework-seleniumlibrary`, `robotframework-sshlibrary`, and `robotframework-databaselibrary`

Install the Python dependencies with:

```bash
pip install -r requirements.txt
```

If your environment does not already have the Browser library runtime available, follow the Robot Framework Browser setup for your platform before executing the suites.

## Configuration

Shared runtime settings live in `resources/dsc_variables.robot`.

Important variables include:

- `BASE_URL` for the Datenschutzcockpit SPA base route
- `AUTH_INFO_URL` for the authentication info page
- `BROWSER` to select the browser type
- `HEADLESS` to control headed or headless execution
- `TIMEOUT` for element waits and validations
- `SLOW_MOTION` for slower local runs
- `AUSWEISAPP_URL` for the AusweisApp SDK endpoint
- `CHROMIUM_EXECUTABLE` for a locally installed Chromium binary

The default target URL in this repository points to the quality-system deployment:

```text
https://qs-datenschutzcockpit.dsc.govkg.de/spa/
```

## Running the tests

The main smoke suites are in `tests/ui/`.

Typical examples:

```bash
robot tests/ui
```

Run a single suite when you only want one area:

```bash
robot tests/ui/ts_01_smoke_test_landing_page.robot
robot tests/ui/ts_02_smoke_test_auth_info_page.robot
robot tests/ui/ts_03_smoke_test_register_selection.robot
robot tests/ui/ts_04_smoke_test_register_selection_BVA.robot
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Run only the generic register-card verification suite:

```bash
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Run the generic first-run capture mode explicitly:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Force regeneration of already completed fixtures:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True --variable FIXTURE_FORCE_REGENERATE:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

The smaller suites in `tests/helpers/` are useful for focused checks and debugging.

### Tag-based execution

The suites use tags such as `smoke`, `landing`, `auth`, `faq`, `accessibility`, `accordion`, `external-link`, `e2e`, and `cookies`. Use Robot Framework tag filtering when you want a narrower run.
The register-selection suite also uses tags such as `register-auswahl`, `interaction`, `selection`, `toggle`, `list-view`, `all-registers`, `dialog`, `security`, `session`, `timer`, and `reload`.

## Docker and CI options

This repository contains several container setups:

- `docker/` provides the AusweisApp SDK simulator stack.
- `docker2/` provides a local test stack with `ausweisapp-sdk` and `robot-tests`, plus a self-hosted GitHub Actions runner configuration.

The Docker-based test setup typically runs with `CI=True`, `HEADLESS=True`, `BROWSER=chromium`, and `AUSWEISAPP_URL=http://127.0.0.1:24727` or a host-gateway equivalent.

To copy results from the runner container after a workflow run, use:

```bash
./tools/get-results.sh
```

## Generated artifacts

After a run, Robot Framework writes standard reports and logs such as:

- `report.html`
- `log.html`
- `output.xml`

If you want artifacts written explicitly into the `results/` folder, run Robot Framework with `robot --outputdir results ...`.

The `results/` and `results2/` directories contain saved artifacts from prior runs and can be used for debugging or comparison.

## Project structure at a glance

- `tests/ui/` - primary smoke test suites
- `tests/helpers/` - focused helper suites
- `tests/examples/` - example and exploratory suites
- `pages/` - page objects and assertions
- `resources/` - shared setup, navigation, and variables
- `docker*/` - Docker and CI support files
- `tools/` - result handling helpers

## Related documentation

- `README_Tests_Overview_EN.md`
- `README_Tests_Overview_DE.md`
- `LogicRegisterTests.md`
- `LogikRegisterTests.md`
