test_that("volumetric concentration works", {
  output <- flux_conc(co2_conc, conc, temp_air) |>
    dplyr::select(f_fluxid, f_temp_air_kelvin, f_conc_vol)

  expect_snapshot(output)
})