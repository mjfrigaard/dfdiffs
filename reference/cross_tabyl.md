# cross_tabyl

cross_tabyl() is a helper function to quickly create a cross-tabulation
of the values in a categorical variable.

## Usage

``` r
cross_tabyl(df, col)
```

## Arguments

- df:

  a data.frame or tibble

- col:

  a column with categorical or factor data

## Value

cross_tabyl

## Examples

``` r
# not run
df <- data.frame(hair_color = c("blond", "brown", "brown", "black", NA))
cross_tabyl(df, "hair_color")
#> # A tibble: 5 × 4
#>   `Variable = hair_color`     N Percent `Valid Percent`
#>   <chr>                   <dbl> <chr>   <chr>          
#> 1 black                       1 20.0%   25.0%          
#> 2 blond                       1 20.0%   25.0%          
#> 3 brown                       2 40.0%   50.0%          
#> 4 NA                          1 20.0%   -              
#> 5 Total Queries               5 -       -              
```
