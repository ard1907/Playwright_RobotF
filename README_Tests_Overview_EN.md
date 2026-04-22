# Test Overview — Playwright_RobotF project
Generated: 2026-04-22

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

- `test_helpers/dsc_basic_test.robot`
  - Suite Setup: `Open Application Browser`
  - Test Setup: `Navigate To Landing Page`
  - Suite Teardown: `Close Application Browser`
  - Test Cases:
    - TC001 — Validate Landing Page
      - A compact suite that validates primary landing page elements (title, H1, CTA, basic checks).
    - TC002 — Navigate To Leichte Sprache And Validate
      - Opens Leichte Sprache dialog and runs the related validation keywords.

- `test_helpers/dsc_get_cookies_requests.robot`
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
  - Contains logout helpers used by some suites: `Logout From Datenschutzcockpit`.

---

## 3) Shared resources (resources/)
- `resources/dsc_setup_teardown.robot`
  - Provides `Open Application Browser`, `Open Chromium Browser`, `Close Application Browser` — central browser lifecycle helpers.
- `resources/dsc_shared_keywords.robot`
  - Utility keywords used across suites: `Navigate To Landing Page`, `Navigate To Authentication Info Page`, `Verify Page Title Contains`, `Element Is Visible`, `Close Currently Open Dialog`, `Open External Tab And Validate`, and dialog/tab helpers.
- `resources/dsc_variables.robot`
  - Variables: `${BASE_URL}`, `${AUTH_INFO_URL}`, `${BROWSER}`, `${HEADLESS}`, `${TIMEOUT}`, `${TITLE_*}` strings, `${AUSWEISAPP_URL}` env override. Controls runtime behavior and expected titles.

---

## 4) How to read the tests quickly
- Top-level smoke suites are in `tests/ui/` and helper suites in `test_helpers/`.
- Each suite imports `resources/dsc_*` and `pages/*` — page objects encapsulate selectors and assertions.
- Look for `Validate ...` master keywords inside `pages/*.robot` to see exactly what assertions are performed.
- Use tags (e.g., `smoke`, `landing`, `auth`, `faq`, `accessibility`, `cookies`) to filter test runs.

---

## 5) Notes & Recommendations
- Pattern: Page Object Model — update selectors only in `pages/*.robot` and shared logic in `resources/*.robot`.
- Adding tests: create page keywords, add a suite in `tests/ui/` or `test_helpers/`, import resources/pages and call the `Validate ...` master keywords.
- When updating external-link assertions, prefer `Open External Tab And Validate` helper to keep consistency.

---

## Where to find files
- Tests: `tests/ui/`, helpers: `test_helpers/`
- Page objects: `pages/`
- Shared resources and variables: `resources/`

---



