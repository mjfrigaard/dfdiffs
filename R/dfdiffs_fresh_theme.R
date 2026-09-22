#' custom theme (bslib)
#'
#' @importFrom bslib bs_theme font_google
#'
#' @return a \code{bslib::bs_theme()} object
#' @export dfdiffs_fresh_theme
#'
#' @description A diff-tool inspired bslib theme: ink/paper neutrals, a
#'   violet brand accent, and semantically correct add/delete/change colors
#'   (green/red/amber) for the New, Deleted, and Changed Data sections.
dfdiffs_fresh_theme <- function() {
  bslib::bs_theme(
    version = 5,
    preset = "shiny",
    bg = "#FAFAF9", # paper
    fg = "#12151A", # ink
    primary = "#4A2E83", # violet (brand)
    secondary = "#6B7280", # slate (base vs. compare neutral)
    success = "#1E7F4F", # add / new data (diff green)
    danger = "#B3261E", # delete / deleted data (diff red)
    warning = "#B4740E", # change / changed data (diff amber)
    info = "#2454A6", # informational blue
    base_font = bslib::font_google("Inter"),
    heading_font = bslib::font_google("Space Grotesk"),
    code_font = bslib::font_google("IBM Plex Mono")
  )
}

