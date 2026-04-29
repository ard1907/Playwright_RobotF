# Test Overview — Playwright_RobotF project
Generated: 2026-04-23

## Purpose
This document summarizes Robot Framework test suites, test cases, and key page-object / resource keywords in the repository. It is intended to help a new reader quickly understand what the automated tests cover and where to find the implementation.

---

## Table of Contents
- Test Suites
- Page objects (pages/)
- Shared resources (resources/)
- How to read the tests
- Notes & recommendations

---

## 1) Test Suites (by file)

- `tests/ui/ts_01_smoke_test_landing_page.robot`
  - Suite Setup: `Open Application Browser`
  - Test Setup: `Navigate To Landing Page`
  - Suite Teardown: `Close Application Browser`
  - Test Cases:
    - TC001 — Validate Landing Page
      - Checks page title, main H1, intro text, primary CTA, FAQ section, footer navigation, floating FAQ button and version string.
    - TC002 — Verify Header Accessibility Buttons Are Present On Landing Page
      - Ensures header logo and accessibility buttons (e.g., leichte Sprache, Gebärdensprache) are visible and enabled.
    - TC003 — Navigate To Leichte Sprache And Validate
      - Opens the 'Leichte Sprache' dialog and validates headings, content anchors and link targets.
    - TC004 — Navigate To Gebaerdensprache And Validate
      - Opens the sign-language dialog, validates heading, embedded video presence and associated links.
    - TC005 — Navigate To FAQ And Validate
      - Opens the FAQ dialog and validates dialog title, section headings and card items.
    - TC006 — Verify All FAQ Cards Are Rendered On Landing Page
      - Confirms the presence of all FAQ accordion cards on the landing page.
    - TC007..TC010 — Per-FAQ-card checks
      - Clicks each FAQ accordion card and validates the displayed content and tab titles.
    - TC011 — Navigate To Impressum And Validate
      - Opens Impressum dialog and validates headings, organizational entries and email links.
    - TC012 — Navigate To Datenschutz And Validate
      - Opens privacy (Datenschutz) dialog and validates numbered sections and regulatory references.
    - TC013 — Navigate To Barrierefreiheit And Validate
      - Opens accessibility dialog and validates headings, contact details and outbound links.
    - TC014 — Full SPA User Journey
      - End-to-end smoke flow: opens each dialog in sequence, performs spot checks and closes dialogs, expands FAQ cards.

- `tests/ui/ts_02_smoke_test_auth_info_page.robot`
  - Suite Setup: `Open Application Browser ${AUTH_INFO_URL}`
  - Test Setup: `Navigate To Authentication Info Page`
  - Suite Teardown: `Close Application Browser`
  - Test Cases:
    - TC001 — Validate Authentication Info Page
      - Verifies page title, H1, logo, accessibility buttons, footer nav, version string, AusweisApp links and embedded FAQ items.
    - TC002 — Verify Header Accessibility And Navigation Buttons Are Present
      - Checks header buttons, floating FAQ and footer navigation are present and functional.
    - TC003 — AusweisApp Link Navigates To External Page
      - Opens external AusweisApp site in a new tab and validates URL and page title.
    - TC004 — Kompatibles Lesegerät Link Navigates To External Page
      - Opens card reader compatibility external page and validates navigation and title.
    - TC005 — Verify AusweisApp Starten Button Is Accessible
      - Validates the `AusweisApp starten` button presence/state and performs safe click flow including login/logout helpers.
    - TC006..TC008 — Per-FAQ-card checks
      - Validate content and links for each FAQ card on the authentication info page.
    - TC009 — Full Login Page User Journey
      - End-to-end run focused on auth-info interactions and FAQ/card flows.

- `tests/ui/ts_03_smoke_test_register_selection.robot`
  - Suite Setup: `Open Browser And Login For AusweisApp Suite ${AUTH_INFO_URL}`
  - Test Setup: `Navigate To Register Auswahl Page`
  - Suite Teardown: `Close Browser After AusweisApp Suite`
  - Test Cases:
    - TC001 — Validate Register Selection Page
      - Verifies core register-selection elements: title, H1/H2, IDNr display, session timer, logout button, and intro text.
    - TC002 — Verify Header Accessibility And Navigation Buttons Are Present
      - Checks header buttons, floating FAQ, footer navigation, and version string.
    - TC003 — Verify Register List Elements Are Rendered
      - Validates the register-list default grid state, toggle controls, and empty-state hints.
    - TC004 — Verify Intro Content Links Are Present
      - Checks the two intro references to Datenschutzcockpit content.
    - TC005 — Verify Feedback Button Is Present
      - Validates the cockpit-specific feedback button.
    - TC006 — Select Single Register Enables Request Start
      - Selects one register and verifies that `Anfrage starten` becomes visible and enabled.
    - TC007 — Toggle Single Register Returns Empty State
      - Removes the selection again and validates the return to the empty state.
    - TC008 — Toggle All Registers Select And Deselect
      - Checks the global select-all / deselect-all register flow.
    - TC009 — Intro Dialog 'Was sehe ich' Opens And Closes
      - Opens the intro dialog when the environment renders the reference as clickable; otherwise uses a controlled warning fallback.
    - TC010 — Intro Dialog 'Was ist das DSC' Opens And Closes
      - Opens the second intro dialog with the same guard/fallback behavior.
    - TC011 — Floating FAQ Dialog Opens And Closes
      - Opens the cockpit FAQ overlay and validates title/close behavior.
    - TC012 — Verify IDNr Is Masked By Default
      - Checks the masked IDNr display and the reveal button.
    - TC013 — Verify Session Timer Counts Down
      - Reads the session timer twice and validates a state change.
    - TC014 — Verify Register Cards Count And More-Info Buttons
      - Checks that register cards and `Mehr zum Register lesen` buttons are present in matching counts.
    - TC015 — Reload Keeps Registerauswahl Stable
      - Reloads the page and validates that core content remains stable.
    - TC016 — Verify Register List View Elements Are Rendered
      - Switches to list view and checks the list-specific controls and empty-state hints.
    - TC017 — Select Single Register In List View Enables Request Start
      - Switches to list view, selects one register, and verifies that `Anfrage starten` becomes visible and enabled.
    - TC018 — Toggle All Registers In List View Select And Deselect
      - Switches to list view and validates the global select-all and deselect-all behavior.

