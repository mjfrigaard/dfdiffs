# similar-work

## Motivation

This vignette covers similar functions/packages that compare two
datasets to each other.

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

Similar packages

``` r

library(janitor) # compare_df_cols
library(testthat) # expect_equal
library(vetr) # alike
library(labelled)
library(gt)
library(gtsummary)
```

### Data

We’ll be using the data in this package to cover similar
`packages::functions()`.

#### New data

To check new data, we’re going to use `T1Data` and `T2Data`. The
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
function shows us the ‘new data’ (i.e. what is here now that wasn’t here
before?)

We can check this against the `NewData` dataset (which should match the
output from
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md))

``` r

T1Data <- dfdiffs::T1Data
T2Data <- dfdiffs::T2Data
T1T2New <- create_new_data(compare = T2Data, base = T1Data)
T1T2New |> 
  knitr::kable(caption = "New data T1 > T2") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|
| D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Four hours of steady work faced us. | associate |
| B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | The hogs were fed chopped corn and garbage. | encourage |
| A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension |

New data T1 \> T2 {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

``` r

NewData <- dfdiffs::NewData
NewData |> 
  knitr::kable(caption = "New data (Comparison)") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|
| D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Four hours of steady work faced us. | associate |
| B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | The hogs were fed chopped corn and garbage. | encourage |
| A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension |

