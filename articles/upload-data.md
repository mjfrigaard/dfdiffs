# upload-data

## Motivation

This vignette walks through the
[`upload_data()`](https://mjfrigaard.github.io/dfdiffs/reference/upload_data.md)
function, which loads a variety of file types into the `dfdiffs` Shiny
application.

``` r

library(dfdiffs)
library(shiny)
library(data.table)
library(dplyr)
library(stringr)
library(lubridate)
library(glue)
library(purrr)
library(reactable)
library(haven)
library(readxl)
library(labelled)
library(gtsummary)
```

### External Data

Test data can be found in the `../inst/extdata/` folder:

    #> ../inst/extdata/
    #> ├── csv
    #> │   ├── ChangedData.csv
    #> │   ├── InitialData.csv
    #> │   ├── diffs
    #> │   │   ├── diff_current.csv
    #> │   │   ├── diff_modified_all_raw.csv
    #> │   │   └── diff_previous.csv
    #> │   └── site-roster
    #> │       ├── 2021
    #> │       │   ├── Enroll.csv
    #> │       │   ├── Name.csv
    #> │       │   ├── Roster.csv
    #> │       │   └── Visit.csv
    #> │       ├── 2022
    #> │       │   ├── Enroll.csv
    #> │       │   ├── Name.csv
    #> │       │   ├── Roster.csv
    #> │       │   └── Visit.csv
    #> │       ├── 2023
    #> │       │   ├── Enroll.csv
    #> │       │   ├── Name.csv
    #> │       │   ├── Roster.csv
    #> │       │   └── Visit.csv
    #> │       └── 2024
    #> │           ├── Enroll.csv
    #> │           ├── Name.csv
    #> │           ├── Roster.csv
    #> │           └── Visit.csv
    #> ├── dta
    #> │   ├── datetime-d.dta
    #> │   ├── iris.dta
    #> │   ├── notes.dta
    #> │   ├── tagged-na-double.dta
    #> │   ├── tagged-na-int.dta
    #> │   └── types.dta
    #> ├── rdata
    #> │   └── proc_app_data.rdata
    #> ├── sas7bdat
    #> │   ├── datetime.sas7bdat
    #> │   ├── formats.sas7bcat
    #> │   ├── hadley.sas7bdat
    #> │   ├── iris.sas7bdat
    #> │   ├── tagged-na.sas7bcat
    #> │   └── tagged-na.sas7bdat
    #> ├── sav
    #> │   ├── datetime.sav
    #> │   ├── iris.sav
    #> │   ├── labelled-num-na.sav
    #> │   ├── labelled-num.sav
    #> │   ├── labelled-str.sav
    #> │   ├── umlauts.sav
    #> │   └── variable-label.sav
    #> ├── tsv
    #> │   └── Enroll.tsv
    #> ├── txt
    #> │   └── Enroll.txt
    #> └── xlsx
    #>     ├── compare-report-text.xlsx
    #>     └── snapshot_compare_270301_20221116_year3_preview_noDAP.xlsx

### load_flat_file()

The
[`load_flat_file()`](https://mjfrigaard.github.io/dfdiffs/reference/load_flat_file.md)
function imports all forms of flat data files.

``` r

load_flat_file <- function(path) {
  ext <- tools::file_ext(path)
  data <- switch(ext,
    txt = data.table::fread(path),
    csv = data.table::fread(path),
    tsv = data.table::fread(path),
    sas7bdat = haven::read_sas(data_file = path),
    sas7bcat = haven::read_sas(data_file = path),
    sav = haven::read_sav(file = path),
    dta = haven::read_dta(file = path)
  )
  return_data <- tibble::as_tibble(data)
  return(return_data)
}
```

The
[`upload_data()`](https://mjfrigaard.github.io/dfdiffs/reference/upload_data.md)
function below also handles Excel files. If the file is an Excel file,
pass the name of the sheet to `sheet`.

``` r

upload_data <- function(path, sheet = NULL) {
  ext <- tools::file_ext(path)
  if (ext == "xlsx") {
    raw_data <- readxl::read_excel(
        path = path,
        sheet = sheet
      )
    uploaded <- tibble::as_tibble(raw_data)
  } else {
    uploaded <- load_flat_file(path = path)
  }
  return(uploaded)
}
```

### Call structure

[`upload_data()`](https://mjfrigaard.github.io/dfdiffs/reference/upload_data.md)
reads Excel workbooks (`.xlsx`) with
[`readxl::read_excel()`](https://readxl.tidyverse.org/reference/read_excel.html)
and hands every other file type to
[`load_flat_file()`](https://mjfrigaard.github.io/dfdiffs/reference/load_flat_file.md),
which picks the reader from the file extension. In the Shiny app, the
upload module
([`mod_upload_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_upload_server.md))
calls
[`upload_data()`](https://mjfrigaard.github.io/dfdiffs/reference/upload_data.md).
The call trees below were generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`); only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "mod_upload_server")
```

    █─mod_upload_server
    └─█─upload_data
      └─load_flat_file

The upload demo app
([`launch_upload_demo()`](https://mjfrigaard.github.io/dfdiffs/reference/launch_upload_demo.md))
shows the module’s UI and server sides together:

``` r

stackcallr::call_tree_dir("R", root = "launch_upload_demo")
```

    █─launch_upload_demo
    ├─dfdiffs_fresh_theme
    ├─mod_upload_ui
    └─█─mod_upload_server
      └─█─upload_data
        └─load_flat_file

### 2021 site roster CSVs

``` r

roster2021_csv_paths <- list.files(path = "../inst/extdata/csv/site-roster/2021", full.names = TRUE, pattern = ".csv$")
head(roster2021_csv_paths)
#> [1] "../inst/extdata/csv/site-roster/2021/Enroll.csv"
#> [2] "../inst/extdata/csv/site-roster/2021/Name.csv"  
#> [3] "../inst/extdata/csv/site-roster/2021/Roster.csv"
#> [4] "../inst/extdata/csv/site-roster/2021/Visit.csv"
```

We’ll test this on `roster2021_csv_paths[4]` (the full `Roster.csv`).

``` r

roster_2021 <- load_flat_file(path = roster2021_csv_paths[4])
glimpse(roster_2021)
#> Rows: 200
#> Columns: 2
#> $ subject_id       <chr> "SUBJ-0001", "SUBJ-0002", "SUBJ-0003", "SUBJ-0004", "…
#> $ first_visit_date <IDate> 2021-05-15, 2021-10-05, 2021-10-28, 2021-06-09, 202…
```

### 2022 site roster CSVs

``` r

roster2022_csv_paths <- list.files(path = "../inst/extdata/csv/site-roster/2022", full.names = TRUE, pattern = ".csv$")
head(roster2022_csv_paths)
#> [1] "../inst/extdata/csv/site-roster/2022/Enroll.csv"
#> [2] "../inst/extdata/csv/site-roster/2022/Name.csv"  
#> [3] "../inst/extdata/csv/site-roster/2022/Roster.csv"
#> [4] "../inst/extdata/csv/site-roster/2022/Visit.csv"
```

We’ll test this on `roster2022_csv_paths[4]`.

``` r

roster_csv_2022 <- load_flat_file(path = roster2022_csv_paths[4])
glimpse(roster_csv_2022)
#> Rows: 237
#> Columns: 2
#> $ subject_id       <chr> "SUBJ-0001", "SUBJ-0002", "SUBJ-0003", "SUBJ-0004", "…
#> $ first_visit_date <IDate> 2021-05-15, 2021-10-05, 2021-10-28, 2021-06-09, 202…
```

### List of 2021 CSVs

Now we import every 2021 CSV into a named list, `roster2021_csv_files`:

``` r

roster2021_csv_files <- map(.x = roster2021_csv_paths,
  .f = load_flat_file) %>%
  set_names(x = ., nm = basename(roster2021_csv_paths))
map(roster2021_csv_files, names)
#> $Enroll.csv
#> [1] "subject_id"   "enroll_year"  "enroll_month" "enroll_day"  
#> 
#> $Name.csv
#> [1] "subject_id" "full_name" 
#> 
#> $Roster.csv
#>  [1] "subject_id"       "first_name"       "last_name"        "site_id"         
#>  [5] "enroll_year"      "enroll_month"     "enroll_day"       "height_cm"       
#>  [9] "full_name"        "first_visit_date" "status"          
#> 
#> $Visit.csv
#> [1] "subject_id"       "first_visit_date"
```

We’ll also test this with the
[`map_df()`](https://purrr.tidyverse.org/reference/map_dfr.html)
function.

``` r

tbl_2021_csv_files <- roster2021_csv_paths %>%
  set_names() %>%
  map_df(.x = .,
  .f = load_flat_file, .id = "source") %>%
  mutate(source = basename(source))
tbl_2021_csv_files %>% count(source)
#> # A tibble: 4 × 2
#>   source         n
#>   <chr>      <int>
#> 1 Enroll.csv   200
#> 2 Name.csv     200
#> 3 Roster.csv   200
#> 4 Visit.csv    200
```

### Test on dta

``` r

dta_paths <- list.files(path = "../inst/extdata/dta", 
  full.names = TRUE, pattern = ".dta$")
tbl_dta_files <- dta_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_dta_files %>% count(source)
#> # A tibble: 6 × 2
#>   source                   n
#>   <chr>                <int>
#> 1 datetime-d.dta           1
#> 2 iris.dta               150
#> 3 notes.dta                5
#> 4 tagged-na-double.dta     8
#> 5 tagged-na-int.dta        8
#> 6 types.dta                2
```

### Test on sas7bdat

``` r

sas7bdat_paths <- list.files(path = "../inst/extdata/sas7bdat", 
  full.names = TRUE, pattern = ".sas7bdat$")
tbl_sas7bdat_files <- sas7bdat_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_sas7bdat_files %>% count(source)
#> # A tibble: 4 × 2
#>   source                 n
#>   <chr>              <int>
#> 1 datetime.sas7bdat      4
#> 2 hadley.sas7bdat        8
#> 3 iris.sas7bdat        150
#> 4 tagged-na.sas7bdat     8
```

### Test on sav

``` r

sav_paths <- list.files(path = "../inst/extdata/sav", 
  full.names = TRUE, pattern = ".sav$")
tbl_sav_files <- sav_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_sav_files %>% count(source)
#> # A tibble: 7 × 2
#>   source                  n
#>   <chr>               <int>
#> 1 datetime.sav            2
#> 2 iris.sav              150
#> 3 labelled-num-na.sav     2
#> 4 labelled-num.sav        1
#> 5 labelled-str.sav        2
#> 6 umlauts.sav             4
#> 7 variable-label.sav      1
```

### Test on tsv

``` r

tsv_paths <- list.files(path = "../inst/extdata/tsv", 
  full.names = TRUE, pattern = ".tsv$")
tbl_tsv_files <- tsv_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_tsv_files %>% count(source)
#> # A tibble: 1 × 2
#>   source         n
#>   <chr>      <int>
#> 1 Enroll.tsv    10
```

### Test on txt

``` r

txt_paths <- list.files(path = "../inst/extdata/txt", 
  full.names = TRUE, pattern = ".txt$")
tbl_txt_files <- txt_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_txt_files %>% count(source)
#> # A tibble: 1 × 2
#>   source         n
#>   <chr>      <int>
#> 1 Enroll.txt    10
```
