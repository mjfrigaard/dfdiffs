diffdf <- function(base,
                   compare,
                   keys = NULL,
                   suppress_warnings = FALSE,
                   strict_numeric = TRUE,
                   strict_factor = TRUE,
                   file = NULL,
                   tolerance = sqrt(.Machine$double.eps),
                   scale = NULL) {
  ### re-define arguments ----
  BASE <- base
  COMP <- compare
  KEYS <- keys
  SUPWARN <- suppress_warnings
  ### initiate output object ----
  COMPARE <- list()
  class(COMPARE) <- c("diffdf", "list")

  is_derived <- FALSE

  ### If no key is supplied match values based upon row number ----
  if (is.null(KEYS)) {
    is_derived <- TRUE
    keyname <- generate_keyname(BASE, COMP)
    BASE[[keyname]] <- 1:nrow(BASE)
    COMP[[keyname]] <- 1:nrow(COMP)
    KEYS <- keyname
  }
  attr(COMPARE, "keys") <- list(value = KEYS, is_derived = is_derived)

  if (!is.numeric(tolerance)) {
    stop("'tolerance' should be numeric")
  }

  if (!is.numeric(scale) && !is.null(scale)) {
    stop("'scale' should be numeric or NULL")
  }

  if (!has_unique_rows(BASE, KEYS)) {
    stop("BY variables in BASE do not result in unique observations")
  }

  if (!has_unique_rows(COMP, KEYS)) {
    stop("BY variables in COMPARE do not result in unique observations")
  }
  ### Check essential variable properties (class & mode) ----
  COMPARE[["UnsupportedColsBase"]] <- construct_issue(
    value = identify_unsupported_cols(BASE),
    message = "There are columns in BASE with unsupported modes !!"
  )
  COMPARE[["UnsupportedColsComp"]] <- construct_issue(
    value = identify_unsupported_cols(COMP),
    message = "There are columns in COMPARE with unsupported modes !!"
  )

  # cast variables if strict is off ----
  if (!strict_factor | !strict_numeric) {
    casted_df <- cast_variables(
      BASE = BASE,
      COMPARE = COMP,
      ignore_vars = KEYS,
      cast_integers = !strict_numeric,
      cast_factors = !strict_factor
    )

    BASE <- casted_df$BASE
    COMP <- casted_df$COMP
  }

  # check for different modes ----
  COMPARE[["VarModeDiffs"]] <- construct_issue(
    value = identify_mode_differences(BASE, COMP),
    message = "There are columns in BASE and COMPARE with different modes !!"
  )
  # check for different classes ----
  COMPARE[["VarClassDiffs"]] <- construct_issue(
    value = identify_class_differences(BASE, COMP),
    message = "There are columns in BASE and COMPARE with different classes !!"
  )
  # exclude UnsupportedCols/VarClassDiffs/VarClassDiffs ----
  exclude_cols <- c(
    COMPARE[["UnsupportedColsBase"]]$VARIABLE,
    COMPARE[["UnsupportedColsComp"]]$VARIABLE,
    COMPARE[["VarClassDiffs"]]$VARIABLE,
    COMPARE[["VarModeDiffs"]]$VARIABLE
  )
  ### Check Validity of Keys ----
  BASE_keys <- names(BASE)[names(BASE) %in% KEYS]
  COMP_keys <- names(COMP)[names(COMP) %in% KEYS]

  ### check 'BASE is missing variables specified in KEYS' ----
  if (length(BASE_keys) != length(KEYS)) {
    stop("BASE is missing variables specified in KEYS")
  }
  ### check 'COMP is missing variables specified in KEYS' ----
  if (length(COMP_keys) != length(KEYS)) {
    stop("COMP is missing variables specified in KEYS")
  }
  ### check 'KEYS are either an invalid or contain different modes between BASE and COMP' ----
  if (any(KEYS %in% exclude_cols)) {
    stop("KEYS are either an invalid or contain different modes between BASE and COMP")
  }
  ### Check Attributes ----
  COMPARE[["AttribDiffs"]] <- construct_issue(
    value = identify_att_differences(BASE, COMP, exclude_cols),
    message = "There are columns in BASE and COMPARE with differing attributes !!"
  )
  ## Check data ----
  BASE <- factor_to_character(BASE, KEYS)
  COMP <- factor_to_character(COMP, KEYS)
  ### Identify extra rows (BASE) ----
  COMPARE[["ExtRowsBase"]] <- construct_issue(
    value = identify_extra_rows(BASE, COMP, KEYS),
    message = "There are rows in BASE that are not in COMPARE !!"
  )
  ### Identify extra rows (COMPARE) ----
  COMPARE[["ExtRowsComp"]] <- construct_issue(
    value = identify_extra_rows(COMP, BASE, KEYS),
    message = "There are rows in COMPARE that are not in BASE !!"
  )
  ### identify extra columns (BASE) ----
  COMPARE[["ExtColsBase"]] <- construct_issue(
    value = identify_extra_cols(BASE, COMP),
    message = "There are columns in BASE that are not in COMPARE !!"
  )
  ### identify extra columns (COMPARE) ----
  COMPARE[["ExtColsComp"]] <- construct_issue(
    value = identify_extra_cols(COMP, BASE),
    message = "There are columns in COMPARE that are not in BASE !!"
  )

  VALUE_DIFFERENCES <- identify_differences(
    BASE, COMP, KEYS, exclude_cols,
    tolerance = tolerance,
    scale = scale
  )
  ## Summarise the number of mismatching rows per variable ----
  if (length(VALUE_DIFFERENCES)) {
    NDIFF <- sapply(VALUE_DIFFERENCES, nrow)
    COMPARE[["NumDiff"]] <- construct_issue(
      value = convert_to_issue(NDIFF),
      message = "Not all Values Compared Equal"
    )
  }

  for (i in names(VALUE_DIFFERENCES)) {
    COMPARE[[paste0("VarDiff_", i)]] <- construct_issue(
      value = VALUE_DIFFERENCES[[i]],
      message = ""
    )
  }

  ## Get all issue messages, remove blank message, and collapse into single string ----
  ISSUE_MSGS <- sapply(COMPARE, function(x) get_issue_message(x))
  ISSUE_MSGS <- ISSUE_MSGS[ISSUE_MSGS != ""]

  if (length(ISSUE_MSGS) != 0) {
    if (!SUPWARN) {
      ISSUE_MSGS <- paste(ISSUE_MSGS, collapse = "\n")
      warning(c("\n", ISSUE_MSGS))
    }
  }


  if (!is.null(file)) {
    x <- print(COMPARE, as_string = TRUE)

    tryCatch(
      {
        sink(file)
        cat(x, sep = "\n")
        sink()
      },
      warning = function(w) {
        sink()
        warning(w)
      },
      error = function(e) {
        sink()
        stop(e)
      }
    )
    return(invisible(COMPARE))
  }

  return(COMPARE)
}
