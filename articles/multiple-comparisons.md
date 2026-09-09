# multiple-comparisons

## Motivation

The goal of the `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?
2.  What rows were here before that aren’t here now?
3.  **What values have been changed?**

This vignette covers how to apply the functions in `dfdiffs` to multiple
datasets (separated by folder)

### Packages

Our package

``` r

library(dfdiffs)
```

Packages for import/export, iteration, wrangling, etc.

``` r

library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(purrr)
library(glue)
```

Packages for tables.

``` r

library(labelled)
library(gt)
library(gtsummary)
library(kableExtra)
```

Similar packages for comparisons.

``` r

library(janitor) # compare_df_cols
library(arsenal) # comparedf
library(diffdf)  # diffdf
library(testthat) # expect_equal
library(vetr) # alike
```

### Folder structure

Below is a folder structure of datasets separated by year.

``` r

fs::dir_tree("../inst/extdata/csv/by-year")
#> ../inst/extdata/csv/by-year
#> ├── 20
#> │   ├── PlayerBirth.csv
#> │   ├── PlayerDebut.csv
#> │   └── PlayerName.csv
#> └── 21
#>     ├── PlayerBirth.csv
#>     ├── PlayerDebut.csv
#>     └── PlayerName.csv
```

We start by storing these files in a vector with
[`list.files()`](https://rdrr.io/r/base/list.files.html), then we clean
up the names a bit, and pass the list of paths to
[`readr::read_csv`](https://readr.tidyverse.org/reference/read_delim.html)
with [`purrr::map()`](https://purrr.tidyverse.org/reference/map.html):

#### Import base dfs

Below we import the compare data tables (from 2020)

``` r

base_files <- list.files(path = "../inst/extdata/csv/by-year/20", 
  pattern = ".csv", recursive = TRUE, full.names = TRUE)
base_files_nms <- purrr::map_chr(base_files, base::basename)
base_dfs <- base_files |> 
  purrr::set_names(base_files_nms) |> 
  purrr::map(readr::read_csv)
base_dfs |> str()
#> List of 3
#>  $ PlayerBirth.csv: spc_tbl_ [20,673 × 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ playerID  : chr [1:20673] "aardsda01" "aaronha01" "aaronto01" "aasedo01" ...
#>   ..$ birthYear : num [1:20673] 1981 1934 1939 1954 1972 ...
#>   ..$ birthMonth: num [1:20673] 12 2 8 9 8 12 11 4 11 10 ...
#>   ..$ birthDay  : num [1:20673] 27 5 5 8 25 17 4 15 11 14 ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   playerID = col_character(),
#>   .. ..   birthYear = col_double(),
#>   .. ..   birthMonth = col_double(),
#>   .. ..   birthDay = col_double()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x560b03474b30> 
#>  $ PlayerDebut.csv: spc_tbl_ [20,673 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ playerID: chr [1:20673] "aardsda01" "aaronha01" "aaronto01" "aasedo01" ...
#>   ..$ debut   : Date[1:20673], format: "2004-04-06" "1954-04-13" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   playerID = col_character(),
#>   .. ..   debut = col_date(format = "")
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x560afa8fef70> 
#>  $ PlayerName.csv : spc_tbl_ [20,673 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ playerID : chr [1:20673] "aardsda01" "aaronha01" "aaronto01" "aasedo01" ...
#>   ..$ nameGiven: chr [1:20673] "David Allan" "Henry Louis" "Tommie Lee" "Donald William" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   playerID = col_character(),
#>   .. ..   nameGiven = col_character()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x560b02b8f4c0>
```

#### Import compare dfs

Below we import the compare data tables (from 2021)

``` r

compare_files <- list.files(path = "../inst/extdata/csv/by-year/21", 
  pattern = ".csv", recursive = TRUE, full.names = TRUE)
compare_files_nms <- purrr::map_chr(compare_files, base::basename)
compare_dfs <- compare_files |> 
  purrr::set_names(compare_files_nms) |> 
  purrr::map(readr::read_csv)
