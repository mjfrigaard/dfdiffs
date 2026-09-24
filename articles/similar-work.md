# similar-work

## Motivation

This vignette covers similar functions and packages that compare two
datasets to each other.

### Packages

Load `dfdiffs`:

``` r

library(dfdiffs)
```

We’ll also need packages for import/export, iteration, and wrangling:

``` r

library(readr)
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
library(testthat) # expect_equal
library(vetr) # alike
library(labelled)
library(gtsummary)
```

### Data

We’ll use the data in this package to cover similar
`packages::functions()`.

#### New data

To check for new data, we’ll use `T1Data` and `T2Data`. The
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
function returns the ‘new data’ (i.e., the rows that are here now but
weren’t here before).

We can check this against the `NewData` dataset, which should match the
output from
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md).

``` r

T1Data <- dfdiffs::T1Data
T2Data <- dfdiffs::T2Data
T1T2New <- create_new_data(compare = T2Data, base = T1Data)
T1T2New |> 
  knitr::kable(caption = "New data T1 > T2") |> 
  kableExtra::kable_paper()
```

|  | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 3 | D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Patient reports lower back pain after activity. | back pain |
| 6 | B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | Patient reports difficulty sleeping through the night. | insomnia |
| 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

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
| D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Patient reports lower back pain after activity. | back pain |
| B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | Patient reports difficulty sleeping through the night. | insomnia |
| A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

