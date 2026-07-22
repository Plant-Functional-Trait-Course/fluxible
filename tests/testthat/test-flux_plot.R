test_that("plot for exponential fit", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  ))
  slopes0_flag <- suppressMessages(flux_quality(
    slopes0,
    conc
  ))

  expect_snapshot(
    suppressMessages( # because the progress bar is messing with check()
      flux_plot(slopes0_flag,
        conc,
        datetime,
        f_plotname = "test_exp_plot",
        print_plot = FALSE,
        output = "pdfpages"
      )
    )
  )
  # the plots are quite heavy so we do not keep them
  unlink("f_quality_plots/", recursive = TRUE, force = TRUE)
})

test_that("plot for linear fit", {
  slopes30lin_flag <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear",
    end_cut = 30
  )) |>
    flux_quality(
      conc
    )

    vdiffr::expect_doppelganger(
      "plot for linear fit",
      flux_plot(slopes30lin_flag, conc, datetime)
    )
})

test_that("plot for linear fit with jpg extension works", {
  slopes30lin_flag <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear",
    end_cut = 30
  )) |>
    flux_quality(
      conc
    )

  expect_snapshot(
    flux_plot(slopes30lin_flag,
      conc,
      datetime,
      f_plotname = "test_lin_plot",
      print_plot = FALSE,
      output = "ggsave",
      ggsave_args = list(device = "jpg")
    )
  )
  # the plots are quite heavy so we do not keep them
  unlink("f_quality_plots/", recursive = TRUE, force = TRUE)
})

test_that("ggssave and print", {
  slopes30lin_flag <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear",
    end_cut = 30
  )) |>
    flux_quality(
      conc
    )

    vdiffr::expect_doppelganger(
      "ggssave and print",
      flux_plot(slopes30lin_flag,
        conc,
        datetime,
        f_plotname = "test_lin_plot",
        print_plot = TRUE,
        output = "ggsave",
        ggsave_args = list(device = "jpg")
      )
    )
  # the plots are quite heavy so we do not keep them
  unlink("f_quality_plots/", recursive = TRUE, force = TRUE)
})

test_that("plot can be exported as an object", {
  slopes30lin_flag <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear",
    end_cut = 30
  )) |>
    flux_quality(
      conc
    )

  plot_object <- flux_plot(slopes30lin_flag, conc, datetime)
  vdiffr::expect_doppelganger("plot as an object", plot_object)
})

test_that("plot for quadratic fit with mid missing data", {
    vdiffr::expect_doppelganger(
      "plot for quadratic fit with mid missing data",
      suppressWarnings(flux_fitting(
        co2_conc_mid_missing,
        conc,
        datetime,
        fit_type = "quadratic",
        end_cut = 60,
        t_zero = 20
      )) |>
        flux_quality(conc) |>
        flux_plot(conc, datetime)
    )
})


test_that("plot for exp_tz fit", {
    vdiffr::expect_doppelganger(
      "plot for exp_tz fit",
      flux_fitting(
        co2_conc,
        conc,
        datetime,
        fit_type = "exp_tz",
        end_cut = 61,
        t_zero = 20
      ) |>
        flux_quality(conc) |>
        flux_plot(conc, datetime)
    )
})


test_that("plot for exp_tz fit with mid missing data", {
    vdiffr::expect_doppelganger(
      "plot for exp_tz fit with mid missing data",
      suppressWarnings(flux_fitting(
        co2_conc_mid_missing,
        conc,
        datetime,
        fit_type = "exp_tz",
        end_cut = 61,
        t_zero = 20
      )) |>
        flux_quality(conc) |>
        flux_plot(conc, datetime)
    )
})

test_that("plot for exp_zhao18 fit with mid missing data", {
    vdiffr::expect_doppelganger(
      "plot for exp_zhao18 fit with mid missing data",
      suppressWarnings(flux_fitting(
        co2_conc_mid_missing,
        conc,
        datetime,
        fit_type = "exp_zhao18",
        end_cut = 61,
        t_zero = 20
      )) |>
        flux_quality(conc) |>
        flux_plot(conc, datetime)
    )
})

