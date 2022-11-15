
<!-- README.md is generated from README.Rmd. Please edit that file -->

``` r
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "man/figures/README-",
  out.width = "100%"
)
# devtools::install_github("mjfrigaard/dfdiffs")
library(dfdiffs)
```

# dfdiffs

<!-- badges: start -->
<!-- badges: end -->

The goal of `dfdiffs` is to is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

You can access a development version of the application
[here.](https://mjfrigaard.shinyapps.io/compareDataApp/)

## Installation

You can install the development version of dfdiffs from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mjfrigaard/dfdiffs")
```

## Packages

Dependencies

``` r
library(dplyr)
library(stringr)
library(forcats)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
library(vroom)
library(haven)
library(readxl)
library(janitor) 
library(arsenal) 
library(gt)
library(labelled)
library(gtsummary)
```

## Package functions

We have functions for answering each of the questions posed above. Each
function has a pair of datasets to demonstrate how they work (which
we’ll cover below).

## *What rows are here now that weren’t here before?*

To check new data, we’re going to use `T1Data` and `T2Data`.

``` r
T1Data <- dfdiffs::T1Data
T2Data <- dfdiffs::T2Data
NewData <- dfdiffs::NewData
```

### Timepoint 1 data (original)

These data represent data taken at T1.

``` r
T1Data |> knitr::kable(format = "pipe")
```

| subject | record | start_date | mid_date   | end_date   | text_var                                    | factor_var |
|:--------|-------:|:-----------|:-----------|:-----------|:--------------------------------------------|:-----------|
| A       |      1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | The birch canoe slid on the smooth planks.  | food       |
| A       |      2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Glue the sheet to the dark blue background. | most       |
| B       |      3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | It’s easy to tell the depth of a well.      | park       |
| C       |      4 | 2022-01-29 | 2022-03-18 | 2022-03-27 | These days a chicken leg is a rare dish.    | between    |
| D       |      5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Rice is often served in round bowls.        | regard     |
| D       |      6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | The juice of lemons makes fine punch.       | law        |

### Timepoint 2 data (new)

This is a ‘new’ dataset representing T2.

``` r
T2Data |> knitr::kable(format = "pipe")
```

| subject | record | start_date | mid_date   | end_date   | text_var                                    | factor_var |
|:--------|-------:|:-----------|:-----------|:-----------|:--------------------------------------------|:-----------|
| D       |      5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Rice is often served in round bowls.        | regard     |
| D       |      6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | The juice of lemons makes fine punch.       | law        |
| D       |      5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Four hours of steady work faced us.         | associate  |
| C       |      4 | 2022-01-29 | 2022-03-18 | 2022-03-27 | These days a chicken leg is a rare dish.    | between    |
| B       |      3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | It’s easy to tell the depth of a well.      | park       |
| B       |      4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | The hogs were fed chopped corn and garbage. | encourage  |
| A       |      1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | The birch canoe slid on the smooth planks.  | food       |
| A       |      2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Glue the sheet to the dark blue background. | most       |
| A       |      2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension    |

### `create_new_data()`

The `create_new_data()` function shows us the ‘new data’ (i.e. what is
here now that wasn’t here before?)

``` r
create_new_data(
  compare = T2Data, 
  base = T1Data) |> 
  knitr::kable(format = "pipe")
```

| subject | record | start_date | mid_date   | end_date   | text_var                                    | factor_var |
|:--------|:-------|:-----------|:-----------|:-----------|:--------------------------------------------|:-----------|
| D       | 5      | 2022-04-04 | 2022-04-13 | 2022-04-22 | Four hours of steady work faced us.         | associate  |
| B       | 4      | 2022-04-02 | 2022-04-14 | 2022-04-20 | The hogs were fed chopped corn and garbage. | encourage  |
| A       | 2      | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension    |

We can check this against the `NewData` dataset (which should match the
output from `create_new_data()`)

``` r
NewData |> knitr::kable(format = "pipe")
```

| subject | record | start_date | mid_date   | end_date   | text_var                                    | factor_var |
|:--------|:-------|:-----------|:-----------|:-----------|:--------------------------------------------|:-----------|
| D       | 5      | 2022-04-04 | 2022-04-13 | 2022-04-22 | Four hours of steady work faced us.         | associate  |
| B       | 4      | 2022-04-02 | 2022-04-14 | 2022-04-20 | The hogs were fed chopped corn and garbage. | encourage  |
| A       | 2      | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension    |

## *What rows were here before that aren’t here now?*

To test for the deleted data, we use the `CompleteData`,
`IncompleteData`, and check these with `DeletedData`.

``` r
CompleteData <- dfdiffs::CompleteData
IncompleteData <- dfdiffs::IncompleteData
DeletedData <- dfdiffs::DeletedData
```

### A complete dataset

`CompleteData` represents a ‘complete’ set of data.

``` r
CompleteData |> knitr::kable(format = "pipe")
```

| subject | record | start_date | mid_date   | end_date   | text_var                                         | factor_var |
|:--------|-------:|:-----------|:-----------|:-----------|:-------------------------------------------------|:-----------|
| A       |      1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | The copper bowl shone in the sun’s rays.         | interest   |
| A       |      2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red.           | state      |
| B       |      1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Take a chance and win a china doll.              | sure       |
| B       |      2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A cramp is no small danger on a swim.            | white      |
| C       |      1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It’s easy to tell the depth of a well.           | grant      |
| D       |      1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue.  | tape       |
| A       |      3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Wake and rise, and step into the green outdoors. | situate    |
| B       |      3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird.              | shut       |
| D       |      2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Say it slow!y but make it ring clear.            | document   |

### An incomplete dataset

This is a dataset with rows removed from `CompleteData`.

``` r
IncompleteData |> knitr::kable(format = "pipe")
```

| subject | record | start_date | mid_date   | end_date   | text_var                                         | factor_var |
|:--------|-------:|:-----------|:-----------|:-----------|:-------------------------------------------------|:-----------|
| A       |      1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | The copper bowl shone in the sun’s rays.         | interest   |
| B       |      1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Take a chance and win a china doll.              | sure       |
| B       |      2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A cramp is no small danger on a swim.            | white      |
| A       |      3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Wake and rise, and step into the green outdoors. | situate    |
| D       |      2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Say it slow!y but make it ring clear.            | document   |

### `create_deleted_data()`

When we run the `create_deleted_data()`, we check for the deleted rows
between `IncompleteData` and `CompleteData`.

``` r
create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData) |> 
  knitr::kable(format = "pipe")
