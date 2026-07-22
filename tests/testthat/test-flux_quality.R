test_that("works for exponential fitting", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exponential"
  ))

  expect_snapshot(
    flux_quality(slopes0,
      conc
    ) |>
      dplyr::select(f_fluxid, f_quality_flag, f_RMSE, f_cor_coef,
                    f_ratio, f_gfactor) |>
      dplyr::distinct()
  )
})

test_that("works for linear fitting", {
  slopes30lin <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    end_cut = 31,
    fit_type = "linear"
  ))

  expect_snapshot(
    flux_quality(slopes30lin,
      conc
    ) |>
      dplyr::select(f_fluxid, f_quality_flag, f_pvalue, f_rsquared) |>
      dplyr::distinct()
  )
})

test_that("works for quadratic fitting", {
  slopes30qua <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    end_cut = 31,
    fit_type = "quadratic"
  ))

  expect_snapshot(
    flux_quality(slopes30qua,
      conc
    ) |>
      dplyr::select(f_fluxid, f_quality_flag, f_pvalue,
                    f_rsquared, f_gfactor) |>
      dplyr::mutate(
        f_rsquared = round(f_rsquared, digits = 3)
        # tests sometime takes 2 and then it makes it fail
      ) |>
      dplyr::distinct()
  )
})

test_that("kappamax with HM model", {
  slopeshm <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    end_cut = 31,
    fit_type = "exp_hm"
  ))

  expect_snapshot(
    flux_quality(slopeshm,
      conc,
      f_pvalue = f_pvalue_lm,
      f_rsquared = f_rsquared_lm,
      kappamax = TRUE
    ) |>
      dplyr::filter(f_cut == "keep") |>
      dplyr::select(f_fluxid, f_quality_flag, f_slope_corr, f_model) |>
      dplyr::distinct()
  )
})

test_that("kappamax with zhao18 model", {
  slopesexp <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    end_cut = 31,
    fit_type = "exp_zhao18"
  ))

  expect_snapshot(
    flux_quality(slopesexp,
      conc,
      f_pvalue = f_pvalue_lm,
      f_rsquared = f_rsquared_lm,
      kappamax = TRUE
    ) |>
      dplyr::filter(f_cut == "keep") |>
      dplyr::select(f_fluxid, f_quality_flag, f_slope_corr, f_model) |>
      dplyr::distinct()
  )
})


test_that("works in a pipeline", {

  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "exp_hm"
    ) |>
      flux_quality(
        f_conc = conc,
        f_pvalue = f_pvalue_lm,
        f_rsquared = f_rsquared_lm,
        kappamax = TRUE
      ) |>
      dplyr::select(f_fluxid, f_quality_flag, f_RMSE, f_cor_coef,
                    f_ratio, f_gfactor) |>
      dplyr::distinct()
  )
})
