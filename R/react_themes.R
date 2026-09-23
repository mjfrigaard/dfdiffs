#' reactable theme (base data)
#'
#' @description theme for base data in reactable table
base_react_theme <- reactable::reactableTheme(
  color = "#FFFFFF",
  backgroundColor = "#4A4A4A", # graphite (brushed aluminum, in shadow)
  borderColor = "#646464",
  stripedColor = "#3A3B45",
  highlightColor = "#5E5E5E",
  inputStyle = list(backgroundColor = "#3A3B45"),
  selectStyle = list(backgroundColor = "#3A3B45"),
  pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
  pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
)
#' reactable theme (compare data)
#'
#' @description theme for compare data in reactable table
comp_react_theme <- reactable::reactableTheme(
  color = "#FFFFFF",
  backgroundColor = "#011627", # deep space navy (primary)
  borderColor = "#646464",
  stripedColor = "#3A3B45",
  highlightColor = "#344552", # lighter navy
  inputStyle = list(backgroundColor = "#3A3B45"),
  selectStyle = list(backgroundColor = "#3A3B45"),
  pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
  pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
)
#' reactable theme (new data)
#'
#' @description theme for new data in reactable table
new_react_theme <- reactable::reactableTheme(
  color = "#2EC4B6", # add / atomic teal
  backgroundColor = "#FFFFFF",
  borderColor = "#CBCBCB", # brushed aluminum
  stripedColor = "#3A3B45",
  highlightColor = "#eeeeee",
  inputStyle = list(backgroundColor = "#eeeeee"),
  selectStyle = list(backgroundColor = "#eeeeee"),
  pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
  pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
)
#' reactable theme (deleted data)
#'
#' @description theme for deleted data in reactable table
deleted_react_theme <- reactable::reactableTheme(
  color = "#FF6F3C", # delete / rocket orange
  backgroundColor = "#FFFFFF",
  borderColor = "#CBCBCB", # brushed aluminum
  stripedColor = "#3A3B45",
  highlightColor = "#eeeeee",
  inputStyle = list(backgroundColor = "#eeeeee"),
  selectStyle = list(backgroundColor = "#eeeeee"),
  pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
  pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
)
#' reactable theme (changed data)
#'
#' @description theme for changed data in reactable table
changed_react_theme <- reactable::reactableTheme(
  color = "#8A6D00", # change / golden yellow, darkened for legibility on white
  backgroundColor = "#FFFFFF",
  borderColor = "#CBCBCB", # brushed aluminum
  stripedColor = "#3A3B45",
  highlightColor = "#eeeeee",
  inputStyle = list(backgroundColor = "#eeeeee"),
  selectStyle = list(backgroundColor = "#eeeeee"),
  pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
  pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
)
