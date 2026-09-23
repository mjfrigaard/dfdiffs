# Changelog

## dfdiffs 0.1.0

New deployed applications with
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
function (from
[`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html))

dev app (<https://mjfrigaard.shinyapps.io/compareDataDev/>)

uat app (<https://mjfrigaard.shinyapps.io/compareDataApp/>)

New
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
function for generating excel reports

- Includes
  [`create_empty_tbl()`](https://mjfrigaard.github.io/dfdiffs/reference/create_empty_tbl.md)
  function

New vignette

- `create-comparison-report.Rmd`: covers the functions used to create an
  excel comparison report.

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