compare_dfs |> str()
#> List of 3
#>  $ PlayerBirth.csv: spc_tbl_ [20,370 × 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ playerID  : chr [1:20370] "aardsda01" "aaronha01" "aaronto01" "aasedo01" ...
#>   ..$ birthYear : num [1:20370] 1981 1934 1939 1954 1972 ...
#>   ..$ birthMonth: num [1:20370] 12 2 8 9 8 12 11 4 11 10 ...
#>   ..$ birthDay  : num [1:20370] 27 5 5 8 25 17 4 15 11 14 ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   playerID = col_character(),
#>   .. ..   birthYear = col_double(),
#>   .. ..   birthMonth = col_double(),
#>   .. ..   birthDay = col_double()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x560b04955c80> 
#>  $ PlayerDebut.csv: spc_tbl_ [20,370 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ playerID: chr [1:20370] "aardsda01" "aaronha01" "aaronto01" "aasedo01" ...
#>   ..$ debut   : Date[1:20370], format: "2004-04-06" "1954-04-13" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   playerID = col_character(),
#>   .. ..   debut = col_date(format = "")
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x560b05c715d0> 
#>  $ PlayerName.csv : spc_tbl_ [20,370 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ playerID : chr [1:20370] "aardsda01" "aaronha01" "aaronto01" "aasedo01" ...
#>   ..$ nameGiven: chr [1:20370] "David Allan" "Henry Louis" "Tommie Lee" "Donald William" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   playerID = col_character(),
#>   .. ..   nameGiven = col_character()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x560b0534f0e0>
```

## Iteration

We’re going to follow the iteration steps from [Charlotte Wickham’s
Happy R Users Purrr
Tutorial](https://www.rstudio.com/resources/rstudioconf-2017/happy-r-users-purrr-tutorial-/)

1.  DO IT FOR ONE  
2.  TURN IT INTO A RECIPE  
3.  DO IT FOR ALL!

### 1) Do it for one (or two)

We’re going to use the
[`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html)
function first. Remember that this function requires an additional
[`summary()`](https://rdrr.io/r/base/summary.html) call!

#### `arsenal::comparedf`

``` r

by_var <- "playerID"
cdf_people <- arsenal::comparedf(
  x = base_dfs$PlayerBirth.csv, 
  y = compare_dfs$PlayerBirth.csv, 
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
  compare = compare_dfs$PlayerBirth.csv, 
  base = base_dfs$PlayerBirth.csv, 
  keys = "playerID")
diffdf_people |> names()
#> [1] "DataSummary"        "ExtRowsBase"        "NumDiff"           
#> [4] "VarDiff_birthYear"  "VarDiff_birthMonth" "VarDiff_birthDay"
```

Just to ensure we’re getting the same display in the output from both
functions, we’re going to use the `diffs.byvar.table`/`NumDiff` tables,
and the `diffs.table`/ `VarDiff_` tables.

##### `diffs.byvar.table`

``` r

sumcdf_people[["diffs.byvar.table"]] |> 
  select(Variable = var.x, 
         `No of Differences` = n) |> 
  knitr::kable(caption = "diffs.byvar.table") |> 
  kableExtra::kable_paper()
```

| Variable   | No of Differences |
|:-----------|------------------:|
| birthYear  |                19 |
| birthMonth |                 3 |
| birthDay   |                 6 |

diffs.byvar.table {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

##### `NumDiff`

``` r

diffdf_people[["NumDiff"]] |> 
  knitr::kable(caption = "NumDiff") |> 
  kableExtra::kable_paper()
```

| Variable   | No of Differences |
|:-----------|------------------:|
| birthYear  |                19 |
| birthMonth |                 3 |
| birthDay   |                 6 |

NumDiff {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

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

| VARIABLE   | playerID  | BASE | COMPARE |
|:-----------|:----------|-----:|--------:|
| birthYear  | bearnla01 | 1940 |    1941 |
| birthYear  | candito01 | 1956 |    1957 |
| birthYear  | childbi01 | 1867 |      NA |
| birthYear  | coopean99 | 1897 |    1898 |
| birthYear  | herremi01 | 1892 |    1897 |
| birthYear  | jimenma01 | 1936 |    1938 |
| birthYear  | jonesco02 | 1905 |    1907 |
| birthYear  | kelletr01 | 1992 |    1993 |
| birthYear  | mcfaror01 | 1935 |    1938 |
| birthYear  | mendomi01 | 1934 |    1933 |
| birthYear  | minosmi01 | 1923 |    1925 |
| birthYear  | naranch01 | 1933 |    1934 |
| birthYear  | olivaed01 | 1937 |    1938 |
| birthYear  | olivoch01 | 1926 |    1928 |
| birthYear  | posadle01 | 1934 |    1936 |
| birthYear  | quirkar01 | 1937 |    1938 |
| birthYear  | senerso01 | 1929 |    1931 |
| birthYear  | willida02 | 1879 |    1880 |
| birthYear  | zamoros01 | 1943 |    1944 |
| birthMonth | hickmch01 |    3 |       5 |
| birthMonth | mendomi01 |   12 |      11 |
| birthMonth | willida02 |    7 |       2 |
| birthDay   | barnesk01 |    7 |       3 |
| birthDay   | jamesbo01 |   15 |      18 |
| birthDay   | mendomi01 |    3 |      16 |
| birthDay   | posadle01 |    1 |      15 |
| birthDay   | walshed01 |   19 |      14 |
| birthDay   | willida02 |   NA |       7 |

diffs.table {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

##### `VarDiff_` tables

``` r

tbl_names <- names(diffdf_people)
vardiff_tbls <- tbl_names[stringr::str_detect(tbl_names, "VarDiff_")]
bind_rows(diffdf_people[vardiff_tbls]) |> 
  knitr::kable(caption = "'VarDiff_' tables") |> 
  kableExtra::kable_paper()
```

| VARIABLE   | playerID  | BASE | COMPARE |
|:-----------|:----------|-----:|--------:|
| birthYear  | bearnla01 | 1940 |    1941 |
| birthYear  | candito01 | 1956 |    1957 |
| birthYear  | childbi01 | 1867 |      NA |
| birthYear  | coopean99 | 1897 |    1898 |
| birthYear  | herremi01 | 1892 |    1897 |
| birthYear  | jimenma01 | 1936 |    1938 |
| birthYear  | jonesco02 | 1905 |    1907 |
| birthYear  | kelletr01 | 1992 |    1993 |
| birthYear  | mcfaror01 | 1935 |    1938 |
| birthYear  | mendomi01 | 1934 |    1933 |
| birthYear  | minosmi01 | 1923 |    1925 |
| birthYear  | naranch01 | 1933 |    1934 |
| birthYear  | olivaed01 | 1937 |    1938 |
| birthYear  | olivoch01 | 1926 |    1928 |
| birthYear  | posadle01 | 1934 |    1936 |
| birthYear  | quirkar01 | 1937 |    1938 |
| birthYear  | senerso01 | 1929 |    1931 |
| birthYear  | willida02 | 1879 |    1880 |
| birthYear  | zamoros01 | 1943 |    1944 |
| birthMonth | hickmch01 |    3 |       5 |
| birthMonth | mendomi01 |   12 |      11 |
| birthMonth | willida02 |    7 |       2 |
| birthDay   | barnesk01 |    7 |       3 |
| birthDay   | jamesbo01 |   15 |      18 |
| birthDay   | mendomi01 |    3 |      16 |
| birthDay   | posadle01 |    1 |      15 |
| birthDay   | walshed01 |   19 |      14 |
| birthDay   | willida02 |   NA |       7 |

‘VarDiff\_’ tables {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### 2) Turn it into a recipe

We have two vectors with file paths (`.x` and `.y`)

``` r

map2(.x = base_dfs, .y = compare_files, )
```

And the `.f` is our
[`arsenal::comparedf`](https://mayoverse.github.io/arsenal/reference/comparedf.html)
or
[`diffdf::diffdf`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html)
functions.

``` r

map2(.x = base_dfs, .y = compare_files, .f = arsenal::comparedf)
map2(.x = compare_files, .y = base_dfs, .f = diffdf::diffdf)
```

We can pass the `by` and `keys` arguments to `...`.

``` r

purrr::map2(.x =  base_dfs, .y = compare_dfs, 
            .f = arsenal::comparedf, by = "playerID")
```

``` r

purrr::map2(.x =  compare_dfs,  .y = base_dfs, 
            .f = diffdf::diffdf, keys = "playerID")
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
  by = "playerID")
all_scdfs <- purrr::map(all_cdfs, .f = summary)
all_scdfs[["PlayerName.csv"]] |> names()
#> [1] "frame.summary.table"      "comparison.summary.table"
#> [3] "vars.ns.table"            "vars.nc.table"           
#> [5] "obs.table"                "diffs.byvar.table"       
#> [7] "diffs.table"              "attrs.table"             
#> [9] "control"
```

#### `map2()` + `diffdf::diffdf`

``` r

all_diffdfs <- purrr::map2(
  .x = base_dfs, 
  .y = compare_dfs, 
  .f = diffdf::diffdf, 
  keys = "playerID")
all_diffdfs[["PlayerName.csv"]] |> names()
#> [1] "DataSummary"       "ExtRowsBase"       "NumDiff"          
#> [4] "VarDiff_nameGiven"
```
