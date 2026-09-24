# change-frequency-from-proc-compare

``` r

library(dfdiffs)
library(openxlsx)
library(readxl)
library(tidyverse)
library(janitor) 
library(arsenal) # comparedf
library(diffdf)  # diffdf
```

## Motivation

This vignette covers how to calculate the frequency of changes per
column in the datasets used in the PROC COMPARE file,
`snapshot_compare_270301_20221116_year3_preview_noDAP.xlsx`.

Below we import the Excel file and build a regular expression for
separating the changes in the `value_changes` and `newvalues` columns.

## Import data

Below we check the names of the sheets in the
`snapshot_compare_270301_20221116_year3_preview_noDAP.xlsx` file.

``` r

snapshot_pth <- "../inst/extdata/app-testing/xlsx/snapshot_compare_270301_20221116_year3_preview_noDAP.xlsx"
snapshoty3_sheets <- readxl::excel_sheets(snapshot_pth)
#> Error:
#> ! `path` does not exist: '../inst/extdata/app-testing/xlsx/snapshot_compare_270301_20221116_year3_preview_noDAP.xlsx'
snapshoty3_sheets
#> Error:
#> ! object 'snapshoty3_sheets' not found
```

### AE

Import the `"AE"` sheet and check the column names.

``` r

snap_ae_raw <- readxl::read_excel(snapshot_pth, sheet = "AE") 
#> Error:
#> ! `path` does not exist: '../inst/extdata/app-testing/xlsx/snapshot_compare_270301_20221116_year3_preview_noDAP.xlsx'
names(snap_ae_raw) |> head(10)
#> Error:
#> ! object 'snap_ae_raw' not found
names(snap_ae_raw) |> tail(10)
#> Error:
#> ! object 'snap_ae_raw' not found
```

We’ll reformat the column names and filter the `"AE"` dataset to only
the rows with an `"Updated"` value in the `status` column.

``` r

snap_updated <- snap_ae_raw |>  
  select(
    subject_id = `Subject name or identifier`, 
    record_num = `Record number`,
    DATASET, 
    STATUS, 
    `Value changes`, 
    NEW_VALUES = NEWVALUES) %>% 
  janitor::clean_names() |> 
  filter(status == "Updated")
#> Error:
#> ! object 'snap_ae_raw' not found
glimpse(snap_updated)
#> Error:
#> ! object 'snap_updated' not found
```

#### Testing `SAEDESC1`

The `SAEDESC1` columns contain a lot of unstructured text with multiple
commas, so we’ll use them to test separating the column names from the
`value_changes` and `newvalues` columns.

``` r

test_SAEDESC1 <- snap_updated |> 
  filter(str_detect(snap_updated$value_changes, "SAEDESC1")) |> 
  head(3)
#> Error:
#> ! object 'snap_updated' not found
glimpse(test_SAEDESC1)
#> Error:
#> ! object 'test_SAEDESC1' not found
```

#### Test with regular expression

Below is the regular expression pattern we’ll test these rows against.

``` r

sas_cols_regex <- "\\w*[A-Z]\\w*[A-Z]\\w*="
sas_cols_regex
#> [1] "\\w*[A-Z]\\w*[A-Z]\\w*="
```

