# Interactive API Coverage System

This directory contains an interactive system for tracking and managing GBIF API coverage in rgbif.

## Overview

The coverage system automatically:
1. Downloads GBIF OpenAPI specifications
2. Compares them against rgbif's implementation
3. Generates a coverage report with interactive checkboxes
4. Allows maintainers to mark parameters/endpoints for action
5. Automatically updates configuration and creates GitHub issues

## Files

- **check-api-coverage.R** - Main script that generates the coverage report with checkboxes
- **process-coverage-checkboxes.R** - Script that processes checked boxes and takes actions
- **api-mapping.json** - Master configuration mapping rgbif functions to GBIF API endpoints
- **coverage-report.md** - Generated report with interactive checkboxes (regenerated automatically)
- **coverage-report.json** - Machine-readable version of the coverage report
- **actions-to-take.json** - Generated file containing actions for the workflow (temporary)

## Workflows

### API Coverage Check (`api-coverage.yml`)
- **Triggers**: Weekly on Mondays, manual, or when mapping files change
- **Actions**: 
  - Downloads latest OpenAPI specs
  - Generates coverage report with checkboxes
  - Commits updated report to repository

### Process Coverage Actions (`process-coverage-actions.yml`)
- **Trigger**: Manual only (`workflow_dispatch`)
- **Actions**:
  - Parses checked boxes in coverage-report.md
  - Updates api-mapping.json with ignored items
  - Creates GitHub issues for items marked for implementation
  - Commits all changes back to repository
  - Resets checkboxes for next use

## Usage Guide

### 1. Review the Coverage Report

Open [coverage-report.md](coverage-report.md) to see missing endpoints and parameters.

### 2. Mark Items for Action

For each missing item, check the appropriate box(es):

#### Endpoints
```markdown
### GET /validation/sequence
- **API:** validator
- **Summary:** Validate sequence data
- **Operation ID:** validateSequence
- **Actions:** [x] Ignore [ ] Issue
```

#### Parameters
```markdown
### occ_count - GET /occurrence/search
- **Missing parameters:**
  - `nucleotideSequence.sequence` [x] Ignore [ ] Issue
  - `nucleotideSequence.gcContent` [ ] Ignore [x] Issue
```

**Checkbox Options:**
- **[x] Ignore** - Add to `ignored_parameters` or `ignored_endpoints` in api-mapping.json
  - Use this for parameters/endpoints that won't be implemented (too specialized, deprecated, etc.)
- **[x] Issue** - Create a GitHub issue to track implementation
  - Use this for parameters/endpoints you plan to implement eventually

You can check both boxes if needed (ignore for now but track for future).

### 3. Commit Your Changes

After checking boxes in coverage-report.md:

```bash
git add .github/coverage-reports/coverage-report.md
git commit -m "Mark API coverage items for processing"
git push
```

### 4. Run the Workflow

Go to **Actions** → **Process Coverage Actions** → **Run workflow**

Options:
- **Dry run**: Check this to preview changes without creating issues or committing

### 5. Review Results

The workflow will:
- ✅ Add checked "Ignore" items to api-mapping.json
- ✅ Create GitHub issues for checked "Issue" items (with deduplication)
- ✅ Reset all checkboxes in coverage-report.md
- ✅ Commit all changes with a summary message

Check the workflow summary for statistics and links to created issues.

## Understanding api-mapping.json

### Structure

```json
{
  "metadata": { ... },
  "mappings": [ ... ],
  "ignored_endpoints": [ ... ],
  "ignored_parameters": {
    "general": { ... },
    "function_name": {
      "parameter_name": "reason"
    }
  }
}
```

### ignored_parameters

Two types of entries:

1. **general** - Parameters ignored across ALL functions
   ```json
   "general": {
     "curlopts": "Internal parameter for curl options - accepted by all functions",
     "arg0": "Generic/placeholder parameter in OpenAPI spec - not a real parameter",
     "Accept-Language": "HTTP header for language preference - not implemented in rgbif"
   }
   ```

2. **function-specific** - Parameters ignored for specific functions
   ```json
   "name_lookup": {
     "q": "Covered by parameter name mapping (q→query)"
   }
   ```

### ignored_endpoints

Endpoints that won't be implemented in rgbif:

```json
"ignored_endpoints": [
  {
    "endpoint": "GET /dataset/suggest",
    "api": "registry",
    "reason": "Autocomplete/suggest helper endpoint not implemented in rgbif",
    "date_added": "2026-05-08"
  }
]
```

## Common Reasons for Ignoring

### Parameters
- **Parameter name mapping** - "Covered by 'uuid' parameter in R function" (when API uses `key` but R uses `uuid`)
- **Generic placeholders** - "Generic/placeholder parameter in OpenAPI spec - not a real parameter" (arg0, arg1, etc.)
- **Not implemented** - "Not implemented" (feature out of scope for R users)
- **Internal handling** - "OAI-PMH protocol parameter - handled internally by function logic"

### Endpoints
- **Too specialized** - "Specialized endpoint not relevant for R users"
- **Write operations** - "Write endpoint - rgbif focuses on read operations"
- **Administrative** - "Administrative endpoint not needed in client library"
- **Deprecated** - "Deprecated endpoint - replaced by newer version"

## Best Practices

1. **Review before checking** - Make sure the parameter/endpoint really isn't implemented
2. **Check documentation** - Look at the R function documentation to verify
3. **Add clear reasons** - While not required, manually editing api-mapping.json with descriptive reasons helps future maintainers
4. **Batch processing** - Check multiple items at once, then run the workflow once
5. **Regular reviews** - Run coverage checks regularly to catch new API additions

## Troubleshooting

### "No actions found"
- Make sure you committed your checkbox changes to coverage-report.md before running the workflow

### "Issue already exists"
- The workflow checks for existing issues with the same labels and title - this is expected behavior to prevent duplicates

### Script fails to parse
- Check that checkbox format is correct: `[ ]` (space between brackets) or `[x]` (lowercase x)
- Make sure parameter names are wrapped in backticks: `` `parameter_name` ``

### Changes not showing in api-mapping.json
- Verify the script ran successfully in the workflow logs
- Check that the "Ignore" checkbox was checked (not just "Issue")
- Ensure the commit step succeeded

## Development

### Testing Locally

```bash
# Generate coverage report with checkboxes
Rscript .github/coverage-reports/check-api-coverage.R

# Manually check some boxes in coverage-report.md

# Process the checkboxes
Rscript .github/coverage-reports/process-coverage-checkboxes.R

# Review changes in api-mapping.json and actions-to-take.json
```

### Adding New Features

To modify the checkbox actions or add new action types:
1. Update the markdown generation in `check-api-coverage.R`
2. Update the parsing logic in `process-coverage-checkboxes.R`
3. Update the workflow in `process-coverage-actions.yml`
4. Test locally before pushing

## See Also

- [API_COVERAGE.md](API_COVERAGE.md) - Background on the coverage tracking system
- [GBIF API Documentation](https://techdocs.gbif.org/)
- [rgbif Documentation](https://docs.ropensci.org/rgbif/)
