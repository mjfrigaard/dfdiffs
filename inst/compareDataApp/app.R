withr::with_options(
  new = list(shiny.autoload.r = FALSE),
  code = {
    if (!interactive()) {
      sink(stderr(), type = "output")
      tryCatch(
        expr  = { library(dfdiffs) },
        error = function(e) { pkgload::load_all() }
      )
    } else {
      pkgload::load_all()
    }
    dfdiffs::launch_app()
  }
)
