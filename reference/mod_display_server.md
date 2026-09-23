# mod_display_server

Server module that previews the uploaded base and compare data

## Usage

``` r
mod_display_server(id, data_upload)
```

## Arguments

- id:

  module id

- data_upload:

  the reactive list returned by
  [`mod_upload_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_upload_server.md)
  (`base_data`, `base_name`, `comp_data`, `comp_name`)

## Value

no return value; renders the base/compare preview outputs
