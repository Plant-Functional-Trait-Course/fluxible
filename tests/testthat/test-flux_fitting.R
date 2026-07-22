test_that("works for exponential fitting", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "exp_zhao18"
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("works for linear fitting", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "lin"
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("works for quadratic fitting", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "qua"
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("works for exponential fitting with cut", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "exp_zhao18",
      start_cut = 20
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("works for linear fitting with cut", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "line",
      start_cut = 20
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("removing duplicated datetime", {
  rep <- co2_conc[rep(1, 200), ] |>
    mutate(
      conc = runif(n = 200, min = 420, max = 460)
    )

  rep_data <- rbind(co2_conc, rep) |>
    arrange(datetime)

  expect_snapshot(
    flux_fitting(
      rep_data,
      conc,
      datetime,
      fit_type = "exponential"
    )
  )
})

test_that("correct flux with duplicated datetime", {
  rep <- co2_conc[rep(1, 200), ] |>
    mutate(
      conc = runif(n = 200, min = 420, max = 460)
    )

  rep_data <- rbind(co2_conc, rep) |>
    arrange(datetime)

  qflux_fitting <- purrr::quietly(flux_fitting)
  expect_equal(
    qflux_fitting(
      rep_data,
      conc,
      datetime,
      fit_type = "exponential"
    ),
    qflux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "exponential"
    )
  )
})

test_that("works for exp_tz fitting", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "exp_tz"
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})


test_that("works for exp_zhao18 with missing data", {
  expect_snapshot(
    flux_fitting(
      co2_conc_missing,
      conc,
      datetime,
      fit_type = "exp_zhao18",
      end_cut = 61,
      t_zero = 20
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("works for exp_zhao18 with mid missing data", {
  expect_snapshot(
    flux_fitting(
      co2_conc_mid_missing,
      conc,
      datetime,
      fit_type = "exp_zhao18",
      end_cut = 61,
      t_zero = 20
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("works for exp_tz with mid missing data", {
  expect_snapshot(
    flux_fitting(
      co2_conc_mid_missing,
      conc,
      datetime,
      fit_type = "exp_tz",
      end_cut = 61,
      t_zero = 20
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("works for quadratic with mid missing data", {
  expect_snapshot(
    flux_fitting(
      co2_conc_mid_missing,
      conc,
      datetime,
      fit_type = "quadratic",
      end_cut = 61,
      t_zero = 20
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

# producing an error where optim can not optimize the equation
test_that("exp_tz: optim produces non-finite values", {

  test_data <- co2_conc_missing |>
    dplyr::mutate(
      conc = replace(
        conc,
        c(297:425, 427:490, 495:506),
        NA
      )
    )

  expect_snapshot(
    flux_fitting(
      test_data,
      conc,
      datetime,
      fit_type = "exp_tz",
      end_cut = 61,
      t_zero = 20
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("exp_zhao18: optim produces non-finite values", {

  test_data <- co2_conc_missing |>
    dplyr::mutate(
      conc = replace(
        conc,
        c(297:425, 427:490, 495:506),
        NA
      )
    )

  expect_snapshot(
    flux_fitting(
      test_data,
      conc,
      datetime,
      fit_type = "exp_zhao18",
      end_cut = 61,
      t_zero = 20
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("works for exp_hm fitting", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "exp_hm"
    ) |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("fitting works with 0 second end cut", {
  test_fit <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "lin"
  ))

  expect_snapshot(test_fit)
})

test_that("fitting works with 30 second end cut", {
  expect_snapshot(flux_fitting(
    co2_conc,
    conc,
    datetime,
    end_cut = 30,
    fit_type = "lin"
  ))
})

test_that("fitting works with 60 second end cut", {
  expect_snapshot(flux_fitting(
    co2_conc,
    end_cut = 60,
    conc,
    datetime,
    fit_type = "lin"
  ))
})

### need to test when data are missing
# warning that NAs were dropped in some fluxID

test_that("warnings when NAs are dropped in conc", {
  expect_warning(
    flux_fitting(co2_conc_missing,
      conc,
      datetime,
      fit_type = "lin"
    ),
    " fluxID 1 : slope was estimated on 70 points out of 210 seconds
 fluxID 2 : slope was estimated on 121 points out of 210 seconds
 fluxID 3 : slope was estimated on 102 points out of 210 seconds
 fluxID 5 : slope was estimated on 161 points out of 210 seconds",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})

# warning when there is no data in some fluxID

test_that("warnings when there is no data in conc", {
  expect_warning(
    flux_fitting(co2_conc_missing,
      conc,
      datetime,
      fit_type = "lin"
    ),
    " fluxID 6 dropped (no data in the conc column)",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})

test_that("warnings with cutting", {
  expect_warning(
    flux_fitting(
      co2_conc_missing,
      conc,
      datetime,
      start_cut = 10,
      fit_type = "lin"
    ),
    " fluxID 1 : slope was estimated on 70 points out of 200 seconds
 fluxID 2 : slope was estimated on 121 points out of 200 seconds
 fluxID 3 : slope was estimated on 102 points out of 200 seconds
 fluxID 5 : slope was estimated on 151 points out of 200 seconds",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})

test_that("error on arguments", {
  expect_error(
    flux_fitting(
      co2_conc_missing,
      conc,
      datetime,
      start_cut = "Voldemort",
      fit_type = "lin"
    ),
    "Please correct the arguments"
  )
})



test_that("cutting too much", {
  expect_error(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      start_cut = 120,
      end_cut = 100,
      fit_type = "lin"
    ),
    "You cannot cut more than the length of the measurements!",
  )
})

test_that("renaming works", {
  co2_conc_names <- co2_conc |>
    dplyr::rename(
      date_time = datetime,
      finish = f_end,
      co2 = conc
    )



  expect_snapshot(
    flux_fitting(
      co2_conc_names,
      co2,
      date_time,
      f_start,
      finish,
      fit_type = "lin"
    )
  )
})

test_that("quadratic fit works", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      f_start,
      f_end,
      f_fluxid,
      fit_type = "quadratic",
      t_zero = 10,
      end_cut = 30
    )
  )
})

test_that("fitting works with 0 second end cut", {
  expect_snapshot(
    flux_fitting(co2_conc,
                 conc,
                 datetime,
                 fit_type = "exponential") |>
      select(f_fluxid, f_slope) |>
      distinct()
  )
})

test_that("fitting works with 30 second end cut", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      end_cut = 30,
      fit_type = "exponential"
    )
  )
})

test_that("fitting works with 60 second end cut", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      end_cut = 60,
      fit_type = "exponential"
    )
  )
})

### need to test when data are missing
# warning that NAs were dropped in some fluxID

test_that("warnings when NAs are dropped in conc", {
  expect_warning(
    flux_fitting(co2_conc_missing,
                 conc,
                 datetime,
                 fit_type = "exponential"),
    " fluxID 1 : slope was estimated on 70 points out of 210 seconds
 fluxID 2 : slope was estimated on 121 points out of 210 seconds
 fluxID 3 : slope was estimated on 102 points out of 210 seconds
 fluxID 5 : slope was estimated on 161 points out of 210 seconds",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})

# warning when there is no data in some fluxID

test_that("warnings when there is no data in conc", {
  expect_warning(
    flux_fitting(co2_conc_missing,
                 conc,
                 datetime,
                 fit_type = "exponential"),
    " fluxID 6 dropped (no data in the conc column)",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})

test_that("warnings with cutting", {
  expect_warning(
    flux_fitting(
      co2_conc_missing,
      conc,
      datetime,
      start_cut = 10,
      fit_type = "exponential"
    ),
    " fluxID 1 : slope was estimated on 70 points out of 200 seconds
 fluxID 2 : slope was estimated on 121 points out of 200 seconds
 fluxID 3 : slope was estimated on 102 points out of 200 seconds
 fluxID 5 : slope was estimated on 151 points out of 200 seconds",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})

test_that("error on arguments", {
  expect_error(
    flux_fitting(
      co2_conc_missing,
      conc,
      datetime,
      start_cut = "Voldemort",
      fit_type = "exponential"
    ),
    "Please correct the arguments"
  )
})



test_that("cutting too much", {
  expect_error(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      start_cut = 120,
      end_cut = 100,
      fit_type = "exponential"
    ),
    "You cannot cut more than the length of the measurements!",
    fixed = TRUE # need that because there parenthesis in the error message
  )
})

test_that("renaming works", {
  co2_conc_names <- co2_conc |>
    dplyr::rename(
      date_time = datetime,
      finish = f_end,
      co2 = conc
    )

  expect_snapshot(
    flux_fitting(
      co2_conc_names,
      co2,
      date_time,
      f_start,
      finish,
      fit_type = "exponential"
    )
  )
})

test_that("cut direction from start", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "line",
      start_cut = 20,
      end_cut = 59,
      cut_direction = "from_start"
    ) |>
      filter(f_cut == "keep") |>
      select(f_fluxid, f_slope) |>
      summarize(
        nrow = dplyr::n(),
        .by = c(f_fluxid, f_slope)
      )
  )
})

test_that("cut direction from end", {
  expect_snapshot(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      fit_type = "line",
      start_cut = 60,
      end_cut = 21,
      cut_direction = "from_end"
    ) |>
      filter(f_cut == "keep") |>
      select(f_fluxid, f_slope) |>
      summarize(
        nrow = dplyr::n(),
        .by = c(f_fluxid, f_slope)
      )
  )
})

test_that("cutting too much from start", {
  expect_error(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      cut_direction = "from_start",
      start_cut = 120,
      end_cut = 300,
      fit_type = "linear"
    ),
    "You cannot cut more than the length of the measurements!"
  )
})

test_that("cutting too much from end", {
  expect_error(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      cut_direction = "from_end",
      start_cut = 300,
      end_cut = 100,
      fit_type = "linear"
    ),
    "You cannot cut more than the length of the measurements!"
  )
})

test_that("from start end cut too small", {
  expect_error(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      cut_direction = "from_start",
      start_cut = 120,
      end_cut = 100,
      fit_type = "linear"
    ),
    "end_cut cannot be smaller than start_cut"
  )
})

test_that("from end start cut too small", {
  expect_error(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      cut_direction = "from_end",
      start_cut = 100,
      end_cut = 140,
      fit_type = "linear"
    ),
    "start_cut cannot be smaller than end_cut"
  )
})

test_that("equal cuts", {
  expect_error(
    flux_fitting(
      co2_conc,
      conc,
      datetime,
      cut_direction = "from_end",
      start_cut = 20,
      end_cut = 20,
      fit_type = "linear"
    ),
    "start_cut cannot be smaller than end_cut"
  )
})
