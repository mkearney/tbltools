% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/print.R
\name{print.tbl_data}
\alias{print.tbl_data}
\title{Print tbl_data}
\usage{
\method{print}{tbl_data}(x, n = NULL, ...)
}
\arguments{
\item{x}{Input object}

\item{n}{Maximum number of rows to print, if NULL (default) defaults to
\code{getOption("tbltools.print_n", 10)}.}

\item{...}{Other args passed to tibble or data.frame print.}
}
\description{
Method for printing pseduo tibble
}
