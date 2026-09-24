# mod_compare_server

compare server module

## Usage

``` r
mod_compare_server(id, data_selected, dev = FALSE, dark_mode = reactive(FALSE))
```

## Arguments

- id:

  module id

- data_selected:

  list of reactives returned by
  [`mod_select_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_select_server.md)
  (`join_selected`, `base_join_col_data`, `comp_join_col_data`)

- dev:

  show developer reactive-value outputs (default FALSE)

- dark_mode:

  reactive returning TRUE when the app is in dark mode (default
  reactive(FALSE))

## Value

NULL invisibly; called for the side effect of rendering the module's
outputs and the report
[`downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)
