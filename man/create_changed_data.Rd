% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_changed_data.R
\name{create_changed_data}
\alias{create_changed_data}
\title{Create changed data}
\usage{
create_changed_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
}
\arguments{
\item{compare}{A 'current' or 'new' dataset (tibble or data.frame)}

\item{base}{A 'previous' or 'old' dataset (tibble or data.frame)}

\item{by}{A join column between the two datasets, or any combination of columns that constitute a unique row.}

\item{by_col}{A new name for the joining column.}

\item{cols}{Columns to be compared.}
}
\value{
modified data
}
\description{
Create changed data
}
\examples{
# with local data
ChangedData <- dfdiffs::ChangedData
InitialData <- dfdiffs::InitialData
create_changed_data(
  compare = ChangedData,
  base = InitialData,
  by = c("subject_id", "record"),
  cols = c("text_value_a", "text_value_b", "updated_date")
)
create_changed_data(
  compare = ChangedData,
  base = InitialData,
  by = c("subject_id", "record")
)
}