test_that("plot for exp_hm fit", {
    vdiffr::expect_doppelganger(
      "plot for exp_hm fit",
      flux_fitting(
        co2_conc,
        conc,
        datetime,
        fit_type = "exp_hm",
        end_cut = 60,
        t_zero = 20
      ) |>
        flux_quality(conc) |>
        flux_plot(conc, datetime)
    )
})

test_that("plot for kappamax fit", {
    vdiffr::expect_doppelganger(
      "plot for kappamax fit",
      suppressWarnings(flux_fitting(
        co2_conc,
        conc,
        datetime,
        fit_type = "exp_hm",
        end_cut = 30,
        t_zero = 10
      )) |>
        flux_quality(
          conc,
          f_pvalue = f_pvalue_lm,
          f_rsquared = f_rsquared_lm,
          kappamax = TRUE
        ) |>
        flux_plot(conc, datetime)
    )
})

test_that("plot with custom facet id", {
  slopes30lin_flag <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear",
    end_cut = 30
  )) |>
    flux_quality(
      conc
    )

    vdiffr::expect_doppelganger(
      "plot with custom facet id",
      flux_plot(
        slopes30lin_flag,
        conc,
        datetime,
        f_facetid = c("type", "turfID")
      )
    )
})

test_that("error with custom facet id not unique", {
  slopes30lin_flag <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear",
    end_cut = 30
  )) |>
    flux_quality(
      conc
    )

  expect_error(
    flux_plot(
      slopes30lin_flag,
      conc,
      datetime,
      f_facetid = "turfID"
    ),
    "Please use a f_facetid that is unique for each measurement"
  )
})

test_that("longpdf works", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  ))
  slopes0_flag <- suppressMessages(flux_quality(
    slopes0,
    conc
  ))

  expect_snapshot(
    flux_plot(slopes0_flag,
      conc,
      datetime,
      f_plotname = "test_exp_plot",
      print_plot = FALSE,
      output = "longpdf"
    )
  )
  # the plots are quite heavy so we do not keep them
  unlink("f_quality_plots/", recursive = TRUE, force = TRUE)
})

test_that("longpdf and print", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  ))
  slopes0_flag <- suppressMessages(flux_quality(
    slopes0,
    conc
  ))

    vdiffr::expect_doppelganger(
      "longpdf and print",
      flux_plot(slopes0_flag,
        conc,
        datetime,
        f_plotname = "test_exp_plot",
        print_plot = TRUE,
        output = "longpdf"
      )
    )
  # the plots are quite heavy so we do not keep them
  unlink("f_quality_plots/", recursive = TRUE, force = TRUE)
})

test_that("argument error", {
  slopes0 <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "exp_zhao18"
  ))
  slopes0_flag <- suppressMessages(flux_quality(
    slopes0,
    conc
  ))

  expect_error(
    flux_plot(slopes0_flag,
      conc,
      datetime,
      f_plotname = "test_exp_plot",
      print_plot = FALSE,
      output = "pdfpages",
      y_text_position = "a bit higher"
    ),
    "Please correct the arguments"
  )
}
)

test_that("flux diff and lm", {

  flux <- co2_liahovden |>
    filter(
      datetime >= lubridate::as_datetime("2022-07-27 13:52:00") &
        datetime <= lubridate::as_datetime("2022-07-27 13:57:00")
    ) |>
    mutate(
      f_fluxid = 1,
      f_start = lubridate::as_datetime("2022-07-27 13:52:00"),
      f_end = lubridate::as_datetime("2022-07-27 13:57:00")
    ) |>
    rename(
      f_conc = "conc",
      f_datetime = "datetime"
    )

  flux_fit <- flux |>
    flux_fitting(
      fit_type = "linear",
      start_cut = 240,
      cut_direction = "from_end"
    )

  flux_flag_lm <- flux_quality(flux_fit)

    vdiffr::expect_doppelganger(
      "flux diff and lm",
      flux_plot(
        flux_flag_lm,
        f_ylim_upper = 500,
        f_ylim_lower = 350,
        y_text_position = 450
      )
    )
})

