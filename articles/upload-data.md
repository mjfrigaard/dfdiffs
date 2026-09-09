# upload-data

## Motivation

This vignette walks through the
[`upload_data()`](https://mjfrigaard.github.io/dfdiffs/reference/upload_data.md)
function, which is used for loading a variety of file types into the
`dfdiffs` shiny application.

``` r

library(dfdiffs)
library(shiny)
library(data.table)
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
library(labelled)
library(gt)
library(gtsummary)
```

### External Data

Test data can be found in the `../inst/extdata/` folder:

    #> ../inst/extdata/
    #> ├── csv
    #> │   ├── 2010-lahman
    #> │   │   ├── Batting.csv
    #> │   │   ├── Fielding.csv
    #> │   │   └── Master.csv
    #> │   ├── 2015-baseballdatabank
    #> │   │   ├── Batting.csv
    #> │   │   ├── Fielding.csv
    #> │   │   └── Master.csv
    #> │   ├── 2020-baseballdatabank
    #> │   │   ├── Batting.csv
    #> │   │   ├── Fielding.csv
    #> │   │   └── People.csv
    #> │   ├── ChangedData.csv
    #> │   ├── InitialData.csv
    #> │   ├── by-year
    #> │   │   ├── 20
    #> │   │   │   ├── PlayerBirth.csv
    #> │   │   │   ├── PlayerDebut.csv
    #> │   │   │   └── PlayerName.csv
    #> │   │   └── 21
    #> │   │       ├── PlayerBirth.csv
    #> │   │       ├── PlayerDebut.csv
    #> │   │       └── PlayerName.csv
    #> │   ├── diffs
    #> │   │   ├── diff_current.csv
    #> │   │   ├── diff_modified_all_raw.csv
    #> │   │   └── diff_previous.csv
    #> │   └── lahman-people
    #> │       ├── People2020.csv
    #> │       └── People2021.csv
    #> ├── dta
    #> │   ├── datetime-d.dta
    #> │   ├── iris.dta
    #> │   ├── notes.dta
    #> │   ├── tagged-na-double.dta
    #> │   ├── tagged-na-int.dta
    #> │   └── types.dta
    #> ├── rdata
    #> │   └── proc_app_data.rdata
    #> ├── sas7bdat
    #> │   ├── datetime.sas7bdat
    #> │   ├── formats.sas7bcat
    #> │   ├── hadley.sas7bdat
    #> │   ├── iris.sas7bdat
    #> │   ├── tagged-na.sas7bcat
    #> │   └── tagged-na.sas7bdat
    #> ├── sav
    #> │   ├── datetime.sav
    #> │   ├── iris.sav
    #> │   ├── labelled-num-na.sav
    #> │   ├── labelled-num.sav
    #> │   ├── labelled-str.sav
    #> │   ├── umlauts.sav
    #> │   └── variable-label.sav
    #> ├── tsv
    #> │   ├── Batting.tsv
    #> │   ├── Fielding.tsv
    #> │   └── People.tsv
    #> ├── txt
    #> │   ├── Batting.txt
    #> │   ├── Fielding.txt
    #> │   └── People.txt
    #> └── xlsx
    #>     ├── compare-report-text.xlsx
    #>     ├── lahman500.xlsx
    #>     └── snapshot_compare_270301_20221116_year3_preview_noDAP.xlsx

### load_flat_file()

The
[`load_flat_file()`](https://mjfrigaard.github.io/dfdiffs/reference/load_flat_file.md)
function imports all forms of flat data files.

``` r

load_flat_file <- function(path) {
  ext <- tools::file_ext(path)
  data <- switch(ext,
    txt = data.table::fread(path),
    csv = data.table::fread(path),
    tsv = data.table::fread(path),
    sas7bdat = haven::read_sas(data_file = path),
    sas7bcat = haven::read_sas(data_file = path),
    sav = haven::read_sav(file = path),
    dta = haven::read_dta(file = path)
  )
  return_data <- tibble::as_tibble(data)
  return(return_data)
}
```

If the file is an excel file, the name of the sheet should be passed to
`sheet`.

``` r

upload_data <- function(path, sheet = NULL) {
  ext <- tools::file_ext(path)
  if (ext == "xlsx") {
    raw_data <- readxl::read_excel(
        path = path,
        sheet = sheet
      )
    uploaded <- tibble::as_tibble(raw_data)
  } else {
    uploaded <- load_flat_file(path = path)
  }
  return(uploaded)
}
```

### 2010 Lahamn CSVs

``` r

lahman_2010_csv_paths <- list.files(path = "../inst/extdata/csv/2010-lahman", full.names = TRUE, pattern = ".csv$")
head(lahman_2010_csv_paths)
#> [1] "../inst/extdata/csv/2010-lahman/Batting.csv" 
#> [2] "../inst/extdata/csv/2010-lahman/Fielding.csv"
#> [3] "../inst/extdata/csv/2010-lahman/Master.csv"
```

Test this on `lahman_2010_csv_paths[3]`

``` r

master_2010 <- load_flat_file(path = lahman_2010_csv_paths[3])
glimpse(master_2010)
#> Rows: 17,674
#> Columns: 33
#> $ lahmanID     <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17…
#> $ playerID     <chr> "aaronha01", "aaronto01", "aasedo01", "abadan01", "abadij…
#> $ managerID    <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "", "…
#> $ hofID        <chr> "aaronha01h", "", "", "", "", "", "", "", "", "", "", "",…
#> $ birthYear    <int> 1934, 1939, 1954, 1972, 1854, 1877, 1869, 1866, 1862, 187…
#> $ birthMonth   <int> 2, 8, 9, 8, 11, 4, 11, 10, 3, 10, 2, 8, 9, 6, 2, 9, 9, 7,…
#> $ birthDay     <int> 5, 5, 8, 25, 4, 15, 29, 14, 16, 22, 16, 17, 19, 2, 18, 5,…
#> $ birthCountry <chr> "USA", "USA", "USA", "USA", "USA", "USA", "USA", "USA", "…
#> $ birthState   <chr> "AL", "AL", "CA", "FL", "PA", "PA", "VT", "NE", "OH", "OH…
#> $ birthCity    <chr> "Mobile", "Mobile", "Orange", "West Palm Beach", "Philade…
#> $ deathYear    <int> NA, 1984, NA, NA, 1905, 1957, 1962, 1926, 1930, 1935, NA,…
#> $ deathMonth   <int> NA, 8, NA, NA, 5, 1, 6, 4, 2, 6, NA, NA, NA, NA, NA, 4, N…
#> $ deathDay     <int> NA, 16, NA, NA, 17, 6, 11, 27, 13, 11, NA, NA, NA, NA, NA…
#> $ deathCountry <chr> "", "USA", "", "", "USA", "USA", "USA", "USA", "USA", "US…
#> $ deathState   <chr> "", "GA", "", "", "NJ", "FL", "VT", "CA", "MI", "CA", "",…
#> $ deathCity    <chr> "", "Atlanta", "", "", "Pemberton", "Ft.Lauderdale", "Ess…
#> $ nameFirst    <chr> "Hank", "Tommie", "Don", "Andy", "John", "Ed", "Bert", "C…
#> $ nameLast     <chr> "Aaron", "Aaron", "Aase", "Abad", "Abadie", "Abbaticchio"…
#> $ nameNote     <chr> "", "", "", "", "", "", "", "", "", "born Harry Frederick…
#> $ nameGiven    <chr> "Henry Louis", "Tommie Lee", "Donald William", "", "John"…
#> $ nameNick     <chr> "Hammer,Hammerin' Hank,Bad Henry", "", "", "", "", "Batty…
#> $ weight       <int> 180, 190, 190, 184, 192, 170, 175, 169, 190, 180, 200, 19…
#> $ height       <dbl> 72, 75, 75, 73, 72, 71, 71, 68, 71, 70, 78, 74, 75, 71, 7…
#> $ bats         <chr> "R", "R", "R", "L", "R", "R", "R", "L", "R", "R", "R", "R…
#> $ throws       <chr> "R", "R", "R", "L", "R", "R", "R", "", "R", "R", "R", "L"…
#> $ debut        <chr> "4/13/1954 0:00:00", "4/10/1962 0:00:00", "7/26/1977 0:00…
#> $ finalGame    <chr> "10/3/1976 0:00:00", "9/26/1971 0:00:00", "10/3/1990 0:00…
#> $ college      <chr> "", "", "Cal St. Fullerton", "Middle Georgia JC", "", "",…
#> $ lahman40ID   <chr> "aaronha01", "aaronto01", "aasedo01", "abadan01", "abadij…
#> $ lahman45ID   <chr> "aaronha01", "aaronto01", "aasedo01", "abadan01", "abadij…
#> $ retroID      <chr> "aaroh101", "aarot101", "aased001", "abada001", "abadj101…
#> $ holtzID      <chr> "aaronha01", "aaronto01", "aasedo01", "abadan01", "abadij…
#> $ bbrefID      <chr> "aaronha01", "aaronto01", "aasedo01", "abadan01", "abadij…
```

### 2015 Lahamn CSVs

``` r

lahman_2015_csv_paths <- list.files(path = "../inst/extdata/csv/2015-baseballdatabank", full.names = TRUE, pattern = ".csv$")
head(lahman_2015_csv_paths)
#> [1] "../inst/extdata/csv/2015-baseballdatabank/Batting.csv" 
#> [2] "../inst/extdata/csv/2015-baseballdatabank/Fielding.csv"
#> [3] "../inst/extdata/csv/2015-baseballdatabank/Master.csv"
```

Test this on `lahman_2015_csv_paths[3]`

``` r

master_csv_2015 <- load_flat_file(path = lahman_2015_csv_paths[3])
glimpse(master_csv_2015)
#> Rows: 18,846
#> Columns: 24
#> $ playerID     <chr> "aardsda01", "aaronha01", "aaronto01", "aasedo01", "abada…
#> $ birthYear    <int> 1981, 1934, 1939, 1954, 1972, 1985, 1854, 1877, 1869, 186…
#> $ birthMonth   <int> 12, 2, 8, 9, 8, 12, 11, 4, 11, 10, 3, 10, 2, 8, 9, 6, 2, …
#> $ birthDay     <int> 27, 5, 5, 8, 25, 17, 4, 15, 11, 14, 16, 22, 16, 17, 19, 2…
#> $ birthCountry <chr> "USA", "USA", "USA", "USA", "USA", "D.R.", "USA", "USA", …
#> $ birthState   <chr> "CO", "AL", "AL", "CA", "FL", "La Romana", "PA", "PA", "V…
#> $ birthCity    <chr> "Denver", "Mobile", "Mobile", "Orange", "Palm Beach", "La…
#> $ deathYear    <int> NA, NA, 1984, NA, NA, NA, 1905, 1957, 1962, 1926, 1930, 1…
#> $ deathMonth   <int> NA, NA, 8, NA, NA, NA, 5, 1, 6, 4, 2, 6, NA, NA, NA, NA, …
#> $ deathDay     <int> NA, NA, 16, NA, NA, NA, 17, 6, 11, 27, 13, 11, NA, NA, NA…
#> $ deathCountry <chr> "", "", "USA", "", "", "", "USA", "USA", "USA", "USA", "U…
#> $ deathState   <chr> "", "", "GA", "", "", "", "NJ", "FL", "VT", "CA", "MI", "…
#> $ deathCity    <chr> "", "", "Atlanta", "", "", "", "Pemberton", "Fort Lauderd…
#> $ nameFirst    <chr> "David", "Hank", "Tommie", "Don", "Andy", "Fernando", "Jo…
#> $ nameLast     <chr> "Aardsma", "Aaron", "Aaron", "Aase", "Abad", "Abad", "Aba…
#> $ nameGiven    <chr> "David Allan", "Henry Louis", "Tommie Lee", "Donald Willi…
#> $ weight       <int> 220, 180, 190, 190, 184, 220, 192, 170, 175, 169, 190, 18…
#> $ height       <int> 75, 72, 75, 75, 73, 73, 72, 71, 71, 68, 71, 70, 78, 74, 7…
#> $ bats         <chr> "R", "R", "R", "R", "L", "L", "R", "R", "R", "L", "R", "R…
#> $ throws       <chr> "R", "R", "R", "R", "L", "L", "R", "R", "R", "L", "R", "R…
#> $ debut        <IDate> 2004-04-06, 1954-04-13, 1962-04-10, 1977-07-26, 2001-09…
#> $ finalGame    <IDate> 2015-08-23, 1976-10-03, 1971-09-26, 1990-10-03, 2006-04…
#> $ retroID      <chr> "aardd001", "aaroh101", "aarot101", "aased001", "abada001…
#> $ bbrefID      <chr> "aardsda01", "aaronha01", "aaronto01", "aasedo01", "abada…
```

### List of 2010 csvs

Now we create `lahman_2010_csv_files`

``` r

lahman_2010_csv_files <- map(.x = lahman_2010_csv_paths, 
  .f = load_flat_file) %>% 
  set_names(x = ., nm = basename(lahman_2010_csv_paths))
map(lahman_2010_csv_files, names)
#> $Batting.csv
#>  [1] "playerID"  "yearID"    "stint"     "teamID"    "lgID"      "G"        
#>  [7] "G_batting" "AB"        "R"         "H"         "2B"        "3B"       
#> [13] "HR"        "RBI"       "SB"        "CS"        "BB"        "SO"       
#> [19] "IBB"       "HBP"       "SH"        "SF"        "GIDP"      "G_old"    
#> 
#> $Fielding.csv
#>  [1] "playerID" "yearID"   "stint"    "teamID"   "lgID"     "POS"     
#>  [7] "G"        "GS"       "InnOuts"  "PO"       "A"        "E"       
#> [13] "DP"       "PB"       "WP"       "SB"       "CS"       "ZR"      
#> 
#> $Master.csv
#>  [1] "lahmanID"     "playerID"     "managerID"    "hofID"        "birthYear"   
#>  [6] "birthMonth"   "birthDay"     "birthCountry" "birthState"   "birthCity"   
#> [11] "deathYear"    "deathMonth"   "deathDay"     "deathCountry" "deathState"  
#> [16] "deathCity"    "nameFirst"    "nameLast"     "nameNote"     "nameGiven"   
#> [21] "nameNick"     "weight"       "height"       "bats"         "throws"      
#> [26] "debut"        "finalGame"    "college"      "lahman40ID"   "lahman45ID"  
#> [31] "retroID"      "holtzID"      "bbrefID"
```

We’ll test this on the
[`map_df()`](https://purrr.tidyverse.org/reference/map_dfr.html)
function.

``` r

tbl_2010_csv_files <- lahman_2010_csv_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_2010_csv_files %>% count(source)
#> # A tibble: 3 × 2
#>   source            n
#>   <chr>         <int>
#> 1 Batting.csv   93955
#> 2 Fielding.csv 160710
#> 3 Master.csv    17674
```

### Test on dta

``` r

dta_paths <- list.files(path = "../inst/extdata/dta", 
  full.names = TRUE, pattern = ".dta$")
tbl_dta_files <- dta_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
#> Registered S3 methods overwritten by 'readr':
#>   method                    from 
#>   as.data.frame.spec_tbl_df vroom
#>   as_tibble.spec_tbl_df     vroom
#>   format.col_spec           vroom
#>   print.col_spec            vroom
#>   print.collector           vroom
#>   print.date_names          vroom
#>   print.locale              vroom
#>   str.col_spec              vroom
tbl_dta_files %>% count(source)
#> # A tibble: 6 × 2
#>   source                   n
#>   <chr>                <int>
#> 1 datetime-d.dta           1
#> 2 iris.dta               150
#> 3 notes.dta                5
#> 4 tagged-na-double.dta     8
#> 5 tagged-na-int.dta        8
#> 6 types.dta                2
```

### Test on sas7bdat

``` r

sas7bdat_paths <- list.files(path = "../inst/extdata/sas7bdat", 
  full.names = TRUE, pattern = ".sas7bdat$")
tbl_sas7bdat_files <- sas7bdat_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_sas7bdat_files %>% count(source)
#> # A tibble: 4 × 2
#>   source                 n
#>   <chr>              <int>
#> 1 datetime.sas7bdat      4
#> 2 hadley.sas7bdat        8
#> 3 iris.sas7bdat        150
#> 4 tagged-na.sas7bdat     8
```

### Test on sav

``` r

sav_paths <- list.files(path = "../inst/extdata/sav", 
  full.names = TRUE, pattern = ".sav$")
tbl_sav_files <- sav_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_sav_files %>% count(source)
#> # A tibble: 7 × 2
#>   source                  n
#>   <chr>               <int>
#> 1 datetime.sav            2
#> 2 iris.sav              150
#> 3 labelled-num-na.sav     2
#> 4 labelled-num.sav        1
#> 5 labelled-str.sav        2
#> 6 umlauts.sav             4
#> 7 variable-label.sav      1
```

### Test on tsv

``` r

tsv_paths <- list.files(path = "../inst/extdata/tsv", 
  full.names = TRUE, pattern = ".tsv$")
tbl_tsv_files <- tsv_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_tsv_files %>% count(source)
#> # A tibble: 3 × 2
#>   source            n
#>   <chr>         <int>
#> 1 Batting.tsv  108789
#> 2 Fielding.tsv 144768
#> 3 People.tsv    20093
```

### Test on txt

``` r

txt_paths <- list.files(path = "../inst/extdata/txt", 
  full.names = TRUE, pattern = ".txt$")
tbl_txt_files <- txt_paths %>% 
  set_names() %>% 
  map_df(.x = ., 
  .f = load_flat_file, .id = "source") %>% 
  mutate(source = basename(source))
tbl_txt_files %>% count(source)
#> # A tibble: 3 × 2
#>   source            n
#>   <chr>         <int>
#> 1 Batting.txt  108789
#> 2 Fielding.txt 144768
#> 3 People.txt    20093
```
