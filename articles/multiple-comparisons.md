# multiple-comparisons

## Motivation

The goal of `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?
2.  What rows were here before that aren’t here now?
3.  **What values have been changed?**

This vignette covers how to apply the functions in `dfdiffs` to multiple
datasets (separated by folder).

### Packages

Load `dfdiffs`:

``` r

library(dfdiffs)
```

We’ll also need packages for import/export, iteration, and wrangling:

``` r

library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(glue)
```

These packages are for building tables:

``` r

library(labelled)
library(gtsummary)
library(kableExtra)
```

These packages offer similar comparison functions:

``` r

library(janitor) # compare_df_cols
library(arsenal) # comparedf
library(diffdf)  # diffdf
library(testthat) # expect_equal
library(vetr) # alike
```

### Folder structure

Below is a folder structure of datasets separated by year. It holds two
yearly pulls of the synthetic (not real) `dfdiffs` site roster (see
[`?Roster2021`](https://mjfrigaard.github.io/dfdiffs/reference/Roster2021.md)),
which `data-raw/Roster.R` has already split into `Enroll`/`Visit`/`Name`
files.

``` r

fs::dir_tree("../inst/extdata/csv/site-roster")
#> ../inst/extdata/csv/site-roster
#> ├── 2021
#> │   ├── Enroll.csv
#> │   ├── Name.csv
#> │   ├── Roster.csv
#> │   └── Visit.csv
#> ├── 2022
#> │   ├── Enroll.csv
#> │   ├── Name.csv
#> │   ├── Roster.csv
#> │   └── Visit.csv
#> ├── 2023
#> │   ├── Enroll.csv
#> │   ├── Name.csv
#> │   ├── Roster.csv
#> │   └── Visit.csv
#> └── 2024
#>     ├── Enroll.csv
#>     ├── Name.csv
#>     ├── Roster.csv
#>     └── Visit.csv
```

We start by storing these file paths in a vector with
[`list.files()`](https://rdrr.io/r/base/list.files.html). Then we clean
up the names a bit and pass the paths to
[`readr::read_csv`](https://readr.tidyverse.org/reference/read_delim.html)
with [`purrr::map()`](https://purrr.tidyverse.org/reference/map.html).

#### Import base dfs

Below we import the base data tables (from the 2021 pull).

``` r

base_files <- list.files(path = "../inst/extdata/csv/site-roster/2021",
  pattern = "Enroll|Visit|Name", recursive = TRUE, full.names = TRUE)
base_files_nms <- purrr::map_chr(base_files, base::basename)
base_dfs <- base_files |>
  purrr::set_names(base_files_nms) |>
  purrr::map(readr::read_csv)
base_dfs |> str()
#> List of 3
#>  $ Enroll.csv: spc_tbl_ [200 × 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id  : chr [1:200] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ enroll_year : num [1:200] 2021 2021 2021 2021 2021 ...
#>   ..$ enroll_month: num [1:200] 5 10 10 6 2 1 4 11 7 7 ...
#>   ..$ enroll_day  : num [1:200] 15 5 28 9 19 18 16 13 14 15 ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   enroll_year = col_double(),
#>   .. ..   enroll_month = col_double(),
#>   .. ..   enroll_day = col_double()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x5582ed075ae0> 
#>  $ Name.csv  : spc_tbl_ [200 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id: chr [1:200] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ full_name : chr [1:200] "Jamie Nguyen" "Riley Jensen" "Rowan Singh" "Reese Diaz" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   full_name = col_character()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x5582ebf8bbc0> 
#>  $ Visit.csv : spc_tbl_ [200 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id      : chr [1:200] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ first_visit_date: Date[1:200], format: "2021-05-15" "2021-10-05" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   first_visit_date = col_date(format = "")
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x5582e94bf220>
```

#### Import compare dfs

Below we import the compare data tables (from the 2022 pull).

``` r

compare_files <- list.files(path = "../inst/extdata/csv/site-roster/2022",
  pattern = "Enroll|Visit|Name", recursive = TRUE, full.names = TRUE)
compare_files_nms <- purrr::map_chr(compare_files, base::basename)
compare_dfs <- compare_files |>
  purrr::set_names(compare_files_nms) |>
  purrr::map(readr::read_csv)
