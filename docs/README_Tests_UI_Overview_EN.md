# UI Test Overview — `tests/ui/`
Generated: 2026-04-23

This document summarizes the UI test suites in `tests/ui/` and lists the contained test cases per suite in a compact form.

## 1) `tests/ui/ts_01_smoke_test_landing_page.robot`

- `TC001 - Validate Landing Page` - Checks the landing page title, H1, intro text, CTA, FAQ section, footer navigation, floating FAQ button, and version string.
- `TC002 - Verify Header Accessibility Buttons Are Present On Landing Page` - Verifies the logo and the header buttons for Leichte Sprache and Gebärdensprache.
- `TC003 - Navigate To Leichte Sprache And Validate` - Opens the Leichte Sprache dialog and validates content, links, and return to the landing page.
- `TC004 - Navigate To Gebärdensprache And Validate` - Opens the sign-language dialog and checks the heading, video, and links.
- `TC005 - Navigate To FAQ And Validate` - Opens the FAQ dialog and validates the title, section headings, and accordion content.
- `TC006 - Verify All FAQ Cards Are Rendered On Landing Page` - Ensures that all four FAQ cards are visible on the landing page.
- `TC007 - Verify FAQ Card 'Was ist das Datenschutzcockpit' And Validate Content` - Opens the first FAQ card and checks its content and tab title.
- `TC008 - Verify FAQ Card 'Was sehe ich im Datenschutzcockpit' And Validate Content` - Opens the second FAQ card and checks the displayed content.
- `TC009 - Verify FAQ Card 'Wer betreibt das Datenschutzcockpit' And Validate Content` - Opens the third FAQ card and checks the referenced organizations.
- `TC010 - Verify FAQ Card 'Weitere Informationen' And Validate Content` - Opens the fourth FAQ card and checks content, links, and tab title.
- `TC011 - Navigate To Impressum And Validate` - Opens the legal notice dialog and validates headings, organizations, and email links.
- `TC012 - Navigate To Datenschutz And Validate` - Opens the privacy dialog and checks the sections and legal references.
- `TC013 - Navigate To Barrierefreiheit And Validate` - Opens the accessibility dialog and checks headings, contact details, and outbound links.
- `TC014 - Full SPA User Journey` - Runs a full smoke flow through the key SPA views and FAQ cards.

## 2) `tests/ui/ts_02_smoke_test_auth_info_page.robot`

