test_that("flux calculation is correct", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  output <- flux_calc(slopes0,
    f_slope,
    datetime,
    temp_air,
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    cut = FALSE
  )

  expect_equal(
    output$f_flux,
    co2_fluxes$f_flux,
    tolerance = 0.001
  )
})


test_that("averaging works", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  output <- flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    cols_ave = c("PAR", "temp_soil"),
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(
      f_fluxid, f_temp_air_ave, datetime, f_flux, PAR_ave, temp_soil_ave
    )


  expect_snapshot(output)
})

test_that("keeping works", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  expect_snapshot(flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    cols_keep = c("turfID", "type", "f_start"),
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, f_flux, turfID, type, f_start, f_slope))
})

test_that("keeping and averaging work together", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  expect_snapshot(flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    cols_keep = c("turfID", "type", "f_start"),
    cols_ave = c("PAR", "temp_soil"),
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(
      f_fluxid, f_flux, turfID, type, f_start, PAR_ave, temp_soil_ave
    ))
})

test_that("nesting works", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear"
  )) |>
    flux_quality(
      conc
    )

  output <- flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    cols_ave = c("PAR", "temp_soil"),
    cols_nest = c("conc", "PAR"),
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(
      f_fluxid, datetime, f_flux, PAR_ave, temp_soil_ave, nested_variables
    ) |>
    tidyr:: unnest(cols = nested_variables)


  expect_snapshot(output)
})

test_that("nesting all works", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear"
  )) |>
    flux_quality(
      conc
    )

  output <- flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    cols_ave = c("PAR", "temp_soil"),
    cols_nest = "all",
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(
      f_fluxid, datetime, f_flux, PAR_ave, temp_soil_ave, nested_variables
    ) |>
    tidyr:: unnest(cols = nested_variables, names_sep = "_")


  expect_snapshot(output)
})

test_that("fahrenheit conversion works", {
  expect_snapshot(flux_calc(
    slopes0_temp,
    f_slope,
    datetime,
    temp_fahr,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    temp_air_unit = "fahrenheit",
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux))
})

test_that("kelvin conversion works", {
  expect_snapshot(flux_calc(
    slopes0_temp,
    f_slope,
    datetime,
    temp_kelvin,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    temp_air_unit = "kelvin",
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux))
})





test_that("error on air temp units", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  expect_error(
    flux_calc(
      slopes0,
      f_slope,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      temp_air_unit = "melvin",
      setup_volume = 24.575,
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
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  expect_error(
    suppressWarnings(flux_calc(
      slopes0,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      setup_volume = 24.575,
      atm_pressure = 1,
      plot_area = 0.0625,
      cut = FALSE
    )),
    "Please correct the arguments"
  )
})

test_that("error slope_col cannot be found in slopes_df", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  expect_error(
    flux_calc(
      slopes0,
      column_with_slope,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      setup_volume = 24.575,
      atm_pressure = 1,
      plot_area = 0.0625,
      cut = FALSE
    ),
    "Can't select columns that don't exist.
x Column `column_with_slope` doesn't exist."
  )
})

test_that("error some cols_keep do not exist", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  expect_error(
    flux_calc(
      slopes0,
      f_slope,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      cols_keep = c("PAR", "site"),
      setup_volume = 24.575,
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
  slopes30_flag <- flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18",
    end_cut = 31
  ) |>
    flux_quality(conc)

  expect_snapshot(
    flux_calc(
      slopes30_flag,
      f_slope_corr,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      keep_arg = "keep",
      setup_volume = 24.575,
      atm_pressure = 1,
      plot_area = 0.0625
    ) |>
      dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux)
  )
})

# testing having the chamber volume as a variable
test_that("volume can be a variable instead of a constant", {
  slopes0_vol <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    ) |>
    mutate(
      volume = case_when(
        f_fluxid == 1 ~ 18,
        f_fluxid == 2 ~ 28,
        f_fluxid == 3 ~ 20,
        f_fluxid == 4 ~ 24,
        f_fluxid == 5 ~ 4,
        f_fluxid == 6 ~ 35
      ),
      volume = volume + 0.075 # adding the tube volume since v1.2.2
    )

  expect_snapshot(
    flux_calc(
      slopes0_vol,
      f_slope,
      datetime,
      temp_air,
      setup_volume = volume,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      atm_pressure = 1,
      plot_area = 0.0625
    ) |>
      dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux)
  )
})

