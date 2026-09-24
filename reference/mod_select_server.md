# mod_select_server

select server module

## Usage

``` r
mod_select_server(id, data_upload, dev = FALSE, dark_mode = reactive(FALSE))
```

## Arguments

- id:

  module id

- data_upload:

  list of reactives returned by
  [`mod_upload_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_upload_server.md)
  (`base_data`, `base_name`, `comp_data`, `comp_name`)

- dev:

  show developer reactive-value outputs (default FALSE)

- dark_mode:

  reactive returning TRUE when the app is in dark mode (default
  reactive(FALSE))

## Value

A list of reactives: `join_selected`, `base_join_col_data`,
`comp_join_col_data`
