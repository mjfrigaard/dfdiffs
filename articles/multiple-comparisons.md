# multiple-comparisons

## Motivation

The goal of `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?
2.  What rows were here before that aren’t here now?
3.  **What values have been changed?**

In this vignette I’ll cover how to apply the functions in `dfdiffs` to
multiple pairs of datasets stored in separate folders.

### Packages

First, we’ll load `dfdiffs`.

``` r

library(dfdiffs)
```

We’ll also need packages for importing data, iteration, and building
tables.

``` r

library(readr)
library(purrr)
```

### Folder structure

The folder structure below stores datasets separated by year. It holds
two yearly pulls of the synthetic (not real) `dfdiffs` site roster (see
[`?Roster2021`](https://mjfrigaard.github.io/dfdiffs/reference/Roster2021.md)),
which `data-raw/Roster.R` has already split into `Enroll`, `Visit`, and
`Name` files.

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

We’ll store the file paths in a vector with
[`list.files()`](https://rdrr.io/r/base/list.files.html) and name each
path with its file name. Then we’ll pass the paths to
[`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
with [`purrr::map()`](https://purrr.tidyverse.org/reference/map.html).

#### Import base dfs

The code below imports the base data tables from the 2021 pull.

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
#>   ..- attr(*, "problems")=<pointer: 0x55cd144e61d0> 
#>  $ Name.csv  : spc_tbl_ [200 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id: chr [1:200] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ full_name : chr [1:200] "Jamie Nguyen" "Riley Jensen" "Rowan Singh" "Reese Diaz" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   full_name = col_character()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x55cd191ad070> 
#>  $ Visit.csv : spc_tbl_ [200 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id      : chr [1:200] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ first_visit_date: Date[1:200], format: "2021-05-15" "2021-10-05" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   first_visit_date = col_date(format = "")
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x55cd18d992f0>
```

#### Import compare dfs

The code below imports the compare data tables from the 2022 pull.

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
#>   ..- attr(*, "problems")=<pointer: 0x55cd1a782310> 
#>  $ Name.csv  : spc_tbl_ [237 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id: chr [1:237] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ full_name : chr [1:237] "Jamie Nguyen" "Riley Jensen" "Rowan Singh" "Reese Diaz" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   full_name = col_character()
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x55cd16f7e2c0> 
#>  $ Visit.csv : spc_tbl_ [237 × 2] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
#>   ..$ subject_id      : chr [1:237] "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#>   ..$ first_visit_date: Date[1:237], format: "2021-05-15" "2021-10-05" ...
#>   ..- attr(*, "spec")=
#>   .. .. cols(
#>   .. ..   subject_id = col_character(),
#>   .. ..   first_visit_date = col_date(format = "")
#>   .. .. )
#>   ..- attr(*, "problems")=<pointer: 0x55cd1aa90710>
```

## Iteration

We’ll follow the three iteration steps from [Charlotte Wickham’s Happy R
Users Purrr
Tutorial](https://www.rstudio.com/resources/rstudioconf-2017/happy-r-users-purrr-tutorial-/):

1.  DO IT FOR ONE
2.  TURN IT INTO A RECIPE
3.  DO IT FOR ALL!

### 1) Do it for one (or two)

[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
runs all three comparisons (new, deleted, and changed) in a single call.
We’ll start with a single pair of tables, `Enroll.csv`.

``` r

by_var <- "subject_id"
enroll_comparison <- compare_data(
  compare = compare_dfs$Enroll.csv,
  base = base_dfs$Enroll.csv,
  by = by_var)
names(enroll_comparison)
#> [1] "new_data"            "deleted_data"        "changed_num_diffs"  
#> [4] "changed_var_diffs"   "changed_class_diffs" "column_diffs"
```

[`compare_summary()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_summary.md)
adds a headline summary for the same pair of tables, in the style of
SAS’s `PROC COMPARE`.

``` r

compare_summary(
  compare = compare_dfs$Enroll.csv,
  base = base_dfs$Enroll.csv,
  by = by_var)
#> <dfdiffs comparison summary>
#>   Observations: base = 200, compare = 237
#>     common: 197 | new: 40 | deleted: 3
#>   Variables: base = 4, compare = 4 (4 common, 0 base only, 0 compare only)
#>   No unequal values found.
```

### 2) Turn it into a recipe

[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
takes `compare` and `base` as its first two arguments, so
[`purrr::map2()`](https://purrr.tidyverse.org/reference/map2.html) can
pass the matching elements of `compare_dfs` and `base_dfs` straight
through. The `by` argument is passed along via `...`. Note that
[`map2()`](https://purrr.tidyverse.org/reference/map2.html) pairs the
two lists by position, not by name, so this relies on
[`list.files()`](https://rdrr.io/r/base/list.files.html) returning the
files in the same order in both folders (which it does here, because
both folders hold the same three file names).

``` r

purrr::map2(.x = compare_dfs, .y = base_dfs,
            .f = compare_data, by = "subject_id")
```

### 3) Do it for all

Now we’ll apply the recipe to every pair of files in `compare_dfs` and
`base_dfs`.

``` r

all_comparisons <- purrr::map2(
  .x = compare_dfs,
  .y = base_dfs,
  .f = compare_data,
  by = "subject_id")
names(all_comparisons)
#> [1] "Enroll.csv" "Name.csv"   "Visit.csv"
names(all_comparisons$Name.csv)
#> [1] "new_data"            "deleted_data"        "changed_num_diffs"  
#> [4] "changed_var_diffs"   "changed_class_diffs" "column_diffs"
```

The same recipe works with
[`compare_summary()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_summary.md)
and gives us one headline summary per file. Below we print the summary
for `Visit.csv`.

``` r

all_summaries <- purrr::map2(
  .x = compare_dfs,
  .y = base_dfs,
  .f = compare_summary,
  by = "subject_id")
all_summaries$Visit.csv
#> <dfdiffs comparison summary>
#>   Observations: base = 200, compare = 237
#>     common: 197 | new: 40 | deleted: 3
#>   Variables: base = 2, compare = 2 (2 common, 0 base only, 0 compare only)
#>   No unequal values found.
```
