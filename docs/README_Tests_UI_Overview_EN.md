# UI Test Overview — `tests/ui/`
Generated: 2026-04-23

This document summarizes the three test suites in `tests/ui/` and lists the contained test cases per suite in a compact form.

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