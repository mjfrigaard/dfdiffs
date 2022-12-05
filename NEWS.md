---
editor_options: 
  markdown: 
    wrap: 72
---

# dfdiffs 0.1.0

-   New deployed applications with `create_modified_data()` function
    (from `arsenal::comparedf()`)

    -   [x] dev app (<https://mjfrigaard.shinyapps.io/compareDataDev/>)

    -   [x] uat app (<https://mjfrigaard.shinyapps.io/compareDataApp/>)

-   New `create_comparison_report()` function for generating excel
    reports

    -   Includes `create_empty_tbl()` function

-   New vignette

    -   `create-comparison-report.Rmd`: covers the functions used to
        create an excel comparison report.

-   Code clean-up:

    -   documented `dev_` modules

    -   documented UAT app modules (in `inst/`)

    -   removed `generate_compare_report()` function

# dfdiffs 0.0.0.9000

-   [x] new vignettes
-   [x] dev app (<https://mjfrigaard.shinyapps.io/compareDataDev/>)
-   [x] uat app (<https://mjfrigaard.shinyapps.io/compareDataApp/>)

## 2022-07-16

-   [x] Development version of modules have the following prefix: `dev_`
    -   [x] `dev_uploadDataUI()`/`dev_uploadDataServer()` create the
        `uploadDataDemo()` app\
    -   [x] `dev_selectDataUI()`/`dev_selectDataServer()` create the
        `selectDataDemo()` app\
    -   [x] `dev_compareDataUI()`/`dev_compareDataServer()` create the
        `compareDataDemo()` app\
    -   [x] the `compareDataApp()` uses the non-development versions
        (stored in `app/` folder)
-   [x] Numbered sidebar\
-   [x] `About` tab added\
-   [x] `compare` columns have been added to `var_diff()` table

## 2022-07-03

-   updated all functions to use `base`/`comp` instead of `prev`/`curr`
    and `olddf`/`newdf`.

-   new function `create_changed_data()` for changed/modified data based
    on the [`diffdf`
    package](https://gowerc.github.io/diffdf/reference/diffdf.html).

-   [uploadDataDemo](https://mjfrigaard.shinyapps.io/selectDataDemo-dev/)
    deployed dev sheet

    -   `dev` folder contains `uploadData` module

-   New vignettes:

    -   getting started

    -   create new data

    -   create deleted data

    -   create modified data

    -   create changed data

    -   similar work
