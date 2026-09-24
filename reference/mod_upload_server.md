# mod_upload_server()

Server module for upload

## Usage

``` r
mod_upload_server(id, dev = FALSE, dark_mode = reactive(FALSE))
```

## Arguments

- id:

  module id

- dev:

  show developer reactive-value outputs (default FALSE)

- dark_mode:

  reactive returning TRUE when the app is in dark mode (default
  reactive(FALSE))

## Value

A list of reactives: `base_data`, `base_name`, `comp_data`, `comp_name`
