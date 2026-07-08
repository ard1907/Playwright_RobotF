# Test Overview â€” Playwright_RobotF

Status: 2026-06-11

This document summarizes the main test areas, the page-object layer, and the shared resource layer of the repository.

## Test areas

### `tests/ui/`

- `ts_01_landing_page.robot` covers the public landing page, public dialogs, FAQ, footer content, and the public journey flow.
- `ts_02_auth_info_page.robot` covers the authentication-info page, external links, FAQ content, and the AusweisApp start entry.
- `ts_03_register_selection.robot` covers post-login register selection, grid/list view, dialogs, timer behavior, feedback, and reload stability.
- `ts_04_register_selection_bva_ui.robot` covers the fixed BVA result workflow including result expansion, detail dialog, and PDF checks.
- `ts_05_register_selection_bva_ui_api.robot` mirrors the BVA workflow and adds API-response verification against `test_data/registers/bva.json`.
- `ts_06_register_cards_generic_dom_test.robot` verifies generic register cards through YAML fixtures such as `bva.yaml` and `dguv.yaml`.
- `ts_07_register_cards_generic_api_test.robot` verifies generic register cards through decrypted API-response fixtures such as `bva.json` and `dguv.json`.

### `tests/helpers/`

- `dsc_basic_test.robot` is a small onboarding suite for the landing page and the easy-language dialog.
- `dsc_get_cookies_requests.robot` is a login-based cookie inspection suite for the authentication page.

### `tests/api/`

- `interceptcrypt_smoke.robot` is a minimal example for the InterceptCrypt hook and decrypted register-data interception in the browser.

### `tests/lup/`

- `lup_common.robot` provides shared keywords for landing-page probes against the production URL.
- `load_test_00.robot` to `load_test_09.robot` provide parallel load and reachability checks designed for `pabot`.

## Page objects in `pages/`

- `dsc_landing_page.robot` contains landing-page validation and public entry checks.
- `dsc_authentication_info_page.robot` contains auth-info, FAQ, and external-link validation.
- `dsc_register_selection_page.robot` contains register-selection, grid/list logic, dialog checks, and state checks.
- `dsc_register_selection_bva.robot` contains BVA-specific result and dialog logic.
- `dsc_register_result_page.robot` contains the generic register-dialog workflow and YAML-based verification.
- `dsc_register_result_page_api.robot` contains the API-based register-dialog workflow and JSON fixture generation.
- `dsc_faq_page.robot`, `dsc_easy_language_page.robot`, `dsc_sign_language_page.robot`, `dsc_imprint_legal_notice_page.robot`, `dsc_privacy_page.robot`, and `dsc_accessibility_page.robot` encapsulate single dialogs and page-specific checks.

## Shared resources in `resources/`

- `dsc_setup_teardown.robot` provides browser lifecycle management, login/logout flows, and suite-wide guards.
- `dsc_shared_keywords.robot` provides general navigation and reusable UI helper keywords.
- `dsc_variables.robot` stores target URLs, browser and timeout settings, expected page titles, and technical constants.
- `browser_scripts/` contains browser-side JavaScript extensions for advanced scenarios such as interception.
- `libraries/` and `scripts_py/` contain Python helpers for fixture processing and technical support logic.

## Register fixtures

- YAML fixtures live in `test_data/registers/` and currently include `bva.yaml` and `dguv.yaml`.
- API fixtures live in `test_data/registers/` and currently include `bva.json`, `bva_raw.json`, `dguv.json`, and `dguv_raw.json`.

## Key architecture notes

- The project follows the Page Object Model, so selectors and UI actions are kept in `pages/` instead of the suites.
- The tests are keyword-driven, so business-readable steps stay separate from technical implementation.
- Login-dependent suites reuse the shared setup and teardown keywords from `resources/`.
- Generic register verification is split into dialog-based YAML verification and API-based JSON verification.
- `first-run` and `first-run-api` are intentionally opt-in and do not run in default suite execution.

## Recommended reading order

- Start with `tests/ui/` for product-level coverage.
- Continue with `pages/` to see the technical interaction layer.
- Continue with `resources/` to understand shared setup and helper logic.
- Open `LogicRegisterTests.md` for the generic register-testing approach.
- Use `presentation.md` for a short German presentation of the whole project.
