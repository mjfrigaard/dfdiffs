# Complete Data (simulated data for checking 'deleted data')

Simulated clinical visit records for four subjects, used to demonstrate
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md).

## Usage

``` r
CompleteData
```

## Format

A data frame with 9 rows and 7 variables:

- subject:

  A character ID variable ("A", "B", "C", "D")

- record:

  A numeric record ID (1-3)

- start_date:

  a beginning date (from 2021-12-26 to 2021-12-30)

- mid_date:

  a middle date (from 2022-01-25 to 2022-01-29)

- end_date:

  a last date (from 2022-02-24 to 2022-02-28)

- text_var:

  a visit record description (e.g. "Vital signs recorded...")

- factor_var:

  the record's category (e.g. "vitals", "labs", "exam")
