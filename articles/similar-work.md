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
#>                 subject record start_date   mid_date   end_date                                    text_var factor_var
#> - actual[1, ]         A      1 2022-01-28 2022-03-20 2022-03-30 The birch canoe slid on the smooth planks.   food     
#> + expected[1, ]       D      5 2022-01-30 2022-03-16 2022-03-26 Rice is often served in round bowls.         regard   
#> - actual[2, ]         A      2 2022-01-25 2022-03-15 2022-03-29 Glue the sheet to the dark blue background.  most     
#> + expected[2, ]       D      6 2022-01-27 2022-03-17 2022-03-31 The juice of lemons makes fine punch.        law      
#> - actual[3, ]         B      3 2022-01-26 2022-03-19 2022-03-25 It's easy to tell the depth of a well.       park     
#> + expected[3, ]       D      5 2022-04-04 2022-04-13 2022-04-22 Four hours of steady work faced us.          associate
#>   actual[4, ]         C      4 2022-01-29 2022-03-18 2022-03-27 These days a chicken leg is a rare dish.     between  
#> - actual[5, ]         D      5 2022-01-30 2022-03-16 2022-03-26 Rice is often served in round bowls.         regard   
#> - actual[6, ]         D      6 2022-01-27 2022-03-17 2022-03-31 The juice of lemons makes fine punch.        law      
#> + expected[5, ]       B      3 2022-01-26 2022-03-19 2022-03-25 It's easy to tell the depth of a well.       park     
#> + expected[6, ]       B      4 2022-04-02 2022-04-14 2022-04-20 The hogs were fed chopped corn and garbage.  encourage
#> + expected[7, ]       A      1 2022-01-28 2022-03-20 2022-03-30 The birch canoe slid on the smooth planks.   food     
#> + expected[8, ]       A      2 2022-01-25 2022-03-15 2022-03-29 Glue the sheet to the dark blue background.  most     
#> + expected[9, ]       A      2 2022-04-04 2022-04-15 2022-04-21 The box was thrown beside the parked truck.  pension  
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
#> - "The birch canoe slid on the smooth planks."
#> + "Rice is often served in round bowls."
#> - "Glue the sheet to the dark blue background."
#> + "The juice of lemons makes fine punch."
#> - "It's easy to tell the depth of a well."
#> + "Four hours of steady work faced us."
#>   "These days a chicken leg is a rare dish."
#> - "Rice is often served in round bowls."
#> - "The juice of lemons makes fine punch."
#> + "It's easy to tell the depth of a well."
#> + "The hogs were fed chopped corn and garbage."
#> + "The birch canoe slid on the smooth planks."
#> + "Glue the sheet to the dark blue background."
#> + "The box was thrown beside the parked truck."
#> 
#>     actual$factor_var | expected$factor_var    
#> [1] "food"            - "regard"            [1]
#> [2] "most"            - "law"               [2]
#> [3] "park"            - "associate"         [3]
#> [4] "between"         | "between"           [4]
#> [5] "regard"          - "park"              [5]
#> [6] "law"             - "encourage"         [6]
#>                       - "food"              [7]
#>                       - "most"              [8]
#>                       - "pension"           [9]
```

### `vetr::alike()`

``` r

vetr::alike(target = InitialData, current = ChangedData)
#> [1] TRUE
```
