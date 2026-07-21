#' Unit conversion coefficient for fluxes
#' @description calculates the conversion coefficient for flux_calc
#' @param flux_units desired units for the calculated fluxes. Has to be of the
#' form amount/time/surface. Amount can be `mol`, `mmol`, `umol`, `nmol` or
#' `pmol`. Time can be `d` (day), `h` (hour), `mn` (minute) or `s` (seconds).
#' Surface can be `m2`, `dm2` or `cm2`.
#' @param conc_units units of gas concentration `mmol/mol`, `ppm`, `ppb` or
#' `ppt`.
#' @param conc_units_list list of possible units for gas concentration.
#' @param amount_units list of possible units for amount.
#' @param time_units list of possible units for time.
#' @param surface_units list of possible units for surface.
#' @details The conversion is done from umol/s/m2 and gas concentration
#' measured in ppm.
#' @return A single numerical to multiply flux values with to convert units.
#' @importFrom stringr str_extract
#' @importFrom dplyr case_when
#' @examples
#' flux_units("mol/m2/mn", "ppm")
#' @export


flux_units <- function(flux_units,
                       conc_units,
                       conc_units_list = c(
                         "mmol/mol", "ppm", "ppb", "ppt",
                         "mol/l", "mmol/l", "umol/l", "nmol/l", "pmol/l"
                       ),
                       amount_units = c("mol", "mmol", "umol", "nmol", "pmol"),
                       surface_units = c("m2", "dm2", "cm2"),
                       time_units = c("d", "h", "mn", "s")) {

  amount <- str_extract(flux_units, "^\\w*")
  surface <- str_extract(flux_units, "(?<=\\/)(\\w.*)(?=\\/)")
  time <- str_extract(flux_units, "\\w*$")

  amount <- match.arg(amount, amount_units)
  surface <- match.arg(surface, surface_units)
  time <- match.arg(time, time_units)
  conc_units <- match.arg(conc_units, conc_units_list)

  # output units in flux_calc are micromol/s/m^2

  amount_coeff <- case_when(
    amount == "mol" ~ 1e-6,
    amount == "mmol" ~ 1e-3,
    amount == "umol" ~ 1,
    amount == "nmol" ~ 1e3,
    amount == "pmol" ~ 1e6
  )

  surface_coeff <- case_when(
    surface == "m2" ~ 1,
    surface == "dm2" ~ 1e-2,
    surface == "cm2" ~ 1e-4
  )

  time_coeff <- case_when(
    time == "d" ~ 86400,
    time == "h" ~ 3600,
    time == "mn" ~ 60,
    time == "s" ~ 1
  )

  conc_coeff <- case_when(
    conc_units == "mmol/mol" ~ 1e3,
    conc_units == "ppm" ~ 1,
    conc_units == "ppb" ~ 1e-3,
    conc_units == "ppt" ~ 1e-6,
    conc_units == "mol/l" ~ 1e6,
    conc_units == "mmol/l" ~ 1e3,
    conc_units == "umol/l" ~ 1,
    conc_units == "nmol/l" ~ 1e-3,
    conc_units == "pmol/l" ~ 1e-6
  )

  flux_coeff <- amount_coeff * surface_coeff * time_coeff * conc_coeff

  flux_coeff
}
