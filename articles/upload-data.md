# upload-data

## Motivation

The data we want to compare rarely arrives in a single format. It might
be a CSV export, a SAS or SPSS dataset, a Stata file, or an Excel
workbook. This vignette walks through
[`upload_data()`](https://mjfrigaard.github.io/dfdiffs/reference/upload_data.md),
the function that reads each of these file types into the `dfdiffs`
Shiny application.

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

### External data

The test files for each format are stored in the `inst/extdata/` folder:

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

[`load_flat_file()`](https://mjfrigaard.github.io/dfdiffs/reference/load_flat_file.md)
chooses a reader based on the file extension. Text files (`.txt`,
`.csv`, and `.tsv`) are read with
[`data.table::fread()`](https://rdrr.io/pkg/data.table/man/fread.html),
and SAS, SPSS, and Stata files are read with `haven`. Every result is
returned as a tibble.

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

[`upload_data()`](https://mjfrigaard.github.io/dfdiffs/reference/upload_data.md)
adds support for Excel workbooks on top of
[`load_flat_file()`](https://mjfrigaard.github.io/dfdiffs/reference/load_flat_file.md).
For `.xlsx` files, pass the name of the sheet to the `sheet` argument.

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
(`pak::pak("mjfrigaard/stackcallr")`). Only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "mod_upload_server")
```

    █─mod_upload_server
    ├─█─upload_data
    │ └─load_flat_file
    ├─base_react_theme
    └─comp_react_theme

The upload demo app
([`launch_upload_demo()`](https://mjfrigaard.github.io/dfdiffs/reference/launch_upload_demo.md))
runs the module’s UI and server functions together in a standalone app:

``` r

stackcallr::call_tree_dir("R", root = "launch_upload_demo")
```

    █─launch_upload_demo
    ├─dfdiffs_fresh_theme
    ├─mod_upload_ui
    └─█─mod_upload_server
      ├─█─upload_data
      │ └─load_flat_file
      ├─base_react_theme
      └─comp_react_theme

### 2021 site roster CSVs

We’ll start by listing the CSV files in the 2021 site roster folder.

``` r

roster2021_csv_paths <- list.files(path = "../inst/extdata/csv/site-roster/2021", full.names = TRUE, pattern = ".csv$")
head(roster2021_csv_paths)
#> [1] "../inst/extdata/csv/site-roster/2021/Enroll.csv"
#> [2] "../inst/extdata/csv/site-roster/2021/Name.csv"  
#> [3] "../inst/extdata/csv/site-roster/2021/Roster.csv"
#> [4] "../inst/extdata/csv/site-roster/2021/Visit.csv"
```

The fourth path (`roster2021_csv_paths[4]`) is the full `Roster.csv`
file. We’ll pass it to
[`load_flat_file()`](https://mjfrigaard.github.io/dfdiffs/reference/load_flat_file.md)
and check the result with
[`glimpse()`](https://pillar.r-lib.org/reference/glimpse.html).

``` r

roster_2021 <- load_flat_file(path = roster2021_csv_paths[4])
glimpse(roster_2021)
#> Rows: 200
#> Columns: 2
#> $ subject_id       <chr> "SUBJ-0001", "SUBJ-0002", "SUBJ-0003", "SUBJ-0004", "…
#> $ first_visit_date <IDate> 2021-05-15, 2021-10-05, 2021-10-28, 2021-06-09, 202…
```

### 2022 site roster CSVs

The 2022 site roster folder follows the same layout.

``` r

roster2022_csv_paths <- list.files(path = "../inst/extdata/csv/site-roster/2022", full.names = TRUE, pattern = ".csv$")
head(roster2022_csv_paths)
#> [1] "../inst/extdata/csv/site-roster/2022/Enroll.csv"
#> [2] "../inst/extdata/csv/site-roster/2022/Name.csv"  
#> [3] "../inst/extdata/csv/site-roster/2022/Roster.csv"
#> [4] "../inst/extdata/csv/site-roster/2022/Visit.csv"
```

We’ll load `roster2022_csv_paths[4]` the same way.

``` r

roster_csv_2022 <- load_flat_file(path = roster2022_csv_paths[4])
glimpse(roster_csv_2022)
#> Rows: 237
#> Columns: 2
#> $ subject_id       <chr> "SUBJ-0001", "SUBJ-0002", "SUBJ-0003", "SUBJ-0004", "…
#> $ first_visit_date <IDate> 2021-05-15, 2021-10-05, 2021-10-28, 2021-06-09, 202…
```

### Importing multiple files

[`load_flat_file()`](https://mjfrigaard.github.io/dfdiffs/reference/load_flat_file.md)
works with
[`purrr::map()`](https://purrr.tidyverse.org/reference/map.html), so we
can import every 2021 CSV at once. The code below stores each file in a
named list (`roster2021_csv_files`) and prints the column names of each
one.

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

We can also stack the files into a single tibble with
[`map_df()`](https://purrr.tidyverse.org/reference/map_dfr.html). The
`source` column records which file each row came from, and
[`count()`](https://dplyr.tidyverse.org/reference/count.html) shows the
number of rows per file.

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

### Other formats

[`load_flat_file()`](https://mjfrigaard.github.io/dfdiffs/reference/load_flat_file.md)
handles `.dta`, `.sas7bdat`, `.sav`, `.tsv`, and `.txt` files the same
way, so we can loop over all five formats instead of repeating the same
steps for each one. The code below loads every file in each format’s
folder and counts the rows per file.

``` r

formats <- c("dta", "sas7bdat", "sav", "tsv", "txt")
format_tbls <- map(formats, function(ext) {
  paths <- list.files(path = paste0("../inst/extdata/", ext),
    full.names = TRUE, pattern = paste0("\\.", ext, "$"))
  paths %>%
    set_names() %>%
    map_df(.f = load_flat_file, .id = "source") %>%
    mutate(source = basename(source))
}) %>%
  set_names(formats)
map(format_tbls, count, source)
#> $dta
#> # A tibble: 6 × 2
#>   source                   n
#>   <chr>                <int>
#> 1 datetime-d.dta           1
#> 2 iris.dta               150
#> 3 notes.dta                5
#> 4 tagged-na-double.dta     8
#> 5 tagged-na-int.dta        8
#> 6 types.dta                2
#> 
#> $sas7bdat
#> # A tibble: 4 × 2
#>   source                 n
#>   <chr>              <int>
#> 1 datetime.sas7bdat      4
#> 2 hadley.sas7bdat        8
#> 3 iris.sas7bdat        150
#> 4 tagged-na.sas7bdat     8
#> 
#> $sav
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
#> 
#> $tsv
#> # A tibble: 1 × 2
#>   source         n
#>   <chr>      <int>
#> 1 Enroll.tsv    10
#> 
#> $txt
#> # A tibble: 1 × 2
#>   source         n
#>   <chr>      <int>
#> 1 Enroll.txt    10
```