- `tests/ui/ts_04_smoke_test_register_selection_BVA.robot`
  - Suite Setup: `Open Browser And Login For BVA Suite`
  - Test Setup: `Open Register Auswahl In Default Grid View`
  - Suite Teardown: `Close Browser After AusweisApp Suite`
  - Test Cases:
    - TC001..TC002 — BVA selection toggle checks
      - Validate selecting and deselecting the Test BVA card.
    - TC003..TC006 — BVA result page checks
      - Validate result-route navigation, result statistics, collapsed state, and expanded state.
    - TC007..TC012 — BVA detail dialog and PDF checks
      - Validate the Protokolldaten dialog, personal-data fetch, PDF checks, dialog close behavior, and return navigation.

- `tests/ui/ts_05_smoke_test_register_cards_generic.robot`
  - Suite Setup: `Open Browser And Login For Generic Register Suite`
  - Test Setup: `Open Register Auswahl In Default Grid View`
  - Suite Teardown: `Close Browser After Generic Register Suite`
  - Purpose:
    - Verifies register cards generically via YAML fixtures in `test_data/registers/`.
    - Uses one test case per register card for normal verification.
    - Uses separate first-run capture tests to build or refresh fixture data.
  - Runtime modes:
    - Normal mode: `robot tests/ui/ts_05_smoke_test_register_cards_generic.robot`
      - Loads a fixture, skips if `first_run.completed` is false, and verifies the live dialog against expected data.
    - First-run mode: `robot --include first-run --variable ENABLE_FIRST_RUN_TESTS:True tests/ui/ts_05_smoke_test_register_cards_generic.robot`
      - Captures live sender and field data, then writes fixture content.
      - Incomplete fixtures are regenerated automatically.
      - Completed fixtures are only overwritten when `FIXTURE_FORCE_REGENERATE=True` is passed.
  - Test Cases:
    - Verify Register Card Workflow: Test BVA
      - Verifies the generic BVA register against `bva.yaml`.
    - Verify Register Card Workflow: Test-DGUV
      - Verifies the generic DGUV register against `dguv.yaml`.
    - First Run: Capture And Generate Fixture For Test BVA
      - Captures live BVA dialog data and writes the fixture.
    - First Run: Capture And Generate Fixture For Test-DGUV
      - Captures live DGUV dialog data and writes the fixture.

- `tests/helpers/dsc_basic_test.robot`
  - Suite Setup: `Open Application Browser`
  - Test Setup: `Navigate To Landing Page`
  - Suite Teardown: `Close Application Browser`
  - Test Cases:
    - TC001 — Validate Landing Page
            - A compact suite that validates primary landing page elements (title, H1, CTA, basic checks).
    - TC002 — Navigate To Leichte Sprache And Validate
      - Opens Leichte Sprache dialog and runs the related validation keywords.

- `tests/helpers/dsc_get_cookies_requests.robot`
  - Suite Setup: `Open Application Browser For Cookie Testing`
  - Test Setup: `Navigate To Authentication Info Page`
  - Suite Teardown: `Close Application Browser`
  - Test Cases:
    - TC001 — Get Cookies From Authentication Info Page
      - Logs cookies after a (safe) login flow; uses `Login Into Datenschutzcockpit` and `Logout From Datenschutzcockpit` helpers. Tagged for cookie checks.

---

## 2) Page objects (pages/)
These provide page-level selectors and keywords. Use these files to update selectors or change assertions.

- `pages/dsc_landing_page.robot`
  - Master keyword: `Validate Landing Page` — checks title, H1, intro, CTA, FAQ section, footer nav and floating FAQ.
- `pages/dsc_easy_language_page.robot`
  - Master keyword: `Validate Leichte Sprache Page` — open/close dialog, verify H1, content anchors and links.
