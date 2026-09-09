# Create empty tibble

Create empty tibble

## Usage

``` r
create_empty_tbl(tbl)
```

## Arguments

- tbl:

  input table

## Value

tibble with columns from tbl, all logical

## Examples

``` r
DF <- data.frame(
        id = 1:6,
        lowercase = letters[1:6],
        uppercase = LETTERS[1:6])
create_empty_tbl(DF)
#> # A tibble: 1 × 3
#>   id    lowercase uppercase
#>   <lgl> <lgl>     <lgl>    
#> 1 NA    NA        NA       
```
