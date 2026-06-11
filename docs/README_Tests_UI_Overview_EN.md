# UI Test Overview — `tests/ui/`

Status: 2026-06-11

This document lists all UI suites and their test cases in compact form.

## 1) `tests/ui/ts_01_landing_page.robot`

- `TC001 - Validate Landing Page` - checks title, H1, intro, CTA, FAQ section, footer, floating FAQ button, and version information.
- `TC002 - Verify Header Accessibility Buttons Are Present On Landing Page` - checks the logo and the header buttons for easy language and sign language.
- `TC003 - Navigate To Leichte Sprache And Validate` - opens the easy-language dialog and validates content, internal links, and external links.
- `TC004 - Navigate To Gebärdensprache And Validate` - opens the sign-language dialog and validates content, video, and external links.
- `TC005 - Navigate To FAQ And Validate` - opens the FAQ dialog and validates title, main sections, and accordions.
- `TC006 - Verify All FAQ Cards Are Rendered On Landing Page` - checks that all FAQ cards are visible.
- `TC007 - Verify FAQ Card 'Was ist das Datenschutzcockpit' And Validate Content` - checks the first FAQ card for content and tab title.
- `TC008 - Verify FAQ Card 'Was sehe ich im Datenschutzcockpit' And Validate Content` - checks the second FAQ card for content and section structure.
- `TC009 - Verify FAQ Card 'Wer betreibt das Datenschutzcockpit' And Validate Content` - checks the third FAQ card for operator references.
- `TC010 - Verify FAQ Card 'Weitere Informationen' And Validate Content` - checks the fourth FAQ card for content and external links.
- `TC011 - Navigate To Impressum And Validate` - checks the legal-notice dialog, organisations, and email links.
- `TC012 - Navigate To Datenschutz And Validate` - checks the privacy dialog and legal references.
- `TC013 - Navigate To Barrierefreiheit And Validate` - checks the accessibility dialog, contact details, and external links.
- `TC014 - Full SPA User Journey` - runs a complete public journey flow across the key dialogs and FAQ cards.

## 2) `tests/ui/ts_02_auth_info_page.robot`

- `TC001 - Validate Authentication Info Page` - checks the auth-info page, header, footer, FAQ, and external guidance texts.
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present` - checks header, FAQ, and footer navigation.
- `TC003 - AusweisApp Link Navigates To External Page` - validates the external AusweisApp link.
- `TC004 - Kompatibles Lesegerät Link Navigates To External Page` - validates the external compatible card-reader link.
- `TC005 - Verify AusweisApp Starten Button Is Accessible` - checks the AusweisApp start button and drives the login/logout path in a controlled way.
- `TC006 - Verify FAQ Card 'Was benötige ich' And Validate Content` - checks the first FAQ card including external references.
- `TC007 - Verify FAQ Card 'Wie melde ich mich' And Validate Content` - checks the second FAQ card with login steps.
- `TC008 - Verify FAQ Card 'Wie sicher ist das Cockpit' And Validate Content` - checks the third FAQ card with security-related content.
- `TC009 - Full Login Page User Journey` - runs a full user-journey test across the auth-info page.

## 3) `tests/ui/ts_03_register_selection.robot`

- `TC001 - Validate Register Selection Page` - checks title, H1/H2, masked ID number, timer, logout, and intro text.
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present` - checks header, FAQ, footer, and version information.
- `TC003 - Verify Register List Elements Are Rendered` - checks the default grid state of the register selection page.
- `TC004 - Verify Intro Content Links Are Present` - checks the two intro buttons inside the page description.
- `TC005 - Verify Feedback Button Is Present` - checks the feedback button of the cockpit page.
- `TC006 - Select Single Register Enables Request Start` - checks that selecting one register enables the request-start button.
- `TC007 - Toggle Single Register Returns Empty State` - checks the return to the empty state after deselection.
- `TC008 - Toggle All Registers Select And Deselect` - checks select-all and deselect-all behavior.
- `TC009 - Intro Dialog 'Was sehe ich' Opens And Closes` - checks the first intro dialog with guard-based fallback behavior.
- `TC010 - Intro Dialog 'Was ist das DSC' Opens And Closes` - checks the second intro dialog with guard-based fallback behavior.
- `TC011 - Floating FAQ Dialog Opens And Closes` - checks the cockpit FAQ overlay.
- `TC012 - Verify IDNr Is Masked By Default` - checks that the ID number is masked by default.
- `TC013 - Verify Session Timer Counts Down` - checks that the session timer changes over time.
- `TC014 - Verify Register Cards Count And More-Info Buttons` - checks the card count and `Mehr zum Register lesen` buttons.
- `TC015 - Verify Register List View Elements Are Rendered` - checks the list view.
- `TC016 - Select Single Register In List View Enables Request Start` - checks selection behavior in list view.
- `TC017 - Toggle All Registers In List View Select And Deselect` - checks global select/deselect behavior in list view.
- `TC018 - Reload Keeps Registerauswahl Stable` - checks that the page stays stable after reload.

