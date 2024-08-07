% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flux_fitting_quadratic.R
\name{flux_fitting_quadratic}
\alias{flux_fitting_quadratic}
\title{quadratic fit to gas concentration over time}
\usage{
flux_fitting_quadratic(
  conc_df,
  start_cut = 0,
  end_cut = 0,
  start_col = "f_start",
  end_col = "f_end",
  datetime_col = "f_datetime",
  conc_col = "f_conc",
  fluxID_col = "f_fluxID",
  t_zero = 0
)
}
\arguments{
\item{conc_df}{dataframe of gas concentration over time}

\item{start_cut}{to cut at the start}

\item{end_cut}{to cut at the end, if you notice on the plots
that the match was not precise enough}

\item{start_col}{column with datetime when the measurement started}

\item{end_col}{column with datetime when the measurement ended}

\item{datetime_col}{column with datetime of each concentration measurement}

\item{conc_col}{column with gas concentration data}

\item{fluxID_col}{column with ID of each flux}

\item{t_zero}{time at which the slope should be calculated (for fits that do not include t_zero as a parameter)}
}
\value{
a df with the modelled gas concentration, slope, intercept,
std error, r square and p value of the linear model
}
\description{
fits a linear model to the gas concentration over time
}