```

| subject | record | start_date | mid_date   | end_date   | text_var                                        | factor_var |
|:--------|:-------|:-----------|:-----------|:-----------|:------------------------------------------------|:-----------|
| A       | 2      | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red.          | state      |
| C       | 1      | 2021-12-30 | 2022-01-29 | 2022-02-28 | It’s easy to tell the depth of a well.          | grant      |
| D       | 1      | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape       |
| B       | 3      | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird.             | shut       |

### The deleted data

This is identical to the data stored in `DeletedData`

``` r
DeletedData |> knitr::kable(format = "pipe")
```

| subject | record | start_date | mid_date   | end_date   | text_var                                        | factor_var |
|:--------|-------:|:-----------|:-----------|:-----------|:------------------------------------------------|:-----------|
| A       |      2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red.          | state      |
| B       |      3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird.             | shut       |
| C       |      1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It’s easy to tell the depth of a well.          | grant      |
| D       |      1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape       |

## *What values have been changed?*

To answer this question, we have two options: `create_changed_data()`
and `create_modified_data()`.

- `create_changed_data()` relies on the `diffdf()` function from the
  [`diffdf`
  package](https://gowerc.github.io/diffdf/reference/diffdf.html)
  package.

- `create_modified_data()` relies on the `comparedf()` function from the
  [`arsenal`
  package](https://mayoverse.github.io/arsenal/reference/comparedf.html)
  package.

To check for changes between two datasets, we use the `InitialData` and
`ChangedData`.

``` r
InitialData <- dfdiffs::InitialData
ChangedData <- dfdiffs::ChangedData
```

### Initial data

``` r
InitialData |> knitr::kable(format = "pipe")
```

| subject_id | record | text_value_a     | text_value_b | created_date | updated_date | entered_date |
|:-----------|-------:|:-----------------|:-------------|:-------------|:-------------|:-------------|
| A          |      1 | Issue unresolved | Fatigue      | 2021-07-29   | 2021-09-29   | 2021-09-29   |
| A          |      2 | Issue unresolved | Fatigue      | 2021-07-29   | 2021-10-03   | 2021-10-29   |
| B          |      3 | Issue resolved   | Fever        | 2021-07-16   | 2021-09-02   | 2021-08-18   |
| C          |      4 | Issue resolved   | Joint pain   | 2021-08-24   | 2021-10-03   | 2021-10-03   |
| C          |      5 | Issue resolved   | Joint pain   | 2021-08-24   | 2021-09-20   | 2021-10-20   |

### Changed data

``` r
ChangedData |> knitr::kable(format = "pipe")
```

| subject_id | record | text_value_a   | text_value_b                       | created_date | updated_date | entered_date |
|:-----------|-------:|:---------------|:-----------------------------------|:-------------|:-------------|:-------------|
| A          |      1 | Issue resolved | Fatigue                            | 2021-07-29   | 2021-10-03   | 2021-11-30   |
| A          |      2 | Issue resolved | Fatigue                            | 2021-07-29   | 2021-11-27   | 2021-11-30   |
| B          |      3 | Issue resolved | Fever                              | 2021-07-16   | 2021-10-20   | 2021-11-21   |
| C          |      4 | Issue resolved | Joint pain, stiffness and swelling | 2021-08-24   | 2021-10-13   | 2021-11-11   |
| C          |      5 | Issue resolved | Joint pain                         | 2021-08-24   | 2021-10-14   | 2021-11-16   |

### `create_changed_data()`

`create_changed_data()` creates a list of tables.

``` r
changed <- create_changed_data(
  compare = ChangedData,
  base = InitialData)
