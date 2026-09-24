# Changed/Modified Current Data (simulated data for checking modified data)

`InitialData`'s adverse-event records after query resolution — some
values have changed, used to demonstrate
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md).

## Usage

``` r
ChangedData
```

## Format

A data frame with 5 rows and 7 variables:

- subject_id:

  A character ID variable ("A", "B", "C")

- record:

  A numeric record ID (1-5)

- text_value_a:

  the adverse event's resolution status ("Issue resolved"/"Issue
  unresolved")

- text_value_b:

  the adverse event term (e.g. "Fatigue", "Fever", "Joint pain")

- created_date:

  a beginning date (from 2021-07-16 to 2021-08-24)

- updated_date:

  a middle date (from 2021-10-03 to 2021-11-27)

- entered_date:

  a last date (from 2021-11-11 to 2021-11-30)
