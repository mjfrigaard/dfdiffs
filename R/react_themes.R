#' reactable theme (base data)
#'
#' @description theme for base data in reactable table
base_react_theme <- reactable::reactableTheme(
  color = "#FFFFFF",
  backgroundColor = "#374151", # slate (secondary)
  borderColor = "#646464",
  stripedColor = "#3A3B45",
  highlightColor = "#4B5563",
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
  backgroundColor = "#4A2E83", # violet (primary)
  borderColor = "#646464",
  stripedColor = "#3A3B45",
  highlightColor = "#5E3DA1",
  inputStyle = list(backgroundColor = "#3A3B45"),
  selectStyle = list(backgroundColor = "#3A3B45"),
  pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
  pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
)
#' reactable theme (new data)
#'
#' @description theme for new data in reactable table
new_react_theme <- reactable::reactableTheme(
  color = "#1E7F4F", # add / diff green
  backgroundColor = "#FFFFFF",
  borderColor = "#A0A0A0",
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
  color = "#B3261E", # delete / diff red
  backgroundColor = "#FFFFFF",
  borderColor = "#A0A0A0",
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
  color = "#B4740E", # change / diff amber
  backgroundColor = "#FFFFFF",
  borderColor = "#646464",
  stripedColor = "#3A3B45",
  highlightColor = "#eeeeee",
  inputStyle = list(backgroundColor = "#eeeeee"),
  selectStyle = list(backgroundColor = "#eeeeee"),
  pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
  pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
)
