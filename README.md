# Playwright_RobotF

Central entry point for the project documentation.

This repository contains Robot Framework and Playwright-based smoke tests for the Datenschutzcockpit SPA.
The documentation is split into language-specific README files, test overviews, and dedicated guides for the generic register-card testing logic.

## Documentation index

### General project documentation

- English: [docs/README_EN.md](docs/README_EN.md)
- Deutsch: [docs/README_DE.md](docs/README_DE.md)

### Test overviews

- Full test overview, English: [docs/README_Tests_Overview_EN.md](docs/README_Tests_Overview_EN.md)
- Full test overview, Deutsch: [docs/README_Tests_Overview_DE.md](docs/README_Tests_Overview_DE.md)
- UI suite overview, English: [docs/README_Tests_UI_Overview_EN.md](docs/README_Tests_UI_Overview_EN.md)
- UI suite overview, Deutsch: [docs/README_Tests_UI_Overview_DE.md](docs/README_Tests_UI_Overview_DE.md)

### Register-card logic guides

- English guide: [docs/LogicRegisterTests.md](docs/LogicRegisterTests.md)
- Deutsche Anleitung: [docs/LogikRegisterTests.md](docs/LogikRegisterTests.md)

## Most important suites

- `tests/ui/ts_03_register_selection.robot` - authenticated register-selection smoke tests
- `tests/ui/ts_04_register_selection_bva_ui.robot` - BVA-specific result workflow
- `tests/ui/ts_05_register_selection_bva_ui_api.robot` - BVA-specific workflow with API-response verification
- `tests/ui/ts_06_register_cards_generic_dom_test.robot` - generic register-card verification via YAML fixtures
- `tests/ui/ts_07_register_cards_generic_api_test.robot` - generic register-card verification via JSON fixtures

## Typical commands

Refresh all Docker stacks after the folder restructure:

```powershell
.\tools\docker\refresh-docker.ps1
```

Run the same refresh with aggressive Docker cleanup of unused resources:

```powershell
.\tools\docker\refresh-docker.ps1 -PruneAll
```

Run all UI suites:

```bash
robotcode --profile default robot
```

Run the curated smoke selection only:

```bash
robotcode --profile default --profile smoke robot
```

Run only the generic dialog/YAML suite:

```bash
robotcode --profile default robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

Run generic YAML first-run capture explicitly:

```bash
robotcode --profile default --profile first-run robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

Force regeneration of completed YAML fixtures:

```bash
robotcode --profile default --profile first-run-force robot --by-longname "Ui.Ts 06 Register Cards Generic Dom Test"
```

Run generic API first-run capture explicitly:

```bash
robotcode --profile default --profile first-run-api robot --by-longname "Ui.Ts 07 Register Cards Generic Api Test"
```

Run the full UI scope in GitHub-hosted CI mode against Prod:

```bash
robotcode --profile default --profile ci-github-hosted robot
```

Run the full UI scope in self-hosted CI mode against QS:

```bash
robotcode --profile default --profile ci-selfhosted robot
```

## Notes

- The curated smoke run currently covers 6 representative UI cases: landing page, authentication info page, AusweisApp start flow, register selection, BVA start flow, and generic BVA register-card verification.
- The generic register-card suites separate normal verification from explicit `first-run` and `first-run-api` capture modes.
- First-run modes are intentionally opt-in and require `ENABLE_FIRST_RUN_TESTS=True` or `ENABLE_API_FIRST_RUN_TESTS=True`.
- `default` is the canonical full-start profile for `tests/ui`; environment-specific behavior is layered on top via additive profiles such as `smoke`, `first-run`, `ci-github-hosted`, and `ci-selfhosted`.
- New register-card logic documentation is available in both German and English via the files linked above.
