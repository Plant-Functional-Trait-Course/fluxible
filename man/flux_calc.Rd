% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flux_calc.R
\name{flux_calc}
\alias{flux_calc}
\title{calculates ecosystem gas fluxes}
\usage{
flux_calc(
  slopes_df,
  slope_col,
  datetime_col = "f_datetime",
  conc_unit,
  flux_unit,
  cut_col = c(),
  keep_arg = c(),
  chamber_volume = 24.5,
  tube_volume = 0.075,
  atm_pressure = 1,
  plot_area = 0.0625,
  cols_keep = c(),
  cols_ave = c(),
  fluxid_col = "f_fluxID",
  temp_air_col = "temp_air",
  temp_air_unit = "celsius",
  fit_type = c()
)
}
\arguments{
\item{slopes_df}{dataframe of flux slopes}

\item{slope_col}{column containing the slope to calculate the flux
(in ppm*s^(-1))}

\item{datetime_col}{column containing the datetime of each gas concentration
measurements in slopes_df. The first one after cutting will be kept as
datetime of each flux in the output.}

\item{conc_unit}{unit in which the concentration of gas was measured
ppm or ppb}

\item{flux_unit}{unit in which the calculated flux will be
\code{mmol} outputs fluxes in mmol*m^(-2)\emph{h^(-1);
\code{micromol} outputs fluxes in micromol}m^(-2)*h^(-1)}

\item{cut_col}{column containing cutting information}

\item{keep_arg}{name in cut_col of data to keep}

\item{chamber_volume}{volume of the flux chamber in L,
default for Three-D project chamber (25x24.5x40cm),
can also be a column in case it is a variable}

\item{tube_volume}{volume of the tubing in L, default for summer 2020 setup,
can also be a column in case it is a variable}

\item{atm_pressure}{atmospheric pressure, assumed 1 atm,
can be a constant (numerical) or a variable (column name)}

\item{plot_area}{area of the plot in m^2, default for Three-D,
can also be a column in case it is a variable}

\item{cols_keep}{columns to keep from the input to the output.
Those columns need to have unique values for each flux,
as distinct() is applied.}

\item{cols_ave}{columns with values that should be averaged
for each flux in the output. Note that NA are removed in mean calculation.}

\item{fluxid_col}{column containing the fluxID}

\item{temp_air_col}{column containing the air temperature used
to calculate fluxes. Will be averaged with NA removed.}

\item{temp_air_unit}{units in which air temperature was measured.
Has to be either Celsius, Fahrenheit or Kelvin.}

\item{fit_type}{(optional) model used in flux_fitting, exponential,
quadratic or linear.
Will be automatically filled if slopes_df was produced using flux_quality().}
}
\value{
a dataframe containing fluxID, fluxes (in mmol*m^(-2)\emph{h^(-1)
or micromol}m^(-2)*h^(-1), depending on the value of \code{flux_unit}),
temperature average for each flux,
slope used for each flux calculation,
the model used in \code{flux_fitting},
and any columns specified in cols_keep and cols_ave.
}
\description{
calculates a flux based on the rate of change
of gas concentration over time
}
\examples{
data(slopes0)
flux_calc(slopes0,
slope_col = "f_slope",
conc_unit = "ppm",
flux_unit = "mmol")
}
