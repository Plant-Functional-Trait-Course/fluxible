test_that("mmol conversion works", {
  coef <- flux_units("mmol/m2/s", "ppm")

  expect_equal(
    coef,
    0.001
  )
})

test_that("mmol/mol conc", {
  coef <- flux_units("umol/m2/s", "mmol/mol")

  expect_equal(
    coef,
    1000
  )
})

test_that("mmol and hours conversion works", {
  coef <- flux_units("mmol/m2/d", "ppm")

  expect_equal(
    coef,
    86.4
  )
})

test_that("mol and minutes conversion works", {
  coef <- flux_units("mol/m2/mn", "ppm")

  expect_equal(
    coef,
    6e-5
  )
})

test_that("volumetric mol per liter conversion works", {
  coef <- flux_units("umol/m2/s", "mol/l")

  expect_equal(
    coef,
    1e6
  )
})

test_that("superseeded but still works (mmol)", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )


  expect_warning(
    flux_calc(
      slopes0,
      f_slope,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "mmol",
      cols_ave = c("PAR", "temp_soil"),
      setup_volume = 24.575,
      atm_pressure = 1,
      plot_area = 0.0625,
      cut = FALSE
    ),
    "The `flux_unit` argument of `flux_calc()` should be in the form amount/surface/time as of fluxible 1.2.4.",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})

test_that("superseeded but still works (micromol)", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  )) |>
    flux_quality(
      conc
    )


  expect_warning(
    flux_calc(
      slopes0,
      f_slope,
      datetime,
      temp_air,
      conc_unit = "ppm",
      flux_unit = "micromol",
      cols_ave = c("PAR", "temp_soil"),
      setup_volume = 24.575,
      atm_pressure = 1,
      plot_area = 0.0625,
      cut = FALSE
    ),
    "The `flux_unit` argument of `flux_calc()` should be in the form amount/surface/time as of fluxible 1.2.4.",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})
