# Copilot Instructions for rgbif

## Code Style and Conventions

### Naming Conventions
- **Function parameters**: Use camelCase (e.g., `publishingCountry`, `datasetKey`, `curlopts`)
- **Function names**: Use snake_case (e.g., `occ_download_stats`, `dataset_search`)
- **Internal functions**: Suffix with underscore (e.g., `dataset_uuid_get_`)

### Function Design
- Always include roxygen2 documentation with `@export`, `@param`, `@return`, `@examples`
- Use `NULL` as default for optional parameters
- Include `curlopts = list(http_version = 2)` parameter for HTTP requests
- Use `assert()` function to validate parameter types at the beginning of functions
- Use helper functions from `zzz.R` where possible (e.g., `rgbif_compact()`, `gbifparser()`)
- **Format function arguments** with each on its own line after the opening parenthesis, with 2-space indentation for continuation lines

### Common Patterns
```r
# Standard function structure
function_name <- function(param1 = NULL, 
  param2 = NULL, 
  curlopts = list(http_version = 2)) {
  
  # Type assertions
  assert(param1, "character")
  assert(param2, c("integer", "numeric"))
  
  # Build API URL
  url <- paste0(gbif_base(), '/endpoint')
  
  # Compact arguments (remove NULL values)
  args <- rgbif_compact(list(
    param1 = param1,
    param2 = param2
  ))
  
  # Make HTTP request
  tt <- gbif_GET(url, args, TRUE, curlopts)
  
  # Return structured data
  structure(list(meta = meta, results = results), 
    class = "gbif")
}
```

### Helper Functions (zzz.R)
- `rgbif_compact()`: Remove NULL/empty elements from lists
- `gbifparser()`: Parse GBIF occurrence data
- `get_hier()`: Extract taxonomic hierarchy
- `gbif_base()`: Get base API URL
- Use these instead of reimplementing logic

### HTTP Requests
- Use `gbif_GET()` for GET requests
- Always pass `curlopts` parameter
- Default to `http_version = 2`
- Handle pagination with `limit` and `offset` parameters

### Return Values
- Prefer structured lists with `meta` and `results` slots
- Convert to tibbles where appropriate
- Include S3 class for custom objects (e.g., `class = "gbif"`)

### Documentation
- Always include `@family` tag to group related functions
- Reference other functions with `[function_name]`
- Include `@note` for important usage information
- Provide runnable examples in `@examples` (wrap with `\dontrun{}` if API calls)
- **Do not use roxygen2 templates** (e.g., `@template occ`) - write documentation directly in the function file

### Documentation Website (pkgdown)
- The package uses pkgdown for documentation website generation
- `_pkgdown.yml` groups functions by topic using naming patterns (e.g., `starts_with("occ_download")`)
- **Function naming is important**: Follow existing prefixes to ensure auto-grouping
  - `occ_download*` functions → "Occurrence downloads" section
  - `occ_*` functions → "Occurrence search" section  
  - `name_*` functions → "Taxonomic names" section
  - `dataset_*` functions → "Registry" section
- When adding functions that follow existing patterns, they will be auto-included
- Only update `_pkgdown.yml` manually for:
  - Completely new function families
  - Functions that don't follow existing naming patterns
  - Reordering or restructuring documentation sections
- Run `pkgdown::build_site()` locally to preview documentation changes

### Error Handling
- Use `assert()` for type checking
- Use `stop()` for user-facing errors
- Validate required parameters early

## Package-Specific Guidelines

### GBIF API Integration
- Base URL via `gbif_base()`
- Use UUID format for keys (e.g., `datasetKey`, `publishingOrgKey`)
- Follow GBIF's parameter naming conventions

### Data Processing
- Use `data.table::rbindlist()` for combining data frames
- Preserve S3 classes through transformations
- Handle empty/NULL values with `rgbif_compact()`

### Testing
- Place tests in `tests/testthat/`
- Mock HTTP requests where possible
- Test parameter validation

## Common Tasks

### Adding a New API Endpoint Function
1. Create function with camelCase parameters
2. Add roxygen2 documentation
3. Use `assert()` for parameter validation
4. Build URL with `paste0(gbif_base(), '/path')`
5. Use `rgbif_compact()` on arguments
6. Call `gbif_GET()` with `curlopts`
7. Return structured list with S3 class
8. Add tests in `tests/testthat/`

### Modifying Existing Functions
- Maintain backward compatibility
- Update documentation if parameters change
- Add deprecation warnings if removing features
- Update NEWS.md with changes