- `pages/dsc_authentication_info_page.robot`
  - Master keyword: `Validate Authentication Info Page` — many `Verify ...` keywords for AusweisApp button, FAQ cards and external links.
- `pages/dsc_faq_page.robot`
  - Master keyword: `Validate FAQ Page` — validates FAQ dialog headings and card items.
- `pages/dsc_imprint_legal_notice_page.robot`
  - Master keyword: `Validate Impressum Page` — checks H1, H2 sections and email links.
- `pages/dsc_privacy_page.robot`
  - Master keyword: `Validate Datenschutz Page` — checks numbered sections and regulatory references.
- `pages/dsc_accessibility_page.robot`
  - Master keyword: `Validate Barrierefreiheit Page` — checks headings, BITV references and contact links.
- `pages/dsc_sign_language_page.robot`
  - Master keyword: `Validate Gebaerdensprache Page` — verifies video presence and headings.
- `pages/dsc_register_selection_page.robot`
  - Contains register-selection assertions, grid/list view keywords, selection/toggle helpers, FAQ/intro dialog checks, IDNr/timer checks, and logout helpers.
- `pages/dsc_register_result_page.robot`
  - Contains the generic register-result flow: register selection, result expansion, Protokolldaten dialog open/fetch/close, pair-aware dialog field verification, and fixture generation rules.

---

## 3) Shared resources (resources/)
- `resources/dsc_setup_teardown.robot`
  - Provides `Open Application Browser`, `Open Chromium Browser`, `Close Application Browser` — central browser lifecycle helpers.
  - Provides `Open Browser And Login For AusweisApp Suite` and `Close Browser After AusweisApp Suite` — the reusable setup/teardown pair for future AusweisApp-dependent suites such as cockpit flows.
- `resources/dsc_shared_keywords.robot`
  - Utility keywords used across suites: `Navigate To Landing Page`, `Navigate To Authentication Info Page`, `Navigate To Register Auswahl Page`, `Verify Page Title Contains`, `Element Is Visible`, `Close Currently Open Dialog`, `Open External Tab And Validate`, and dialog/tab helpers.
  - Contains `Skip Current Test If AusweisApp Environment Is Missing` for isolated login-dependent tests that should skip on standard CI without skipping a whole suite.
- `resources/dsc_variables.robot`
  - Variables: `${BASE_URL}`, `${AUTH_INFO_URL}`, `${BROWSER}`, `${HEADLESS}`, `${TIMEOUT}`, `${TITLE_*}` strings, `${AUSWEISAPP_URL}` env override. Controls runtime behavior and expected titles.
- `resources/libraries/dsc_register_fixture_library.py`
  - Loads and writes YAML fixtures, exposes first-run status and expected dialog data, and supports robust key/value matching for the generic register-card suite.

---

## 4) How to read the tests quickly
- Top-level smoke suites are in `tests/ui/`, helper suites in `tests/helpers/`, and examples in `tests/examples/`.
- Each suite imports `resources/dsc_*` and `pages/*` — page objects encapsulate selectors and assertions.
- Look for `Validate ...` master keywords inside `pages/*.robot` to see exactly what assertions are performed.
- Use tags (e.g., `smoke`, `landing`, `auth`, `faq`, `accessibility`, `cookies`, `register-auswahl`, `interaction`, `selection`, `toggle`, `list-view`, `all-registers`, `dialog`, `security`, `session`, `timer`, `reload`) to filter test runs.

---

## 5) Notes & Recommendations
- Pattern: Page Object Model — update selectors only in `pages/*.robot` and shared logic in `resources/*.robot`.
- Adding tests: create page keywords, add a suite in `tests/ui/`, `tests/helpers/`, or `tests/examples/`, import resources/pages and call the `Validate ...` master keywords.
- For future AusweisApp-dependent suites such as `ts_04`, prefer this template instead of duplicating CI guards in tests or page objects:
  - `Suite Setup     Open Browser And Login For AusweisApp Suite    ${AUTH_INFO_URL}`
  - `Suite Teardown  Close Browser After AusweisApp Suite`
  - `Test Setup      <route-specific navigation keyword>`
- The temporary standard-CI skip is centrally switchable: comment out the `Skip If` line in `resources/dsc_setup_teardown.robot` for suite-wide behavior and in `resources/dsc_shared_keywords.robot` for isolated test-level login guards.
- When updating external-link assertions, prefer `Open External Tab And Validate` helper to keep consistency.
- For stable cockpit tests in `ts_03`, load the target route fresh per test so UI state is not inherited from the previous case.
- For the generic register-card suite, keep first-run opt-in explicit. Do not rely on the `first-run` tag alone; use `ENABLE_FIRST_RUN_TESTS=True`.
- When a register dialog renders fields in an unusual DOM structure, review the generated YAML and compare it with `LogicRegisterTests.md` before adjusting the capture JavaScript.

---

## Where to find files
- Tests: `tests/ui/`, helpers: `tests/helpers/`, examples: `tests/examples/`
- Page objects: `pages/`
- Shared resources and variables: `resources/`

---
