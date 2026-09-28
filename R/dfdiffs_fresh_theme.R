#' custom theme (bslib)
#'
#' @importFrom bslib bs_theme font_google
#'
#' @return a \code{bslib::bs_theme()} object
#' @export dfdiffs_fresh_theme
#'
#' @description Golden Age Pulp Cover bslib theme (light): pulp-cream page,
#'   midnight-ink text, and cover-navy/rocket-red/pulp-amber accents for the
#'   New, Deleted, and Changed Data sections. Matches the pkgdown site.
dfdiffs_fresh_theme <- function() {
  bslib::bs_theme(
    version = 5,
    preset = "shiny",
    bg = "#EAE2B7", # pulp cream
    fg = "#14213D", # midnight ink
    primary = "#1D3461", # cover navy (brand)
    secondary = "#14213D", # midnight ink
    success = "#1D3461", # cover navy - add / new data
    danger = "#D62828", # rocket red - delete / deleted data
    warning = "#F4A300", # pulp amber - change / changed data
    info = "#1D3461", # cover navy
    base_font = bslib::font_google("Inter"),
    heading_font = bslib::font_google("Space Grotesk"),
    code_font = bslib::font_google("IBM Plex Mono")
  )
}