New data (Comparison) {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

We can see the only differences between the datasets are the formats of
the date columns:

``` r

waldo::compare(x = T1T2New, y = NewData)
#> `old$start_date` is a character vector ('2022-04-04', '2022-04-02', '2022-04-04')
#> `new$start_date` is an S3 object of class <Date>, a double vector
#> 
#> `old$mid_date` is a character vector ('2022-04-13', '2022-04-14', '2022-04-15')
#> `new$mid_date` is an S3 object of class <Date>, a double vector
#> 
#> `old$end_date` is a character vector ('2022-04-22', '2022-04-20', '2022-04-21')
#> `new$end_date` is an S3 object of class <Date>, a double vector
```

#### Deleted data

To test for the deleted data, we use the `CompleteData`,
`IncompleteData`, and `DeletedData`.

`CompleteData` represents a ‘complete’ set of data,

``` r

CompleteData <- dfdiffs::CompleteData
CompleteData |> 
  knitr::kable(caption = "CompleteData") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|---:|:---|:---|:---|:---|:---|
| A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | The copper bowl shone in the sun’s rays. | interest |
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Take a chance and win a china doll. | sure |
| B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A cramp is no small danger on a swim. | white |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It’s easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |
| A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Wake and rise, and step into the green outdoors. | situate |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Say it slow!y but make it ring clear. | document |

CompleteData {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

and `IncompleteData` is a dataset with rows removed from `CompleteData`.

``` r

IncompleteData <- dfdiffs::IncompleteData
IncompleteData |> 
  knitr::kable(caption = "IncompleteData") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|---:|:---|:---|:---|:---|:---|
| A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | The copper bowl shone in the sun’s rays. | interest |
| B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Take a chance and win a china doll. | sure |
| B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A cramp is no small danger on a swim. | white |
| A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Wake and rise, and step into the green outdoors. | situate |
| D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Say it slow!y but make it ring clear. | document |

IncompleteData {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

When we run the
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
we check for the deleted rows between `IncompleteData` and
`CompleteData`.

``` r

IncompCompDiff <- create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData) |> 
  arrange(subject)
IncompCompDiff |> 
  knitr::kable(caption = "IncompCompDiff") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It’s easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

IncompCompDiff {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

This is identical to the data stored in `DeletedData`

``` r

DeletedData <- dfdiffs::DeletedData
DeletedData |> 
  knitr::kable(caption = "DeletedData") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|---:|:---|:---|:---|:---|:---|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It’s easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

DeletedData {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

``` r

waldo::compare(x = IncompCompDiff, y = DeletedData)
#> `old$record` is a character vector ('2', '3', '1', '1')
#> `new$record` is an integer vector (2, 3, 1, 1)
#> 
#> `old$start_date` is a character vector ('2021-12-28', '2021-12-26', '2021-12-30', '2021-12-27')
#> `new$start_date` is an S3 object of class <Date>, a double vector
#> 
#> `old$mid_date` is a character vector ('2022-01-27', '2022-01-25', '2022-01-29', '2022-01-26')
#> `new$mid_date` is an S3 object of class <Date>, a double vector
#> 
#> `old$end_date` is a character vector ('2022-02-26', '2022-02-24', '2022-02-28', '2022-02-25')
#> `new$end_date` is an S3 object of class <Date>, a double vector
```

#### InitialData/ChangedData Data

To check for changes between two datasets, we uses the `InitialData` and
`ChangedData`.

``` r

InitialData <- dfdiffs::InitialData
ChangedData <- dfdiffs::ChangedData
mods <- create_modified_data(
  compare = ChangedData, base = InitialData)
```

The changes by variable are stored in `diffs_byvar`.

``` r

mods$diffs_byvar |> 
  knitr::kable(caption = "diffs_byvar") |> 
  kableExtra::kable_paper()
```

| Variable name | Modified Values | Missing Values |
|:--------------|----------------:|---------------:|
| subject_id    |               0 |              0 |
| record        |               0 |              0 |
| text_value_a  |               2 |              0 |
| text_value_b  |               1 |              0 |
| created_date  |               0 |              0 |
| updated_date  |               5 |              0 |
| entered_date  |               5 |              0 |

diffs_byvar {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

The changes by row are stored in `diffs`.

``` r

mods$diffs |> 
  knitr::kable(caption = "diffs") |> 
  kableExtra::kable_paper()
```

| Variable name | Current Value                      | Previous Value   |
|:--------------|:-----------------------------------|:-----------------|
| text_value_a  | Issue resolved                     | Issue unresolved |
| text_value_a  | Issue resolved                     | Issue unresolved |
| text_value_b  | Joint pain, stiffness and swelling | Joint pain       |
| updated_date  | 2021-10-03                         | 2021-09-29       |
| updated_date  | 2021-11-27                         | 2021-10-03       |
| updated_date  | 2021-10-20                         | 2021-09-02       |
| updated_date  | 2021-10-13                         | 2021-10-03       |
| updated_date  | 2021-10-14                         | 2021-09-20       |
| entered_date  | 2021-11-30                         | 2021-09-29       |
| entered_date  | 2021-11-30                         | 2021-10-29       |
| entered_date  | 2021-11-21                         | 2021-08-18       |
| entered_date  | 2021-11-11                         | 2021-10-03       |
| entered_date  | 2021-11-16                         | 2021-10-20       |

diffs {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### `janitor::compare_df_cols_same()`

The
[`compare_df_cols_same()`](https://sfirke.github.io/janitor/reference/compare_df_cols_same.html)
function from `janitor` compares two datasets and “*indicates if they
will successfully bind together by rows.*”

``` r

compare_df_cols_same(T1Data, T2Data, strict_description = FALSE)
#> [1] TRUE
compare_df_cols_same(CompleteData, IncompleteData, strict_description = FALSE)
#> [1] TRUE
compare_df_cols_same(InitialData, ChangedData, strict_description = FALSE)
#> [1] TRUE
```

All of our test datasets meet this condition, but this could be used as
a step in one our `create_` functions (to see if they can be
successfully bound together).

### `testthat::expect_equal()`

This works, but returns the result as an error.

``` r

testthat::expect_equal(object = InitialData, expected = ChangedData)
#> Error:
#> ! Expected `InitialData` to equal `ChangedData`.
#> Differences:
#> Component "text_value_a": 2 string mismatches
#> Component "text_value_b": 1 string mismatch
#> Component "updated_date": Mean relative difference: 0.001492585
#> Component "entered_date": Mean relative difference: 0.002698184
```

``` r

testthat::expect_equal(object = T1Data, expected = T2Data)
#> Error:
#> ! Expected `T1Data` to equal `T2Data`.
#> Differences:
#> Attributes: < Component "row.names": Numeric: lengths (6, 9) differ >
#> Component "subject": Lengths (6, 9) differ (string compare on first 6)
#> Component "subject": 5 string mismatches
#> Component "record": Numeric: lengths (6, 9) differ
#> Component "start_date": Numeric: lengths (6, 9) differ
#> Component "mid_date": Numeric: lengths (6, 9) differ
#> Component "end_date": Numeric: lengths (6, 9) differ
#> Component "text_var": Lengths (6, 9) differ (string compare on first 6)
#> Component "text_var": 5 string mismatches
#> ...
```

### `vetr::alike()`

``` r

vetr::alike(target = InitialData, current = ChangedData)
#> [1] TRUE
```
