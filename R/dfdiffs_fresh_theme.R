#' custom theme (bslib)
#'
#' @importFrom bslib bs_theme font_google
#'
#' @return a \code{bslib::bs_theme()} object
#' @export dfdiffs_fresh_theme
#'
#' @description Atomic Age Space Race bslib theme: deep-space-navy/brushed-
#'   aluminum neutrals, and rocket-orange/atomic-teal/golden-yellow accents
#'   for the Deleted, New, and Changed Data sections.
dfdiffs_fresh_theme <- function() {
  bslib::bs_theme(
    version = 5,
    preset = "shiny",
    bg = "#FAFAF9", # paper
    fg = "#011627", # deep space navy
    primary = "#011627", # deep space navy (brand)
    secondary = "#CBCBCB", # brushed aluminum
    success = "#2EC4B6", # atomic teal - add / new data
    danger = "#FF6F3C", # rocket orange - delete / deleted data
    warning = "#FFD23F", # golden yellow - change / changed data
    info = "#2EC4B6", # atomic teal
    base_font = bslib::font_google("Inter"),
    heading_font = bslib::font_google("Space Grotesk"),
    code_font = bslib::font_google("IBM Plex Mono")
  )
}

