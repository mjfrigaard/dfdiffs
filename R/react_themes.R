#' reactable theme (base data)
#'
#' @param dark use dark-mode colors (default FALSE)
#'
#' @description theme for base data in reactable table
base_react_theme <- function(dark = FALSE) {
  if (isTRUE(dark)) {
    reactable::reactableTheme(
      color = "#FFFFFF",
      backgroundColor = "#1E1F24",
      borderColor = "#3A3B45",
      stripedColor = "#26272E",
      highlightColor = "#33343D",
      inputStyle = list(backgroundColor = "#26272E"),
      selectStyle = list(backgroundColor = "#26272E"),
      pageButtonHoverStyle = list(backgroundColor = "#26272E"),
      pageButtonActiveStyle = list(backgroundColor = "#33343D")
    )
  } else {
    reactable::reactableTheme(
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
  }
}
#' reactable theme (compare data)
#'
#' @param dark use dark-mode colors (default FALSE)
#'
#' @description theme for compare data in reactable table
comp_react_theme <- function(dark = FALSE) {
  if (isTRUE(dark)) {
    reactable::reactableTheme(
      color = "#FFFFFF",
      backgroundColor = "#010B15", # deep space navy, darkened further
      borderColor = "#3A3B45",
      stripedColor = "#1B2733",
      highlightColor = "#22303D",
      inputStyle = list(backgroundColor = "#1B2733"),
      selectStyle = list(backgroundColor = "#1B2733"),
      pageButtonHoverStyle = list(backgroundColor = "#1B2733"),
      pageButtonActiveStyle = list(backgroundColor = "#22303D")
    )
  } else {
    reactable::reactableTheme(
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
  }
}
#' reactable theme (new data)
#'
#' @param dark use dark-mode colors (default FALSE)
#'
#' @description theme for new data in reactable table
new_react_theme <- function(dark = FALSE) {
  if (isTRUE(dark)) {
    reactable::reactableTheme(
      color = "#2EC4B6", # add / atomic teal
      backgroundColor = "#1E1F24",
      borderColor = "#3A3B45",
      stripedColor = "#26272E",
      highlightColor = "#33343D",
      inputStyle = list(backgroundColor = "#26272E"),
      selectStyle = list(backgroundColor = "#26272E"),
      pageButtonHoverStyle = list(backgroundColor = "#26272E"),
      pageButtonActiveStyle = list(backgroundColor = "#33343D")
    )
  } else {
    reactable::reactableTheme(
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
  }
}
#' reactable theme (deleted data)
#'
#' @param dark use dark-mode colors (default FALSE)
#'
#' @description theme for deleted data in reactable table
deleted_react_theme <- function(dark = FALSE) {
  if (isTRUE(dark)) {
    reactable::reactableTheme(
      color = "#FF6F3C", # delete / rocket orange
      backgroundColor = "#1E1F24",
      borderColor = "#3A3B45",
      stripedColor = "#26272E",
      highlightColor = "#33343D",
      inputStyle = list(backgroundColor = "#26272E"),
      selectStyle = list(backgroundColor = "#26272E"),
      pageButtonHoverStyle = list(backgroundColor = "#26272E"),
      pageButtonActiveStyle = list(backgroundColor = "#33343D")
    )
  } else {
    reactable::reactableTheme(
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
  }
}
#' reactable theme (changed data)
#'
#' @param dark use dark-mode colors (default FALSE)
#'
#' @description theme for changed data in reactable table
changed_react_theme <- function(dark = FALSE) {
  if (isTRUE(dark)) {
    reactable::reactableTheme(
      color = "#E8BE3B", # change / golden yellow, brightened for legibility on dark
      backgroundColor = "#1E1F24",
      borderColor = "#3A3B45",
      stripedColor = "#26272E",
      highlightColor = "#33343D",
      inputStyle = list(backgroundColor = "#26272E"),
      selectStyle = list(backgroundColor = "#26272E"),
      pageButtonHoverStyle = list(backgroundColor = "#26272E"),
      pageButtonActiveStyle = list(backgroundColor = "#33343D")
    )
  } else {
    reactable::reactableTheme(
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
  }
}
#' reactable theme (neutral info tables)
#'
#' @param dark use dark-mode colors (default FALSE)
#'
#' @description theme for small neutral info/reference tables (e.g.
#'   intersecting columns, compare columns) shown in `mod_select`/`mod_compare`
info_react_theme <- function(dark = FALSE) {
  if (isTRUE(dark)) {
    reactable::reactableTheme(
      color = "#FFFFFF",
      backgroundColor = "#1E1F24",
      borderColor = "#3A3B45",
      stripedColor = "#26272E",
      highlightColor = "#33343D",
      cellPadding = "8px 12px"
    )
  } else {
    reactable::reactableTheme(
      color = "#011627",
      borderColor = "#e5eaee",
      stripedColor = "#f6f8fa",
      highlightColor = "#f0f5f9",
      cellPadding = "8px 12px"
    )
  }
}
