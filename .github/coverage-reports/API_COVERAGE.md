# GBIF API Coverage Tracking

This directory contains tools for tracking which GBIF API endpoints are implemented in the rgbif package.

## Overview

The GBIF API Coverage system helps maintain visibility into which API endpoints from the official GBIF OpenAPI specifications are implemented in rgbif. This ensures we can:

- Track API coverage over time
- Identify missing endpoints that users might need
- Detect when new API endpoints are added by GBIF
- Maintain alignment between rgbif and the GBIF API

## Components

### 1. Mapping File (`coverage-reports/api-mapping.json`)

The mapping file is the central source of truth connecting rgbif R functions to GBIF API endpoints. It includes:

- **mappings**: List of rgbif functions with their corresponding API endpoints and parameters
- **ignored_endpoints**: Endpoints intentionally not implemented (with reasons)
- **ignored_parameters**: Function parameters intentionally omitted (with reasons)
- **metadata**: Version, last updated date, and notes

#### Schema

```json
{
  "metadata": { 
    ...
    "priority_field": "Optional 'priority' field can be added to mappings and ignored_endpoints"
  },
  "mappings": [
    {
      "function_name": "occ_search",
      "endpoint": "/occurrence/search",
      "method": "GET",
      "api": "occurrence",
      "parameters": ["taxonKey", "country", ...],
      "notes": "Optional description",
      "priority": "high|low|unclassified (optional)"
    }
  ],
  "ignored_endpoints": [
    {
      "endpoint": "/admin/endpoint",
      "api": "registry",
      "reason": "Administrative endpoint not relevant for R users",
      "date_added": "2026-05-05",
      "priority": "low (optional)"
    }
  ],
  "ignored_parameters": {
    "function_name": {
      "parameter": "reason for omission"
    }
  }
}
```

#### Priority Field

The optional `priority` field helps classify endpoints by implementation importance:

- **`high`**: Critical endpoints that are commonly used or essential functionality
- **`low`**: Nice-to-have endpoints that are less commonly needed
- **`unclassified`**: New endpoints that haven't been prioritized yet

The field can be omitted entirely if prioritization hasn't been determined. This is useful for:
- Tracking which missing endpoints should be implemented first
- Planning development roadmap
- Understanding which ignored endpoints might be reconsidered
- Identifying new API additions that need triage

### 2. Coverage Check Script (`coverage-reports/check-api-coverage.R`)

The main script that:

1. Downloads the three GBIF OpenAPI specifications:
   - `https://techdocs.gbif.org/openapi/occurrence.json`
   - `https://techdocs.gbif.org/openapi/checklistbank.json`
   - `https://techdocs.gbif.org/openapi/registry.json`

2. Extracts all endpoints and parameters from each spec

3. Compares against `coverage-reports/api-mapping.json`

4. Generates coverage reports:
   - Console output with colored status messages
   - JSON report (`coverage-reports/coverage-report.json`)
   - Markdown report (`coverage-reports/coverage-report.md`)

5. Calculates coverage statistics:
   - Total endpoints in GBIF APIs
   - Number of ignored endpoints
   - Number of implemented endpoints
   - Coverage percentage
   - Functions with missing parameters

### 3. Mapping Template Generator (`coverage-reports/generate-mapping-template.R`)

A helper script to bootstrap the mapping file by:

1. Scanning all R files in the `R/` directory
2. Identifying exported functions (via `@export` roxygen tag)
3. Extracting API endpoint URLs from code patterns like `paste0(gbif_base(), '/endpoint')`
4. Extracting function parameters from function signatures
5. Generating a template JSON file (`coverage-reports/api-mapping-template.json`)

This is useful when adding many new functions or doing a comprehensive mapping update.

### 4. GitHub Actions Workflow (`workflows/api-coverage.yml`)

Automated workflow that:

- Runs weekly (Monday at 9 AM UTC)
- Can be triggered manually via workflow_dispatch
- Runs on pushes to mapping or script files
- Uploads coverage reports as artifacts (retained for 90 days)
- Displays coverage summary in workflow output
- Optionally can fail if coverage drops below threshold

## Usage

### Running Coverage Check Locally

```bash
# From the package root directory
Rscript .github/coverage-reports/check-api-coverage.R
```

**Prerequisites:**
- R installed
- R packages: `jsonlite`, `httr`

**Output:**
- Console output with coverage statistics
- Reports saved to `.github/coverage-reports/`

### Generating Mapping Template

```bash
# From the package root directory
Rscript .github/coverage-reports/generate-mapping-template.R
```

This creates `.github/coverage-reports/api-mapping-template.json` with auto-detected function mappings. Review and merge into `coverage-reports/api-mapping.json` manually.

### Viewing Reports

Coverage reports are saved in `.github/coverage-reports/`:

- `coverage-report.json` - Machine-readable report (overwritten each run)
- `coverage-report.md` - Human-readable report (overwritten each run)

Reports include:
- Coverage summary statistics
- List of missing endpoints with descriptions
- Functions with missing parameters

### GitHub Actions