- `TC001 - Validate Authentication Info Page` - Checks the authentication info page for title, H1, logo, accessibility buttons, footer, version, AusweisApp references, and FAQ content.
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present` - Checks header buttons, the floating FAQ button, and footer navigation for visibility and state.
- `TC003 - AusweisApp Link Navigates To External Page` - Opens the AusweisApp link in a new tab and validates the target page, URL, and title.
- `TC004 - Kompatibles Lesegerät Link Navigates To External Page` - Opens the compatible reader link and validates the external destination.
- `TC005 - Verify AusweisApp Starten Button Is Accessible` - Checks the button presence and state; the login/logout flow is covered in a controlled way.
- `TC006 - Verify FAQ Card 'Was benötige ich' And Validate Content` - Opens the first FAQ card and checks the content and external references.
- `TC007 - Verify FAQ Card 'Wie melde ich mich' And Validate Content` - Opens the second FAQ card and validates the step-by-step content.
- `TC008 - Verify FAQ Card 'Wie sicher ist das Cockpit' And Validate Content` - Opens the third FAQ card and checks security-related content and headings.
- `TC009 - Full Login Page User Journey` - Runs a complete smoke flow across the auth-info page and its FAQ content.

## 3) `tests/ui/ts_03_smoke_test_register_selection.robot`

- `TC001 - Validate Register Selection Page` - Checks the register-selection page for title, H1/H2, masked ID number, session timer, logout button, and intro text.
- `TC002 - Verify Header Accessibility And Navigation Buttons Are Present` - Checks the header buttons, floating FAQ button, footer navigation, and version display.
- `TC003 - Verify Register List Elements Are Rendered` - Checks the default state of the register list, selection controls, cards, and empty-state hints.
- `TC004 - Verify Intro Content Links Are Present` - Checks the two intro buttons that reference cockpit content.
- `TC005 - Verify Feedback Button Is Present` - Checks the feedback button in the side action bar.
- `TC006 - Select Single Register Enables Request Start` - Selects one register and verifies that `Anfrage starten` becomes visible and enabled.
- `TC007 - Toggle Single Register Returns Empty State` - Selects and deselects one register and verifies the return to the empty state.
- `TC008 - Toggle All Registers Select And Deselect` - Verifies the global select-all and deselect-all behavior.
- `TC009 - Intro Dialog "Was sehe ich" Opens And Closes` - Opens and closes the intro dialog for “Was sehe ich im Datenschutzcockpit?” with guarded fallback behavior.
- `TC010 - Intro Dialog "Was ist das DSC" Opens And Closes` - Opens and closes the second intro dialog with the same guarded fallback behavior.
- `TC011 - Floating FAQ Dialog Opens And Closes` - Opens the cockpit FAQ dialog and verifies title and close behavior.
- `TC012 - Verify IDNr Is Masked By Default` - Checks the masked ID number display and the reveal button.
- `TC013 - Verify Session Timer Counts Down` - Reads the session timer twice and verifies that it changes.
- `TC014 - Verify Register Cards Count And More-Info Buttons` - Checks that register cards and "Mehr zum Register lesen" buttons are present in matching counts.
- `TC015 - Reload Keeps Registerauswahl Stable` - Reloads the page and verifies that the core content stays stable.
- `TC016 - Verify Register List View Elements Are Rendered` - Switches to list view and checks the list-specific controls and empty-state hints.
- `TC017 - Select Single Register In List View Enables Request Start` - Switches to list view, selects one register, and verifies that `Anfrage starten` becomes visible and enabled.
- `TC018 - Toggle All Registers In List View Select And Deselect` - Switches to list view and verifies the global select-all and deselect-all behavior.

## Note

The register-selection suite is only reachable after a successful login. Some intro and more-info elements can be rendered as non-standard click targets depending on the environment; the suite handles that with controlled fallbacks. The suite also covers both grid and list views.

## 4) `tests/ui/ts_04_smoke_test_register_selection_BVA.robot`

- `TC001 - Select Test BVA Register Card Enables Anfrage Starten` - Selects the BVA register and verifies the request button state.
- `TC002 - Deselect Test BVA Register Card Returns Empty Selection State` - Verifies the BVA card can be toggled off cleanly.
- `TC003 - Start BVA Request Navigates To Results Page` - Starts a BVA request and checks the result route.
- `TC004 - Verify Results Page Shows Correct Statistics For BVA` - Checks the result counters for the BVA workflow.
- `TC005 - Verify Test BVA Result Entry Is Visible And Collapsed` - Verifies the BVA result box in collapsed state.
- `TC006 - Expand Test BVA Result Entry Shows Data Tables` - Expands the BVA result and checks table headings.
- `TC007 - Open First Protokolldaten Dialog Shows Initial State` - Opens the first BVA detail dialog and validates the initial state.
- `TC008 - Request Personal Data Shows Inhaltsdaten In Dialog` - Fetches personal data in the BVA dialog and validates the loaded state.
- `TC009 - Verify PDF Download Filename Matches Pattern And Timestamp` - Checks the generated PDF filename.
- `TC010 - Verify PDF Content Contains Current Date As Datenübermittlung Heading` - Checks the generated PDF content.
- `TC011 - Close Protokolldaten Dialog Returns To Results View` - Verifies dialog close behavior.
- `TC012 - Navigate Back To Register Auswahl Restores Correct URL` - Verifies returning from the result page.

## 5) `tests/ui/ts_05_smoke_test_register_cards_generic.robot`

- `Verify Register Card Workflow: Test BVA` - Verifies the generic BVA register-card workflow against `test_data/registers/bva.yaml`.
- `Verify Register Card Workflow: Test-DGUV` - Verifies the generic DGUV register-card workflow against `test_data/registers/dguv.yaml`.
- `First Run: Capture And Generate Fixture For Test BVA` - Captures the BVA dialog data and can regenerate `bva.yaml` when first-run is explicitly enabled.
- `First Run: Capture And Generate Fixture For Test-DGUV` - Captures the DGUV dialog data and can regenerate `dguv.yaml` when first-run is explicitly enabled.

## Note

The generic register-card suite uses two modes:

- Normal mode verifies live dialog data against YAML fixtures.
- First-run mode captures dialog data and writes fixtures.

First-run mode is opt-in and must be started with `--include first-run --variable ENABLE_FIRST_RUN_TESTS:True`.
Incomplete fixtures are regenerated automatically during first-run. Completed fixtures are only overwritten when `FIXTURE_FORCE_REGENERATE=True` is passed.
For a simple end-to-end explanation, see `LogicRegisterTests.md`.