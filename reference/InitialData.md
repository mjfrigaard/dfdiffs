# Changed/Modified Initial Data (simulated data for checking modified data)

Simulated adverse-event records for three subjects, taken before query
resolution, used to demonstrate
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md).

## Usage

``` r
InitialData
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

  a middle date (from 2021-09-02 to 2021-10-03)

- entered_date:

  a last date (from 2021-08-18 to 2021-10-29)