test_that("pressure can be a variable instead of a constant", {
  slopes0_vol <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    ) |>
    mutate(
      f_pressure = case_when(
        f_fluxid == 1 ~ 0.8,
        f_fluxid == 2 ~ 1,
        f_fluxid == 3 ~ 1.3,
        f_fluxid == 4 ~ 1.1,
        f_fluxid == 5 ~ 0.7,
        f_fluxid == 6 ~ 1.2
      )
    )

  expect_snapshot(
    flux_calc(
      slopes0_vol,
      f_slope,
      datetime,
      temp_air,
      setup_volume = 24.575,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      atm_pressure = f_pressure,
      plot_area = 0.0625
    ) |>
      dplyr::select(f_fluxid, f_temp_air_ave, datetime, f_flux)
  )
})


test_that("Fluxible workflow works from start to finish", {
  conc_test <- flux_match(
    co2_df_short,
    record_short,
    datetime,
    start,
    measurement_length = 180
  )
  slopes_test <- suppressWarnings(flux_fitting(
    conc_test,
    conc,
    datetime,
    start,
    start_cut = 10,
    fit_type = "exp_zhao18"
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
    flux_unit = "mmol/m2/h",
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625
  )

  expect_snapshot(
    str(fluxes_test)
  )
})

test_that("Stupeflux returns the same as step by step workflow", {
  conc_test <- flux_match(
    co2_df_short,
    record_short,
    datetime,
    start,
    measurement_length = 180
  )
  slopes_test <- suppressWarnings(flux_fitting(
    conc_test,
    conc,
    datetime,
    f_start,
    start_cut = 10,
    fit_type = "exp_zhao18"
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
    flux_unit = "mmol/m2/h",
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625
  ) |>
    dplyr::mutate(f_atm_pressure_ave = 1) |>
    dplyr::relocate(f_fluxid, f_slope_corr, f_temp_air_ave,
                    f_atm_pressure_ave, datetime, f_flux, f_model)

  expect_equal(
    stupeflux(
      raw_conc = co2_df_short,
      field_record = record_short,
      f_datetime = datetime,
      start_col = start,
      f_conc = conc,
      start_cut = 10,
      measurement_length = 180,
      fit_type = "exp_zhao18",
      temp_air_col = temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      setup_volume = 24.575,
      atm_pressure = 1,
      plot_area = 0.0625
    ),
    fluxes_test
  )
})

test_that("Stupeflux works with slope_correction = FALSE", {
  expect_snapshot(
    stupeflux(
      raw_conc = co2_df_short,
      field_record = record_short,
      f_datetime = datetime,
      start_col = start,
      f_conc = conc,
      start_cut = 10,
      measurement_length = 180,
      fit_type = "exp_zhao18",
      temp_air_col = temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol/m2/h",
      setup_volume = 24.575,
      atm_pressure = 1,
      plot_area = 0.0625,
      slope_correction = FALSE
    )
  )
})

test_that("Fluxible workflow works with kappamax", {
  conc_test <- flux_match(
    co2_df_short,
    record_short,
    datetime,
    start,
    measurement_length = 220
  )
  slopes_test <- suppressWarnings(flux_fitting(
    conc_test,
    conc,
    datetime,
    start,
    start_cut = 10,
    end_cut = 31,
    fit_type = "exp_hm"
  ))
  slopes_flag_test <- flux_quality(
    slopes_test,
    conc,
    f_pvalue = f_pvalue_lm,
    f_rsquared = f_rsquared_lm,
    kappamax = TRUE
  )
  fluxes_test <- flux_calc(
    slopes_flag_test,
    f_slope_corr,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625
  ) |>
    dplyr::select(!c(f_fluxid, f_slope_corr))

  expect_snapshot(
    fluxes_test
  )
})

test_that("Working with two gases", {
  conc_twogases <- flux_match(
    raw_twogases,
    twogases_record,
    datetime,
    start,
    measurement_length = 180,
    time_diff = 0
  )

  slopes_twogases_co2 <- flux_fitting(
    conc_twogases,
    co2_conc,
    datetime,
    fit_type = "exponential",
    start_cut = 10
  )

  slopes_twogases_ch4 <- flux_fitting(
    conc_twogases,
    ch4_conc,
    datetime,
    fit_type = "exponential",
    start_cut = 10
  )

  flag_twogases_co2 <- flux_quality(
    slopes_twogases_co2,
    co2_conc,
    force_discard = "8" # there is a peak at the start that looks like an error
  )

  flag_twogases_ch4 <- flux_quality(
    slopes_twogases_ch4,
    ch4_conc,
    ambient_conc = 2000 # the default is for CO2
  )

  fluxes_twogases_co2 <- flux_calc(
    flag_twogases_co2,
    f_slope_corr,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    setup_volume = 6.31,
    atm_pressure = 1,
    plot_area = 0.31,
    cols_keep = "f_quality_flag" # to use the flags of CO2 to discard CH4 fluxes
  ) |>
    rename( # to avoid any confusion, we rename the flux column
      flux_co2 = "f_flux"
    ) |> # and we remove the slope one
    select(!f_slope_corr)

  fluxes_twogases_ch4 <- flux_calc(
    flag_twogases_ch4,
    f_slope_corr,
    datetime,
    temp_air,
    conc_unit = "ppb", # ch4 is measured in ppb
    flux_unit = "umol/m2/h", # we want a flux in umol/m2/h
    setup_volume = 6.31,
    atm_pressure = 1,
    plot_area = 0.31
  ) |>
    rename( # to avoid any confusion, we rename the flux column
      flux_ch4 = "f_flux"
    ) |> # and we remove the slope one
    select(!f_slope_corr)

  fluxes_twogases <- left_join(
    fluxes_twogases_co2,
    fluxes_twogases_ch4,
    by = c(
      "f_fluxid",
      "f_temp_air_ave",
      "datetime",
      "f_model"
    )
  ) |>
    mutate( # we discard the CH4 fluxes based on CO2 fluxes quality flags
      flux_ch4 = case_when(
        f_quality_flag != "ok" ~ NA,
        TRUE ~ flux_ch4
      )
    )

  expect_snapshot(
    str(fluxes_twogases)
  )
})

test_that("sum and median works", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  output <- flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    cols_sum = "PAR",
    cols_med = "temp_soil",
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(
      f_fluxid, f_temp_air_ave, datetime, f_flux, PAR_sum, temp_soil_med
    )


  expect_snapshot(output)
})

test_that("sum and average works on same variable", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )

  output <- flux_calc(
    slopes0,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "ppm",
    flux_unit = "mmol/m2/h",
    cols_sum = "PAR",
    cols_ave = c("temp_soil", "PAR"),
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, datetime, f_flux, PAR_sum, temp_soil_ave, PAR_ave)


  expect_snapshot(output)
})

test_that("volumetric concentration works", {
  slopes <- flux_conc(co2_conc, conc, temp_air)
  fit_df <- suppressWarnings(flux_fitting(
    slopes,
    f_conc_vol,
    datetime
  ))

  quality_df <- flux_quality(
    fit_df,
    f_conc_vol,
    ambient_conc = 18, # approx ambient CO2 concentration at 20°C in umol/l
    error = 4 # this one also needs to be adapted
  )

  output_vol <- flux_calc(
    quality_df,
    f_slope,
    datetime,
    temp_air,
    conc_unit = "umol/l",
    flux_unit = "mmol/m2/h",
    cols_sum = "PAR",
    cols_ave = c("temp_soil", "PAR"),
    setup_volume = 24.575,
    atm_pressure = 1,
    plot_area = 0.0625,
    cut = FALSE
  ) |>
    dplyr::select(f_fluxid, datetime, f_flux, PAR_sum, temp_soil_ave, PAR_ave)

  expect_snapshot(output_vol)
})
