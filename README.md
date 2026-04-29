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

- `tests/ui/ts_03_smoke_test_register_selection.robot` - authenticated register-selection smoke tests
- `tests/ui/ts_04_smoke_test_register_selection_BVA.robot` - BVA-specific result workflow
- `tests/ui/ts_05_smoke_test_register_cards_generic.robot` - generic register-card verification via YAML fixtures

## Typical commands

Run all UI suites:

```bash
robot tests/ui
```

Run only the generic register-card suite:

```bash
robot tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Run generic first-run capture explicitly:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

Force regeneration of completed generic fixtures:

```bash
robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True --variable FIXTURE_FORCE_REGENERATE:True tests/ui/ts_05_smoke_test_register_cards_generic.robot
```

## Notes

- The generic register-card suite has a normal verification mode and a separate first-run capture mode.
- First-run is intentionally opt-in and requires `ENABLE_FIRST_RUN_TESTS=True`.
- New register-card logic documentation is available in both German and English via the files linked above.