names(changed)
#> [1] "num_diffs" "var_diffs"
```

#### Counts of changes (`num_diffs`)

The counts of changes by variable are stored in `num_diffs`.

``` r
changed$num_diffs |> knitr::kable(format = "pipe")
```

| variable     | no_of_differences |
|:-------------|------------------:|
| text_value_a |                 2 |
| text_value_b |                 1 |
| updated_date |                 5 |
| entered_date |                 5 |

#### Changes by row (`var_diffs`)

The changes by row are stored in `var_diffs`.

``` r
changed$var_diffs |> knitr::kable(format = "pipe")
```

| variable     | rownumber | base             | compare                            |
|:-------------|:----------|:-----------------|:-----------------------------------|
| text_value_a | 1         | Issue unresolved | Issue resolved                     |
| text_value_a | 2         | Issue unresolved | Issue resolved                     |
| text_value_b | 4         | Joint pain       | Joint pain, stiffness and swelling |
| updated_date | 1         | 2021-09-29       | 2021-10-03                         |
| updated_date | 2         | 2021-10-03       | 2021-11-27                         |
| updated_date | 3         | 2021-09-02       | 2021-10-20                         |
| updated_date | 4         | 2021-10-03       | 2021-10-13                         |
| updated_date | 5         | 2021-09-20       | 2021-10-14                         |
| entered_date | 1         | 2021-09-29       | 2021-11-30                         |
| entered_date | 2         | 2021-10-29       | 2021-11-30                         |
| entered_date | 3         | 2021-08-18       | 2021-11-21                         |
| entered_date | 4         | 2021-10-03       | 2021-11-11                         |
| entered_date | 5         | 2021-10-20       | 2021-11-16                         |

### `create_modified_data()`

The `create_modified_data()` function also creates a list of tables.

``` r
modified <- create_modified_data(
  compare = ChangedData,
  base = InitialData)
names(modified)
#> [1] "diffs"       "diffs_byvar"
```

#### Counts of changes (`diffs_byvar`)

The counts of changes by variable are stored in `diffs_byvar`.

``` r
modified$diffs_byvar |> knitr::kable(format = "pipe")
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

#### Changes by row

The changes by row are stored in `diffs`.

``` r
modified$diffs |> knitr::kable(format = "pipe")
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
