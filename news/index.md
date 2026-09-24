# Changelog

## dfdiffs 2.1.0

The comparison engine
([`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md),
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md),
and the helpers behind them) is now built entirely on base R. `dplyr`,
`tidyr`, `tidyselect`, and `diffdf` are no longer required to use the
package; `Imports` drops from 16 packages to 11.

- New base-R helpers replace the `dplyr`/`diffdf` call sites:
  [`select_cols()`](https://mjfrigaard.github.io/dfdiffs/reference/select_cols.md),
  [`anti_join_base()`](https://mjfrigaard.github.io/dfdiffs/reference/anti_join_base.md),
  [`left_join_base()`](https://mjfrigaard.github.io/dfdiffs/reference/left_join_base.md)
  (in `R/join_helpers.R`), and
  [`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)/[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)
  (in `R/compare_values.R`), the direct replacement for
  [`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html).

- Value comparison is more accurate than before, not just equivalent:
  [`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)
  does real numeric-tolerance comparison (ported from `diffdf`’s own
  formula), treats a `Date` and a `POSIXct` representing the same
  instant as equal (an explicit improvement, since `diffdf` itself
  treats that as a class mismatch), and compares factors by label.
  Previously, both
  [`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
  and
  [`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
  coerced every column to character before comparing, so none of this
  tolerance or type-awareness was ever actually exercised.

- `diffdf`, `dplyr`, and `tidyr` moved to `Suggests` (a few vignettes
  demonstrate them directly as points of comparison, matching how
  `arsenal` was already handled); `tidyselect` and `stringr` were
  dropped entirely.

- Fixed two latent cross-file `NAMESPACE` coupling bugs that this change
  surfaced: `mod_select.R`/`mod_compare.R`’s bare
  [`select()`](https://dplyr.tidyverse.org/reference/select.html) calls
  and `launch_select_demo.R`’s bare
  [`str_detect()`](https://stringr.tidyverse.org/reference/str_detect.html)
  call were only working because an unrelated file happened to declare
  the matching `@importFrom` tag.

- Fixed a `data.table` compatibility bug in the new base-R helpers.
  Because `data.table`’s `[` has different indexing semantics than a
  plain `data.frame`, every helper now coerces its input with
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) first.

## dfdiffs 2.0.0

Major overhaul of the app-package: bslib UI, fewer dependencies, new
example data, and a more complete test suite.

- App migrated from bs4Dash to bslib
  ([`page_navbar()`](https://rstudio.github.io/bslib/reference/page_navbar.html),
  [`input_dark_mode()`](https://rstudio.github.io/bslib/reference/input_dark_mode.html)),
  with modules renamed to `mod_upload`/`mod_select`/`mod_compare` and
  entry points renamed to
  [`launch_app()`](https://mjfrigaard.github.io/dfdiffs/reference/launch_app.md)/[`launch_app_dev()`](https://mjfrigaard.github.io/dfdiffs/reference/launch_app_dev.md)/`launch_*_demo()`.
  A custom “Atomic Age Space Race” theme applies to both the app and the
  pkgdown site.

- Every reactable table in `mod_upload`/`mod_select`/`mod_compare` now
  follows the navbar’s dark-mode toggle (`react_themes.R`’s themes
  became `dark`-aware functions).

- The upload/select/compare workflow now auto-advances between steps as
  the user completes them, with a “Step X of 3” indicator in the navbar.
  [`fluidRow()`](https://rdrr.io/pkg/shiny/man/fluidPage.html)/[`column()`](https://rdrr.io/pkg/shiny/man/column.html)
  grids were replaced with
  [`bslib::layout_columns()`](https://rstudio.github.io/bslib/reference/layout_columns.html),
  and the results tables can go full-screen.

- `mod_display` (unwired, redundant with `mod_select`’s preview) was
  removed, along with its demo app and tests.

- Dependencies cut from ~34 Imports to ~17: dropped unused packages
  entirely (`hrbrthemes`, `RColorBrewer`, `vroom` from Imports), rewrote
  small call sites to drop `magrittr`, `forcats`, and `rlang`, and moved
  vignette-only packages (`flextable`, `kableExtra`, `gtsummary`, `gt`,
  `glue`, `labelled`, `readr`, `lubridate`, `vetr`, `waldo`, `vctrs`,
  `fs`) to Suggests. Added `ggplot2` to Imports (it was already used but
  undeclared).
  [`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)/[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
  now build on
  [`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html)
  instead of
  [`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html),
  so the package no longer needs both comparison engines; `arsenal` was
  dropped.

- All 8 core example datasets (`T1Data`, `T2Data`, `NewData`,
  `CompleteData`, `IncompleteData`, `DeletedData`, `InitialData`,
  `ChangedData`) now carry a clinical-observation story instead of
  placeholder pangram text. The Sean Lahman baseball archive data (~96MB
  across `data/` and `inst/extdata/`, undeclared and unattributed) was
  replaced by a synthetic, package-generated “site roster” dataset
  family (`Roster2021`-`Roster2024`) used across the `compare-data`,
  `create-comparison-report`, `create-join-column`, `upload-data`, and
  `multiple-comparisons` vignettes. 11 orphaned/unused datasets were
  removed.

- Fixed: `ggplot2` was used in `mod_compare.R` without being declared in
  `DESCRIPTION`. Fixed: `R/_diffdf.R`, a dead, unexported, broken
  vendored copy of
  [`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html),
  was removed. Fixed: a `create-join-column.Rmd` vignette chunk locally
  redefined
  [`create_join_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_join_column.md)
  with stale parameter names, shadowing the real function so the
  vignette never actually exercised it.

- New tests for
  [`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md),
  [`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md),
  the xlsx upload path in
  [`mod_upload_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_upload_server.md),
  and a build smoke test for every `launch_*()` entry point. Filled in
  missing `@param`/ `@return` documentation on the module UI/server
  functions.

- Known issue (not fixed in this release):
  [`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
  errors with `sep must be a single string, not absent` when
  [`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)/[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
  are called with a `by_col` argument or a multi-column `by`.

## dfdiffs 0.1.0

New deployed applications with the
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
function (from
[`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html))

dev app (<https://mjfrigaard.shinyapps.io/compareDataDev/>)

uat app (<https://mjfrigaard.shinyapps.io/compareDataApp/>)

New
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
function for generating Excel reports

- Includes
  [`create_empty_tbl()`](https://mjfrigaard.github.io/dfdiffs/reference/create_empty_tbl.md)
  function

New vignette

- `create-comparison-report.Rmd`: covers the functions used to create an
  Excel comparison report.

Code clean-up:

- documented `dev_` modules

- documented UAT app modules (in `inst/`)

- removed `generate_compare_report()` function

## dfdiffs 0.0.0.9000

new vignettes

dev app (<https://mjfrigaard.shinyapps.io/compareDataDev/>)

uat app (<https://mjfrigaard.shinyapps.io/compareDataApp/>)

### 2022-07-16

Development version of modules have the following prefix: `dev_`

`dev_uploadDataUI()`/`dev_uploadDataServer()` create the
`uploadDataDemo()` app  

`dev_selectDataUI()`/`dev_selectDataServer()` create the
`selectDataDemo()` app  

`dev_compareDataUI()`/`dev_compareDataServer()` create the
`compareDataDemo()` app  

the `compareDataApp()` uses the non-development versions (stored in
`app/` folder)

Numbered sidebar  

`About` tab added  

`compare` columns have been added to `var_diff()` table

### 2022-07-03

- updated all functions to use `base`/`comp` instead of `prev`/`curr`
  and `olddf`/`newdf`.

- new function
  [`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
  for changed/modified data based on the [`diffdf`
  package](https://gowerc.github.io/diffdf/reference/diffdf.html).

- [uploadDataDemo](https://mjfrigaard.shinyapps.io/selectDataDemo-dev/)
  deployed dev sheet

  - `dev` folder contains `uploadData` module

- New vignettes:

  - getting started

  - create new data

  - create deleted data

  - create modified data

  - create changed data

  - similar work
