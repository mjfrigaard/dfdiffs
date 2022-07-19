#' BioMarin theme (fresh <> bs4Dash)
#'
#' @return theme shiny app
#' @export bmrn_fresh_theme
#'
#' @description this is the fresh theme with BioMarin colors.
bmrn_fresh_theme <- function() {
  fresh::create_theme(
    # theme vars  -------------------------------------------------------------
    fresh::bs4dash_vars(
      navbar_light_color = "#353d98", # purple
      navbar_light_active_color = "#353d98", # purple
      navbar_light_hover_color = "#f26631" # orange
    ),
    # # theme yiq -------------------------------------------------------------
    fresh::bs4dash_yiq(
      contrasted_threshold = 255,
      text_dark = "#0a0a0a", # dark_gray_s10
      text_light = "#f5f5f5" # gray_t10
    ),
    # theme layout ---------------------------------------------------------
    fresh::bs4dash_layout(
      main_bg = NULL, # #ececec
      font_size_root = 12
    ),
    # theme sidebar_light -------------------------------------------------
    fresh::bs4dash_sidebar_light(
      header_color = "#ccd5dd", # light blue
      bg = "#eaebf4", # background of entire side-bar
      color = "#002E56", # text color (no hover)
      hover_color = "#ee304e", # text color on hover
      hover_bg = "#353D98", # color on hover
      active_color = "#f26631", # color is actually the 'primary' status color
      submenu_bg = "#f5f5f5", # purple
      submenu_color = "#002444",
      submenu_hover_color = "#353D98" # purple
    ),
    # # theme sidebar_dark -------------------------------------------------
    fresh::bs4dash_sidebar_dark(
      header_color = "#ccd5dd",
      bg = "#1a1e4c",
      color = "#EE304E", # text color (no hover)
      hover_bg = "#aeb1d5", # color on hover
      hover_color = "#EE304E", # text color on hover
      active_color = "#f26631" # color is actually the 'primary' status color
    ),
    # theme status -------------------------------------------------
    fresh::bs4dash_status(
      dark = "#323232",
      light = "#A0A0A0", # gray
      warning = "#F26631", # orange
      primary = "#A9218E", # violet = #A9218E, blue = #00509C
      secondary = "#353D98", # purple
      success = "#00509C", # blue
      danger = "#EE304E", # red
      info = "#A0A0A0" # gray
    ),
    # theme color -------------------------------------------------
    fresh::bs4dash_color(
      gray_900 = "#1f245b",
      gray_800 = "#646464",
      lightblue = "#6696c3",
      blue = "#00509C"
    )
  )
}