New data (Comparison) {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

We can see the only differences between the datasets are the formats of
the date columns:

``` r

waldo::compare(x = T1T2New, y = NewData)
#> `class(old)`: "data.frame"                   
#> `class(new)`: "tbl_df"     "tbl" "data.frame"
#> 
#> `attr(old, 'row.names')`: 3 6 9
#> `attr(new, 'row.names')`: 1 2 3
#> 
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

To test for deleted data, we’ll use `CompleteData`, `IncompleteData`,
and `DeletedData`.

`CompleteData` represents a ‘complete’ set of data.

``` r

CompleteData <- dfdiffs::CompleteData
CompleteData |> 
  knitr::kable(caption = "CompleteData") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|---:|:---|:---|:---|:---|:---|
| A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at screening visit. | vitals |
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Laboratory sample collected for hematology panel. | labs |
| B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | ECG performed during screening assessment. | ecg |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
| A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at follow-up visit. | vitals |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Laboratory sample collected for chemistry panel. | labs |

CompleteData {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

`IncompleteData` is a dataset with rows removed from `CompleteData`.

``` r

IncompleteData <- dfdiffs::IncompleteData
IncompleteData |> 
  knitr::kable(caption = "IncompleteData") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|---:|:---|:---|:---|:---|:---|
| A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at screening visit. | vitals |
| B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Laboratory sample collected for hematology panel. | labs |
| B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | ECG performed during screening assessment. | ecg |
| A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at follow-up visit. | vitals |
| D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Laboratory sample collected for chemistry panel. | labs |

IncompleteData {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

Running
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
checks for rows that were deleted between `CompleteData` and
`IncompleteData`.

``` r

IncompCompDiff <- create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData) |> 
  arrange(subject)
#> Error in `arrange()`:
#> ! could not find function "arrange"
IncompCompDiff |> 
  knitr::kable(caption = "IncompCompDiff") |> 
  kableExtra::kable_paper()
#> Error:
#> ! object 'IncompCompDiff' not found
```

The output above is identical to the data stored in `DeletedData`.

``` r

DeletedData <- dfdiffs::DeletedData
DeletedData |> 
  knitr::kable(caption = "DeletedData") |> 
  kableExtra::kable_paper()
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|---:|:---|:---|:---|:---|:---|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

DeletedData {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

We can confirm this with
[`waldo::compare()`](https://waldo.r-lib.org/reference/compare.html):

``` r

waldo::compare(x = IncompCompDiff, y = DeletedData)
#> Error:
#> ! object 'IncompCompDiff' not found
```

#### Changed data

To check for changes between two datasets, we’ll use `InitialData` and
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

| Variable name | Modified Values |
|:--------------|----------------:|
| subject_id    |               0 |
| record        |               0 |
| text_value_a  |               2 |
| text_value_b  |               1 |
| created_date  |               0 |
| updated_date  |               5 |
| entered_date  |               5 |

diffs_byvar {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

The changes by row are stored in `diffs`.

``` r

mods$diffs |> 
  knitr::kable(caption = "diffs") |> 
  kableExtra::kable_paper()
```

| Variable name | rownumber | Current Value                      | Previous Value   |
|:--------------|----------:|:-----------------------------------|:-----------------|
| text_value_a  |         1 | Issue resolved                     | Issue unresolved |
| text_value_a  |         2 | Issue resolved                     | Issue unresolved |
| text_value_b  |         4 | Joint pain, stiffness and swelling | Joint pain       |
| updated_date  |         1 | 2021-10-03                         | 2021-09-29       |
| updated_date  |         2 | 2021-11-27                         | 2021-10-03       |
| updated_date  |         3 | 2021-10-20                         | 2021-09-02       |
| updated_date  |         4 | 2021-10-13                         | 2021-10-03       |
| updated_date  |         5 | 2021-10-14                         | 2021-09-20       |
| entered_date  |         1 | 2021-11-30                         | 2021-09-29       |
| entered_date  |         2 | 2021-11-30                         | 2021-10-29       |
| entered_date  |         3 | 2021-11-21                         | 2021-08-18       |
| entered_date  |         4 | 2021-11-11                         | 2021-10-03       |
| entered_date  |         5 | 2021-11-16                         | 2021-10-20       |

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

All of our test datasets meet this condition, but this check could be
used as a step in one of our `create_` functions (to confirm the
datasets can be bound together).

### `testthat::expect_equal()`

This works, but it returns the result as an error.

``` r

testthat::expect_equal(object = InitialData, expected = ChangedData)
#> Error:
#> ! Expected `InitialData` to equal `ChangedData`.
#> Differences:
#> actual vs expected
#>                     text_value_a                       text_value_b updated_date entered_date
#> - actual[1, ]   Issue unresolved Fatigue                              2021-09-29   2021-09-29
#> + expected[1, ] Issue resolved   Fatigue                              2021-10-03   2021-11-30
#> - actual[2, ]   Issue unresolved Fatigue                              2021-10-03   2021-10-29
#> + expected[2, ] Issue resolved   Fatigue                              2021-11-27   2021-11-30
#> - actual[3, ]   Issue resolved   Fever                                2021-09-02   2021-08-18
#> + expected[3, ] Issue resolved   Fever                                2021-10-20   2021-11-21
#> - actual[4, ]   Issue resolved   Joint pain                           2021-10-03   2021-10-03
#> + expected[4, ] Issue resolved   Joint pain, stiffness and swelling   2021-10-13   2021-11-11
#> - actual[5, ]   Issue resolved   Joint pain                           2021-09-20   2021-10-20
#> + expected[5, ] Issue resolved   Joint pain                           2021-10-14   2021-11-16
#> 
#>     actual$text_value_a | expected$text_value_a    
#> [1] "Issue unresolved"  - "Issue resolved"      [1]
#> [2] "Issue unresolved"  - "Issue resolved"      [2]
#> [3] "Issue resolved"    | "Issue resolved"      [3]
#> [4] "Issue resolved"    | "Issue resolved"      [4]
#> [5] "Issue resolved"    | "Issue resolved"      [5]
#> 
#>     actual$text_value_b | expected$text_value_b                   
#> [1] "Fatigue"           | "Fatigue"                            [1]
#> [2] "Fatigue"           | "Fatigue"                            [2]
#> [3] "Fever"             | "Fever"                              [3]
#> [4] "Joint pain"        - "Joint pain, stiffness and swelling" [4]
#> [5] "Joint pain"        | "Joint pain"                         [5]
#> 
#>     actual$updated_date | expected$updated_date    
#> [1] "2021-09-29"        - "2021-10-03"          [1]
#> [2] "2021-10-03"        - "2021-11-27"          [2]
#> [3] "2021-09-02"        - "2021-10-20"          [3]
#> [4] "2021-10-03"        - "2021-10-13"          [4]
#> [5] "2021-09-20"        - "2021-10-14"          [5]
#> 
#>     actual$entered_date | expected$entered_date    
#> [1] "2021-09-29"        - "2021-11-30"          [1]
#> [2] "2021-10-29"        - "2021-11-30"          [2]
#> [3] "2021-08-18"        - "2021-11-21"          [3]
#> [4] "2021-10-03"        - "2021-11-11"          [4]
#> [5] "2021-10-20"        - "2021-11-16"          [5]
```

``` r

testthat::expect_equal(object = T1Data, expected = T2Data)
#> Error:
#> ! Expected `T1Data` to equal `T2Data`.
#> Differences:
#>   `attr(actual, 'row.names')[4:6]`: 4 5 6      
#> `attr(expected, 'row.names')[4:9]`: 4 5 6 7 8 9
#> 
#> actual vs expected
#>                 subject record start_date   mid_date   end_date                                               text_var factor_var
#> - actual[1, ]         A      1 2022-01-28 2022-03-20 2022-03-30 Patient reports mild headache after morning dose.       headache 
#> + expected[1, ]       D      5 2022-01-30 2022-03-16 2022-03-26 Patient reports mild rash on the left forearm.          rash     
#> - actual[2, ]         A      2 2022-01-25 2022-03-15 2022-03-29 Patient reports occasional nausea following meals.      nausea   
#> + expected[2, ]       D      6 2022-01-27 2022-03-17 2022-03-31 Patient reports low-grade fever in the evening.         fever    
#> - actual[3, ]         B      3 2022-01-26 2022-03-19 2022-03-25 Patient reports persistent fatigue throughout the day.  fatigue  
#> + expected[3, ]       D      5 2022-04-04 2022-04-13 2022-04-22 Patient reports lower back pain after activity.         back pain
#>   actual[4, ]         C      4 2022-01-29 2022-03-18 2022-03-27 Patient reports brief dizziness upon standing.          dizziness
#> - actual[5, ]         D      5 2022-01-30 2022-03-16 2022-03-26 Patient reports mild rash on the left forearm.          rash     
#> - actual[6, ]         D      6 2022-01-27 2022-03-17 2022-03-31 Patient reports low-grade fever in the evening.         fever    
#> + expected[5, ]       B      3 2022-01-26 2022-03-19 2022-03-25 Patient reports persistent fatigue throughout the day.  fatigue  
#> + expected[6, ]       B      4 2022-04-02 2022-04-14 2022-04-20 Patient reports difficulty sleeping through the night.  insomnia 
#> + expected[7, ]       A      1 2022-01-28 2022-03-20 2022-03-30 Patient reports mild headache after morning dose.       headache 
#> + expected[8, ]       A      2 2022-01-25 2022-03-15 2022-03-29 Patient reports occasional nausea following meals.      nausea   
#> + expected[9, ]       A      2 2022-04-04 2022-04-15 2022-04-21 Patient reports dry cough lasting several days.         cough    
#> 
#> `actual$subject`:   "A" "A" "B" "C" "D" "D"            
#> `expected$subject`: "D" "D" "D" "C" "B" "B" "A" "A" "A"
#> 
#>   `actual$record`: 1 2 3 4 5 6      
#> `expected$record`: 5 6 5 4 3 4 1 2 2
#> 
#>     actual$start_date | expected$start_date    
#> [1] "2022-01-28"      - "2022-01-30"        [1]
#> [2] "2022-01-25"      - "2022-01-27"        [2]
#> [3] "2022-01-26"      - "2022-04-04"        [3]
#> [4] "2022-01-29"      | "2022-01-29"        [4]
#> [5] "2022-01-30"      - "2022-01-26"        [5]
#> [6] "2022-01-27"      - "2022-04-02"        [6]
#>                       - "2022-01-28"        [7]
#>                       - "2022-01-25"        [8]
#>                       - "2022-04-04"        [9]
#> 
#>     actual$mid_date | expected$mid_date    
#> [1] "2022-03-20"    - "2022-03-16"      [1]
#> [2] "2022-03-15"    - "2022-03-17"      [2]
#> [3] "2022-03-19"    - "2022-04-13"      [3]
#> [4] "2022-03-18"    | "2022-03-18"      [4]
#> [5] "2022-03-16"    - "2022-03-19"      [5]
#> [6] "2022-03-17"    - "2022-04-14"      [6]
#>                     - "2022-03-20"      [7]
#>                     - "2022-03-15"      [8]
#>                     - "2022-04-15"      [9]
#> 
#>     actual$end_date | expected$end_date    
#> [1] "2022-03-30"    - "2022-03-26"      [1]
#> [2] "2022-03-29"    - "2022-03-31"      [2]
#> [3] "2022-03-25"    - "2022-04-22"      [3]
#> [4] "2022-03-27"    | "2022-03-27"      [4]
#> [5] "2022-03-26"    - "2022-03-25"      [5]
#> [6] "2022-03-31"    - "2022-04-20"      [6]
#>                     - "2022-03-30"      [7]
#>                     - "2022-03-29"      [8]
#>                     - "2022-04-21"      [9]
#> 
#> actual$text_var vs expected$text_var
#> - "Patient reports mild headache after morning dose."
#> + "Patient reports mild rash on the left forearm."
#> - "Patient reports occasional nausea following meals."
#> + "Patient reports low-grade fever in the evening."
#> - "Patient reports persistent fatigue throughout the day."
#> + "Patient reports lower back pain after activity."
#>   "Patient reports brief dizziness upon standing."
#> - "Patient reports mild rash on the left forearm."
#> - "Patient reports low-grade fever in the evening."
#> + "Patient reports persistent fatigue throughout the day."
#> + "Patient reports difficulty sleeping through the night."
#> + "Patient reports mild headache after morning dose."
#> + "Patient reports occasional nausea following meals."
#> + "Patient reports dry cough lasting several days."
#> 
#>     actual$factor_var | expected$factor_var    
#> [1] "headache"        - "rash"              [1]
#> [2] "nausea"          - "fever"             [2]
#> [3] "fatigue"         - "back pain"         [3]
#> [4] "dizziness"       | "dizziness"         [4]
#> [5] "rash"            - "fatigue"           [5]
#> [6] "fever"           - "insomnia"          [6]
#>                       - "headache"          [7]
#>                       - "nausea"            [8]
#>                       - "cough"             [9]
```

### `vetr::alike()`

``` r

vetr::alike(target = InitialData, current = ChangedData)
#> [1] TRUE
```