The workflow runs automatically but can be triggered manually:

1. Go to **Actions** tab in GitHub
2. Select **API Coverage Check** workflow
3. Click **Run workflow**
4. View results and download artifacts

## Maintaining the Mapping

### When Adding a New Function

1. Implement your new R function in `R/`
2. Add a mapping entry to `.github/coverage-reports/api-mapping.json`:

```json
{
  "function_name": "your_new_function",
  "endpoint": "/api/endpoint",
  "method": "GET",
  "api": "occurrence",
  "parameters": ["param1", "param2"],
  "notes": "Brief description",
  "priority": "high" // optional: high, low, or unclassified
}
```

3. Run coverage check to verify:
   ```bash
   Rscript .github/coverage-reports/check-api-coverage.R
   ```

### When Ignoring an Endpoint

If an API endpoint is intentionally not implemented (e.g., administrative endpoints, experimental features), add it to `ignored_endpoints`:

```json
{
  "endpoint": "/admin/endpoint",
  "api": "registry",
  "reason": "Administrative endpoint not relevant for R users",
  "date_added": "2026-05-05",
  "priority": "low" // optional: helps track if endpoint might be reconsidered
}
```

**Good reasons to ignore:**
- Administrative/internal endpoints
- Experimental/unstable endpoints
- Redundant endpoints covered by other functions
- Endpoints not relevant for R package users

### When GBIF Updates Their API

1. Run the coverage check - it will detect new endpoints
2. Review the missing endpoints in the report
3. Decide for each endpoint:
   - **Implement**: Add new R function and update mapping
   - **Ignore**: Add to `ignored_endpoints` with reason
   - **Defer**: Track in GitHub issue for future implementation

### Parameter Updates

If GBIF adds new parameters to existing endpoints:

1. The coverage check will flag functions with missing parameters
2. Update the R function to include the new parameter
3. Update the `parameters` list in `coverage-reports/api-mapping.json`
4. Update function documentation

If a parameter is intentionally omitted, add to `ignored_parameters`.

## CI/CD Integration

The workflow is configured to:

- **Schedule**: Run weekly to catch API updates
- **Artifacts**: Upload reports (90-day retention)
- **Threshold**: Warn if coverage drops below 50% (configurable)
- **Notifications**: Display summary in workflow output

To make the workflow fail on low coverage, uncomment the `exit 1` line in the threshold check step.

## Troubleshooting

### Coverage check fails to download specs

- Check internet connectivity
- Verify OpenAPI spec URLs are still valid
- Check if GBIF API is accessible

### Mapping file validation errors

- Ensure JSON is valid (use `jsonlint` or an online validator)
- Check that all required fields are present
- Verify endpoint paths match GBIF API format (start with `/`)

### Template generator doesn't detect endpoints

- Ensure functions use the standard pattern: `paste0(gbif_base(), '/endpoint')`
- Check that functions have `@export` roxygen tag
- Verify R file can be sourced without errors

### Reports not generating

- Check write permissions to `.github/coverage-reports/`
- Ensure `jsonlite` package is installed
- Look for error messages in console output

## Configuration

### Environment Variables

The coverage check script supports these environment variables:

- `COVERAGE_THRESHOLD` - Minimum coverage percentage (default: 50)
- `OPENAPI_CACHE_DIR` - Cache directory for downloaded specs

### Workflow Configuration

Edit `.github/workflows/api-coverage.yml` to customize:

- **Schedule**: Change the cron expression
- **Branches**: Modify `push.branches` list
- **Threshold**: Update the `THRESHOLD` variable
- **Retention**: Change `retention-days` for artifacts

## Best Practices

1. **Keep mappings updated**: Update `coverage-reports/api-mapping.json` when adding/modifying functions
2. **Document ignored items**: Always provide a clear reason for ignored endpoints/parameters
3. **Use priority field**: Add `priority` field to new endpoints/functions to help with planning and roadmap decisions
4. **Review reports regularly**: Check coverage reports from automated runs
5. **Use semantic versioning**: Update `metadata.version` for significant mapping changes
6. **Test locally first**: Run coverage check locally before pushing changes
7. **Track API changes**: Monitor GBIF API documentation for updates

## Related Resources

- [GBIF API Documentation](https://www.gbif.org/developer/summary)
- [GBIF OpenAPI Specifications](https://techdocs.gbif.org/en/openapi/)
- [rgbif Documentation](https://docs.ropensci.org/rgbif/)

## Future Enhancements

Potential improvements to consider:

- **Parameter type validation**: Compare parameter types (string, integer, enum)
- **API versioning support**: Track multiple API versions
- **Automated issue creation**: Create GitHub issues for missing endpoints
- **Coverage badges**: Generate README badges showing coverage percentage
- **Historical tracking**: Store coverage trends over time
- **Interactive dashboard**: Web interface for exploring coverage

## Questions or Issues

If you have questions about the API coverage system or encounter issues:

1. Check this documentation
2. Review existing coverage reports
3. Open an issue on GitHub with the `api-coverage` label
