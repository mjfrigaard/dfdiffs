#' reactable theme (base data)
#'
#' @param dark use dark-mode colors (default FALSE)
#'
#' @description theme for base data in reactable table
base_react_theme <- function(dark = FALSE) {
  if (isTRUE(dark)) {
    reactable::reactableTheme(
      color = "#FFFFFF",
      backgroundColor = "#14213D", # midnight ink
      borderColor = "#2C3E66",
      stripedColor = "#1A2A4D",
      highlightColor = "#24365E",
      inputStyle = list(backgroundColor = "#1A2A4D"),
      selectStyle = list(backgroundColor = "#1A2A4D"),
      pageButtonHoverStyle = list(backgroundColor = "#1A2A4D"),
      pageButtonActiveStyle = list(backgroundColor = "#24365E")
    )
  } else {
    reactable::reactableTheme(
      color = "#EAE2B7", # pulp cream
      backgroundColor = "#1D3461", # cover navy
      borderColor = "#14213D",
      stripedColor = "#24406F",
      highlightColor = "#35548C",
      inputStyle = list(backgroundColor = "#14213D"),
      selectStyle = list(backgroundColor = "#14213D"),
      pageButtonHoverStyle = list(backgroundColor = "#14213D"),
      pageButtonActiveStyle = list(backgroundColor = "#35548C")
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
      backgroundColor = "#0E172B", # midnight ink, darkened further
      borderColor = "#2C3E66",
      stripedColor = "#14213D",
      highlightColor = "#1D3461",
      inputStyle = list(backgroundColor = "#14213D"),
      selectStyle = list(backgroundColor = "#14213D"),
      pageButtonHoverStyle = list(backgroundColor = "#14213D"),
      pageButtonActiveStyle = list(backgroundColor = "#1D3461")
    )
  } else {
    reactable::reactableTheme(
      color = "#EAE2B7", # pulp cream
      backgroundColor = "#14213D", # midnight ink
      borderColor = "#1D3461",
      stripedColor = "#1D3461",
      highlightColor = "#2A4578",
      inputStyle = list(backgroundColor = "#1D3461"),
      selectStyle = list(backgroundColor = "#1D3461"),
      pageButtonHoverStyle = list(backgroundColor = "#1D3461"),
      pageButtonActiveStyle = list(backgroundColor = "#2A4578")
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
      color = "#9DB8EA", # cover navy, lightened for legibility on dark
      backgroundColor = "#14213D", # midnight ink
      borderColor = "#2C3E66",
      stripedColor = "#1A2A4D",
      highlightColor = "#24365E",
      inputStyle = list(backgroundColor = "#1A2A4D"),
      selectStyle = list(backgroundColor = "#1A2A4D"),
      pageButtonHoverStyle = list(backgroundColor = "#1A2A4D"),
      pageButtonActiveStyle = list(backgroundColor = "#24365E")
    )
  } else {
    reactable::reactableTheme(
      color = "#1D3461", # add / cover navy
      backgroundColor = "#F5F0D6", # pale pulp cream
      borderColor = "#C9BE8A", # aged cream
      stripedColor = "#EFE8C6",
      highlightColor = "#E3D9A2",
      inputStyle = list(backgroundColor = "#E3D9A2"),
      selectStyle = list(backgroundColor = "#E3D9A2"),
      pageButtonHoverStyle = list(backgroundColor = "#E3D9A2"),
      pageButtonActiveStyle = list(backgroundColor = "#E3D9A2")
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
      color = "#F0574F", # rocket red, lightened for legibility on dark
      backgroundColor = "#14213D", # midnight ink
      borderColor = "#2C3E66",
      stripedColor = "#1A2A4D",
      highlightColor = "#24365E",
      inputStyle = list(backgroundColor = "#1A2A4D"),
      selectStyle = list(backgroundColor = "#1A2A4D"),
      pageButtonHoverStyle = list(backgroundColor = "#1A2A4D"),
      pageButtonActiveStyle = list(backgroundColor = "#24365E")
    )
  } else {
    reactable::reactableTheme(
      color = "#D62828", # delete / rocket red
      backgroundColor = "#F5F0D6", # pale pulp cream
      borderColor = "#C9BE8A", # aged cream
      stripedColor = "#EFE8C6",
      highlightColor = "#E3D9A2",
      inputStyle = list(backgroundColor = "#E3D9A2"),
      selectStyle = list(backgroundColor = "#E3D9A2"),
      pageButtonHoverStyle = list(backgroundColor = "#E3D9A2"),
      pageButtonActiveStyle = list(backgroundColor = "#E3D9A2")
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
      color = "#F4A300", # change / pulp amber
      backgroundColor = "#14213D", # midnight ink
      borderColor = "#2C3E66",
      stripedColor = "#1A2A4D",
      highlightColor = "#24365E",
      inputStyle = list(backgroundColor = "#1A2A4D"),
      selectStyle = list(backgroundColor = "#1A2A4D"),
      pageButtonHoverStyle = list(backgroundColor = "#1A2A4D"),
      pageButtonActiveStyle = list(backgroundColor = "#24365E")
    )
  } else {
    reactable::reactableTheme(
      color = "#8A6D00", # change / pulp amber, darkened for legibility on cream
      backgroundColor = "#F5F0D6", # pale pulp cream
      borderColor = "#C9BE8A", # aged cream
      stripedColor = "#EFE8C6",
      highlightColor = "#E3D9A2",
      inputStyle = list(backgroundColor = "#E3D9A2"),
      selectStyle = list(backgroundColor = "#E3D9A2"),
      pageButtonHoverStyle = list(backgroundColor = "#E3D9A2"),
      pageButtonActiveStyle = list(backgroundColor = "#E3D9A2")
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
      backgroundColor = "#14213D",
      borderColor = "#2C3E66",
      stripedColor = "#1A2A4D",
      highlightColor = "#24365E",
      cellPadding = "8px 12px"
    )
  } else {
    reactable::reactableTheme(
      color = "#14213D",
      borderColor = "#C9BE8A",
      stripedColor = "#EFE8C6",
      highlightColor = "#E3D9A2",
      cellPadding = "8px 12px"
    )
  }
}
