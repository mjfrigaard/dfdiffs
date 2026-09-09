# NA

## create_empty_tbl()

Re-write the following function using only base R:

``` r

create_empty_tbl <- function(tbl) {
  nms <- names(tbl)
  empty_tbl <- tibble::tibble(!!!nms, .rows = 1)
  nmd_tbl <- purrr::set_names(empty_tbl, nms)
  log_tbl <- dplyr::mutate(.data = nmd_tbl,
    dplyr::across(.cols = tidyselect::everything(), .fns = as.logical))
  return(log_tbl)
}
```

``` r

create_empty_tbl <- function(tbl) {
  nms <- names(tbl)
  empty_tbl <- as.data.frame(matrix(ncol = length(nms), nrow = 1))
  names(empty_tbl) <- nms
  log_tbl <- lapply(empty_tbl, function(x) as.logical(x))
  log_tbl <- as.data.frame(log_tbl)
  return(log_tbl)
}
```

## create_join_column()

Re-write the following function using only base R:

``` r

create_join_column <- function(df, by_colums, new_by_column_name) {
    # select by_vars
    tmp <- dplyr::select(df, all_of(by_colums))
    # convert to character
    tmp <- dplyr::mutate(tmp, across(.fns = as.character))
    # rename data
    join_col_data <- df
    # assign new col
    join_col_data$new_col <- purrr::pmap_chr(.l = tmp, .f = paste, sep = "-")
    # rename
    names(join_col_data)[names(join_col_data) == "new_col"] <- new_by_column_name
    # relocate
    join_col_data <- dplyr::relocate(join_col_data,
      all_of(new_by_column_name))
    # return
    return(join_col_data)
}
```

``` r

create_join_column <- function(df, by_columns, new_by_column_name) {
    tmp <- df[, by_columns, drop = FALSE]
    tmp <- data.frame(lapply(tmp, as.character), stringsAsFactors = FALSE)
    df$new_col <- apply(tmp, 1, paste, collapse = "-")
    names(df)[names(df) == "new_col"] <- new_by_column_name
    df <- df[c(new_by_column_name, setdiff(names(df), new_by_column_name))]
    return(df)
}
```

## make_join_column()

Re-write the following function using only base R:

``` r

make_join_column <- function(data, cols, new_name, sep) {
    new_col_data <- data |> 
      tidyr::unite({{new_name}}, {{cols}}, remove = FALSE, sep = sep) |> 
      dplyr::relocate({{new_name}}, dplyr::everything())
    return(new_col_data)
}
```

``` r

make_join_column <- function(data, cols, new_name, sep) {
    # Create the new column by concatenating the specified columns with the separator
    new_col <- apply(data[cols], 1, function(x) paste(x, collapse = sep))

    # Add the new column to the dataframe
    data[[new_name]] <- new_col

    # Reorder columns to move the new column to the front
    data <- data[c(new_name, setdiff(names(data), new_name))]

    return(data)
}
```

Write a Gherkin scenario for the following function:

``` r

pickler_logo <- function() {
  cat("
             d8b          888      888
             Y8P          888      888
                          888      888
    88888b.  888  .d8888b 888  888 888  .d88b.  888d888
    888 '88b 888 d88P'    888 .88P 888 d8P  Y8b 888P'
    888  888 888 888      888888K  888 88888888 888
    888 d88P 888 Y88b.    888 '88b 888 Y8b.     888
    88888P'  888  'Y8888P 888  888 888  'Y8888  888
    888
    888
    888
    ")
}
```
