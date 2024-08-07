% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flux_fitting.R
\name{flux_fitting}
\alias{flux_fitting}
\title{wrap up function for fitting}
\usage{
flux_fitting(
  conc_df,
  start_cut = 0,
  end_cut = 0,
  start_col = "f_start",
  end_col = "f_end",
  datetime_col = "f_datetime",
  conc_col = "f_conc",
  fluxID_col = "f_fluxID",
  t_window = 20,
  Cz_window = 15,
  b_window = 10,
  a_window = 10,
  roll_width = 15,
  t_zero = 0,
  fit_type
)
}
\arguments{
\item{conc_df}{dataframe of gas concentration over time}

\item{start_cut}{to cut at the start}

\item{end_cut}{to cut at the end, if you notice on the plots that the match
was not precise enough}

\item{start_col}{column with datetime when the measurement started}

\item{end_col}{column with datetime when the measurement ended}

\item{datetime_col}{column with datetime of each concentration measurement}

\item{conc_col}{column with gas concentration data}

\item{fluxID_col}{column with ID of each flux}

\item{t_window}{enlarge focus window before and after tmin and tmax}

\item{Cz_window}{window used to calculate Cz, at the beginning of cut window}

\item{b_window}{window to estimate b. It is an interval after tz where
it is assumed that C fits the data perfectly}

\item{a_window}{window at the end of the flux to estimate a}

\item{roll_width}{width of the rolling mean for CO2 when looking for tz,
ideally same as Cz_window}

\item{t_zero}{time at which the slope should be calculated (for fits that do not include t_zero as a parameter)}

\item{fit_type}{exponential or linear, depending on the wish of the user.
Exponential is using the fit described in Zhao 2018}
}
\value{
a dataframe with the slope at t zero,
modelled concentration over time and exponential expression parameters
}
\description{
fits gas concentration over time with an exponential or
linear model
}
\examples{
data(co2_conc)
flux_fitting(co2_conc, fit_type = "exp")
flux_fitting(co2_conc, fit_type = "quadratic", t_zero = 10, end_cut = 30)
}
