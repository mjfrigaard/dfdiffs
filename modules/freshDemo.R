library(fresh)
library(shiny)
library(bs4Dash)

# Retrieve all variables
# all_vars <- search_vars_bs4dash()
# head(all_vars, 20)
# Search for a pattern
# head(search_vars_bs4dash("navbar"))

bmrn_theme <- function() {
  fresh::create_theme(
    # theme vars  -------------------------------------------------------------
    fresh::bs4dash_vars(
      navbar_light_color = "#353d98", # purple
      navbar_light_active_color = "#F26631", # purple
      navbar_light_hover_color = "#f26631" # orange
    ),
    # theme yiq -------------------------------------------------------------
    fresh::bs4dash_yiq(
      contrasted_threshold = 255,
      text_dark = "#0a0a0a", # dark_gray_s10
      text_light = "#f5f5f5" # gray_t10
    ),
    # theme layout ---------------------------------------------------------
    fresh::bs4dash_layout(
      main_bg = NULL,
      font_size_root = 12
    ),
    # theme sidebar light -------------------------------------------------
    fresh::bs4dash_sidebar_light(
      header_color = "#ccd5dd", # dark_blue_t9
      bg = "#d6d8ea", # background of entire side-bar
      color = "#002E56", # text color (no hover)
      hover_color = "#ee304e", # text color on hover
      hover_bg = "#353D98", # color on hover
      active_color = "#f26631", # color is actually the 'primary' status color
      submenu_bg = "#f5f5f5", # purple
      submenu_color = "#002444",
      submenu_hover_color = "#353D98" # purple
    ),
    # theme sidebar dark -------------------------------------------------
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
      dark = "#646464",
      light = "#A0A0A0",
      warning = "#F26631", # orange
      primary = "#00509C", # blue
      secondary = "#353D98", # purple
      success = "#A9218E", # violet
      danger = "#EE304E", # red
      info = "#A0A0A0" #orange
    ),
  fresh::bs4dash_color(
    yellow = "#F26631",
    gray_900 = "#15183C",
    green = "#A9218E",
    navy = "#002E56",
    cyan = "#A0A0A0",
    blue = "#00509C",
    red = "#EE304E",
    gray_800 = "#646464",
    white = "#272c30",
   )
  )
}

theme <- bmrn_theme()

# create tibble for box global config
box_config <- tibble::tribble(
  ~background, ~labelStatus,
  "warning", "warning",
  "success", "success",
  "secondary", "secondary",
  "primary", "primary",
  "danger", "danger",
  "info", "info",
  "gray-dark", "dark"
)

# box factory function
box_factory <- function(background, labelStatus) {
  box(
    title = paste0("BioMarin Box (", labelStatus, ")"),
    collapsible = TRUE,
    background = background,
    height = "200px",
    label = boxLabel(1, labelStatus)
  )
}

# pmap magic
boxes <- purrr::pmap(box_config, box_factory)

shinyApp(
  ui = bs4Dash::dashboardPage(
    skin = "light",
    freshTheme = theme,
    header = dashboardHeader(
      status = "secondary"
      # leftUi = dropdownMenu(
      #   type = "messages",
      #   badgeStatus = "success",
      #   messageItem(
      #     from = "Support Team",
      #     message = "This is the content of a message.",
      #     time = "5 mins"
      #   ),
      #   messageItem(
      #     from = "Support Team",
      #     message = "This is the content of another message.",
      #     time = "2 hours"
      #   )
      # )
    ),
    sidebar = dashboardSidebar(skin = "light"),
    body = dashboardBody(boxes),
    controlbar = dashboardControlbar(),
    title = "Fresh theming"
  ),
  server = function(input, output) { }
)