compare_dfs |> str()
#> List of 3
#>  $ Enroll.csv: spc_tbl_ [237 × 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id  : chr [1:237] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ enroll_year : num [1:237] 2021 2021 2021 2021 2021 ...
#>   ..$ enroll_month: num [1:237] 5 10 10 6 1 4 11 7 7 10 ...
#>   ..$ enroll_day  : num [1:237] 15 5 28 9 18 16 13 14 15 23 ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   enroll_year = col_double(),
#>   .. ..   enroll_month = col_double(),
#>   .. ..   enroll_day = col_double()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x5582e98beb10> 
#>  $ Name.csv  : spc_tbl_ [237 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id: chr [1:237] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ full_name : chr [1:237] "Jamie Nguyen" "Riley Jensen" "Rowan Singh" "Reese Diaz" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   full_name = col_character()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x5582e66c08a0> 
#>  $ Visit.csv : spc_tbl_ [237 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id      : chr [1:237] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ first_visit_date: Date[1:237], format: "2021-05-15" "2021-10-05" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   first_visit_date = col_date(format = "")
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x5582e940d520>
```

## Iteration

We’re going to follow the iteration steps from [Charlotte Wickham’s
Happy R Users Purrr
Tutorial](https://www.rstudio.com/resources/rstudioconf-2017/happy-r-users-purrr-tutorial-/):

1.  DO IT FOR ONE  
2.  TURN IT INTO A RECIPE  
3.  DO IT FOR ALL!

### 1) Do it for one (or two)

We’ll start with the
[`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html)
function. Remember that this function requires an additional
[`summary()`](https://rdrr.io/r/base/summary.html) call.

#### `arsenal::comparedf`

``` r

by_var <- "subject_id"
cdf_people <- arsenal::comparedf(
  x = base_dfs$Enroll.csv, 
  y = compare_dfs$Enroll.csv, 
  by = by_var)
sumcdf_people <- summary(cdf_people)
names(sumcdf_people)
#> [1] "frame.summary.table"      "comparison.summary.table"
#> [3] "vars.ns.table"            "vars.nc.table"           
#> [5] "obs.table"                "diffs.byvar.table"       
#> [7] "diffs.table"              "attrs.table"             
#> [9] "control"
```

#### `diffdf::diffdf`

Next we’ll use the
[`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html)
function.

``` r

diffdf_people <- diffdf::diffdf(
  compare = compare_dfs$Enroll.csv, 
  base = base_dfs$Enroll.csv, 
  keys = "subject_id")
diffdf_people |> names()
#> [1] "DataSummary" "ExtRowsBase" "ExtRowsComp"
```

To make sure the output from both functions is displayed the same way,
we’ll use the `diffs.byvar.table`/`NumDiff` tables and the
`diffs.table`/`VarDiff_` tables.

##### `diffs.byvar.table`

``` r

sumcdf_people[["diffs.byvar.table"]] |> 
  select(Variable = var.x, 
         `No of Differences` = n) |> 
  knitr::kable(caption = "diffs.byvar.table") |> 
  kableExtra::kable_paper()
```

| Variable     | No of Differences |
|:-------------|------------------:|
| enroll_year  |                 0 |
| enroll_month |                 0 |
| enroll_day   |                 0 |

diffs.byvar.table {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

##### `NumDiff`

``` r

diffdf_people[["NumDiff"]] |> 
  knitr::kable(caption = "NumDiff") |> 
  kableExtra::kable_paper()
#> Error in `matrix()`:
#> ! data is too long
```

##### `diffs.table`

``` r

sumcdf_people[["diffs.table"]] |> 
  unnest(values.x) |> 
  unnest(values.y) |> 
  select(
    VARIABLE = var.x,
    all_of(by_var),
    BASE = values.x,
    COMPARE = values.y
  ) |> 
  knitr::kable(caption = "diffs.table") |> 
  kableExtra::kable_paper()
```

| VARIABLE | subject_id | BASE | COMPARE |
|:---|:---|:---|:---|
| character(0) | c(“:——–”, “:———-”, “:—-”, “:——-”) | character(0) | c(“:——–”, “:———-”, “:—-”, “:——-”) |

diffs.table {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

##### `VarDiff_` tables

``` r

tbl_names <- names(diffdf_people)
vardiff_tbls <- tbl_names[stringr::str_detect(tbl_names, "VarDiff_")]
bind_rows(diffdf_people[vardiff_tbls]) |> 
  knitr::kable(caption = "'VarDiff_' tables") |> 
  kableExtra::kable_paper()
#> Error in `matrix()`:
#> ! data is too long
```

### 2) Turn it into a recipe

We have two vectors with file paths (`.x` and `.y`).

``` r

map2(.x = base_dfs, .y = compare_files, )
```

The `.f` argument is either the
[`arsenal::comparedf`](https://mayoverse.github.io/arsenal/reference/comparedf.html)
or the
[`diffdf::diffdf`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html)
function.

``` r

map2(.x = base_dfs, .y = compare_files, .f = arsenal::comparedf)
map2(.x = compare_files, .y = base_dfs, .f = diffdf::diffdf)
```

We can pass the `by` and `keys` arguments through `...`.

``` r

purrr::map2(.x =  base_dfs, .y = compare_dfs, 
            .f = arsenal::comparedf, by = "subject_id")
```

``` r

purrr::map2(.x =  compare_dfs,  .y = base_dfs, 
            .f = diffdf::diffdf, keys = "subject_id")
```

### 3) Do it for all

#### `map2()` + `arsenal::comparedf`

Now we use the
[`purrr::map2()`](https://purrr.tidyverse.org/reference/map2.html)
function to compare all of the items in `base_dfs` to `compare_dfs`.

``` r

all_cdfs <- purrr::map2(
  .x =  base_dfs, 
  .y = compare_dfs, 
  .f = arsenal::comparedf, 
  by = "subject_id")
all_scdfs <- purrr::map(all_cdfs, .f = summary)
all_scdfs[["Name.csv"]] |> names()
#> [1] "frame.summary.table"      "comparison.summary.table"
#> [3] "vars.ns.table"            "vars.nc.table"           
#> [5] "obs.table"                "diffs.byvar.table"       
#> [7] "diffs.table"              "attrs.table"             
#> [9] "control"
```

#### `map2()` + `diffdf::diffdf`

We can do the same with
[`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html).

``` r

all_diffdfs <- purrr::map2(
  .x = base_dfs, 
  .y = compare_dfs, 
  .f = diffdf::diffdf, 
  keys = "subject_id")
all_diffdfs[["Name.csv"]] |> names()
#> [1] "DataSummary" "ExtRowsBase" "ExtRowsComp"
```
