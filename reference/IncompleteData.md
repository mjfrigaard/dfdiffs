# Incomplete Data (simulated data for checking deleted data)

`CompleteData` with four records removed, used to demonstrate
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md).

## Usage

``` r
IncompleteData
```

## Format

A data frame with 5 rows and 7 variables:

- subject:

  A character ID variable ("A", "B", "C", "D")

- record:

  A numeric record ID (1-3)

- start_date:

  a beginning date (from 2021-12-26 to 2021-12-28)

- mid_date:

  a middle date (from 2022-01-25 to 2022-01-27)

- end_date:

  a last date (from 2022-02-24 to 2022-02-26)

- text_var:

  a visit record description (e.g. "Vital signs recorded...")

- factor_var:

  the record's category (e.g. "vitals", "labs")
