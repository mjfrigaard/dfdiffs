# Compare data (create new, deleted, and changed data)

Compare data (create new, deleted, and changed data)

## Usage

``` r
compare_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
```

## Arguments

- compare:

  comparison data table

- base:

  base data table

- by:

  join column

- by_col:

  new join column name

- cols:

  columns to compare

## Value

list of comparison tables

## Examples

``` r
# not run
r21 <- dfdiffs::Roster2021
r22 <- dfdiffs::Roster2022
compare_data(compare = r22, base = r21,
    by = "subject_id",
    cols = c("first_name", "last_name", "full_name"))
#> $new_data
#>     subject_id first_name last_name      full_name
#> 198  SUBJ-0201      Riley    Jensen   Riley Jensen
#> 199  SUBJ-0202      Casey     Hayes    Casey Hayes
#> 200  SUBJ-0203     Skyler     Grant   Skyler Grant
#> 201  SUBJ-0204     Skyler       Kim     Skyler Kim
#> 202  SUBJ-0205      Riley     Irwin    Riley Irwin
#> 203  SUBJ-0206      Casey       Kim      Casey Kim
#> 204  SUBJ-0207     Hayden    Foster  Hayden Foster
#> 205  SUBJ-0208       Drew     Moore     Drew Moore
#> 206  SUBJ-0209      Quinn    Nguyen   Quinn Nguyen
#> 207  SUBJ-0210     Skyler     Lopez   Skyler Lopez
#> 208  SUBJ-0211      Avery       Kim      Avery Kim
#> 209  SUBJ-0212       Drew       Kim       Drew Kim
#> 210  SUBJ-0213     Skyler     Moore   Skyler Moore
#> 211  SUBJ-0214      Casey     Hayes    Casey Hayes
#> 212  SUBJ-0215     Taylor    Foster  Taylor Foster
#> 213  SUBJ-0216     Taylor    Carter  Taylor Carter
#> 214  SUBJ-0217    Cameron     Grant  Cameron Grant
#> 215  SUBJ-0218      Casey   Bennett  Casey Bennett
#> 216  SUBJ-0219     Taylor     Hayes   Taylor Hayes
#> 217  SUBJ-0220    Cameron       Kim    Cameron Kim
#> 218  SUBJ-0221      Jamie     Lopez    Jamie Lopez
#> 219  SUBJ-0222      Rowan     Lopez    Rowan Lopez
#> 220  SUBJ-0223      Riley     Singh    Riley Singh
#> 221  SUBJ-0224      Rowan      Diaz     Rowan Diaz
#> 222  SUBJ-0225    Emerson    Carter Emerson Carter
#> 223  SUBJ-0226      Riley       Kim      Riley Kim
#> 224  SUBJ-0227      Quinn      Diaz     Quinn Diaz
#> 225  SUBJ-0228      Riley     Patel    Riley Patel
#> 226  SUBJ-0229     Taylor    Foster  Taylor Foster
#> 227  SUBJ-0230     Skyler    Foster  Skyler Foster
#> 228  SUBJ-0231      Quinn     Ortiz    Quinn Ortiz
#> 229  SUBJ-0232     Skyler     Patel   Skyler Patel
#> 230  SUBJ-0233     Skyler    Jensen  Skyler Jensen
#> 231  SUBJ-0234    Cameron     Irwin  Cameron Irwin
#> 232  SUBJ-0235     Skyler     Moore   Skyler Moore
#> 233  SUBJ-0236      Riley      Diaz     Riley Diaz
#> 234  SUBJ-0237      Reese    Jensen   Reese Jensen
#> 235  SUBJ-0238     Taylor   Bennett Taylor Bennett
#> 236  SUBJ-0239      Jamie     Patel    Jamie Patel
#> 237  SUBJ-0240     Skyler     Singh   Skyler Singh
#> 
#> $deleted_data
#>     subject_id first_name last_name   full_name
#> 5    SUBJ-0005      Jamie     Singh Jamie Singh
#> 50   SUBJ-0050      Riley     Patel Riley Patel
#> 150  SUBJ-0150     Skyler       Kim  Skyler Kim
#> 
#> $changed_num_diffs
#> # A tibble: 3 × 2
#>   `Variable name` `Modified Values`
#>   <chr>                       <int>
#> 1 first_name                      0
#> 2 last_name                       0
#> 3 full_name                       0
#> 
#> $changed_var_diffs
#> # A tibble: 0 × 4
#> # ℹ 4 variables: Variable name <chr>, Current Value <chr>,
#> #   Previous Value <chr>, subject_id <chr>
#> 
```
