# compare-data

``` r

library(dfdiffs)
library(openxlsx)
library(janitor) 
library(arsenal) # comparedf
library(diffdf)  # diffdf
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(forcats)
library(glue)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)
```

## Motivation

The goal of the `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

### Test data

These are two Masters tables from the [Lahman baseball
database.](https://www.seanlahman.com/baseball-archive/statistics/)

``` r

m15 <- dfdiffs::master15 |> 
  dplyr::slice_sample(n = 3000, replace = FALSE)
max(m15$debut, na.rm = TRUE)
#> [1] "2015-09-13"
m20 <- dfdiffs::master20 |> 
  dplyr::slice_sample(n = 3000, replace = FALSE)
max(m20$debut, na.rm = TRUE)
#> [1] "2019-09-14"
```

### The `compare_data()` function

``` r

compare_data(compare = , base = , by = , by_col = , cols = )
```

``` r

comparisons <- compare_data(
  compare = m20, base = m15, 
  by = "playerID", by_col = "join", 
  cols = c("nameFirst", "nameLast", "nameGiven", "height"))
#> Error in `tidyr::unite()`:
#> ! `sep` must be a single string, not absent.
names(comparisons)
#> Error:
#> ! object 'comparisons' not found
```

### `$new_data`

``` r

comparisons$new_data
```

    #> Error:
    #> ! object 'comparisons' not found

### `$deleted_data`

``` r

comparisons$deleted_data
```

    #> Error:
    #> ! object 'comparisons' not found

### `$changed_num_diffs`

``` r

comparisons$changed_num_diffs
```

    #> Error:
    #> ! object 'comparisons' not found

### `$changed_var_diffs`

``` r

comparisons$changed_var_diffs
```

    #> Error:
    #> ! object 'comparisons' not found
