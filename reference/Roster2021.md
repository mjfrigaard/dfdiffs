# Roster2021 (synthetic site roster, year one)

A synthetic (not real) clinical site roster, used to demonstrate
`dfdiffs` at a larger scale than the small toy datasets above.
`Roster2021`/`Roster2022`/`Roster2023`/`Roster2024` are four yearly
pulls of the same growing roster: most subjects present in one year's
pull are still present the next, a few new subjects enroll each year,
and a handful withdraw and stop appearing. The same data is also shipped
as CSV files under
`system.file("extdata/csv/site-roster", package = "dfdiffs")`.

## Usage

``` r
Roster2021
```

## Format

A data frame with 200 rows and 11 variables:

- subject_id:

  A unique character ID ("SUBJ-0001", ...)

- first_name:

  First name

- last_name:

  Last name

- site_id:

  The enrolling site ("SITE-01".."SITE-08")

- enroll_year:

  Year first enrolled (fixed per subject, not the pull year)

- enroll_month:

  Month enrolled (1-12)

- enroll_day:

  Day enrolled (1-28)

- height_cm:

  Height in centimeters

- full_name:

  `first_name` and `last_name` combined

- first_visit_date:

  `enroll_year`/`enroll_month`/`enroll_day` as a date

- status:

  Enrollment status ("Active" for every subject in every pull)