test_that("slope crosses fit at tz with exp_tz", {

  flux <- co2_liahovden |>
    filter(
      datetime >= lubridate::as_datetime("2022-07-27 13:52:00") &
        datetime <= lubridate::as_datetime("2022-07-27 13:57:00")
    ) |>
    mutate(
      f_fluxid = 1,
      f_start = lubridate::as_datetime("2022-07-27 13:52:00"),
      f_end = lubridate::as_datetime("2022-07-27 13:57:00")
    ) |>
    rename(
      f_conc = "conc",
      f_datetime = "datetime"
    )

  flux_fit <- flux |>
    flux_fitting(
      fit_type = "exp_tz",
      start_cut = 250,
      cut_direction = "from_end",
      t_zero = 20
    )

  flux_flag_tz <- flux_quality(flux_fit)

    vdiffr::expect_doppelganger(
      "slope crosses fit at tz with exp_tz",
      flux_plot(
        flux_flag_tz,
        f_ylim_upper = 500,
        f_ylim_lower = 350,
        y_text_position = 450
      )
    )
})

test_that("slope crosses fit at tz with exp_hm", {

  flux <- co2_liahovden |>
    filter(
      datetime >= lubridate::as_datetime("2022-07-27 13:52:00") &
        datetime <= lubridate::as_datetime("2022-07-27 13:57:00")
    ) |>
    mutate(
      f_fluxid = 1,
      f_start = lubridate::as_datetime("2022-07-27 13:52:00"),
      f_end = lubridate::as_datetime("2022-07-27 13:57:00")
    ) |>
    rename(
      f_conc = "conc",
      f_datetime = "datetime"
    )

  flux_fit <- flux |>
    flux_fitting(
      fit_type = "exp_hm",
      start_cut = 250,
      cut_direction = "from_end",
      t_zero = 30
    )

  flux_flag_hm <- flux_quality(flux_fit)

    vdiffr::expect_doppelganger(
      "slope crosses fit at tz with exp_hm",
      flux_plot(
        flux_flag_hm,
        f_ylim_upper = 500,
        f_ylim_lower = 350,
        y_text_position = 450
      )
    )
})

test_that("slope crosses fit at tz with quadratic", {

  flux <- co2_liahovden |>
    filter(
      datetime >= lubridate::as_datetime("2022-07-27 13:52:00") &
        datetime <= lubridate::as_datetime("2022-07-27 13:57:00")
    ) |>
    mutate(
      f_fluxid = 1,
      f_start = lubridate::as_datetime("2022-07-27 13:52:00"),
      f_end = lubridate::as_datetime("2022-07-27 13:57:00")
    ) |>
    rename(
      f_conc = "conc",
      f_datetime = "datetime"
    )

  flux_fit <- flux |>
    flux_fitting(
      fit_type = "quadratic",
      start_cut = 240,
      cut_direction = "from_end"
    )

  flux_flag_zhao18 <- flux_quality(flux_fit)

    vdiffr::expect_doppelganger(
      "slope crosses fit at tz with quadratic",
      flux_plot(
        flux_flag_zhao18,
        f_ylim_upper = 500,
        f_ylim_lower = 350,
        y_text_position = 450
      )
    )
})

test_that("facet ordering", {
  slopes30lin_flag <- suppressWarnings(flux_fitting(
    co2_conc,
    conc,
    datetime,
    fit_type = "linear",
    end_cut = 30
  )) |>
    flux_quality(
      conc
    ) |>
    mutate(
      plotID = f_fluxid,
      plotID = case_when(
        plotID == 1 ~ "b",
        plotID == 2 ~ "c",
        plotID == 3 ~ "a",
        plotID == 4 ~ "f",
        plotID == 5 ~ "m",
        plotID == 6 ~ "f"
      )
    )

  plot_object <- flux_plot(
    slopes30lin_flag,
    conc,
    datetime,
    f_facetid = c("f_fluxid", "plotID"),
    arrange_col = plotID
  )
  vdiffr::expect_doppelganger("facet ordering", plot_object)
})
