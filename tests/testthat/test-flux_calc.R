test_that("flux calculation is correct", {
  output <- flux_calc(slopes0,
    f_slope,
    datetime,
    temp_air,
    chamber_volume = 24.5,
    tube_volume = 0.075,
    atm_pressure = 1,
    plot_area = 0.0625,
    conc_unit = "ppm",
    flux_unit = "mmol",
    cut = FALSE
  )

  expect_equal(
    output$f_flux,
    co2_fluxes$f_flux,
    tolerance = 0.001
  )
})


test_that("averaging works", {
  output <- flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol",
    cols_ave = c("PAR", "temp_soil"),
    chamber_volume = 24.5,
    tube_volume = 0.075,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux, PAR, temp_soil)


  expect_snapshot(output)
})

test_that("keeping works", {
  expect_snapshot(flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol",
    cols_keep = c("turfID", "type", "f_start"),
    chamber_volume = 24.5,
    tube_volume = 0.075,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, f_flux, turfID, type, f_start, f_slope))
})

test_that("keeping and averaging work together", {
  expect_snapshot(flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol",
    cols_keep = c("turfID", "type", "f_start"),
    cols_ave = c("PAR", "temp_soil"),
    chamber_volume = 24.5,
    tube_volume = 0.075,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, f_flux, turfID, type, f_start, PAR, temp_soil))
})

test_that("fahrenheit conversion works", {
  expect_snapshot(flux_calc(
    slopes0_temp,
    f_slope,
    datetime,
    temp_fahr,
    conc_unit = "ppm",
    flux_unit = "mmol",
    temp_air_unit = "fahrenheit",
    chamber_volume = 24.5,
    tube_volume = 0.075,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux, f_volume_setup))
})

test_that("kelvin conversion works", {
  expect_snapshot(flux_calc(
    slopes0_temp,
    f_slope,
    datetime,
    temp_kelvin,
    conc_unit = "ppm",
    flux_unit = "mmol",
    temp_air_unit = "kelvin",
    chamber_volume = 24.5,
    tube_volume = 0.075,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux, f_volume_setup))
})





test_that("error on air temp units", {
  expect_error(
    flux_calc(
      slopes0,
      f_slope,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol",
      temp_air_unit = "melvin",
      chamber_volume = 24.5,
      tube_volume = 0.075,
      atm_pressure = 1,
      plot_area = 0.0625,
      cut = FALSE
    ),
    "'arg' should be one of \"celsius\", \"fahrenheit\", \"kelvin\""
  )
  # Played for Laughs in the 1985 humor book "Science Made Stupid"
  # by Tom Weller, in which a table in its appendix lists such units as the
  # "arg" (the unit of work done incorrectly), the "galumph" (unit of waste
  # motion), the "lumpen" (unit of resistance to getting out of bed in the
  # morning), and the "melvin" (unit of temperature, "as measured from
  # absolutely perfect to absolutely awful"). A separate table of conversions
  # for weights and measures on the same page listed equivalencies such as
  # "325 cubebs = 1 furbish; 6 furbishes = 1 nautical smile;
  # 20 nautical smiles = 1 minor league; 3 minor leagues = 1 major league"
  # and "24 carrots = 1 pickelweight; 30 pickelweights = 1 tuna;
  # 1000 tuna = 1 short ton; 1.37 short tons = 1 tall ton".
  # (https://allthetropes.org/wiki/Fantastic_Measurement_System)
})

test_that("error that slope column is missing", {
  expect_error(
    suppressWarnings(flux_calc(
      slopes0,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol",
      chamber_volume = 24.5,
      tube_volume = 0.075,
      atm_pressure = 1,
      plot_area = 0.0625,
      cut = FALSE
    )),
    "Please correct the arguments"
  )
})

test_that("error slope_col cannot be found in slopes_df", {
  expect_error(
    flux_calc(
      slopes0,
      column_with_slope,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol",
      chamber_volume = 24.5,
      tube_volume = 0.075,
      atm_pressure = 1,
      plot_area = 0.0625,
      cut = FALSE
    ),
    "Can't select columns that don't exist.
x Column `column_with_slope` doesn't exist."
  )
})

test_that("error some cols_keep do not exist", {
  expect_error(
    flux_calc(
      slopes0,
      f_slope,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol",
      cols_keep = c("PAR", "site"),
      chamber_volume = 24.5,
      tube_volume = 0.075,
      atm_pressure = 1,
      plot_area = 0.0625,
      cut = FALSE
    ),
    "some names in cols_keep cannot be found in slopes_df"
  )
})

# reproducing the error I had in the example in the manuscript
# when there is a cut, flux_calc calculates a flux for keep and a flux for cut,
# which is wrong. I need to discard the cut data first.

test_that("calculating fluxes on dataset with cuts", {
  expect_snapshot(
    flux_calc(
      slopes30_flag,
      f_slope_corr,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol",
      keep_arg = "keep",
      chamber_volume = 24.5,
      tube_volume = 0.075,
      atm_pressure = 1,
      plot_area = 0.0625
    ) |>
      dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux, f_volume_setup)
  )
})

# testing having the chamber volume as a variable
test_that("volume can be a variable instead of a constant", {
  expect_snapshot(
    flux_calc(
      slopes0_vol,
      f_slope,
      datetime,
      temp_air,
      volume,
      conc_unit = "ppm",
      flux_unit = "mmol",
      tube_volume = 0.075,
      atm_pressure = 1,
      plot_area = 0.0625
    ) |>
      dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux, f_volume_setup)
  )
})


test_that("Fluxible workflow works from start to finish", {
  conc_test <- flux_match(
    co2_df_short,
    record_short,
    datetime,
    start,
    conc,
    startcrop = 10,
    measurement_length = 180
  )
  slopes_test <- suppressWarnings(flux_fitting(
    conc_test,
    conc,
    datetime,
    start,
    fit_type = "exp"
  ))
  slopes_flag_test <- flux_quality(
    slopes_test,
    conc
  )
  fluxes_test <- flux_calc(
    slopes_flag_test,
    f_slope_corr,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol",
    chamber_volume = 24.5,
    tube_volume = 0.075,
    atm_pressure = 1,
    plot_area = 0.0625
  )

  expect_snapshot(
    str(fluxes_test)
  )
})
