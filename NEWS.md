# dfdiffs 0.1.0

# dfdiffs 0.0.0.9000



## 0.0.0.9000

-   [x] new vignettes
-   [x] dev app (<https://mjfrigaard.shinyapps.io/compareDataDev/>)
-   [x] uat app (<https://mjfrigaard.shinyapps.io/compareDataApp/>)

## 2022-07-16

-   [x] Development version of modules have the following prefix: `dev_`
    -   [x] `dev_uploadDataUI()`/`dev_uploadDataSServer()` create the
        `uploadDataDemo()` app\
    -   [x] `dev_selectDataUI()`/`dev_selectDataSServer()` create the
        `selectDataDemo()` app\
    -   [x] `dev_compareDataUI()`/`dev_compareDataSServer()` create the
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
