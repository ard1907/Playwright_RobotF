# Playwright_RobotF

This repository automates tests for the Datenschutzcockpit SPA with Robot Framework, Python, and the Playwright-based Browser Library.
Its focus is UI validation for public pages, login-adjacent cockpit flows, register selection, and post-login result and dialog workflows.

## Quick overview

- `tests/ui/` contains the seven main UI suites.
- `tests/helpers/` contains small helper suites for basic checks and cookie analysis.
- `tests/api/` contains a demo suite for the InterceptCrypt approach.
- `tests/lup/` contains load and parallel probes for the production landing page.
- `pages/` implements the Page Object Model for pages, dialogs, and result workflows.
- `resources/` holds setup, teardown, shared navigation, variables, and Python helper libraries.
- `test_data/registers/` stores YAML and JSON fixtures for generic register testing.
- `docker/sdk/`, `docker/tests/`, and `docker/runner/` provide Docker stacks for SDK simulation, test execution, and the self-hosted runner.

## Tech stack

- Python 3.11 as the runtime for Robot Framework and project libraries
- Robot Framework as the keyword-driven automation framework
- `robotframework-browser` as the Playwright-based browser layer
- `robotframework-requests`, `robotframework-jsonlibrary`, `robotframework-seleniumlibrary`, `robotframework-sshlibrary`, `robotframework-databaselibrary`, `robotframework-pabot`
- `PyYAML` for YAML fixtures and `pypdf` for PDF verification in the BVA workflow

## Key UI suites

- `ts_01_landing_page.robot`: landing page, dialogs, FAQ, footer, and the full public journey flow
- `ts_02_auth_info_page.robot`: authentication-info page, FAQ, external links, and the AusweisApp start button
- `ts_03_register_selection.robot`: post-login register selection, grid/list view, dialogs, timer, feedback, and stability
- `ts_04_register_selection_bva.robot`: fixed BVA workflow including results page, dialog, PDF download, and back navigation
- `ts_04b_register_selection_bva.robot`: BVA workflow plus API-response verification against a JSON fixture
- `ts_05_register_cards_generic.robot`: generic register-card verification against YAML fixtures
- `ts_05b_register_cards_generic.robot`: generic register-card verification against decrypted API responses stored as JSON fixtures

## Typical commands

Install dependencies:

```bash
pip install -r requirements.txt
```

Run all UI suites:

```bash
robot tests/ui
```

Run the curated smoke selection:

```bash
robot --include smoke --outputdir results tests/ui
```

Run only the generic dialog/YAML suite:

```bash
robot tests/ui/ts_05_register_cards_generic.robot
```

Enable YAML first-run explicitly:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_register_cards_generic.robot
```

Enable API first-run explicitly:

```bash
robot --include first-run-api --variable ENABLE_API_FIRST_RUN_TESTS:True tests/ui/ts_05b_register_cards_generic.robot
```

## Docker and CI/CD

- `docker/sdk/docker-compose.yml` starts a local AusweisApp SDK simulator on port `24727`.
- `docker/tests/docker-compose.yml` starts `ausweisapp-sdk` and the non-root `robot-tests` container for CI-like runs.
- `docker/runner/docker-compose.yml` starts a pinned self-hosted GitHub Actions runner container.
- `.github/workflows/ci_tests_workflow.yml` runs the UI suites on `ubuntu-latest`, installs browser dependencies, and uploads Robot artifacts.
- `.github/workflows/ci_tests_workflow_selfhosted.yml` runs the Docker test stack on the self-hosted runner and copies artifacts out of the `robot-tests` container.

## Artifacts and fixtures

- Standard reports: `report.html`, `log.html`, `output.xml`
- Workflow output folders: `results/` and `results2/`
- Dialog fixtures: `test_data/registers/*.yaml`
- API fixtures: `test_data/registers/*.json` and `*_raw.json`

## Related documentation

- `README_Tests_Overview_EN.md`: overall test, page, and resource overview
- `README_Tests_UI_Overview_EN.md`: all UI suites and test cases in detail
- `LogicRegisterTests.md`: register-testing logic for YAML- and API-based verification
- `presentation.md`: short German project presentation in simple language
