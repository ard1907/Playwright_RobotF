# LUP – Landing Page Load Tests

Parallel landing-page probes against the production environment.

## Execution

### Option 1: Test-Level Split (Recommended)

Run a single suite with 20 test cases in parallel using `--testlevelsplit`:

```powershell
pabot --testlevelsplit --outputdir results_pabot tests\lup\load_test_00.robot
```

**Important:** `load_test_00.robot` uses `Test Setup` (not `Suite Setup`) to ensure each test case opens its own browser instance. This simulates **20 concurrent users/browser sessions** for a realistic performance test.

This approach parallelizes individual test cases within one suite and is more efficient than running multiple suite files.

### Option 2: Suite-Level Split (Legacy)

Run all nine LUP suites in parallel with pabot:

```powershell
pabot --processes 9 --outputdir results_pabot tests\lup\load_test_*.robot
```

Or from the workspace root:

```powershell
pabot --processes 9 --outputdir results_pabot tests/lup/load_test_*.robot
```

## Configuration

- **Target URL**: `https://datenschutzcockpit.bund.de/spa/`
- **Browser**: Chromium headless
- **Browser Timeout**: 30s (required for stable 9-way parallel navigation)
- **Shared Resource**: `tests/lup/lup_common.robot`

## Results

All pabot artifacts (logs, reports, worker outputs) are written to `results_pabot/` and excluded from version control via `.gitignore`.

## Performance Metrics

Each suite logs navigation performance metrics captured via `performance.getEntriesByType('navigation')`:

- `domContentLoadedMs`
- `loadEventEndMs`
- `responseEndMs`

Example output:

```json
{
  "url": "https://datenschutzcockpit.bund.de/spa/",
  "title": "Datenschutzcockpit - Startseite",
  "readyState": "complete",
  "domContentLoadedMs": 2352,
  "loadEventEndMs": 2352,
  "responseEndMs": 198
}
```