We’ll start by using the
[`str_view_all()`](https://stringr.tidyverse.org/reference/str_view.html)
function to check if our regular expression is working.

``` r

str_view_all(string = test_SAEDESC1$value_changes, 
  pattern = sas_cols_regex) 
#> Warning: `str_view_all()` was deprecated in stringr 1.5.0.
#> ℹ Please use `str_view()` instead.
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> Error:
#> ! object 'test_SAEDESC1' not found
```

### `count_change_columns()`

Now that we have a regular expression for matching the column names in
`value_changes`, we’ll count the occurrences of each match.

``` r

count_change_columns <- function(df) {
  sas_cols_regex <- "\\w*[A-Z]\\w*[A-Z]\\w*="
  # clean names
  df_clean_nms <- df |> janitor::clean_names()
  # value_changes
  value_change_match <- dplyr::mutate(df_clean_nms, 
         raw_col_match = stringr::str_match_all(value_changes, 
                                                sas_cols_regex)) |> 
    dplyr::relocate(raw_col_match, .after = 1)
  # unnest 
  raw_matches_long <- tidyr::unnest_longer(data = value_change_match, 
                                  col = raw_col_match)
  col_matches_long <- dplyr::mutate(.data = raw_matches_long,
      col_matches = stringr::str_remove_all(raw_col_match, "=")) |> 
    dplyr::relocate(col_matches, .after = 2)
  col_count_raw <- dplyr::count(col_matches_long, col_matches, 
                            name = "occurrence")
  col_count <- dplyr::filter(col_count_raw, !is.na(col_matches))
  count_tbl <- dplyr::rename(.data = col_count,
    Field = col_matches,
    ChangeCount = occurrence
  )
  return(count_tbl)
}
```

### Field and Change Count

We can derive `Field` and `ChangeCount` from `snap_ae_raw` (the data
imported from the spreadsheet).

``` r

ae_change_freq <- count_change_columns(df = snap_ae_raw)
#> Error:
#> ! object 'snap_ae_raw' not found
ae_change_freq
#> Error:
#> ! object 'ae_change_freq' not found
```

### Graph Changes

We can build a graph of these changes, but we have to manually set the
font size because of the long `y` axis.

``` r

ggplot(data = ae_change_freq, 
       mapping = aes(x = ChangeCount, 
                     y = forcats::fct_reorder(.f = Field, 
                                              .x = ChangeCount))) + 
  geom_col(aes(fill = Field), show.legend = FALSE) + 
  labs(title = "AE Changes", 
       y = "Field", 
       x = "Number of Changes") + 
  theme_minimal(base_size = 6)
#> Error:
#> ! object 'ae_change_freq' not found
```

## Map to other sheets

Now we can apply `count_change_columns()` to all sheets in
`snapshot_compare_270301_20221116_year3_preview_noDAP.xlsx`.

First, we remove the first two sheets from `snapshoty3_sheets`:

``` r

form_sheets <- snapshoty3_sheets[! snapshoty3_sheets %in% c('Summary', 'Key variables')]
#> Error:
#> ! object 'snapshoty3_sheets' not found
form_sheets
#> Error:
#> ! object 'form_sheets' not found
```

Then we name each sheet in the vector and store the result in
`form_sheets_nmd`:

``` r

form_sheets_nmd <- purrr::set_names(form_sheets)
#> Error:
#> ! object 'form_sheets' not found
form_sheets_nmd
#> Error:
#> ! object 'form_sheets_nmd' not found
```

### Import all sheets

We can now import all the sheets from the file at `snapshot_pth` and
store them in `all_sheets`.

``` r

all_sheets <- form_sheets_nmd |> 
  map(~ readxl::read_excel(path = snapshot_pth, sheet = .x))
#> Error:
#> ! object 'form_sheets_nmd' not found
```

Checking the names of this list confirms it contains all the imported
sheets.

``` r

names(all_sheets)
#> Error:
#> ! object 'all_sheets' not found
```

### Map `count_change_columns()` to `all_sheets`

We [`map()`](https://purrr.tidyverse.org/reference/map.html) the
`count_change_columns()` function over every item in `all_sheets` and
store the results in the `all_field_counts` list.

``` r

all_field_counts <- purrr::map(.x = all_sheets, .f = count_change_columns)
#> Error:
#> ! object 'all_sheets' not found
names(all_field_counts)
#> Error:
#> ! object 'all_field_counts' not found
```

We can check the results by graphing the changes in a few of the forms.

#### CM Changes

``` r

all_field_counts$CM |> 
  ggplot(mapping = aes(x = ChangeCount, 
                     y = forcats::fct_reorder(.f = Field, 
                                              .x = ChangeCount))) + 
  geom_col(aes(fill = Field), show.legend = FALSE) + 
  labs(title = "CM Changes", 
       y = "Field", 
       x = "Number of Changes") + 
  theme_minimal(base_size = 6)
#> Error:
#> ! object 'all_field_counts' not found
```

#### QSQOL Changes

``` r

all_field_counts$QSQOL |> 
  ggplot(mapping = aes(x = ChangeCount, 
                     y = forcats::fct_reorder(.f = Field, 
                                              .x = ChangeCount))) + 
  geom_col(aes(fill = Field), show.legend = FALSE) + 
  labs(title = "QSQOL Changes", 
       y = "Field", 
       x = "Number of Changes") + 
  theme_minimal(base_size = 6)
#> Error:
#> ! object 'all_field_counts' not found
```

#### VS Changes

``` r

all_field_counts$VS |> 
  ggplot(mapping = aes(x = ChangeCount, 
                     y = forcats::fct_reorder(.f = Field, 
                                              .x = ChangeCount))) + 
  geom_col(aes(fill = Field), show.legend = FALSE) + 
  labs(title = "VS Changes", 
       y = "Field", 
       x = "Number of Changes") + 
  theme_minimal(base_size = 6)
#> Error:
#> ! object 'all_field_counts' not found
```

### Export field count tables

We can export these into the `inst/out/` folder as
`all-field-counts.xlsx`.

``` r

library(openxlsx)
# create wb
openxlsx::write.xlsx(x = all_field_counts,
                file = "../inst/out/all-field-counts.xlsx")
#> Error:
#> ! object 'all_field_counts' not found
```

### Collapse into a single table
