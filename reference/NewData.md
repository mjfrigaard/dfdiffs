# NewData (difference between 'time-point 1' & 'time-point 2' data)

The three observations present in `T2Data` but not `T1Data` — the
expected result of `create_new_data(compare = T2Data, base = T1Data)`.

## Usage

``` r
NewData
```

## Format

A data frame with 3 rows and 7 variables:

- subject:

  A character ID variable ("A", "B", "D")

- record:

  A numeric record ID (2, 4, 5)

- start_date:

  a beginning date (from 2022-04-02 to 2022-04-04)

- mid_date:

  a middle date (from 2022-04-13 to 2022-04-15)

- end_date:

  a last date (from 2022-04-20 to 2022-04-22)

- text_var:

  a patient-reported clinical observation

- factor_var:

  the observation's category (e.g. "cough", "insomnia")
