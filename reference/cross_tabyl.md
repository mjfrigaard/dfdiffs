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

  a bs4Dash::column with categorical or factor data

## Value

cross_tabyl

## Examples

``` r
# not run
library(dplyr)
cross_tabyl(starwars, "hair_color")
#> # A tibble: 13 × 4
#>    `Variable = hair_color`     N Percent `Valid Percent`
#>    <chr>                   <dbl> <chr>   <chr>          
#>  1 auburn                      1 1.1%    1.2%           
#>  2 auburn, grey                1 1.1%    1.2%           
#>  3 auburn, white               1 1.1%    1.2%           
#>  4 black                      13 14.9%   15.9%          
#>  5 blond                       3 3.4%    3.7%           
#>  6 blonde                      1 1.1%    1.2%           
#>  7 brown                      18 20.7%   22.0%          
#>  8 brown, grey                 1 1.1%    1.2%           
#>  9 grey                        1 1.1%    1.2%           
#> 10 none                       38 43.7%   46.3%          
#> 11 white                       4 4.6%    4.9%           
#> 12 NA                          5 5.7%    -              
#> 13 Total Queries              87 -       -              
cross_tabyl(starwars, "name")
#> # A tibble: 88 × 3
#>    `Variable = name`       N Percent
#>    <chr>               <dbl> <chr>  
#>  1 Ackbar                  1 1.1%   
#>  2 Adi Gallia              1 1.1%   
#>  3 Anakin Skywalker        1 1.1%   
#>  4 Arvel Crynyd            1 1.1%   
#>  5 Ayla Secura             1 1.1%   
#>  6 BB8                     1 1.1%   
#>  7 Bail Prestor Organa     1 1.1%   
#>  8 Barriss Offee           1 1.1%   
#>  9 Ben Quadinaros          1 1.1%   
#> 10 Beru Whitesun Lars      1 1.1%   
#> # ℹ 78 more rows
```