## 4) `tests/ui/ts_04_register_selection_bva.robot`

- `TC001 - Select Test BVA Register Card Enables Anfrage Starten` - checks selection of the BVA card.
- `TC002 - Deselect Test BVA Register Card Returns Empty Selection State` - checks clean deselection of the BVA card.
- `TC003 - Start BVA Request Navigates To Results Page` - checks navigation to the results page.
- `TC004 - Verify Results Page Shows Correct Statistics For BVA` - checks the result counters.
- `TC005 - Verify Test BVA Result Entry Is Visible And Collapsed` - checks the collapsed result block.
- `TC006 - Expand Test BVA Result Entry Shows Data Tables` - checks the expanded result block and its tables.
- `TC007 - Open First Protokolldaten Dialog Shows Initial State` - checks the initial state of the detail dialog.
- `TC008 - Request Personal Data Shows Inhaltsdaten In Dialog` - checks the loaded dialog after personal-data retrieval.
- `TC009 - Verify PDF Download Filename Matches Pattern And Timestamp` - checks PDF filename and timing window.
- `TC010 - Verify PDF Content Contains Current Date As Datenübermittlung Heading` - checks the PDF content.
- `TC011 - Close Protokolldaten Dialog Returns To Results View` - checks dialog closing behavior.
- `TC012 - Navigate Back To Register Auswahl Restores Correct URL` - checks back navigation.

## 5) `tests/ui/ts_04b_register_selection_bva.robot`

- `TC001` to `TC012` - mirror the BVA workflow from `ts_04` as a self-contained suite.
- `TC013 - Verify Test BVA Personal Data API Response Matches Fixture` - compares the live API response with `bva.json`.
- `API First Run: Capture BVA Personal Data API Response Fixture` - generates or updates `bva.json` in explicit `first-run-api` mode.

## 6) `tests/ui/ts_05_register_cards_generic.robot`

- `Verify Register Card Workflow: Test BVA` - validates the generic BVA dialog against `bva.yaml`.
- `Verify Register Card Workflow: Test-DGUV` - validates the generic DGUV dialog against `dguv.yaml`.
- `First Run: Capture And Generate Fixture For Test BVA` - generates or updates `bva.yaml` in explicit `first-run` mode.
- `First Run: Capture And Generate Fixture For Test-DGUV` - generates or updates `dguv.yaml` in explicit `first-run` mode.

## 7) `tests/ui/ts_05b_register_cards_generic.robot`

- `Verify Register Api Workflow: Test BVA` - validates the API response of the generic BVA flow against `bva.json`.
- `Verify Register Api Workflow: Test-DGUV` - validates the API response of the generic DGUV flow against `dguv.json`.
- `API First Run: Capture And Generate Fixture For Test BVA` - generates or updates `bva.json` and `bva_raw.json` in explicit `first-run-api` mode.
- `API First Run: Capture And Generate Fixture For Test-DGUV` - generates or updates `dguv.json` and `dguv_raw.json` in explicit `first-run-api` mode.

## Shared notes

- Suites `ts_03` to `ts_05b` require a successful AusweisApp login.
- `first-run` and `first-run-api` are intentionally opt-in and do not run during a normal suite execution.
- The generic register-testing approach is explained in more detail in `LogicRegisterTests.md`.
